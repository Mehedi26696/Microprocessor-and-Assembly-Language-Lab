extern printf
extern scanf

SECTION .data
    inFmt db "%ld", 0
    outFmt db "%ld ", 0
    newline db 10, 0
    r1 dq 0
    c1 dq 0
    r2 dq 0

SECTION .bss
    A resq 10000
    B resq 10000
    C resq 10000

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 16             ; Align stack

    ; Read r1, c1, r2
    mov rdi, inFmt
    mov rsi, r1
    xor rax, rax
    call scanf
    
    mov rdi, inFmt
    mov rsi, c1
    xor rax, rax
    call scanf
    
    mov rdi, inFmt
    mov rsi, r2
    xor rax, rax
    call scanf

    ; Read Matrix A (r1 x c1)
    mov rax, [r1]
    imul rax, [c1]
    mov rcx, rax
    mov rbx, 0
.read_A:
    cmp rbx, rcx
    je .read_B_init
    push rcx
    push rbx
    mov rdi, inFmt
    lea rsi, [A + rbx*8]
    xor rax, rax
    call scanf
    pop rbx
    pop rcx
    inc rbx
    jmp .read_A

.read_B_init:
    ; Read Matrix B (r2 x c1)
    mov rax, [r2]
    imul rax, [c1]
    mov rcx, rax
    mov rbx, 0
.read_B:
    cmp rbx, rcx
    je .calc_init
    push rcx
    push rbx
    mov rdi, inFmt
    lea rsi, [B + rbx*8]
    xor rax, rax
    call scanf
    pop rbx
    pop rcx
    inc rbx
    jmp .read_B

.calc_init:
    ; C = A * B^T
    ; Dim: A(r1 x c1) * B^T(c1 x r2) = C(r1 x r2)
    ; C[i][j] = sum(A[i][k] * B[j][k])
    
    xor r12, r12            ; i (0 to r1-1)
.row_loop:
    cmp r12, [r1]
    je .print_init
    
    xor r13, r13            ; j (0 to r2-1)
.col_loop:
    cmp r13, [r2]
    je .next_row
    
    xor r14, r14            ; sum
    xor r15, r15            ; k (0 to c1-1)
.sum_loop:
    cmp r15, [c1]
    je .store_c
    
    ; A[i][k]
    mov rax, r12
    imul rax, [c1]
    add rax, r15
    mov rbx, [A + rax*8]
    
    ; B[j][k]
    mov rax, r13
    imul rax, [c1]
    add rax, r15
    mov rcx, [B + rax*8]
    
    imul rbx, rcx
    add r14, rbx
    inc r15
    jmp .sum_loop

.store_c:
    mov rax, r12
    imul rax, [r2]
    add rax, r13
    mov [C + rax*8], r14
    
    inc r13
    jmp .col_loop

.next_row:
    inc r12
    jmp .row_loop

.print_init:
    xor r12, r12
.p_row:
    cmp r12, [r1]
    je .end
    
    xor r13, r13
.p_col:
    cmp r13, [r2]
    je .p_newline
    
    mov rax, r12
    imul rax, [r2]
    add rax, r13
    
    mov rdi, outFmt
    mov rsi, [C + rax*8]
    xor rax, rax
    call printf
    
    inc r13
    jmp .p_col

.p_newline:
    mov rdi, newline
    xor rax, rax
    call printf
    inc r12
    jmp .p_row

.end:
    add rsp, 16
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits