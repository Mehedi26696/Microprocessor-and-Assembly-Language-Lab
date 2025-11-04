extern printf
extern scanf

section .data
 
    dim_prompt1 db "Enter number of rows: ", 0
    dim_prompt2 db "Enter number of columns: ", 0
    
   
    prompt1 db "Enter elements for Matrix 1:", 10, 0
    prompt2 db "Enter elements for Matrix 2:", 10, 0
    element_prompt db "Element [%d,%d]: ", 0
    msg1    db 10, "Matrix 1:", 10, 0
    msg2    db 10, "Matrix 2:", 10, 0
    msg3    db 10, "Result (Matrix1 AND Matrix2):", 10, 0
    in_fmt  db "%d", 0
    num_fmt db "%3d ", 0
    newline db 10, 0

section .bss
    rows    resd 1      
    cols    resd 1       
    size    resd 1       
    matrix1 resb 100    
    matrix2 resb 100     
    result  resb 100     
    temp    resd 1           

section .text
    global main

main:
    push rbp
    
 
    mov rdi, dim_prompt1
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    lea rsi, [rows]
    xor rax, rax
    call scanf
    
    mov rdi, dim_prompt2
    xor rax, rax
    call printf
    
    mov rdi, in_fmt
    lea rsi, [cols]
    xor rax, rax
    call scanf
    
    
    mov eax, [rows]
    mov ebx, [cols]
    mul ebx
    mov [size], eax
    
 
    mov rdi, prompt1
    xor rax, rax
    call printf
    
    mov rsi, matrix1
    call input_matrix
    
 
    mov rdi, prompt2
    xor rax, rax
    call printf
    
    mov rsi, matrix2
    call input_matrix
    
   
    mov rdi, msg1
    xor rax, rax
    call printf
    
    mov rsi, matrix1
    call display_matrix
    
  
    mov rdi, msg2
    xor rax, rax
    call printf
    
    mov rsi, matrix2
    call display_matrix
    
  
    call matrix_and
    
  
    mov rdi, msg3
    xor rax, rax
    call printf
    
    mov rsi, result
    call display_matrix
    
    mov rax, 0
    pop rbp
    ret

input_matrix:
    push rbp
    push rbx
    push r12
    push r13
    push r14
    
    mov r12, rsi         
    mov r13, 0          
    
input_row_loop:
    mov r14, 0           
    
input_col_loop:
    mov rdi, element_prompt
    mov rsi, r13
    mov rdx, r14
    xor rax, rax
    call printf
    
  
    mov rdi, in_fmt
    lea rsi, [temp]
    xor rax, rax
    call scanf
    
    mov eax, r13d           
    mov ebx, [cols]         
    mul ebx                 
    add eax, r14d       
    mov rbx, [temp]         
    mov [r12 + rax], bl     
    
    inc r14                 
    cmp r14d, [cols]    
    jl input_col_loop
    
    inc r13             
    cmp r13d, [rows]        
    jl input_row_loop
    
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
matrix_and:
    mov ecx, [size]      
    mov rsi, matrix1     
    mov rdi, matrix2     
    mov rdx, result      
    
and_loop:
    mov al, [rsi]        
    and al, [rdi]       
    mov [rdx], al        
    
    inc rsi              
    inc rdi              
    inc rdx              
    
    dec ecx              
    jnz and_loop         
    
    ret

display_matrix:
    push rbp
    push rbx
    push r12
    push r13
    
    mov r12, rsi         
    mov r13, 0           
    
display_loop:
    movzx rsi, byte [r12 + r13]   
    mov rdi, num_fmt
    xor rax, rax
    call printf
    
    inc r13              
     
    mov eax, r13d
    mov ebx, [cols]      
    xor edx, edx
    div ebx
    cmp edx, 0
    jne skip_newline
    
   
    mov rdi, newline
    xor rax, rax
    call printf
    
skip_newline:
    cmp r13d, [size]     
    jl display_loop
    
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret