extern printf
extern scanf

SECTION .data
    inFmt db "%ld", 0
    outFmt db "%ld ", 0
    newline db 10, 0
    rows dq 0
    cols dq 0

SECTION .bss
    A resq 10000
    B resq 10000

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    sub rsp, 8              ; Align stack

    ; Read rows and cols
    mov rdi, inFmt
    mov rsi, rows
    xor rax, rax
    call scanf
    
    mov rdi, inFmt
    mov rsi, cols
    xor rax, rax
    call scanf

    ; Calculate total elements
    mov rax, [rows]
    imul rax, [cols]
    mov r12, rax            ; r12 = total elements

    ; Read Matrix A
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
    xor rbx, rbx
.read_B:
    cmp rbx, r12
    je .sub_and_print
    mov rdi, inFmt
    lea rsi, [B + rbx*8]
    xor rax, rax
    call scanf
    inc rbx
    jmp .read_B

.sub_and_print:
    xor r12, r12            ; i (row)
.row_loop:
    cmp r12, [rows]
    je .end
    
    xor r13, r13            ; j (col)
.col_loop:
    cmp r13, [cols]
    je .next_row
    
    ; index = i * cols + j
    mov rax, r12
    imul rax, [cols]
    add rax, r13
    
    mov rsi, [A + rax*8]
    sub rsi, [B + rax*8]    ; A[i][j] - B[i][j]
    
    mov rdi, outFmt
    xor rax, rax
    call printf
    
    inc r13
    jmp .col_loop

.next_row:
    mov rdi, newline
    xor rax, rax
    call printf
    inc r12
    jmp .row_loop

.end:
    add rsp, 8
    pop r13
    pop r12
    pop rbx
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
