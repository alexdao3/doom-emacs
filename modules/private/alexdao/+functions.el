;;; private/alexdao/+functions.el -*- lexical-binding: t; -*-

(defun wpc/insert-flow-annotation ()
    ;; Inserts a flow type annotation to the beginning of a buffer.
    (interactive)
    (save-excursion
      (beginning-of-buffer)
      (insert "// @flow\n")))

(defun wpc/find-or-create-js-test ()
  (->> buffer-file-name
       (s-chop-suffix ".js")
       (s-append ".test.js")
       (find-file)))

(defun wpc/find-or-create-js-module ()
  (->> buffer-file-name
       (s-chop-suffix ".test.js")
       (s-append ".js")
       (find-file)))

(defun wpc/toggle-between-js-test-and-module ()
  "Toggle between a Javascript test or module."
  (interactive)
  (if (s-ends-with? ".test.js" buffer-file-name)
      (wpc/find-or-create-js-module)
    (if (s-ends-with? ".js" buffer-file-name)
        (wpc/find-or-create-js-test)
      (message "Not in a Javascript file. Exiting..."))))

(setq wpcarro/create-snippet (lambda ()
                                  (interactive)
                                  (require 'evil)
                                  (require 'yasnippet)
                                  (evil-window-vsplit)
                                  (call-interactively #'yas-new-snippet)))

;;(evil-leader/set-key-for-mode 'rjsx-mode "if" #'wpc/insert-flow-annotation)
;;(evil-define-key 'normal rjsx-mode-map (kbd "K") #'flow-minor-type-at-pos)
;;    (evil-leader/set-key-for-mode 'rjsx-mode "t" #'wpc/toggle-between-js-test-and-module)
;;
;;
   ;; (setq wpcarro/create-snippet (lambda ()
   ;;                                (interactive)
   ;;                                (require 'evil)
   ;;                                (require 'yasnippet)
   ;;                                (evil-window-vsplit)
   ;;                                (call-interactively #'yas-new-snippet)))
;;
;;
;;
;;;; inside of flycheck-flow
;;    (evil-leader/set-key
;;      "i" #'helm-semantic-or-imenu
;;      "j" #'jump-to-register
;;      "h" #'help
;;      "t" #'wpc/toggle-between-js-test-and-module
;;      "p" #'counsel-git-grep
;;      "f" #'wpc/find-file
;;      "b" #'ivy-switch-buffer
;;      "es" wpcarro/create-snippet
;;      "ev" wpcarro/edit-init-el
;;      "B" #'ibuffer
;;      "w" #'ace-select-window)))
