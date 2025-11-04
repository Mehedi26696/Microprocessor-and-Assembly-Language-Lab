extern printf
extern scanf

SECTION .data
a: dq 0
b: dq 0
gcd: dq 0

enter: db "Enter two numbers: ",0
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%ld",10,0


SECTION .text

global main

main:
    
    push rbp

    mov rax,0

    mov rdi, first_fmt
    mov rsi, enter
    call printf

    mov rdi, int_fmt
    mov rsi, a
    call scanf

    mov rdi, int_fmt
    mov rsi,b
    call scanf

    mov rax,[a]
    mov rbx,[b]

    cmp rax,rbx

    jl choto_ta_paichi

    mov rax,rbx


choto_ta_paichi:
    mov rcx , rax

gcd_loop:
   
    cmp rcx,0
    je sesh

    mov rax,[a]
    cqo
    idiv rcx
    cmp rdx,0
    jne rcx_komate_hobe

    mov rax,[b]
    cqo
    idiv rcx
    cmp rdx,0
    jne rcx_komate_hobe

    jmp sesh

rcx_komate_hobe:
    dec rcx
    jmp gcd_loop


sesh:
    mov [gcd],rcx
    mov rdi,out_fmt
    mov rsi, [gcd]
    call printf

    pop rbp
    mov rax,0
    ret




    