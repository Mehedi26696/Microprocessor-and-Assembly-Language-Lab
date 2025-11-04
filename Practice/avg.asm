extern printf
extern scanf

SECTION .data
in_str_fmt:    db "%s", 0
in_int_fmt:    db "%ld", 0
out_fmt:       db "Student: %s, Average: %ld.%ld, Grade: %c", 10, 0

msg_name:      db "Enter student name: ", 0
msg1:          db "Enter score 1: ", 0
msg2:          db "Enter score 2: ", 0
msg3:          db "Enter score 3: ", 0

SECTION .bss
name:          resb 50
score1:        resq 1
score2:        resq 1
score3:        resq 1
avg_int:       resq 1
avg_dec:       resq 1
grade:         resb 1

SECTION .text
global main

main:
    push rbp

    ; ==== Input name ====
    mov rdi, msg_name
    xor rax, rax
    call printf

    mov rdi, in_str_fmt
    lea rsi, [name]
    xor rax, rax
    call scanf

    ; ==== Input 3 scores ====
    mov rdi, msg1
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    lea rsi, [score1]
    xor rax, rax
    call scanf

    mov rdi, msg2
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    lea rsi, [score2]
    xor rax, rax
    call scanf

    mov rdi, msg3
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    lea rsi, [score3]
    xor rax, rax
    call scanf

    ; ==== Compute total ====
    mov rax, [score1]
    add rax, [score2]
    add rax, [score3]

    ; ==== Integer division to get average and remainder ====
    mov rbx, 3
    cqo
    idiv rbx               ; rax = integer avg, rdx = remainder
    mov [avg_int], rax

    ; ==== Calculate decimal part (approx. one digit) ====
    imul rdx, 10           ; remainder * 10
    cqo
    idiv rbx               ; rax = decimal part
    mov [avg_dec], rax

    ; ==== Grade ====
    mov rax, [avg_int]
    cmp rax, 50
    jb fail
    mov byte [grade], 'P'
    jmp print

fail:
    mov byte [grade], 'F'

print:
    mov rdi, out_fmt
    mov rsi, name
    mov rdx, [avg_int]
    mov rcx, [avg_dec]
    movzx r8, byte [grade]
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret
