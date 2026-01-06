extern printf
extern scanf

SECTION .data
    inFmt db "%ld", 0
    outFmt db "%ld ", 0
    newline db 10, 0
    r1 dq 0
    c1 dq 0
    c2 dq 0

SECTION .bss
    A resq 10000
    B resq 10000
    C resq 10000

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 8              ; Align stack (7 pushes * 8 = 56. 56 + 8 = 64 bytes)

    ; Read r1, c1, c2
    mov rdi, inFmt
    mov rsi, r1
    xor rax, rax
    call scanf
    
    mov rdi, inFmt
    mov rsi, c1
    xor rax, rax
    call scanf
    
    mov rdi, inFmt
    mov rsi, c2
    xor rax, rax
    call scanf

    ; Read Matrix A (r1 x c1)
    mov rax, [r1]
    imul rax, [c1]
    mov r12, rax
    xor rbx, rbx
.read_A:
    cmp rbx, r12
    je .read_B_init
    mov rdi, inFmt
    lea rsi, [A + rbx*8]
    xor rax, rax
    call scanf
    inc rbx
    jmp .read_A

.read_B_init:
    ; Read Matrix B (c1 x c2)
    mov rax, [c1]
    imul rax, [c2]
    mov r12, rax
    xor rbx, rbx
.read_B:
    cmp rbx, r12
    je .multiply
    mov rdi, inFmt
    lea rsi, [B + rbx*8]
    xor rax, rax
    call scanf
    inc rbx
    jmp .read_B

.multiply:
    xor r12, r12            ; i (row of A)
.row_loop:
    cmp r12, [r1]
    je .print_init
    
    xor r13, r13            ; j (col of B)
.col_loop:
    cmp r13, [c2]
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
    
    ; B[k][j]
    mov rax, r15
    imul rax, [c2]
    add rax, r13
    mov rcx, [B + rax*8]
    
    imul rbx, rcx
    add r14, rbx
    inc r15
    jmp .sum_loop

.store_c:
    mov rax, r12
    imul rax, [c2]
    add rax, r13
    mov [C + rax*8], r14
    
    inc r13
    jmp .col_loop

.next_row:
    inc r12
    jmp .row_loop

.print_init:
    xor r12, r12            ; i
.p_row:
    cmp r12, [r1]
    je .end
    
    xor r13, r13            ; j
.p_col:
    cmp r13, [c2]
    je .p_newline
    
    mov rax, r12
    imul rax, [c2]
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
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
