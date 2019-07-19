let c_headers = "
#include <sys/socket.h>
#include <sys/un.h>
#define SUN_PATH_LEN (sizeof(((struct sockaddr_un *)0)->sun_path))
#define SA_DATA_LEN (sizeof(((struct sockaddr*)0)->sa_data))
#define SA_FAMILY_LEN (sizeof(((struct sockaddr*)0)->sa_family))
#define SOCKLEN_T_LEN (sizeof(socklen_t))
"

let () =
  let fname = Sys.argv.(1) in
  let oc = open_out_bin fname in
  let format =
    Format.formatter_of_out_channel oc
  in
  Format.fprintf format "%s@\n" c_headers;
  Cstubs.Types.write_c format (module Unix_sys_socket_constants.Def);
  Format.pp_print_flush format ();
  close_out oc
