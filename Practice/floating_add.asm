extern printf
extern scanf

section .data
    a: dq 0.0
    b: dq 0.0
    c: dq 0.0

    enter_msg: db "Enter two numbers: ", 0
    in_fmt:    db "%lf", 0
    out_fmt:   db "%.2lf + %.2lf = %.2lf", 10, 0

section .text
    global main

main:
    push rbp
    mov rbp, rsp

    mov rdi, enter_msg
    mov rax,0
    call printf

  
    mov rdi, in_fmt
    mov rsi, a         
    mov rax,0
    call scanf

 
    mov rdi, in_fmt
    mov rsi, b        
    mov rax,0
    call scanf

 
    movsd xmm0, [a]
    addsd xmm0, [b]
    movsd [c], xmm0

    mov rdi, out_fmt
    movsd xmm0, [a]
    movsd xmm1, [b]
    movsd xmm2, [c]
    mov eax, 3         
    call printf

    mov eax, 0
    leave
    ret
