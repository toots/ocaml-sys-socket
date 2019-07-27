module Def (S : Cstubs.Types.TYPE) = struct
  let af_unix = S.constant "AF_UNIX" S.int
  let sun_path_len = S.constant "SUN_PATH_LEN" S.int
  let socklen_t_len = S.constant "SOCKLEN_T_LEN" S.int
end
