open Ctypes

module Def (S : Cstubs.Types.TYPE) = struct
  include Constants.Def(Unix_sys_socket_constants)

  include S

  type sockaddr = unit
  type sockaddr_s = sockaddr Ctypes_static.structure
  
  module SockaddrUnix = struct
    let t : sockaddr_s typ = structure "sockaddr_un"
    let sun_family = field t "sun_family" int
    let sun_path = field t "sun_path" (array sockaddr_un_path_len char)
    let () = seal t
  end
  
  type in_port_t = Unsigned.uint16
  
  module SockaddrInet = struct
    type in_addr = unit
    type in_addr_s = in_addr structure
    type in_addr_t = Unsigned.uint32
  
    let in_addr = structure "in_addr"
    let s_addr = field in_addr "s_addr" uint32_t
    let () = seal in_addr
  
    let t = structure "sockaddr_in"
    let sin_family = field t "sin_family" int
    let sin_port = field t "sin_port" uint16_t
    let sin_addr  = field t "sin_addr " in_addr
    let () = seal t
  end
  
  module SockaddrInet6 = struct
    type in6_addr = unit
    type in6_addr_s = in6_addr structure
    type in6_addr_t = Unsigned.uint8 carray
  
    let in6_addr = structure "in6_addr"
    let s6_addr = field in6_addr "s6_addr" (array 16 uint8_t)
    let () = seal in6_addr
  
    let t = structure "sockaddr_in6"
    let sin6_family = field t "sin6_family" int
    let sin6_port = field t "sin6_port" uint16_t
    let sin6_flowinfo = field t "sin6_flowinfo" uint32_t
    let sin6_addr  = field t "sin6_addr" in6_addr
    let sin6_scope_id = field t "sin6_scope_id" uint32_t
    let () = seal t
  end
end
