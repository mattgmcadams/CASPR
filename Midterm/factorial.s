#PURPOSE - Given a number, this program computes the
#          factorial. For example, the factorial of
#          3 is 3 * 2 * 1, or 6. The factorial of
#          4 is 4 * 3 * 2 * 1, or 24, and so on.
#

#This program shows how to call a function recursively.

.section .data

# This program has no data

.section .text

.globl _start
.globl factorial # this is unneeded unless we want to share
                 # this function among other progs

_start:
    push    $4              # The factorial takes one argument - the 
                            # number we want a factorial of. So, it
                            # gets pushed
    call    factorial       # run the factorial function
    addq    $4,     %rsp    # Scrubs the parameter that was pushed on
                            # the stack
    movl    %eax,   %ebx    # factorial returns the answer in %eax, but
                            # we want it in %ebx to send it as our exit
                            # status
    movl    $1,     %eax    # call the kernel’s exit function
    int     $0x80           


    # This is the actual function definition
    .type factorial,@function
factorial:
    pushq   %ebp            # standard function stuff - we have to
                            # restore %ebp to its prior state before
                            # returning, so we have to push it
    movq    %esp,   %ebp
    movq    8(%ebp), %eax
    
    cmpl    $1,     %eax
    je      end_factorial
    decl    %eax
    pushl   %eax
    call    factorial
    movl    8(%ebp), %ebx
    imull   %ebx,   %eax
end_factorial:
    ret
