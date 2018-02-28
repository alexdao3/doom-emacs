;;; private/alexdao/autoloads/+haskell.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +camsbury/haskell/add-extension (extension)
  "adds haskell extensions in a friendly way"
  (interactive
   "sExtension name: ")
  (save-excursion
    (evil-goto-first-line)
    (let (has-extensions)
      (setq has-extensions (word-at-point))
      (evil-open-above nil)
      (insert "{-# LANGUAGE ")
      (insert extension)
      (insert " #-}")
      (when
          (equal has-extensions "module")
        (haskell-indentation-newline-and-indent)))
    (evil-normal-state)))

;;;###autoload
(defun +camsbury/haskell/add-import (module qualified)
  "adds haskell imports in a friendly way"
  (interactive
   "sModule name: \nsQualified? ")
  (save-excursion
    (haskell-navigate-imports nil)
    (let (has-imports)
      (setq has-imports (word-at-point))
      (evil-open-above nil)
      (insert "import ")
      (when
          (equal qualified "y")
        (insert "qualified "))
      (insert module)
      (when
          (not (equal has-imports "import"))
        (haskell-indentation-newline-and-indent)))
    (evil-normal-state)))

;;; TODO: Expand this into a very smart macro
;;;###autoload
(defun +camsbury/haskell/evil-open-below ()
  "haskell-friendly evil-open-below"
  (interactive)
  (evil-append-line nil)
  (haskell-indentation-newline-and-indent))
