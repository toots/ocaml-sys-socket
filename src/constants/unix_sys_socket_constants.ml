module Def (S : Cstubs.Types.TYPE) = struct
  let af_inet = S.constant "AF_INET" S.int
  let af_inet6 = S.constant "AF_INET6" S.int
  let af_unix = S.constant "AF_UNIX" S.int
  let af_undefined = S.constant "AF_UNSPEC" S.int
  let sun_path_len = S.constant "SUN_PATH_LEN" S.int
  let sa_data_len = S.constant "SA_DATA_LEN" S.int
  let sa_family_len = S.constant "SA_FAMILY_LEN" S.int
end
