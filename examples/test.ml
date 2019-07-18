let () =
  let inet_addr =
    Unix.inet_addr_of_string "127.0.0.1"
  in
  let sockaddr =
    Unix_sys_socket.sockaddr_of_unix_sockaddr (Unix.ADDR_INET (inet_addr,80))
  in
  Printf.printf "sockaddr_in.sin_addr.s_addr = %d\n%!"
    (Unsigned.UInt32.to_int
      (Ctypes.getf
        (Ctypes.getf sockaddr Unix_sys_socket.SockaddrInet.sin_addr)
          Unix_sys_socket.SockaddrInet.s_addr))  
