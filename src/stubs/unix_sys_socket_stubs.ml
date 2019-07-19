open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  let inet_pton = foreign "inet_pton" (int @-> string @-> ptr void @-> (returning int))

  let inet_ntop = foreign "inet_ntop" (int @-> ptr void @-> ocaml_bytes @-> int @-> (returning string))

  let strnlen = foreign "strnlen" (ptr char @-> size_t @-> (returning size_t))
end
