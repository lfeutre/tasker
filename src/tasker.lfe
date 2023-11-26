(defmodule tasker
  (behaviour gen_server)
  ;; gen_server implementation
  (export
   (start_link 1)
   (stop 0))
  ;; callback implementation
  (export
   (init 1)
   (handle_call 3)
   (handle_cast 2)
   (handle_continue 2)
   (handle_info 2)
   (terminate 2)
   (code_change 3))
  ;; server API
  (export
   (pid 0)
   (echo 1))
  ;; other
  (export
   (start 0)
   (run 3)))

(include-lib "logjam/include/logjam.hrl")

;;; ----------------
;;; config functions
;;; ----------------

(defun SERVER () (MODULE))
(defun initial-state (tasks) `#m(tasks ,tasks state undefined))
(defun genserver-opts () '())
(defun unknown-command () #(error "Unknown command."))

;;; -------------------------
;;; gen_server implementation
;;; -------------------------

(defun start()
  (application:ensure_all_started 'tasker))

(defun start_link (args)
  (let ((init (initial-state args)))
    (log-debug "Starting gen_server with initial state: ~p" (list init))
    (gen_server:start_link `#(local ,(SERVER))
                           (MODULE)
                           init
                           (genserver-opts))))

(defun stop ()
  (gen_server:call (SERVER) 'stop))

;;; -----------------------
;;; callback implementation
;;; -----------------------

(defun init (state)
  `#(ok ,state #(continue first-run)))

(defun handle_cast (msg state)
  (log-error "Unexpected cast message: ~p" (list msg))
  `#(noreply ,state))

(defun handle_call
  (('stop _from state)
   `#(stop shutdown ok ,state))
  ((`#(echo ,msg) _from state)
   `#(reply ,msg ,state))
  ((msg _from state)
   (log-error "Unexpected call message: ~p" (list msg))
   `#(reply ,(unknown-command) ,state)))

(defun handle_continue
  (('first-run state)
   (run-tasks (self) (mref state 'tasks))
   `#(noreply ,state)))

(defun handle_info
  ((`#(EXIT ,_from normal) state)
   `#(noreply ,state))
  ((`#(EXIT ,pid ,reason) state)
   (log-warning "Process ~p exited! (Reason: ~p)~n" `(,pid ,reason))
   `#(noreply ,state))
  ((`#(stdout ,_pid ,result) state)
   (log-info (lists:droplast (binary_to_list result)))
   `#(noreply ,state))
  ((msg state)
   (log-error "Unexpected info message: ~p" (list msg))
   `#(noreply ,state)))

(defun terminate (_reason _state)
  'ok)

(defun code_change (_old-version state _extra)
  `#(ok ,state))

;;; --------------
;;; our server API
;;; --------------

(defun pid ()
  (erlang:whereis (SERVER)))

(defun echo (msg)
  (gen_server:call (SERVER) `#(echo ,msg)))

;;; -----------------
;;; private functions
;;; -----------------

(defun run-tasks
  ((_ '())
   (log-debug "Finished task kick-off."))
  ((pid `(,task . ,rest))
   (let* ((name (proplists:get_value 'name task))
          (cmd (proplists:get_value 'cmd task))
          (args (proplists:get_value 'args task))
          (interval (proplists:get_value 'interval task))
          (ms (* interval 1000))
          (joined (string:join (lists:append (list cmd) (lists:append args (list "2>&1")))
                               " ")))
     (log-info "Running task ~s (every ~p seconds)" (list name interval))
     (timer:apply_repeatedly ms (MODULE) 'run (list pid name joined))
     (run-tasks pid rest))))

(defun run (pid name task)
  (log-notice "Running task ~s" (list name))
  (log-debug "Executing OS call: ~s" (list task))
  (exec:run task `(#(stderr ,pid) #(stdout ,pid) monitor)))
