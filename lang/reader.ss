#lang s-exp syntax/module-reader
#:language `(planet ,(this-package-version-symbol lang))
#:read        scribble:read
#:read-syntax scribble:read-syntax
#:whole-body-readers? #f
;#:wrapper1 (lambda (t) (list* 'doc 'values '() (t)))

(require (planet cce/scheme:4:1/planet)
         (prefix-in scribble: scribble/reader))