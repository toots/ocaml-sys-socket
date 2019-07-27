open Ctypes
open Sys_socket

include Sys_socket_unix_types.Def(Sys_socket_unix_generated_types)

let from_sockaddr_storage t ptr =
  from_voidp t (to_voidp ptr)

module SockaddrUnix = struct
  include SockaddrUnix
  let from_sockaddr_storage = from_sockaddr_storage t
  let sun_path_len = sun_path_len
end

let inet_pton tag addr sockaddr_ptr =
  match inet_pton tag addr (to_voidp sockaddr_ptr) with
    | 1 -> ()
    | _ -> failwith "inet_addr_of_string"

let inet_ntop tag sockaddr_ptr =
  let len = 64 in
  let ret = Bytes.create len in
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      match inet_ntop tag (to_voidp sockaddr_ptr) (ocaml_bytes_start ret) len with
        | ""   -> None
        | ret  -> Some ret))

let to_unix_sockaddr s =
  match !@ (s |-> SockaddrStorage.ss_family) with
    | id when id = af_unix  ->
       let s = SockaddrUnix.from_sockaddr_storage s in
       let path =
         !@ (s |-> SockaddrUnix.sun_path)
       in
       let len =
          strnlen (CArray.start path)
            (Unsigned.Size_t.of_int (CArray.length path))
       in
       let path =
         string_from_ptr (CArray.start path)
           ~length:(Unsigned.Size_t.to_int len)
       in
       Unix.ADDR_UNIX path
    | id when id = af_inet  ->
       let s = SockaddrInet.from_sockaddr_storage s in
       let inet_addr =
         Unix.inet_addr_of_string
           (inet_ntop (int_of_sa_family af_inet) (s |-> SockaddrInet.sin_addr))
       in
       let port =
         Unsigned.UInt16.to_int
           (ntohs
             (!@ (s |-> SockaddrInet.sin_port)))
       in
       Unix.ADDR_INET (inet_addr, port)
    | id when id = af_inet6 ->
       let s = SockaddrInet6.from_sockaddr_storage s in
       let inet_addr =
         Unix.inet_addr_of_string
           (inet_ntop (int_of_sa_family af_inet6) (s |-> SockaddrInet6.sin6_addr))
       in
       let port =
         Unsigned.UInt16.to_int
          (ntohs
            (!@ (s |-> SockaddrInet6.sin6_port)))
       in
       Unix.ADDR_INET (inet_addr, port)
    | _ -> failwith "unix_sockaddr_from_sockaddr_storage"

let from_unix_sockaddr sockaddr =
  let ss =
    allocate_n SockaddrStorage.t ~count:(sizeof sockaddr_storage_t)
  in
  begin
   match sockaddr with
     | Unix.ADDR_UNIX path ->
         let path =
           if String.length path > sun_path_len then
             String.sub path 0 sun_path_len
           else
             path
         in
         let path =
           CArray.of_list char (List.of_seq (String.to_seq path))
         in
         let s = SockaddrUnix.from_sockaddr_storage ss in
         (s |-> SockaddrUnix.sun_family) <-@ af_unix;
         (s |-> SockaddrUnix.sun_path) <-@ path
     | Unix.ADDR_INET (inet_addr,port) ->
         let inet_addr =
           Unix.string_of_inet_addr inet_addr
         in
         let port =
           htons (Unsigned.UInt16.of_int port)
         in
         try
           let s = SockaddrInet6.from_sockaddr_storage ss in
           (s |-> SockaddrInet6.sin6_family) <-@ af_inet6;
           (s |-> SockaddrInet6.sin6_port) <-@ port;
           inet_pton (int_of_sa_family af_inet6) inet_addr (s |-> SockaddrInet6.sin6_addr)
         with Failure s when s = "inet_addr_of_string" ->
           let s = SockaddrInet.from_sockaddr_storage ss in
           (s |-> SockaddrInet.sin_family) <-@ af_inet;
           (s |-> SockaddrInet.sin_port) <-@ port;
           inet_pton (int_of_sa_family af_inet) inet_addr (s |-> SockaddrInet.sin_addr)
  end;
  ss
