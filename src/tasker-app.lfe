(defmodule tasker-app
  (behaviour application)
  ;; app implementation
  (export
   (start 2)
   (stop 1)))

;;; --------------------------
;;; application implementation
;;; --------------------------

(defun start (_type _args)
  (logger:set_application_level 'tasker 'all)
  (logger:info "Starting tasker application ...")
  (tasker-sup:start_link))

(defun stop (_state)
  (tasker-sup:stop)
  'ok)
