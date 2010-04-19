#lang scheme
(require (for-syntax scheme))

(define-for-syntax c-strs 
  (box empty))

(define-for-syntax c-flags-strs
  (box empty))

(define-for-syntax ld-flags-strs
  (box empty))

(provide (for-syntax c-strs
                     c-flags-strs
                     ld-flags-strs))