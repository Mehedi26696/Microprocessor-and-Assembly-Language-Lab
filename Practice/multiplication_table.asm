extern printf
extern scanf

SECTION .data

a: dq 0
mul: dq 0

msg: db "Enter a number: ",0
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%ld * %ld = %ld", 0xA, 0


SECTION .text

global main

main:
    
    push rbp
    mov rax,0
    mov rdi,first_fmt
    mov rsi,msg
    call printf

    mov rdi,int_fmt
    mov rsi,a
    call scanf

    mov rax,[a]
    
    mov rbx,1


loop_start:

    cmp rbx,10
    jg sesh
    
    mov rax, [a]
    imul rax,rbx
    mov [mul] ,rax

    mov rdi,out_fmt
    mov rsi,[a]
    mov rdx,rbx
    mov rcx,[mul]
    call printf

 
    inc rbx


    jmp loop_start

sesh:
  pop rbp
  mov rax,0
  ret

    

   