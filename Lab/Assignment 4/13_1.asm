extern printf
extern scanf

section .data
    inFmt db "%ld", 0
    outFmt db "%ld", 0
    space db " ", 0
    newline db 0xA, 0
    first_num db 1

section .bss
    n resq 1
    arr resq 1000
    root resq 1
    node_count resq 1
    nodes resb 24000

section .text
    global main

main:
    push rbp
    mov rbp, rsp
    
    mov qword [root], 0
    mov qword [node_count], 0
    mov byte [first_num], 1
    
    mov rdi, inFmt
    mov rsi, n
    xor eax, eax
    call scanf
    
    mov rcx, [n]
    mov rbx, arr
    
.read_loop:
    push rcx
    push rbx
    
    mov rdi, inFmt
    mov rsi, rbx
    xor eax, eax
    call scanf
    
    pop rbx
    pop rcx
    add rbx, 8
    loop .read_loop
    
    mov rcx, [n]
    mov rbx, arr
    
.insert_loop:
    push rcx
    push rbx
    
    mov rdi, [rbx]
    mov rsi, [root]
    call insert_bst
    
    mov [root], rax
    
    pop rbx
    pop rcx
    add rbx, 8
    loop .insert_loop
    
    mov rdi, [root]
    call inorder_traverse
    
    mov rdi, newline
    xor eax, eax
    call printf
    
    mov rsp, rbp
    pop rbp
    ret

insert_bst:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    mov r12, rdi
    mov r13, rsi
    
    cmp r13, 0
    jne .insert_else
    
    mov rax, [node_count]
    imul rax, 24
    lea rbx, [nodes + rax]
    inc qword [node_count]
    
    mov [rbx], r12
    mov qword [rbx + 8], 0
    mov qword [rbx + 16], 0
    
    mov rax, rbx
    jmp .insert_end
    
.insert_else:
    cmp r12, [r13]
    je .insert_end
    
    jl .insert_left
    
    mov rdi, r12
    mov rsi, [r13 + 16]
    call insert_bst
    mov [r13 + 16], rax
    mov rax, r13
    jmp .insert_end
    
.insert_left:
    mov rdi, r12
    mov rsi, [r13 + 8]
    call insert_bst
    mov [r13 + 8], rax
    mov rax, r13
    
.insert_end:
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret

inorder_traverse:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    
    mov r12, rdi
    
    cmp r12, 0
    je .traverse_end
    
    mov rdi, [r12 + 8]
    call inorder_traverse
    
    mov rdi, [r12]
    call print_number
    
    mov rdi, [r12 + 16]
    call inorder_traverse
    
.traverse_end:
    pop r12
    pop rbx
    pop rbp
    ret

print_number:
    push rbp
    mov rbp, rsp
    push rbx
    
    mov rbx, rdi
    
    cmp byte [first_num], 0
    je .print_with_space
    
    mov byte [first_num], 0
    mov rdi, outFmt
    mov rsi, rbx
    xor eax, eax
    call printf
    jmp .print_end
    
.print_with_space:
    mov rdi, space
    xor eax, eax
    call printf
    
    mov rdi, outFmt
    mov rsi, rbx
    xor eax, eax
    call printf
    
.print_end:
    pop rbx
    pop rbp
    ret
