open Ctypes
open Sys_socket

(** Ctypes routines for C type socklen_t. *)
type socklen
val socklen_t : socklen typ
val int_of_socklen : socklen -> int
val socklen_of_int : int -> socklen

(** Socket types constants. *)
val af_unix     : sa_family

(** Unix socket_un structure. *)
module SockaddrUnix : sig
  type t
  val t : t structure typ
  val sun_family : (sa_family, t structure) field 
  val sun_path : (char carray, t structure) field 
  val sun_path_len : int

  val from_sockaddr_storage : SockaddrStorage.t structure ptr -> t structure ptr
end

type sockaddr_un = SockaddrUnix.t structure
val sockaddr_un_t : sockaddr_un typ

(** Interface with the [Unix] module. *)
val from_unix_sockaddr : Unix.sockaddr -> sockaddr_storage ptr
val to_unix_sockaddr : sockaddr_storage ptr -> Unix.sockaddr
