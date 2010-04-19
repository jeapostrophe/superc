#lang scheme
(require scheme/foreign
         (for-syntax scheme/base
                     scheme/file
                     scheme/system
                     syntax/parse))

(unsafe!)

(define-syntax (c-loader stx)
  (syntax-parse 
   stx 
   [(_ this-lib-b c-flags-string:str ld-flags-string:str c-source-string:str)
    (define gcc-path (find-executable-path "gcc"))
    (define scheme-path (make-temporary-file "superc-tmp~a.ss"))
    (define c-path (path-replace-suffix scheme-path #".c"))
    (define o-path (path-replace-suffix scheme-path #".o"))
    (define dylib-path (path-replace-suffix scheme-path #".dylib"))
    
    (with-output-to-file c-path
      (lambda ()
        (write-string (syntax->datum #'c-source-string)))
      #:exists 'replace)
    
    (if (zero? 
         (system/exit-code 
          (string-append
           (path->string gcc-path)
           " -m32 "
           (syntax->datum #'c-flags-string)
           " -c " (path->string c-path)
           " -o " (path->string o-path))))
        (if (zero?
             (system/exit-code
              (string-append
               (path->string gcc-path)
               " -m32 " " -dynamiclib "
               (syntax->datum #'ld-flags-string)
               " -o " (path->string dylib-path)
               " -dylib " (path->string o-path))))
            (quasisyntax/loc stx
              (set-box! this-lib-b (ffi-lib #,dylib-path)))
            (raise-syntax-error 'c-loader (format "Error linking C object: ~e" o-path)))
        (raise-syntax-error 'c-loader (format "Error compiling C code: ~e" c-path)))]))

(provide c-loader)