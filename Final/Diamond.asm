extern printf
extern scanf

SECTION .data
    inFmt db "%ld", 0
    star db "*", 0
    space db " ", 0
    newline db 10, 0
    n dq 0

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rdi, inFmt
    mov rsi, n
    xor rax, rax
    call scanf

    mov r12, [n]
    cmp r12, 0
    jle .exit

    xor r13, r13
.top_half:
    cmp r13, r12
    je .bottom_half_init

    mov r14, r12
    sub r14, r13
    dec r14
.top_space_loop:
    cmp r14, 0
    jle .top_star_init
    mov rdi, space
    xor rax, rax
    call printf
    dec r14
    jmp .top_space_loop

.top_star_init:
    mov r14, r13
    shl r14, 1
    inc r14
.top_star_loop:
    cmp r14, 0
    jle .top_row_end
    mov rdi, star
    xor rax, rax
    call printf
    dec r14
    jmp .top_star_loop

.top_row_end:
    mov rdi, newline
    xor rax, rax
    call printf
    inc r13
    jmp .top_half

.bottom_half_init:
    mov r13, r12
    sub r13, 2
.bottom_half:
    cmp r13, 0
    jl .exit

    mov r14, r12
    sub r14, r13
    dec r14
.bottom_space_loop:
    cmp r14, 0
    jle .bottom_star_init
    mov rdi, space
    xor rax, rax
    call printf
    dec r14
    jmp .bottom_space_loop

.bottom_star_init:
    mov r14, r13
    shl r14, 1
    inc r14
.bottom_star_loop:
    cmp r14, 0
    jle .bottom_row_end
    mov rdi, star
    xor rax, rax
    call printf
    dec r14
    jmp .bottom_star_loop

.bottom_row_end:
    mov rdi, newline
    xor rax, rax
    call printf
    dec r13
    jmp .bottom_half

.exit:
    add rsp, 16
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
