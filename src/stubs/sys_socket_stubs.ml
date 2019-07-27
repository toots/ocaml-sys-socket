open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  let htonl = foreign "htonl" (uint32_t @-> (returning uint32_t))

  let htons = foreign "htons" (uint16_t @-> (returning uint16_t)) 

  let ntohs = foreign "ntohs" (uint16_t @-> (returning uint16_t))

  let ntohl = foreign "ntohl" (uint32_t @-> (returning uint32_t))
end
