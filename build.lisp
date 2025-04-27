(require :asdf)
(require :uiop)
(load "~/.sbclrc")
(asdf:load-asd (concatenate 'string (uiop:unix-namestring (uiop:getcwd)) "/sysinfo.asd"))
(ql:quickload "sysinfo")
(sb-ext:save-lisp-and-die #p"sysinfo"
                          :toplevel #'main
                          :executable t
                          :compression 22)
