open Ctypes

include Sys_socket_types.SaFamily

include Sys_socket_stubs.Def(Sys_socket_generated_stubs)

type socket_type = int
let socket_type_t = int

let sock_dgram = Types.sock_dgram
let sock_stream = Types.sock_stream
let sock_seqpacket = Types.sock_seqpacket

let sa_family_t = Types.sa_family_t

let af_inet = Types.af_inet
let af_inet6 = Types.af_inet6
let af_unspec = Types.af_unspec

type socklen = Types.socklen
let socklen_t = Types.socklen_t
let int_of_socklen = Types.int_of_socklen
let socklen_of_int = Types.socklen_of_int

let from_sockaddr_storage t ptr =
  from_voidp t (to_voidp ptr)

module SockaddrStorage = Types.SockaddrStorage

type sockaddr_storage = SockaddrStorage.t structure
let sockaddr_storage_t = SockaddrStorage.t

module Sockaddr = struct
  include Types.Sockaddr
  let from_sockaddr_storage = from_sockaddr_storage t
  let sa_data_len = Types.sa_data_len
end

type sockaddr = Sockaddr.t structure
let sockaddr_t = Sockaddr.t

type in_port = Unsigned.uint16
let in_port_t = uint16_t

module SockaddrInet = struct
  include Types.SockaddrInet
  let from_sockaddr_storage = from_sockaddr_storage t
end

type sockaddr_in = SockaddrInet.t structure
let sockaddr_in_t = SockaddrInet.t

module SockaddrInet6 = struct
  include Types.SockaddrInet6
  let from_sockaddr_storage = from_sockaddr_storage t
end

type sockaddr_in6 = SockaddrInet6.t structure
let sockaddr_in6_t = SockaddrInet6.t

let getnameinfo sockaddr_ptr =
  let maxhost = Types.ni_maxhost in
  let s = allocate_n char ~count:maxhost in
  match getnameinfo sockaddr_ptr (socklen_of_int (sizeof sockaddr_t))
                    s (socklen_of_int maxhost) 
                    null (socklen_of_int 0) Types.ni_numerichost with
    | 0 ->
      let length =
        Unsigned.Size_t.to_int
          (strnlen s (Unsigned.Size_t.of_int Types.ni_maxhost))
      in
      string_from_ptr s ~length
    | _ -> failwith "inet_addr_of_string"
