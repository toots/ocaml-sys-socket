open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  let strnlen = foreign "strnlen" (ptr char @-> size_t @-> (returning size_t))
end
