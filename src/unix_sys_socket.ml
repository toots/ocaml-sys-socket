open Ctypes

include Unix_sys_socket_types.Def(Unix_sys_socket_generated_types)

include Unix_sys_socket_stubs.Def(Unix_sys_socket_generated_stubs)

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
  match getf s Sockaddr.sa_family with
    | id when id = af_unix  ->
       let path =
         String.of_seq
           (List.to_seq
             (CArray.to_list
               (getf s SockaddrUnix.sun_path)))
       in
       Unix.ADDR_UNIX path
    | id when id = af_inet  ->
       let inet_addr =
         Unix.inet_addr_of_string
           (inet_ntop (int_of_sa_family af_inet) (s @. SockaddrInet.sin_addr))
       in
       let port =
         Unsigned.UInt16.to_int
           (getf s SockaddrInet.sin_port)
       in
       Unix.ADDR_INET (inet_addr, port)
    | id when id = af_inet6 ->
       let inet_addr =
         Unix.inet_addr_of_string
           (inet_ntop (int_of_sa_family af_inet6) (s @. SockaddrInet6.sin6_addr))
       in
       let port =
         Unsigned.UInt16.to_int
           (getf s SockaddrInet6.sin6_port)
       in
       Unix.ADDR_INET (inet_addr, port)
    | _ -> failwith "unix_sockaddr_of_sockaddr"

let of_unix_sockaddr = function
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
      let s = make SockaddrUnix.t in
      setf s SockaddrUnix.sun_family af_unix;
      setf s SockaddrUnix.sun_path path;
      s
  | Unix.ADDR_INET (inet_addr,port) ->
      let inet_addr = 
        Unix.string_of_inet_addr inet_addr
      in
      try      
        let s = make SockaddrInet6.t in
        setf s SockaddrInet6.sin6_family af_inet6;
        setf s SockaddrInet6.sin6_port (Unsigned.UInt16.of_int port);
        inet_pton (int_of_sa_family af_inet6) inet_addr (s @. SockaddrInet6.sin6_addr);
        s
      with Failure s when s = "inet_addr_of_string" ->
        let s = make SockaddrInet.t in
        setf s SockaddrInet.sin_family af_inet;
        setf s SockaddrInet.sin_port (Unsigned.UInt16.of_int port);
        inet_pton (int_of_sa_family af_inet) inet_addr (s @. SockaddrInet.sin_addr);
        s
