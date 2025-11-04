
extern printf
extern scanf

SECTION .data

a: dq 0
b: dq 0

msg: db "Enter a number: ",0
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%0*ld",10,0   ; zero-padded

SECTION .text

global main

main:

    push rbp

    mov rax,0
    mov rdi, first_fmt
    mov rsi, msg
    call printf

    mov rdi, int_fmt
    mov rsi,a
    call scanf

    mov rax,[a]
    mov rcx,0
    mov rbx, 10
    mov r8, rax


count_loop:

    cmp rax,0
    je set_value

    cqo
    idiv rbx

    inc rcx
    
    jmp count_loop

set_value:
   mov rax,[a]
   mov [b] , rcx
   mov rcx,0
   mov rdx,0

   jmp loop_start


loop_start:
    cmp rax,0
    je sesh

    cqo
    idiv rbx

    imul rcx,10
    add rcx,rdx

    jmp loop_start

sesh:
  
  mov rdi,out_fmt
  mov rsi,[b]
  mov rdx,rcx
  call printf

  pop rbp
  mov rax,0
  ret