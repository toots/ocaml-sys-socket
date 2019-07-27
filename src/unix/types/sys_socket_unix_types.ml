open Ctypes
open Sys_socket_types

module Constants = Sys_socket_unix_constants.Def(Sys_socket_unix_generated_constants)

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

  module T = SaFamily.T(S)

  let af_unix = SaFamily.sa_family_of_int af_unix


  module SockaddrUnix = struct
    type t = unit

    let t = S.structure "sockaddr_un"
    let sun_family = S.field t "sun_family" T.t
    let sun_path = S.field t "sun_path" (S.array sun_path_len S.char)
    let () = S.seal t
  end

  type sockaddr_un = SockaddrUnix.t structure
  let sockaddr_un_t = SockaddrUnix.t
end
