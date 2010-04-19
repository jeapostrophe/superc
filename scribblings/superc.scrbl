#lang scribble/doc
@(require scribble/manual
          scribble/basic
          (planet cce/scheme:4:1/planet)
          (for-label (only-in "../lang.ss"
                              c cflags ldflags)))

@title[#:tag "top"]{Super C}
@author[(author+email "Jay McCarthy" "jay@plt-scheme.org")]

@defmodule/this-package[lang]

This package provides a language for writing integrated C and Scheme, it uses the Scribble reader.

There are a few examples in the source of this package in the @filepath{examples} directory.

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

@commandline{gcc -m32 @scheme[_cflags] -c @scheme[_c-source] -o @scheme[_object-file]}

@commandline{gcc -m32 -dynamiclib @scheme[_ldflags] -o @scheme[_dylib-file] -dylib @scheme[_object-file]}

@bold{Warning:} @link["http://en.wikipedia.org/wiki/Super_Contra"]{Super C} is unsafe by nature and currently only supports Mac OS X with Developer Tools. Since MzScheme requires 32-bit on OS X, it can't be used with some obvious libraries.