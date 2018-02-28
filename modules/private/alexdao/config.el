;;; private/alexdao/config.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (featurep 'evil)
  (load! +bindings)
  (load! +company)
  (load! +evil)
  (load! +text-objects)
 (load! +functions))
(after! doom-themes
  ;; Since Fira Mono doesn't have an italicized variant, highlight it instead
  (set-face-attribute 'italic nil
                      :weight 'ultra-light
                      :foreground "#ffffff"
                      :background (doom-color 'current-line)))
;; FONT
(setq doom-font (font-spec :family "Operator Mono" :size 13)
      doom-variable-pitch-font (font-spec :family "Operator Mono")
      doom-unicode-font (font-spec :family "Operator Mono")
      doom-big-font (font-spec :family "Operator Mono" :size 19))
(setq initial-buffer-choice "~/dev/urbint")
;; TODO: define
(setq +ivy-buffer-icons t)
;; TODO: ensure utility
(defvar +cam-dir
  (file-name-directory load-file-name))
;; TODO: ensure utility
(set-register ?d '(file . "~/projects/dotfiles/"))
(set-register ?u '(file . "~/projects/urbint/"))
;; TODO: define
(setq backup-directory-alist `(("." . "~/.emacs-tmp/")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs-tmp/" t)))
;; TODO: define & compare to init.el
;; config Emacs to use $PATH values
(def-package! exec-path-from-shell
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)))
;; TODO: test with git & define
(global-auto-revert-mode t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Syntax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Spaces over tabs TODO: define details
(setq c-basic-indent 2)
(setq c-default-style "linux")
(setq tab-width 2)
(setq-default indent-tabs-mode nil)
;; Turn off line wrapping TODO: test
(setq-default truncate-lines 1)
;; TODO: delete-trailing-whitespace vs whitespace-cleanup
(add-hook 'before-save-hook 'whitespace-cleanup)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language Specific
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; haskell TODO: test & define
(def-package! intero
  :after haskell-mode
  :config
  (intero-global-mode 1)
  (eldoc-mode)
  (flycheck-add-next-checker 'intero 'haskell-hlint))
(add-hook! haskell-mode
  (setq
   whitespace-line-column 100
   whitespace-style
   '(face trailing lines-tail))
  (whitespace-mode t)
  (rainbow-delimiters-mode)
)
;; javascript
(setq js-indent-level 2)

(add-hook! js-mode
  (flycheck-mode)
  (rainbow-delimiters-mode)
  )
(def-package! flow-minor-mode
  :config
  (add-hook 'js2-mode-hook #'flow-minor-mode))
(def-package! company-flow
  :init
  (defun flow/set-flow-executable ()
    (interactive)
    (let* ((root (locate-dominating-file buffer-file-name  "node_modules/flow-bin"))
           (executable (car (file-expand-wildcards
                             (concat root "node_modules/flow-bin/*osx*/flow")))))
      (setq-local company-flow-executable executable)
      ;; These are not necessary for this package, but a good idea if you use
      ;; these other packages
      (setq-local flow-minor-default-binary executable)
      (setq-local flycheck-javascript-flow-executable executable)))
  :config
  (add-hook 'rjsx-mode-hook #'flow/set-flow-executable)
  (add-to-list 'company-flow-modes 'rjsx-mode)
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-flow)))
(def-package! flycheck-flow
  :config
  (with-eval-after-load 'flycheck
    (flycheck-add-mode 'javascript-flow 'rjsx-mode)
    (flycheck-add-mode 'javascript-flow 'flow-minor-mode)
    (flycheck-add-mode 'javascript-eslint 'flow-minor-mode)
    (flycheck-add-next-checker 'javascript-flow 'javascript-eslint)))

    ;; (evil-leader/set-key
    ;;   "i" #'helm-semantic-or-imenu
    ;;   "j" #'jump-to-register
    ;;   "h" #'help
    ;;   "t" #'wpc/toggle-between-js-test-and-module
    ;;   "p" #'counsel-git-grep
    ;;   "f" #'wpc/find-file
    ;;   "b" #'ivy-switch-buffer
    ;;   "es" wpcarro/create-snippet
    ;;   "ev" wpcarro/edit-init-el
    ;;   "B" #'ibuffer
    ;;   "w" #'ace-select-window))

;; eslint integration with flycheck
(setq flycheck-javascript-eslint-executable "~/dev/urbint/frontend/grid-front-end/node_modules/.bin/eslint")
;; general css settings
(setq css-indent-offset 2)
(def-package! prettier-js
  :config
  (add-hook 'js2-mode-hook #'prettier-js-mode)
  (add-hook 'json-mode-hook #'prettier-js-mode)
  (add-hook 'css-mode-hook #'prettier-js-mode))
(def-package! rjsx-mode
  :bind (:map rjsx-mode-map
              ("<" . nil)
              ("C-d" . nil)
              (">" . nil))
  :config
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode)))
;; (let (m-symbols
;;       '(("`mappend`" . "⊕")
;;         ("<>"        . "⊕")))
;;   (dolist (item m-symbols) (add-to-list 'haskell-font-lock-symbols-alist item)))
;; (setq haskell-font-lock-symbols t)
;; Cameron BS TODO: test
(custom-set-variables
 '(haskell-process-suggest-hoogle-imports t))
;; rust
(add-hook! rust-mode
  (flycheck-mode)
  (rainbow-delimiters-mode)
  )
;; elixir
(add-hook! elixir-mode
  (whitespace-mode t)
  (setq whitespace-line-column 100)
  (setq whitespace-style '(face lines-tail))
  (flycheck-mode)
  (turn-off-smartparens-mode)
  (rainbow-delimiters-mode))
(def-package! flycheck-credo
  :after elixir-mode
  :config
  (setq flycheck-elixir-credo-strict t)
  (add-hook 'flycheck-mode-hook #'flycheck-credo-setup))
;; emacs-lisp
(add-hook! :append 'emacs-lisp-mode-hook 'turn-off-smartparens-mode)
(add-hook! :append 'emacs-lisp-mode-hook (flycheck-mode 0))

