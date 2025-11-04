
extern printf
extern scanf

section .data
    num1: dq 0
    num2: dq 0
    result: dq 0
    in_fmt:     db "%ld", 0            
    out_fmt:    db "Sum = %ld", 10, 0  
    prompt1:    db "Enter first integer: ", 0
    prompt2:    db "Enter second integer: ", 0

section .text

global main

main:
    push rbp

    
    mov rdi, prompt1
    xor rax, rax
    call printf

 
    mov rdi, in_fmt
    lea rsi, [num1]
    xor rax, rax
    call scanf

 
    mov rdi, prompt2
    xor rax, rax
    call printf

    mov rdi, in_fmt
    mov rsi, num2
    mov rax, 0
    call scanf

    mov rdi, [num1]      
    mov rsi, [num2]      
    call sum             

    mov [result], rax   


    mov rdi, out_fmt
    mov rsi, [result]
    xor rax, rax
    call printf


    mov rax, 0
    pop rbp
    ret
sum:
    mov rax, rdi     
    add rax, rsi     
    ret
