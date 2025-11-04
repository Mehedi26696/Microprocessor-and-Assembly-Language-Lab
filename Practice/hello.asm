extern printf

SECTION .data
msg: db "Hello World!!!",0
output_format: db "%s",10,0

SECTION .text
global main

main:
    push rbp
    mov rax,0
    mov rdi,output_format
    mov rsi,msg
    call printf
    pop rbp
    mov rax,0
    ret