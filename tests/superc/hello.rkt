#lang superc

@c{
#include <stdio.h>
 
int main(void)
{
    int x = 0;
    printf("hello, world\n");
    scanf("%d", &x);
    printf("you typed: %d\n", x);
    return 1;
}
}

(define main (get-ffi-obj-from-this 'main (_fun -> _int)))

(printf "The C program returned: ~a~n"
        (main))
