open Ctypes
open Sys_socket

(** Socket types constants. *)
val af_unix     : sa_family

(** IP address conversion functions. *)
val inet_pton : int -> string -> Sockaddr.t ptr -> unit
val inet_ntop : int -> Sockaddr.t ptr -> string

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
