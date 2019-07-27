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

let to_unix_sockaddr s =
  assert false

let from_unix_sockaddr sockaddr = 
  assert false
