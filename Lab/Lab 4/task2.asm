
extern printf           
extern scanf            

SECTION .data
n:      dq 0            
mul:    dq 0           
fmt_in:  db "%ld", 0     
fmt_out: db "%ld x %ld = %ld", 10, 0 ; 

SECTION .bss

SECTION .text
global main
main:
    push rbp
    
 
    mov rdi, fmt_in       
    mov rsi, n            
    call scanf           

    mov rbx, 1           

print_table:
    cmp rbx, 11          
    jge end_program

    mov rax, [n]         
    imul rax, rbx        
    mov [mul], rax        

    mov rdi, fmt_out      
    mov rsi, [n]        
    mov rdx, rbx         
    mov rcx, [mul]        
    mov rax, 0            
    call printf

    inc rbx             
    jmp print_table

end_program:
    pop rbp
    mov rax, 0
    ret
