open Ctypes
open Sys_socket

include Sys_socket_unix_types.Def(Sys_socket_unix_generated_types)

include Sys_socket_unix_stubs.Def(Sys_socket_unix_generated_stubs)

let from_sockaddr_storage t ptr =
  from_voidp t (to_voidp ptr)

module SockaddrUnix = struct
  include SockaddrUnix
  let from_sockaddr_storage = from_sockaddr_storage t
  let sun_path_len = sun_path_len
end

let to_unix_sockaddr s =
  match !@ (s |-> SockaddrStorage.ss_family) with
    | id when id = af_unix ->
       let s = SockaddrUnix.from_sockaddr_storage s in
       let path =
         !@ (s |-> SockaddrUnix.sun_path)
       in
       let len =
          strnlen (CArray.start path)
            (Unsigned.Size_t.of_int (CArray.length path))
       in       
       let path =
         string_from_ptr (CArray.start path)
           ~length:(Unsigned.Size_t.to_int len)
       in
       Unix.ADDR_UNIX path
    | _ ->
       to_unix_sockaddr s

let from_unix_sockaddr = function 
  | Unix.ADDR_UNIX path ->
      let ss =
        allocate_n SockaddrStorage.t ~count:(sizeof sockaddr_storage_t)
      in
      let path =
        if String.length path > sun_path_len then
          String.sub path 0 sun_path_len
        else
          path
      in
      let path =
        CArray.of_list char (List.of_seq (String.to_seq path))
      in
      let s = SockaddrUnix.from_sockaddr_storage ss in
      (s |-> SockaddrUnix.sun_family) <-@ af_unix;
      (s |-> SockaddrUnix.sun_path) <-@ path;
      ss
  | sockaddr ->
     from_unix_sockaddr sockaddr
