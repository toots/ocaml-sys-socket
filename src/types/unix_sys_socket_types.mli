open Ctypes

module Def (S : Cstubs.Types.TYPE) : sig 
  type sa_family

  val int_of_sa_family : sa_family -> int

  val af_inet      : sa_family
  val af_inet6     : sa_family
  val af_unix      : sa_family
  val af_undefined : sa_family
  val sun_path_len : int
  val sa_data_len  : int
  
  type socklen
  val socklen_t : socklen S.typ
  val int_of_socklen : socklen -> int
  val socklen_of_int : int -> socklen

  module Sockaddr : sig
    type t
    val t : t structure S.typ
    val sa_family : (sa_family, t structure) S.field
    val sa_data : (char carray, t structure) S.field
  end
  
  module SockaddrUnix : sig
    type t

    val t : t structure S.typ
    val sun_family : (sa_family, t structure) S.field 
    val sun_path : (char carray, t structure) S.field 
  end
  
  type in_port_t = Unsigned.uint16
  
  module SockaddrInet : sig
    type in_addr
    type in_addr_s = in_addr structure
    type in_addr_t = Unsigned.uint32
  
    val in_addr : in_addr_s S.typ
    val s_addr : (in_addr_t, in_addr_s) S.field
  
    type t

    val t : t structure S.typ
    val sin_family : (sa_family, t structure) S.field
    val sin_port : (in_port_t, t structure) S.field
    val sin_addr : (in_addr_s, t structure) S.field
  end
  
  module SockaddrInet6 : sig
    type in6_addr
    type in6_addr_s = in6_addr structure
    type in6_addr_t = Unsigned.uint8 carray
  
    val in6_addr : in6_addr_s S.typ
    val s6_addr : (in6_addr_t, in6_addr_s) S.field
  
    type t

    val t : t structure S.typ
    val sin6_family : (sa_family, t structure) S.field
    val sin6_port : (in_port_t, t structure) S.field
    val sin6_flowinfo : (Unsigned.uint32, t structure) S.field
    val sin6_addr : (in6_addr_s, t structure) S.field
    val sin6_scope_id : (Unsigned.uint32, t structure) S.field
  end
end
