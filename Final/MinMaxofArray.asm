extern printf
extern scanf

SECTION .data
    input_fmt: db "%ld", 0
    output_fmt: db "%ld %ld", 10, 0
    n: dq 0
    val: dq 0
    min_val: dq 0
    max_val: dq 0

SECTION .text
global main

main:
    push rbp
    mov rbp, rsp
    push rbx            ; Save rbx (callee-saved)
    sub rsp, 8          ; Align stack to 16 bytes (rbp + rbx + 8 = 24? No, push rbp is 8, push rbx is 8, sub rsp 8 is 8. Total 24. Wait.)
                        ; Default stack is 16-bye aligned at start of main.
                        ; Call to main: [RIP] (8 bytes off)
                        ; push rbp: rsp is 16-byte aligned.
                        ; push rbx: rsp is 8-byte aligned.
                        ; sub rsp, 8: rsp is 16-byte aligned. Correct.

    ; Read size n
    mov rdi, input_fmt
    mov rsi, n
    xor rax, rax
    call scanf

    ; Check if n <= 0
    mov rcx, [n]
    cmp rcx, 0
    jle .end

    ; Read first element to initialize min and max
    mov rdi, input_fmt
    mov rsi, val
    xor rax, rax
    call scanf
    
    mov rax, [val]
    mov [min_val], rax
    mov [max_val], rax

    ; Read remaining n - 1 elements
    mov rbx, 1          ; index starts from 1
.loop:
    cmp rbx, [n]
    je .print_results
    
    mov rdi, input_fmt
    mov rsi, val
    xor rax, rax
    call scanf
    
    mov rax, [val]
    
    ; Compare with current max
    cmp rax, [max_val]
    jle .check_min
    mov [max_val], rax
    jmp .loop_next

.check_min:
    cmp rax, [min_val]
    jge .loop_next
    mov [min_val], rax

.loop_next:
    inc rbx
    jmp .loop

.print_results:
    ; Print Max then Min in one line
    mov rdi, output_fmt
    mov rsi, [max_val]
    mov rdx, [min_val]
    xor rax, rax
    call printf

.end:
    add rsp, 8
    pop rbx
    pop rbp
    xor rax, rax
    ret

SECTION .note.GNU-stack noalloc noexec nowrite progbits
