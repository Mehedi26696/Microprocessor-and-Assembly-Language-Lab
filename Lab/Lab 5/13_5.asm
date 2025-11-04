extern printf
extern scanf

SECTION .data
in_str_fmt:    db "%s", 0
in_int_fmt:    db "%ld", 0
out_fmt:       db "Student: %s, Average: %ld, Grade: %c", 10, 0

msg_name:      db "Enter student name: ", 0
msg1:          db "Enter score 1: ", 0
msg2:          db "Enter score 2: ", 0
msg3:          db "Enter score 3: ", 0

SECTION .bss
name:          resb 50
score1:        resq 1
score2:        resq 1
score3:        resq 1
avg:           resq 1
grade:         resb 1

SECTION .text
global main
main:
    push rbp

 
    mov rdi, msg_name
    xor rax, rax
    call printf

    mov rdi, in_str_fmt
    mov rsi, name
    xor rax, rax
    call scanf

 
    mov rdi, msg1
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    mov rsi, score1
    xor rax, rax
    call scanf

    mov rdi, msg2
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    mov rsi, score2
    xor rax, rax
    call scanf

    mov rdi, msg3
    xor rax, rax
    call printf
    mov rdi, in_int_fmt
    mov rsi, score3
    xor rax, rax
    call scanf

  
    mov rax, [score1]
    add rax, [score2]
    add rax, [score3]
    mov rbx, 3
    cqo                
    idiv rbx
    mov [avg], rax

    
    cmp rax, 50
    jae pass
    mov byte [grade], 'F'
    jmp print

pass:
    mov byte [grade], 'P'

print:
 
    mov rdi, out_fmt
    mov rsi, name
    mov rdx, [avg]
    movzx rcx, byte [grade]  ; char grade
    xor rax, rax
    call printf
 
    mov rax, 0
    pop rbp
    ret