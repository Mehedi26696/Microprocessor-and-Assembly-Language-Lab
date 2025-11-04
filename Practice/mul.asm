
extern printf
extern scanf

SECTION .data

a: dq 0
b: dq 0
c: dq 0
d: dq 0

enter: db "Enter two numbers: ",10
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%ld * %ld * %ld = %ld",10,0

SECTION .text

global main

main:

    push rbp

    mov rax,0
    mov rdi , first_fmt
    mov rsi , enter
    call printf

    mov rax,0
    mov rdi , int_fmt
    mov rsi , a
    call scanf

    mov rax,0
    mov rdi , int_fmt
    mov rsi , b
    call scanf

    mov rax,0
    mov rdi , int_fmt
    mov rsi , c
    call scanf


    mov rax,0
    mov rax,[a]
    mov rbx,[b]
    imul rax,rbx
    imul rax,[c]
    mov [d], rax
    mov rdi, out_fmt
    mov rsi, [a]
    mov rdx,[b]
    mov rcx,[c]
    mov r8 , [d]
    call printf

    pop rbp
    mov rax,0
    ret