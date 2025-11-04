extern printf
extern scanf

section .data
    in_str_fmt:    db "%s", 0
    in_int_fmt:    db "%ld", 0
    out_fmt:       db "Student: %s, Average: %.2lf, Grade: %c", 10, 0

    msg_name:      db "Enter student name: ", 0
    msg1:          db "Enter score 1: ", 0
    msg2:          db "Enter score 2: ", 0
    msg3:          db "Enter score 3: ", 0

    three:         dq 3.0

section .bss
    name:          resb 50
    score1:        resq 1
    score2:        resq 1
    score3:        resq 1
    avg:           resq 1
    grade:         resb 1

section .text
    global main

main:
    push rbp
    mov rbp, rsp

    ; ---- Input Student Name ----
    mov rdi, msg_name
    xor rax, rax
    call printf

    mov rdi, in_str_fmt
    mov rsi, name
    xor rax, rax
    call scanf

    ; ---- Input Scores ----
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

    ; ---- Convert to double and calculate average ----
    ; Load integer scores into registers and convert to double
    fild qword [score1]
    fild qword [score2]
    faddp st1, st0
    fild qword [score3]
    faddp st1, st0
    fidiv qword [three]    ; divide by 3.0
    fstp qword [avg]       ; store result into avg

    ; ---- Determine Grade ----
    movsd xmm0, [avg]
    movsd xmm1, [avg]
    mov rax, [avg]          ; for comparison, approximate integer
    cvttsd2si rax, xmm0     ; convert double to int (truncate)
    cmp rax, 50
    jae pass
    mov byte [grade], 'F'
    jmp print

pass:
    mov byte [grade], 'P'

print:
    ; ---- Print Result ----
    mov rdi, out_fmt
    mov rsi, name
    movsd xmm0, [avg]
    movzx rdx, byte [grade]
    mov eax, 1      ; 1 XMM register used
    call printf

    ; ---- Exit ----
    mov eax, 0
    pop rbp
    ret
