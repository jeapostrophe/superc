#lang setup/infotab
(define name "Super C")
(define blurb
  (list "A language for writing integrated C and Scheme"))
(define scribblings '(["scribblings/superc.scrbl" (multi-page)]))
(define categories '(devtools))
(define primary-file "lang.ss")
(define compile-omit-paths '("examples"))
(define release-notes (list))
(define repositories '("4.x"))
