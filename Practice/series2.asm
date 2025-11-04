
extern printf
extern scanf


SECTION .data

a: dq 0

enter: db "Enter a number: ",0
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "Summation from 1 to %ld is %ld",10,0


SECTION .text

global main

main:

    push rbp

    mov rax,0
    mov rdi, first_fmt
    mov rsi, enter
    call printf

    mov rax,0
    mov rdi, int_fmt
    mov rsi,a
    call scanf


    mov rax,0
    mov rbx,1
    mov rcx ,[a]

loop_start:
    
    cmp rbx,rcx
    jg loop_end

    add rax,rbx

    inc rbx

    jmp loop_start

loop_end:
     
    mov rdi , out_fmt
    mov rsi, [a]
    mov rdx, rax
    call printf

    pop rbp

    mov rax,0
    ret