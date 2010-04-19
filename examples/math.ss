#lang planet jaymccarthy/superc

@c{
 #include <stdio.h>
 #include <math.h>
}

(define-for-syntax y 6)

@c{
int main(void) {
 printf("The Scheme program contains: @|y|\n");
 return cos(M_PI);
}
}

(define main (get-ffi-obj-from-this 'main (_fun -> _int)))

(printf "The C program returned: ~a~n"
        (main))