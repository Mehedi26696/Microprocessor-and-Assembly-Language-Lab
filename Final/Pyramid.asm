extern printf
extern scanf

SECTION .data
    in_fmt: db "%ld", 0
    star: db "*", 0
    space: db " ", 0
    newline: db 10, 0
    n: dq 0

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 16         ; Align stack for calls

    ; Read n
    mov rdi, in_fmt
    mov rsi, n
    xor rax, rax
    call scanf

    mov r12, [n]        ; r12 = total rows
    xor r13, r13        ; r13 = i (current row index, 0 to n-1)

.row_loop:
    cmp r13, r12
    jge .done

    ; Calculate spaces: r12 - r13 - 1
    mov r14, r12
    sub r14, r13
    dec r14             ; r14 = number of spaces

.space_loop:
    cmp r14, 0
    jle .stars_init
    mov rdi, space
    xor rax, rax
    call printf
    dec r14
    jmp .space_loop

.stars_init:
    ; Calculate stars: 2*r13 + 1
    mov r14, r13
    shl r14, 1
    inc r14             ; r14 = number of stars

.star_loop:
    cmp r14, 0
    jle .next_row
    mov rdi, star
    xor rax, rax
    call printf
    dec r14
    jmp .star_loop

.next_row:
    ; Print newline
    mov rdi, newline
    xor rax, rax
    call printf

    inc r13
    jmp .row_loop

.done:
    add rsp, 16
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
