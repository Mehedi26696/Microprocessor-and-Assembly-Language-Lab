extern printf
extern scanf
extern malloc

SECTION .data
    inFmt db "%ld", 0
    outFmt db "%ld ", 0
    preMsg db "Preorder: ", 0
    inMsg db "Inorder: ", 0
    postMsg db "Postorder: ", 0
    newline db 10, 0
    val_temp dq 0

SECTION .bss
    n resq 1
    root resq 1

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    sub rsp, 8

    mov rdi, inFmt
    mov rsi, n
    xor rax, rax
    call scanf

    mov r12, [n]
    xor r13, r13
    mov qword [root], 0

.read_loop:
    cmp r13, r12
    je .print_pre
    
    mov rdi, inFmt
    mov rsi, val_temp
    xor rax, rax
    call scanf
    
    mov rdi, root
    mov rsi, [val_temp]
    call insert
    
    inc r13
    jmp .read_loop

.print_pre:
    mov rdi, preMsg
    xor rax, rax
    call printf
    mov rdi, [root]
    call preorder
    mov rdi, newline
    xor rax, rax
    call printf

.print_in:
    mov rdi, inMsg
    xor rax, rax
    call printf
    mov rdi, [root]
    call inorder
    mov rdi, newline
    xor rax, rax
    call printf

.print_post:
    mov rdi, postMsg
    xor rax, rax
    call printf
    mov rdi, [root]
    call postorder
    mov rdi, newline
    xor rax, rax
    call printf

.done:
    add rsp, 8
    pop r13
    pop r12
    pop rbp
    xor rax, rax
    ret

insert:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    sub rsp, 8

    mov rbx, rdi
    mov r12, rsi

    mov rax, [rbx]
    test rax, rax
    jnz .traverse

    mov rdi, 24
    call malloc
    mov [rax], r12
    mov qword [rax+8], 0
    mov qword [rax+16], 0
    mov [rbx], rax
    jmp .exit

.traverse:
    mov rbx, rax
    cmp r12, [rbx]
    jl .left
    lea rdi, [rbx+16]
    mov rsi, r12
    call insert
    jmp .exit
.left:
    lea rdi, [rbx+8]
    mov rsi, r12
    call insert

.exit:
    add rsp, 8
    pop r12
    pop rbx
    pop rbp
    ret

preorder:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8
    
    mov rbx, rdi
    test rbx, rbx
    jz .done
    
    mov rdi, outFmt
    mov rsi, [rbx]
    xor rax, rax
    call printf
    
    mov rdi, [rbx+8]
    call preorder
    mov rdi, [rbx+16]
    call preorder

.done:
    add rsp, 8
    pop rbx
    pop rbp
    ret

inorder:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8
    
    mov rbx, rdi
    test rbx, rbx
    jz .done
    
    mov rdi, [rbx+8]
    call inorder
    
    mov rdi, outFmt
    mov rsi, [rbx]
    xor rax, rax
    call printf
    
    mov rdi, [rbx+16]
    call inorder

.done:
    add rsp, 8
    pop rbx
    pop rbp
    ret

postorder:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 8
    
    mov rbx, rdi
    test rbx, rbx
    jz .done
    
    mov rdi, [rbx+8]
    call postorder
    mov rdi, [rbx+16]
    call postorder
    
    mov rdi, outFmt
    mov rsi, [rbx]
    xor rax, rax
    call printf

.done:
    add rsp, 8
    pop rbx
    pop rbp
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
