open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  let inet_pton = foreign "inet_pton" (int @-> string @-> ptr void @-> (returning int))
end
