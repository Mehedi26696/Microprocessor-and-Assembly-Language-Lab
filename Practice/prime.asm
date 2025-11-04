
extern printf
extern scanf

SECTION .data

a: dq 0

enter: db "Enter a number: ",0
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%s",10, 0

prime: db "Yes, it's a prime number",0
non_prime: db "No, it's not a prime number",0


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
    mov rsi, a
    call scanf

    mov rax,[a]


    cmp rax,0
    je loop_exit

    cmp rax,1
    je loop_exit

    mov rcx, [a]
    mov rbx ,2


loop_start:
    
    cmp rbx,rcx
    je loop_end
    mov rax,[a]
    cqo 
    idiv rbx

  
    cmp rdx,0
    je loop_exit


    inc rbx

    jmp loop_start

loop_exit:
     
     mov rdi, out_fmt
     mov rsi, non_prime
     call printf

     pop rbp
     mov rax,0
     ret

loop_end:

     mov rdi, out_fmt
     mov rsi, prime
     call printf

     pop rbp
     mov rax,0
     ret

     

    