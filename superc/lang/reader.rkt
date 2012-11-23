#lang s-exp syntax/module-reader
#:language `superc/lang
#:read        scribble:read
#:read-syntax scribble:read-syntax
#:whole-body-readers? #f
;#:wrapper1 (lambda (t) (list* 'doc 'values '() (t)))

(require (prefix-in scribble: scribble/reader))
