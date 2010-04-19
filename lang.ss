#lang scheme
(require scheme/foreign
         "lang-api.ss"
         "c-loader.ss"
         (for-syntax scheme
                     scribble/text/output
                     unstable/syntax
                     (planet cce/scheme:4:1/planet)))
(unsafe!)

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
                           (#%module-begin (require (planet #,(this-package-version-symbol lang-api)))
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
         (except-out (all-from-out scheme)
                     #%module-begin)
         (all-from-out scheme/foreign))
