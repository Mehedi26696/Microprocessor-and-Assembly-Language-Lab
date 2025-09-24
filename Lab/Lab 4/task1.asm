extern printf          
extern scanf            

SECTION .data
n:      dq 0            
rev:    dq 0            
rem:    dq 0         
in_fmt:  db "%ld", 0    
out_fmt: db "%ld", 10, 0  

SECTION .text
global main
main:
    push rbp

 
    mov rdi, in_fmt      
    mov rsi, n           
    call scanf        

    mov rax, [n]          
    mov qword [rev], 0    

reverse_loop:
    cmp rax, 0
    je print_result       

    mov rdx, 0           
    mov rcx, 10
    div rcx               
    mov [rem], rdx       

    mov rbx, [rev]
    imul rbx, 10        
    add rbx, rdx         
    mov [rev], rbx

    mov rax, rax          
    jmp reverse_loop

print_result:
    mov rdi, out_fmt      
    mov rsi, [rev]       
    mov rax, 0
    call printf

    pop rbp
    mov rax, 0
    ret
