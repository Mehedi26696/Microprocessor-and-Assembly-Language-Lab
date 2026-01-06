extern printf
extern scanf

SECTION .data
    inFmt db "%s %s", 0
    yesMsg db "YES", 10, 0
    noMsg db "NO", 10, 0

SECTION .bss
    str1 resb 101
    str2 resb 101
    counts resd 256

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rdi, inFmt
    mov rsi, str1
    mov rdx, str2
    xor rax, rax
    call scanf

    mov rdi, str1
    mov rsi, str2
    call is_anagram

    test rax, rax
    jz .print_no

    mov rdi, yesMsg
    xor rax, rax
    call printf
    jmp .done

.print_no:
    mov rdi, noMsg
    xor rax, rax
    call printf

.done:
    add rsp, 16
    pop rbp
    xor rax, rax
    ret

is_anagram:
    push rbp
    mov rbp, rsp

    mov rcx, 256
    mov rdi, counts
    xor rax, rax
    rep stosd

    mov r8, rdi             ; Save RDI if needed, but we use str1/str2
    mov rsi, str1
.count_str1:
    movzx rax, byte [rsi]
    test al, al
    jz .check_str2
    inc dword [counts + rax*4]
    inc rsi
    jmp .count_str1

.check_str2:
    mov rsi, str2
.count_str2:
    movzx rax, byte [rsi]
    test al, al
    jz .compare
    dec dword [counts + rax*4]
    inc rsi
    jmp .count_str2

.compare:
    mov rcx, 256
    mov rsi, counts
.check_loop:
    cmp dword [rsi], 0
    jne .not_anagram
    add rsi, 4
    loop .check_loop

    mov rax, 1
    jmp .exit

.not_anagram:
    xor rax, rax

.exit:
    mov rsp, rbp
    pop rbp
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
