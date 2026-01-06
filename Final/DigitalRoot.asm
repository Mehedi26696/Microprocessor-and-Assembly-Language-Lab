extern printf
extern scanf

SECTION .data
    input_fmt: db "%ld", 0
    output_fmt: db "%ld", 10, 0
    n: dq 0

SECTION .text
global main


digital_root:
    cmp rdi, 9
    jle .done
    mov rcx, rdi      ; rcx = number
    mov rsi,0      ; rsi = sum = 0

.sum_loop:
    cmp rcx, 0
    je .recurse

    mov rax, rcx
    mov rbx, 10
    div rbx           ; rax = rcx / 10, rdx = rcx % 10
    
    add rsi, rdx      ; rsi += rcx % 10
    mov rcx, rax      ; rcx = rcx / 10
    jmp .sum_loop

.recurse:
    mov rdi, rsi      ; rsi = sum, pass as new input
    call digital_root
    ret
.done:
    mov rax, rdi
    ret

main:
    push rbp

    mov rdi, input_fmt
    mov rsi, n
    call scanf

    mov rdi, [n]
    mov rsi, 0
    call digital_root

    mov rsi, rax
    mov rdi, output_fmt
    call printf

    pop rbp
    mov rax, 0
    ret
