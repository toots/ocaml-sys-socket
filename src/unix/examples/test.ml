open Ctypes
open Sys_socket
open Sys_socket_unix

let () =
  Printf.printf "sizeof(socklen_t) = %d\n%!" (sizeof socklen_t)

let () =
  let ss =
    from_unix_sockaddr (Unix.ADDR_UNIX "/path/to/socket")
  in
  let sockaddr = SockaddrUnix.from_sockaddr_storage ss in
  Printf.printf "sockaddr_un.sun_family = %d\n%!"
    (int_of_sa_family
      (!@ (sockaddr |-> SockaddrUnix.sun_family)));
  let unix_socket =
    to_unix_sockaddr ss
  in
  match unix_socket with
    | Unix.ADDR_UNIX path ->
         Printf.printf "Unix.ADDR_UNIX(%S)\n%!" path
    | _ -> assert false
