extern	printf		
extern	scanf		

SECTION .data		

num: dq 0
enter: db "Enter a number: ",0
out_fmt_2: db "%s",10,0
prime_fmt: db "%ld is a prime number",10,0
not_prime_fmt: db "%ld is not a prime number",10,0
in_fmt: db "%ld",0

SECTION .text

global main		
main:				 
    push rbp ; base pointer register save kortechi

    ; out_fmt_2 ta print kortechi
    mov rax, 0
    mov rdi, out_fmt_2
    mov rsi, enter
    call printf

    ; a er value input nitechi and memory location labeled a te store kortechi
    mov rax, 0
    mov rdi, in_fmt
    mov rsi, num
    call scanf

    mov rax, [num]  ; num er value rax a nitechi
    cmp rax, 2
    jl .not_prime      ; jodi number ta 2 theke choto hoy tahole not_prime

    mov rcx, 2         ; rcx a 2 store kortechi and 2 theke vag kora shuru kortechi
    mov rbx, [num]     ; rbx a number ta store kortechi

.prime_loop:
    cmp rcx, rbx
    jge .is_prime      ; jodi rcx er value rbx(num) er greater or equal hoy then number ta prime hobe
    mov rax, [num]   ; rax a number ta store kortechi
    mov rdx, 0       ; rdx er value zero initialize
    div rcx          ; rcx diye vag kortechi and result rax asbe and remainder ta rdx a
    cmp rdx, 0      
    je .not_prime      ; jodi rdx er value 0 hoy mane remainder 0 tahole vag kora jabe so not_prime
    inc rcx           ; rcx er value 1 kore baracchi
    jmp .prime_loop

.is_prime:
    ; prime hole format onujayee print kortechi 
    mov rdi, prime_fmt
    mov rsi, [num]
    mov rax, 0
    call printf
    jmp .end_main

.not_prime:
    
    ; not prime hole format onujayee print kortechi
    mov rdi, not_prime_fmt
    mov rsi, [num]
    mov rax, 0
    call printf

.end_main:
    pop rbp
    mov rax, 0
    ret