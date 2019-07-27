open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  module Types = Sys_socket_types.Def(Sys_socket_generated_types)

  open Types

  let getnameinfo = foreign "getnameinfo" (ptr sockaddr_t @-> socklen_t @-> ptr char @-> socklen_t @-> ptr void @-> socklen_t @-> int @-> (returning int))

  let htonl = foreign "htonl" (uint32_t @-> (returning uint32_t))

  let htons = foreign "htons" (uint16_t @-> (returning uint16_t)) 

  let ntohs = foreign "ntohs" (uint16_t @-> (returning uint16_t))

  let ntohl = foreign "ntohl" (uint32_t @-> (returning uint32_t))
end
