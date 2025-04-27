;;; sysinfo is a program which prints system information to STDOUT.
;;; It is meant to be used in bar utilities such as swaybar or i3bar.
(require :uiop)

;; A list of strings defining system commands and their icons.
(defvar command-strings '(("📦" . "apt-get -qs --with-new-pkgs upgrade | grep --count '^Inst'")
                          ("🖪" . "df -h | grep 'nvme0n1p2' | awk '{printf(\"%s/%s %s\", $2, $3, $5)}'")
                          ("🖧" . "nmcli -m tabular -f NAME,TYPE -o c show --active | grep 'wifi' | awk '{print $1}'")
                          ("🛈" . "ip -j a show dev wlan0 | jq '.[0].addr_info[0].local' | sed 's/\"//g'")
                          ("🗓" . "date '+%a %d %b %Y %H:%M:%S'")))

(defun command-output (command-string-pair)
  "Return formatted OUTPUT of COMMAND-STRING execution with an icon attached."
  (multiple-value-bind (output error exit-code)
      (uiop:run-program (cdr command-string-pair)
                        :output '(:string :stripped t)
                        :ignore-error-status t)
    (format nil "~A ~A" (car command-string-pair) output)))

(defun main ()
  "Return text to STDOUT"
  (format t "~{~A | ~}~&" (map 'list #'command-output command-strings)))
