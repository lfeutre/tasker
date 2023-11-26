(defmodule tasker-app
  (behaviour application)
  ;; app implementation
  (export
   (start 2)
   (stop 1)))

(include-lib "logjam/include/logjam.hrl")

;;; --------------------------
;;; application implementation
;;; --------------------------

(defun start (type args)
  (logger:set_application_level 'tasker 'all)
  (logjam:set-dev-config)
  (log-debug "Default args: ~p" (list args))
  (case (application:get_all_env)
    ('() (start type args 'default))
    (env (start type env 'override)))) 

(defun stop (_state)
  (tasker-sup:stop)
  'ok)

;;; -----------------
;;; private functions
;;; -----------------

(defun start (type args mode)
  (let ((tasks (proplists:get_value 'tasks args)))
    (log-info "Starting tasker application (~p) with tasks: ~p" (list mode tasks))
    (tasker-sup:start_link tasks)))
