
extern printf
SECTION .data

a: dq 5
b: dq 6
c: dq 0
fmt: db "%ld + %ld = %ld", 10 ,0

SECTION .text

global main

main:
   
    push rbp
    mov rax , [a]
    mov rbx , [b]
    add rax , rbx
    mov [c] , rax
    mov rdi , fmt
    mov rsi, [a]
    mov rdx, [b]
    mov rcx, [c]
    call printf

    pop rbp
    mov rax,0
    ret