extern	printf		
extern	scanf		

SECTION .data		

a: dq 0
b: dq 0
c: dq 0
enter: db "Enter three numbers: ",0
out_fmt_2: db "%s",10,0
max_fmt: db "Maximum is %ld",10,0
in_fmt: db "%ld",0

SECTION .text

global main		
main:				 
    push rbp
    mov rax, 0
    mov rdi, out_fmt_2
    mov rsi, enter
    call printf

    mov rax, 0
    mov rdi, in_fmt
    mov rsi, a
    call scanf

    mov rax, 0
    mov rdi, in_fmt
    mov rsi, b
    call scanf

    mov rax, 0
    mov rdi, in_fmt
    mov rsi, c
    call scanf

    mov rax, [a]
    mov rbx, [b]
    mov rcx, [c]

    ; Find max of a, b, c
    cmp rax, rbx  
    jge .check_c ; check kortechi rax is greater than or equal to rbx and if so then move to check_c
    mov rax, rbx ; rax a rbx store kortechi as rbx is greate for this case 
.check_c:
    cmp rax, rcx
    jge .print_max ; check kortechi rax is greater 
    mov rax, rcx
.print_max:
    mov rdi, max_fmt
    mov rsi, rax
    mov rax, 0
    call printf

    pop rbp
    mov rax, 0
    ret