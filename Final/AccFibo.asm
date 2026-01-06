extern printf
extern scanf

SECTION .data
    inFmt db "%ld", 0
    outFmt db "%ld", 10, 0
    overflowMsg db "OVERFLOW", 10, 0
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

    mov rdi, [n]
    cmp rdi, 0
    jl .done

    call fibonacci_safe

    cmp rax, -1
    je .print_overflow

    mov rdi, outFmt
    mov rsi, rax
    xor rax, rax
    call printf
    jmp .done

.print_overflow:
    mov rdi, overflowMsg
    xor rax, rax
    call printf

.done:
    add rsp, 16
    pop rbp
    xor rax, rax
    ret

fibonacci_safe:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13

    mov rcx, rdi
    
    cmp rcx, 0
    jne .check_one
    xor rax, rax
    jmp .exit

.check_one:
    cmp rcx, 1
    jne .compute
    mov rax, 1
    jmp .exit

.compute:
    mov r12, 0
    mov r13, 1
    mov rbx, 2

.loop:
    cmp rbx, rcx
    jg .result
    
    mov rax, r12
    add rax, r13
    
    mov rdx, 0xFFFFFFFF
    cmp rax, rdx
    ja .overflow_detected
    
    mov r12, r13
    mov r13, rax
    
    inc rbx
    jmp .loop

.result:
    mov rax, r13
    jmp .exit

.overflow_detected:
    mov rax, -1

.exit:
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits