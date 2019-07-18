open Ctypes

include Types.Def(Unix_sys_socket_types)

include Stubs.Def(Unix_sys_socket_stubs)

let inet_pton tag addr ptr =
  match inet_pton tag addr ptr with
    | 1 -> ()
    | _ -> failwith "inet_addr_of_string"

let sockaddr_of_unix_sockaddr = function
  | Unix.ADDR_UNIX path ->
      let path =
        if String.length path > sockaddr_un_path_len then
          String.sub path 0 sockaddr_un_path_len
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
        inet_pton af_inet6 inet_addr (to_voidp (s @. SockaddrInet6.sin6_addr));
        s
      with Failure s when s = "inet_addr_of_string" ->
        let s = make SockaddrInet.t in
         setf s SockaddrInet.sin_family af_inet;
         setf s SockaddrInet.sin_port (Unsigned.UInt16.of_int port);
         inet_pton af_inet inet_addr (to_voidp (s @. SockaddrInet.sin_addr));
         s
