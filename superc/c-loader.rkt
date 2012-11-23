#lang racket/base
(require ffi/unsafe
         (for-syntax racket/base
                     racket/file
                     racket/system
                     syntax/parse))

(define-syntax (c-loader stx)
  (syntax-parse 
   stx 
   [(_ this-lib-b c-flags-string:str ld-flags-string:str c-source-string:str)
    (define gcc-path (find-executable-path "gcc"))
    (define racket-path (make-temporary-file "superc-tmp~a.ss"))
    (define c-path (path-replace-suffix racket-path #".c"))
    (define o-path (path-replace-suffix racket-path #".o"))
    (define so-path (path-replace-suffix racket-path #".so"))

    (define (system/exit-code* s)
      ;; (eprintf "Running: ~a\n" s)
      (system/exit-code s))
    
    (with-output-to-file c-path
      (lambda ()
        (write-string (syntax->datum #'c-source-string)))
      #:exists 'replace)
    
    (if (zero? 
         (system/exit-code*
          (string-append
           (path->string gcc-path)
           (syntax->datum #'c-flags-string)
           " -fPIC "
           " -c " (path->string c-path)
           " -o " (path->string o-path))))
        (if (zero?
             (system/exit-code*
              (string-append
               (path->string gcc-path)
               " -shared "
               (syntax->datum #'ld-flags-string)
               (path->string o-path)
               " -o " (path->string so-path))))
            (quasisyntax/loc stx
              (set-box! this-lib-b (ffi-lib #,so-path)))
            (raise-syntax-error 'c-loader (format "Error linking C object: ~e" o-path)))
        (raise-syntax-error 'c-loader (format "Error compiling C code: ~e" c-path)))]))

(provide c-loader)
