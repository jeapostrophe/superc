#lang scribble/doc
@(require scribble/manual
          scribble/basic
          (for-label (only-in "../lang.rkt"
                              c cflags ldflags)))

@title[#:tag "top"]{Super C}
@author[(author+email "Jay McCarthy" "jay@racket-lang.org")]

@defmodulelang[superc #:use-sources (superc/lang)]

This package provides a language for writing integrated C and Racket, it uses the Scribble reader.

There are a few examples in the source of this package in the @filepath{tests/superc} directory.

A Super C program may contain any number of the following calls:

@defform[(c expr ...)]{
 Specifies some C code that is evaluated at expansion time to strings.
 
 Each C block is appended together to construct the C source.
}

@defform[(cflags expr ...)]{
 Specifies some flags to the C compiler code that is evaluated at expansion time to strings.
 
 Each set of flags is appended together to construct the C flags.
}

@defform[(ldflags expr ...)]{
 Specifies some flags to the C linker code that is evaluated at expansion time to strings.
 
 Each set of flags is appended together to construct the LD flags.
}

The C portion of the Super C program is compiled and linked by GCC with the following flags:

@commandline{gcc @racket[_cflags] -fPIC -c @racket[_c-source] -o @racket[_object-file]}

@commandline{gcc -shared @racket[_ldflags] @racket[_object-file] -o @racket[_dylib-file]}

@bold{Warning:}
@link["http://en.wikipedia.org/wiki/Super_Contra"]{Super C} is unsafe
by nature and only tested on Linux with GCC.
