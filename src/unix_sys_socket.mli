open Ctypes

type sa_family
val af_inet      : sa_family
val af_inet6     : sa_family
val af_unix      : sa_family
val af_undefined : sa_family

val int_of_sa_family : sa_family -> int

val sa_data_len  : int
val sun_path_len : int

type socklen
val socklen_t : socklen typ
val int_of_socklen : socklen -> int
val socklen_of_int : int -> socklen

module Sockaddr : sig
  type t
  val t : t structure typ
  val sa_family : (sa_family, t structure) field
  val sa_data : (char carray, t structure) field
end

type sockaddr = Sockaddr.t structure
val sockaddr_t : sockaddr typ

module SockaddrUnix : sig
  type t
  val t : t structure typ
  val sun_family : (sa_family, t structure) field 
  val sun_path : (char carray, t structure) field 

  val from_sockaddr : Sockaddr.t structure ptr -> t structure ptr
  val to_sockaddr : t structure ptr -> Sockaddr.t structure ptr
end

type sockaddr_un = SockaddrUnix.t structure
val sockaddr_un_t : sockaddr_un typ

type in_port = Unsigned.uint16
val in_port_t : Unsigned.uint16 typ

module SockaddrInet : sig
  type in_addr = Unsigned.uint32
  val in_addr_t : in_addr typ
  val in_addr : in_addr structure typ
  val s_addr : (in_addr, in_addr structure) field

  type t
  val t : t structure typ
  val sin_family : (sa_family, t structure) field
  val sin_port : (in_port, t structure) field
  val sin_addr : (in_addr structure, t structure) field

  val from_sockaddr : Sockaddr.t structure ptr -> t structure ptr
  val to_sockaddr : t structure ptr -> Sockaddr.t structure ptr
end

type sockaddr_in = SockaddrInet.t structure
val sockaddr_in_t : sockaddr_in typ

module SockaddrInet6 : sig
  type in6_addr
  val in6_addr : in6_addr structure typ
  val s6_addr : (in6_addr, in6_addr structure) field

  type t
  val t : t structure typ
  val sin6_family : (sa_family, t structure) field
  val sin6_port : (in_port, t structure) field
  val sin6_flowinfo : (Unsigned.uint32, t structure) field
  val sin6_addr : (in6_addr structure, t structure) field
  val sin6_scope_id : (Unsigned.uint32, t structure) field

  val from_sockaddr : Sockaddr.t structure ptr -> t structure ptr
  val to_sockaddr : t structure ptr -> Sockaddr.t structure ptr
end

type sockaddr_in6 = SockaddrInet6.t structure
val sockaddr_in6_t : sockaddr_in6 typ

val inet_pton : int -> string -> Sockaddr.t ptr -> unit
val inet_ntop : int -> Sockaddr.t ptr -> string

val from_unix_sockaddr : Unix.sockaddr -> sockaddr ptr
val to_unix_sockaddr : sockaddr ptr -> Unix.sockaddr
