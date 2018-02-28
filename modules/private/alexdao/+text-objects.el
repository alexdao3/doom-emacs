;;; private/alexdao/+text-objects.el -*- lexical-binding: t; -*-

(defmacro define-and-bind-text-object (key start-regex end-regex)
  (let ((inner-name (make-symbol "inner-name"))
        (outer-name (make-symbol "outer-name")))
    `(progn
       (evil-define-text-object ,inner-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count nil))
       (evil-define-text-object ,outer-name (count &optional beg end type)
         (evil-select-paren ,start-regex ,end-regex beg end type count t))
       (define-key evil-inner-text-objects-map ,key (quote ,inner-name))
       (define-key evil-outer-text-objects-map ,key (quote ,outer-name)))))

(define-and-bind-text-object "l" "^\\s-*" "\\s-*$") ;; lines
(define-and-bind-text-object "e" "\\`\\s-*" "\\s-*\\'") ;; entire buffers
(define-and-bind-text-object "c" "^--\\s-*" "\\s-*$") ;; comment
(define-and-bind-text-object "F" "=> *" "\\s-*$") ;; JS arrow functions
(define-and-bind-text-object "f" "{" "}") ;; JS functions (won't work properly from inside if-statement)
