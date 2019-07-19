let () =
  Printf.printf "sizeof(socklen_t) = %d\n%!" (Ctypes.sizeof Unix_sys_socket.socklen_t);
  let inet_addr =
    Unix.inet_addr_of_string "127.0.0.1"
  in
  let sockaddr =
    Unix_sys_socket.from_unix_sockaddr (Unix.ADDR_INET (inet_addr,80))
  in
  Printf.printf "sockaddr_in.sa_family = %d\n%!"
    (Unix_sys_socket.int_of_sa_family
      (Ctypes.getf sockaddr Unix_sys_socket.Sockaddr.sa_family));
  let sockaddr_in =
    Unix_sys_socket.SockaddrInet.from_sockaddr sockaddr
  in
  Printf.printf "sockaddr_in.sin_addr.s_addr = %d\n%!"
    (Unsigned.UInt32.to_int
      (Ctypes.getf
        (Ctypes.getf sockaddr_in Unix_sys_socket.SockaddrInet.sin_addr)
          Unix_sys_socket.SockaddrInet.s_addr));
  let unix_socket =
    Unix_sys_socket.to_unix_sockaddr sockaddr
  in
  match unix_socket with
    | Unix.ADDR_INET (inet_addr,port) ->
         Printf.printf "Unix.ADDR_INET(%s,%d)\n%!" (Unix.string_of_inet_addr inet_addr) port 
    | _ -> assert false
