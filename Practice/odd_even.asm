extern printf
extern scanf

SECTION .data

a: dq 0

enter: db "Enter a number: ",0
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%s",10,0
odd: db "ODD",0
even: db "EVEN",0


SECTION .text

global main

main:
    
    push rbp

    mov rax,0
    mov rdi,first_fmt
    mov rsi, enter
    call printf

    mov rdi,int_fmt
    mov rsi, a
    call scanf


    mov rax,0
    mov rax,[a]
    mov rbx , 2

    cqo

    idiv rbx
    

ODD_Check:
    cmp rdx,0
    je SESH

    mov rdi,out_fmt
    mov rsi, odd
    call printf

    pop rbp
    mov rax,0
    ret

SESH:
    mov rdi,out_fmt
    mov rsi, even
    call printf

    pop rbp
    mov rax,0
    ret




