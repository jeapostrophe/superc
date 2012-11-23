#lang racket/base
(require ffi/unsafe
         "lang-api.rkt"
         "c-loader.rkt"
         (for-syntax racket/base
                     racket/list
                     racket/port
                     scribble/text/output
                     racket/syntax))

(define-syntax (c stx)
  (syntax-case stx ()
    [(_ c-str ...)
     (set-box! 
      c-strs 
      (append (unbox c-strs)
              (syntax-local-eval #'(list "\n" c-str ... "\n"))))
     (syntax/loc stx
       (void))]))
(define-syntax (cflags stx)
  (syntax-case stx ()
    [(_ c-str ...)
     (set-box! 
      c-flags-strs 
      (append (unbox c-flags-strs)
              (syntax-local-eval #'(list " " c-str ... " "))))
     (syntax/loc stx
       (void))]))
(define-syntax (ldflags stx)
  (syntax-case stx ()
    [(_ c-str ...)
     (set-box! 
      ld-flags-strs 
      (append (unbox ld-flags-strs)
              (syntax-local-eval #'(list " " c-str ... " "))))
     (syntax/loc stx
       (void))]))

(define this-lib-b (box #f))

(define-syntax-rule (get-ffi-obj-from-this sym e ...)
  (get-ffi-obj sym (unbox this-lib-b) e ...))

(define-for-syntax (output-to-string l)
  (with-output-to-string (lambda () (output l))))

(define-syntax (module-begin stx)
  (syntax-case stx ()
    [(_ e ...)
     (with-syntax 
         ([(pmb body ...)
           (local-expand (quasisyntax/loc stx
                           (#%module-begin (require superc/lang-api)
                                           e ...))
                         'module-begin 
                         empty)])
       (quasisyntax/loc stx
         (#%module-begin
          (c-loader this-lib-b
                    #,(output-to-string (unbox c-flags-strs))
                    #,(output-to-string (unbox ld-flags-strs))
                    #,(output-to-string (unbox c-strs)))
          body ...)))]))

(provide c
         cflags
         ldflags
         get-ffi-obj-from-this
         (rename-out [module-begin #%module-begin])
         (except-out (all-from-out racket/base)
                     #%module-begin)
         (for-syntax (all-from-out racket/base))
         (all-from-out ffi/unsafe))
