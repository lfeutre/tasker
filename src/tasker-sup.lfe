(defmodule tasker-sup
  (behaviour supervisor)
  ;; supervisor implementation
  (export
   (start_link 1)
   (stop 0))
  ;; callback implementation
  (export
    (init 1)))

(include-lib "logjam/include/logjam.hrl")

;;; ----------------
;;; config functions
;;; ----------------

(defun SERVER () (MODULE))
(defun sup-flags ()
  `#m(strategy one_for_one
      intensity 3
      period 60))

;;; -------------------------
;;; supervisor implementation
;;; -------------------------

(defun start_link (args)
  (supervisor:start_link `#(local ,(SERVER))
                         (MODULE)
                         args))

(defun stop ()
  (gen_server:call (SERVER) 'stop))

;;; -----------------------
;;; callback implementation
;;; -----------------------

(defun init (args)
  (log-debug "Initialising supervisor with args: ~p" (list args))
  (let ((cfg `#(ok #(,(sup-flags) (,(child 'tasker 'start_link args))))))
    (log-debug "init cfg data: ~p" (list cfg))
    cfg))

;;; -----------------
;;; private functions
;;; -----------------

(defun child (mod fun args)
  `#M(id ,mod
      start #(,mod ,fun (,args))
      restart permanent
      shutdown 2000
      type worker
      modules (,mod)))
