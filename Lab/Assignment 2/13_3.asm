extern printf
extern scanf

section .data
    prompt: db "Enter a string: ",0
    in_fmt: db "%s",0
    out_fmt: db "Reversed string: %s",10,0

section .bss
    str_input: resb 100
    len: resq 1

section .text
global main

main:
    push rbp
    mov rbp, rsp

    mov rdi, prompt
    xor rax, rax
    call printf

    mov rdi, in_fmt
    mov rsi, str_input
    xor rax, rax
    call scanf

    mov rbx, str_input
    xor rcx, rcx
len_loop:
    mov al, [rbx + rcx]
    cmp al, 0
    je len_done
    inc rcx
    jmp len_loop
len_done:
    mov [len], rcx

    mov rdi, str_input
    mov rsi, [len]
    call reverse_str

    mov rdi, out_fmt
    mov rsi, str_input
    xor rax, rax
    call printf

    mov rax, 0
    pop rbp
    ret

reverse_str:
    push rbp
    mov rbp, rsp

    mov rcx, 0
    mov rdx, rsi
    dec rdx
rev_loop:
    cmp rcx, rdx
    jge rev_done
    mov al, [rdi + rcx]
    mov bl, [rdi + rdx]
    mov [rdi + rcx], bl
    mov [rdi + rdx], al
    inc rcx
    dec rdx
    jmp rev_loop
rev_done:
    pop rbp
    ret

