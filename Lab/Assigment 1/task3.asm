 

extern printf           
extern scanf            

SECTION .data
n:      dq 0             
div:    dq 0            
fmt_in:  db "%ld", 0     
fmt_out: db "%ld", 10, 0  

SECTION .bss

SECTION .text
global main
main:
    push rbp
 
    mov rdi, fmt_in      
    mov rsi, n           
    call scanf            

    mov rbx, 1         
    mov r8, [n]          
    cmp r8, 1
    jl end_program       

print_divisors:
    cmp rbx, r8           
    jg end_program

    mov rax, [n]         
    mov rdx, 0            
    mov rcx, rbx          
    div rcx              
    cmp rdx, 0           
    jne not_divisor

    mov rdi, fmt_out     
    mov rsi, rbx         
    mov rax, 0
    call printf

not_divisor:
    inc rbx            
    jmp print_divisors

end_program:
    pop rbp
    mov rax, 0
    ret
