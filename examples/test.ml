open Ctypes
open Sys_socket

let () =
  let inet_addr =
    Unix.inet_addr_of_string "0.0.0.1"
  in
  let ss =
    from_unix_sockaddr (Unix.ADDR_INET (inet_addr,80))
  in
  let sockaddr = Sockaddr.from_sockaddr_storage ss in
  Printf.printf "sockaddr.sa_family = %d\n%!"
    (int_of_sa_family
      (!@ (sockaddr |-> Sockaddr.sa_family)));
  let sockaddr_in =
    SockaddrInet.from_sockaddr_storage ss
  in
  Printf.printf "sockaddr_in.sin_addr.s_addr = %d\n%!"
    (Unsigned.UInt32.to_int
      (ntohl
        (!@ ((sockaddr_in |-> SockaddrInet.sin_addr) |-> SockaddrInet.s_addr))));
  let unix_socket =
    to_unix_sockaddr ss
  in
  match unix_socket with
    | Unix.ADDR_INET (inet_addr,port) ->
         Printf.printf "Unix.ADDR_INET(%S,%d)\n%!" (Unix.string_of_inet_addr inet_addr) port 
    | _ -> assert false
