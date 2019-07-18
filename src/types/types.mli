open Ctypes

module Def (S : Cstubs.Types.TYPE) : sig 
  val af_inet      : int
  val af_inet6     : int
  val af_unix      : int
  val af_undefined : int
  val sockaddr_un_path_len : int
  
  type sockaddr
  type sockaddr_s = sockaddr structure
  
  module SockaddrUnix : sig
    val t : sockaddr_s S.typ
    val sun_family : (int, sockaddr_s) S.field 
    val sun_path : (char carray, sockaddr_s) S.field 
  end
  
  type in_port_t = Unsigned.uint16
  
  module SockaddrInet : sig
    type in_addr
    type in_addr_s = in_addr structure
    type in_addr_t = Unsigned.uint32
  
    val in_addr : in_addr_s S.typ
    val s_addr : (in_addr_t, in_addr_s) S.field
  
    val t : sockaddr_s S.typ
    val sin_family : (int, sockaddr_s) S.field
    val sin_port : (in_port_t, sockaddr_s) S.field
    val sin_addr : (in_addr_s, sockaddr_s) S.field
  end
  
  module SockaddrInet6 : sig
    type in6_addr
    type in6_addr_s = in6_addr structure
    type in6_addr_t = Unsigned.uint8 carray
  
    val in6_addr : in6_addr_s S.typ
    val s6_addr : (in6_addr_t, in6_addr_s) S.field
  
    val t : sockaddr_s S.typ
    val sin6_family : (int, sockaddr_s) S.field
    val sin6_port : (in_port_t, sockaddr_s) S.field
    val sin6_flowinfo : (Unsigned.uint32, sockaddr_s) S.field
    val sin6_addr : (in6_addr_s, sockaddr_s) S.field
    val sin6_scope_id : (Unsigned.uint32, sockaddr_s) S.field
  end
end
