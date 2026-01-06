extern printf
extern scanf

SECTION .data
    in_fmt: db "%ld", 0
    out_fmt: db "%ld ", 0
    newline: db 10, 0
    n: dq 0

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    sub rsp, 8

    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf

    mov r12, [n]
    mov r13, 1

.loop:
    cmp r13, r12
    jg .end

    mov rax, r12
    xor rdx, rdx
    div r13
    
    cmp rdx, 0
    jne .next

    mov rdi, out_fmt
    mov rsi, r13
    xor rax, rax
    call printf

.next:
    inc r13
    jmp .loop

.end:
    mov rdi, newline
    xor rax, rax
    call printf

    add rsp, 8
    pop r13
    pop r12
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
