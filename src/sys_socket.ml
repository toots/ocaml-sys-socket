open Ctypes

include Sys_socket_types.SaFamily

include Sys_socket_types.Def(Sys_socket_generated_types)

include Sys_socket_stubs.Def(Sys_socket_generated_stubs)

type socket_type = int
let socket_type_t = int

let from_sockaddr_storage t ptr =
  from_voidp t (to_voidp ptr)

module Sockaddr = struct
  include Sockaddr
  let from_sockaddr_storage = from_sockaddr_storage t
  let sa_data_len = sa_data_len
end

module SockaddrInet = struct
  include SockaddrInet
  let from_sockaddr_storage = from_sockaddr_storage t
end

module SockaddrInet6 = struct
  include SockaddrInet6
  let from_sockaddr_storage = from_sockaddr_storage t
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
     | Unix.ADDR_UNIX _ ->
         failwith "Not implemented, use Sys_socket_unix"
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
