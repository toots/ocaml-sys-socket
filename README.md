# unix-sys-socket

This OCaml module provides access to the features exposed in sys/socket.h

The interface is implemented using [ocaml-ctypes](https://github.com/ocamllabs/ocaml-ctypes) is intended
to exposed the machine-specific, low-level details of the most important parts of POSIX's specifications
of the following headers:
* [sys/sock.h](https://pubs.opengroup.org/onlinepubs/009695399/basedefs/sys/socket.h.html)
* [sys/un.h](http://pubs.opengroup.org/onlinepubs/009695399/basedefs/sys/un.h.html)
* [netinet/in.h](https://pubs.opengroup.org/onlinepubs/009695399/basedefs/netinet/in.h.html)

Its API mirrors as much as possible the original POSIX definitions, including integers representation (network bytes order,
host byte order). It is defined in [unix_sys_socket.mli](src/unix_sys_socket.mli)

Happy hacking!
