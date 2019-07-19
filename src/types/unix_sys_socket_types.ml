open Ctypes

module Constants = Unix_sys_socket_constants.Def(Unix_sys_socket_generated_constants)

module type SaFamily = sig
  type sa_family
  val int_of_sa_family : sa_family -> int
  val sa_family_of_int : int -> sa_family
  
  module T : functor (S : Cstubs.Types.TYPE) -> sig
    val t : sa_family S.typ
  end
end

let saFamily : (module SaFamily)  =
    match Constants.sa_family_len with
      | 1 ->  (module struct
                 type sa_family = Unsigned.uint8
                 let int_of_sa_family = Unsigned.UInt8.to_int
                 let sa_family_of_int = Unsigned.UInt8.of_int                 
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.uint8_t
                 end
               end)
      | 2 -> (module struct
                 type sa_family = Unsigned.uint16
                 let int_of_sa_family = Unsigned.UInt16.to_int
                 let sa_family_of_int = Unsigned.UInt16.of_int
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.uint16_t
                 end
               end)
      | 4 -> (module struct
                 type sa_family = Unsigned.uint32
                 let int_of_sa_family = Unsigned.UInt32.to_int
                 let sa_family_of_int = Unsigned.UInt32.of_int
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.uint32_t
                 end
               end)
      | 8 -> (module struct
                 type sa_family = Unsigned.uint64
                 let int_of_sa_family = Unsigned.UInt64.to_int
                 let sa_family_of_int = Unsigned.UInt64.of_int
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.uint64_t
                 end
               end)
      | _ -> assert false

module SaFamily = (val saFamily : SaFamily)

module type Socklen = functor (S : Cstubs.Types.TYPE) -> sig
  type socklen
  val socklen_t : socklen S.typ
  val int_of_socklen : socklen -> int
  val socklen_of_int : int -> socklen
end

let socklen : (module Socklen)  =
    match Constants.socklen_t_len with
      | 1 ->  (module functor (S : Cstubs.Types.TYPE) -> struct
                 type socklen = Unsigned.uint8
                 let socklen_t = S.uint8_t
                 let int_of_socklen = Unsigned.UInt8.to_int
                 let socklen_of_int = Unsigned.UInt8.of_int
               end)
      | 2 -> (module functor (S : Cstubs.Types.TYPE) -> struct
                 type socklen = Unsigned.uint16
                 let socklen_t = S.uint16_t
                 let int_of_socklen = Unsigned.UInt16.to_int
                 let socklen_of_int = Unsigned.UInt16.of_int
               end)
      | 4 -> (module functor (S : Cstubs.Types.TYPE) -> struct
                 type socklen = Unsigned.uint32
                 let socklen_t = S.uint32_t
                 let int_of_socklen = Unsigned.UInt32.to_int
                 let socklen_of_int = Unsigned.UInt32.of_int
               end)
      | 8 -> (module functor (S : Cstubs.Types.TYPE) -> struct
                 type socklen = Unsigned.uint32
                 let socklen_t = S.uint32_t
                 let int_of_socklen = Unsigned.UInt32.to_int
                 let socklen_of_int = Unsigned.UInt32.of_int
               end)
      | _ -> assert false

module Socklen = (val socklen : Socklen)

module Def (S : Cstubs.Types.TYPE) = struct
  include Constants

  include Socklen(S)

  type sockaddr = unit
  type sockaddr_s = sockaddr structure

  include SaFamily
  module T = SaFamily.T(S)

  let af_unix = sa_family_of_int af_unix
  let af_inet = sa_family_of_int af_inet
  let af_inet6 = sa_family_of_int af_inet6
  let af_undefined = sa_family_of_int af_undefined

  let sa_family_t = S.typedef T.t "sa_family_t"

  module Sockaddr = struct
    type t = unit
    let t = S.structure "sockaddr"
    let sa_family = S.field t "sa_family" sa_family_t
    let sa_data = S.field t "sa_data" (S.array sa_data_len S.char)
    let () = S.seal t
  end

  module SockaddrUnix = struct
    type t = unit

    let t = S.structure "sockaddr_un"
    let sun_family = S.field t "sun_family" sa_family_t
    let sun_path = S.field t "sun_path" (S.array sun_path_len S.char)
    let () = S.seal t
  end
  
  type in_port_t = Unsigned.uint16
  
  module SockaddrInet = struct
    type in_addr = unit
    type in_addr_s = in_addr structure
    type in_addr_t = Unsigned.uint32
  
    let in_addr = S.structure "in_addr"
    let s_addr = S.field in_addr "s_addr" S.uint32_t
    let () = S.seal in_addr
  
    type t = unit

    let t = S.structure "sockaddr_in"
    let sin_family = S.field t "sin_family" sa_family_t
    let sin_port = S.field t "sin_port" S.uint16_t
    let sin_addr  = S.field t "sin_addr " in_addr
    let () = S.seal t
  end
  
  module SockaddrInet6 = struct
    type in6_addr = unit
    type in6_addr_s = in6_addr structure
    type in6_addr_t = Unsigned.uint8 carray
  
    let in6_addr = S.structure "in6_addr"
    let s6_addr = S.field in6_addr "s6_addr" (S.array 16 S.uint8_t)
    let () = S.seal in6_addr

    type t = unit

    let t = S.structure "sockaddr_in6"
    let sin6_family = S.field t "sin6_family" sa_family_t
    let sin6_port = S.field t "sin6_port" S.uint16_t
    let sin6_flowinfo = S.field t "sin6_flowinfo" S.uint32_t
    let sin6_addr  = S.field t "sin6_addr" in6_addr
    let sin6_scope_id = S.field t "sin6_scope_id" S.uint32_t
    let () = S.seal t
  end
end
