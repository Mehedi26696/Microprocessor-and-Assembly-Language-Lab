extern printf
extern scanf

SECTION .data
    input_fmt: db "%ld", 0
    output_fmt: db "%ld ", 0
    newline: db 10, 0
    n: dq 0
    array: times 100 dq 0

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 16         ; Align stack to 16 bytes for calls

  
    mov rdi, input_fmt
    mov rsi, n
    xor rax, rax
    call scanf

 
    mov rcx, [n]
    cmp rcx, 0
    jle .end

    mov rbx, 0          ; index
.input_loop:
    cmp rbx, [n]
    je .sort_init
    
    mov rdi, input_fmt
    lea rsi, [array + rbx*8]
    xor rax, rax
    call scanf
    
    inc rbx
    jmp .input_loop

.sort_init:
    mov r8, [n]
    dec r8              ; r8 = n - 1 (outer loop limit)
    cmp r8, 0
    jle .print_init

    mov rbx, 0          ; i = 0 (outer loop)
.outer_loop:
    cmp rbx, r8
    je .print_init
    
    mov rcx, 0          ; j = 0 (inner loop)
    mov r9, r8
    sub r9, rbx         ; r9 = n - 1 - i (inner loop limit)
    
.inner_loop:
    cmp rcx, r9
    je .outer_next
    
    mov rax, [array + rcx*8]
    mov rdx, [array + rcx*8 + 8]
    
    cmp rax, rdx
    jle .inner_next
    
    ; swap
    mov [array + rcx*8], rdx
    mov [array + rcx*8 + 8], rax
    
.inner_next:
    inc rcx
    jmp .inner_loop

.outer_next:
    inc rbx
    jmp .outer_loop

.print_init:
    mov rbx, 0          ; index
.print_loop:
    cmp rbx, [n]
    je .print_newline
    
    mov rdi, output_fmt
    mov rsi, [array + rbx*8]
    xor rax, rax        ; printf is variadic
    call printf
    
    inc rbx
    jmp .print_loop

.print_newline:
    mov rdi, newline
    xor rax, rax
    call printf

.end:
    add rsp, 16
    pop rbp
    mov rax, 0
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
