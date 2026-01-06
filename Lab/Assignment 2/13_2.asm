extern printf
extern scanf

section .data
    in_fmt:     db "%ld", 0
    out_fmt:    db "The larger number is: %ld", 10, 0
    prompt1:    db "Enter first integer: ", 0
    prompt2:    db "Enter second integer: ", 0

section .bss
    num1:   resq 1
    num2:   resq 1
    result: resq 1

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
    lea rsi, [num2]
    xor rax, rax
    call scanf

 
    mov rdi, [num1]
    mov rsi, [num2]
    call max_of_two

    mov [result], rax

    mov rdi, out_fmt
    mov rsi, [result]
    xor rax, rax
    call printf

 
    mov rax, 0
    pop rbp
    ret

max_of_two:
    cmp rdi, rsi
    jge .first_is_max
    mov rax, rsi
    ret

.first_is_max:
    mov rax, rdi
    ret
