
extern printf
extern scanf

SECTION .data

a: dq 0
oflow: db "OVERFLOW",0

first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%ld",10,0

SECTION .text
global main

main: 

   push rbp

   mov rax,0

   mov rdi,int_fmt
   mov rsi,a
   call scanf

   mov rax,[a]

   cmp rax,13
   jge sesh
   mov rcx,[a]
   mov rbx, 1

loop_start:

   cmp rbx,rcx
   je loop_end

   imul rax,rbx

   inc rbx

   jmp loop_start

sesh:

    mov rdi,first_fmt
    mov rsi,oflow
    call printf

    pop rbp
    mov rax,0
    ret

loop_end:

   mov rdi , out_fmt
   mov rsi, rax
   call printf

   pop rbp
   mov rax,0
   ret