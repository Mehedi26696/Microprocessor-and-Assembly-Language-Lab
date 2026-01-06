extern printf
extern scanf

SECTION .data
    inFmt db "%ld", 0
    outFmt db "%ld %ld", 10, 0
    n dq 0

SECTION .bss
    arr resq 100

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 8

    mov rdi, inFmt
    mov rsi, n
    xor rax, rax
    call scanf

    mov r12, [n]
    xor rbx, rbx
.read_loop:
    cmp rbx, r12
    je .sort_init
    mov rdi, inFmt
    lea rsi, [arr + rbx*8]
    xor rax, rax
    call scanf
    inc rbx
    jmp .read_loop

.sort_init:
    cmp r12, 2
    jl .end
    mov rbx, 0
.outer:
    mov r13, r12
    dec r13
    cmp rbx, r13
    je .print
    xor rcx, rcx
.inner:
    mov rdx, r12
    sub rdx, rbx
    dec rdx
    cmp rcx, rdx
    je .next_outer
    
    mov rax, [arr + rcx*8]
    mov r8, [arr + rcx*8 + 8]
    cmp rax, r8
    jle .next_inner
    mov [arr + rcx*8], r8
    mov [arr + rcx*8 + 8], rax
.next_inner:
    inc rcx
    jmp .inner
.next_outer:
    inc rbx
    jmp .outer

.print:
    mov rax, r12
    sub rax, 2
    mov rsi, [arr + rax*8]
    mov rdx, [arr + 8]
    mov rdi, outFmt
    xor rax, rax
    call printf

.end:
    add rsp, 8
    pop r13
    pop r12
    pop rbx
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
