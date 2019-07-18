open Ctypes

module Def (S : Cstubs.Types.TYPE) = struct
  include S

  let af_inet = constant "AF_INET" int
  let af_inet6 = constant "AF_INET6" int
  let af_unix = constant "AF_UNIX" int
  let af_undefined = constant "AF_UNSPEC" int
  let sockaddr_un_path_len = constant "SUN_PATH_LEN" int
end
