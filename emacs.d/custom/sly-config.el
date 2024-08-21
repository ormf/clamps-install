;; ======== SLY ============================================================
(setq lisp-mode-hook (remove 'slime-lisp-mode-hook lisp-mode-hook))
(require 'sly)
(require 'sly-autoloads)

(setq inferior-lisp-program "/usr/bin/sbcl")
;;; (setq inferior-lisp-program "/usr/local/bin/cm-all")

(setq sly-lisp-implementations
      '((sbcl ("/usr/bin/sbcl") :coding-system utf-8-unix)
        (clamps ("/usr/local/bin/clamps") :coding-system utf-8-unix)))

(setq sly-use-autodoc-mode t)

(add-hook
 'lisp-mode-hook
 (lambda ()
   (recentf-mode t)
   (company-mode t)
   (rainbow-delimiters-mode t)
   (paredit-mode t)
   (define-key sly-mode-map (kbd "C-c C-y") 'sly-mrepl)
   (define-key sly-mode-map (kbd "\C-c\C-dc") 'cm-lookup)
   (define-key sly-mode-map (kbd "C-.") 'incudine-hush)
   (define-key sly-mode-map (kbd "C-c C-.") 'incudine-rt-stop)
   (define-key sly-mode-map (kbd "C-c M-.") 'incudine-rt-start)
   (define-key sly-mode-map (kbd "C-c t") 'test-midi)
   (define-key sly-mode-map (kbd "C-c C-d l") 'cltl2-view-function-definition)
   (define-key sly-mode-map (kbd "C-c C-d h") 'hyperspec-lookup)))

(eval-after-load 'paredit
       '(progn
          (define-key paredit-mode-map (kbd "RET") nil)
          (define-key paredit-mode-map (kbd "C-j") 'paredit-newline)))

(setq sly-enable-evaluate-in-emacs t)

(defun std-incudine-hush ()
  (interactive)
  (progn
    (sly-interactive-eval "(incudine:flush-pending)")
    (sly-interactive-eval "(dotimes (chan 16) (cm::sprout (cm::new cm::midi-control-change :time 0 :controller 123 :value 127 :channel chan)))")
    (sly-interactive-eval "(incudine::node-free-unprotected)")
;;;    (sly-interactive-eval "(scratch::node-free-all)")
    ))

(defun cm-incudine-hush ()
  (interactive)
  (progn
    (sly-interactive-eval "(cm::rts-hush)")
;;;    (sly-interactive-eval "(scratch::node-free-all)")
    ))

(defun set-std-incudine-hush ()
  (interactive)
  (setq incudine-hush (symbol-function 'std-incudine-hush)))

(defun set-cm-incudine-hush ()
  (interactive)
  (setq incudine-hush (symbol-function 'cm-incudine-hush)))

(defun incudine-rt-start ()
  (interactive)
  (sly-interactive-eval "(incudine:rt-start)"))

(defun incudine-rt-stop ()
  (interactive)
  (sly-interactive-eval "(incudine:rt-stop)"))

(defun install-incudine-hooks ()
  (interactive)
  (sly-interactive-eval "(when (find-package :cm-all)
    (call-sly-connected-hooks))"))

;;; (setq sly-connected-hook '(install-incudine-hooks sly-mrepl-on-connection))

(setq sly-connected-hook
      (cons 'install-incudine-hooks sly-connected-hook))

(defun test-midi ()
  (interactive)
  (sly-interactive-eval "(cm::testmidi)"))

(set-cm-incudine-hush)

(global-set-key "\C-x\C-l" 'sly)

(add-hook
 'sly-mrepl-mode-hook
 (lambda ()
   (recentf-mode t)
   (company-mode t)
   (rainbow-delimiters-mode t)
   (paredit-mode t)
   (define-key sly-mrepl-mode-map (kbd "C-<up>") 'sly-mrepl-previous-input-or-button)
   (define-key sly-mrepl-mode-map (kbd "C-<down>") 'sly-mrepl-next-input-or-button)
   (define-key sly-mrepl-mode-map (kbd "\C-c\C-dc") 'cm-lookup)
   (define-key sly-mrepl-mode-map (kbd "\C-c\C-dc") 'cm-lookup)
   (define-key sly-mrepl-mode-map (kbd "C-.") 'incudine-hush)
   (define-key sly-mrepl-mode-map (kbd "C-c C-.") 'incudine-rt-stop)
   (define-key sly-mrepl-mode-map (kbd "C-c M-.") 'incudine-rt-start)
   (define-key sly-mrepl-mode-map (kbd "C-c t") 'test-midi)
   (define-key sly-mrepl-mode-map (kbd "C-c C-d l") 'cltl2-view-function-definition)
   (define-key sly-mrepl-mode-map (kbd "C-c C-d h") 'hyperspec-lookup)))

(add-to-list 'load-path "~/quicklisp/local-projects/clamps/extra/elisp")
(require 'cm)
(load "clamps.el")
(load "cm-dict.el")
(load "clamps-dict.el")
(load (expand-file-name "~/quicklisp/clhs-use-local.el") t)
(sly)

;; ======== End SLY ============================================================

