(defmodule tasker-app
  (behaviour application)
  ;; app implementation
  (export
   (start 2)
   (stop 1))
  (export
   (read-erl-config 1)
   (read-toml-config 1)))

(include-lib "logjam/include/logjam.hrl")

;;; --------------------------
;;; application implementation
;;; --------------------------

(defun start (type args)
  (logger:set_application_level 'tasker 'all)
  (logjam:set-dev-config)
  (let ((cli-args (cli-args)))
    (log-debug "Passed config? ~p" (list (passed-config? cli-args)))
    (log-debug "CLI args: ~p" (list cli-args))
    (log-debug "Default app args: ~p" (list args))
    (case (application:get_all_env)
      ('() (start type args 'default))
      (env (start type env 'override)))))

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

(defun default-cfg-file ()
  (dirs:config '(tasker config.toml)))

(defun cli-args ()
  (let ((supported '(toml config))
        (all (init:get_arguments)))
    (log-debug "System args: ~p" (list all))
    (list-comp ((<- s supported))
      `#(,s ,(proplists:get_value s all 'undefined)))))

(defun passed-config? (args)
  (case (proplists:get_value 'config args 'undefined)
    ('undefined 'false)
    (_ 'true)))

(defun config-file? ()
  (filelib:is_regular (default-cfg-file)))

(defun read-config (filename)
  (read-config filename '()))

(defun read-config (filename args)
  ())

(defun read-erl-config (filename)
  (let ((`#(ok (,data)) (file:consult filename)))
    (proplists:get_value 'tasks
                         (proplists:get_value 'tasker data '())
                         '())))

(defun read-toml-config (filename)
  (let ((`#(ok ,data) (bombadil:read filename)))
    (list-comp ((<- x (maps:values (bombadil:get-in data '(tasker tasks)))))
      (list-comp ((<- `#(,k ,v) (maps:to_list x)))
        `#(,(binary_to_list k) ,v)))))

(defun get-config (cli-args app-args)
  "Order of precedence is:
   * if a CLI -config flag is used to set a value, use that one
   * if not, check for the default location of the config file
   * failing that, use the default defined in the app.src"
  (if (passed-config? cli-args)
    (let ((file (proplists:get_value 'config cli-args)))
      (log-debug "Config file '~s' was explicitly passed; using it ..." (list file))
      (read-config file))
    (if (config-file?)
      (let ((file (default-cfg-file)))
        (log-debug "No config file passed, using default '~s' file ..." (list file))
        (read-config file cli-args))
      ;; XXX
      'tbd)))