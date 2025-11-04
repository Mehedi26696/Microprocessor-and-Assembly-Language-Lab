
extern printf
extern scanf

SECTION .data

a: dq 0
b: dq 0
c: dq 0
d: dq 0

msg: db "Enter three numbers: ",0
first_fmt: db "%s",10,0
int_fmt: db "%ld",0
out_fmt: db "%ld",10,0


SECTION .text

global main

main:
    push rbp
    
    mov rax,0
    mov rdi,first_fmt
    mov rsi,msg
    call printf

    mov rdi,int_fmt
    mov rsi, a
    call scanf

    mov rdi,int_fmt
    mov rsi, b
    call scanf

    mov rdi,int_fmt
    mov rsi, c
    call scanf


    mov rax,[a]
    mov rbx,[b]
    mov rcx,[c]

    cmp rax,rbx
    jg a_boro

    jmp b_boro

a_boro:
    cmp rax,rcx
    jg sesh_a

    jmp c_boro

b_boro:
    cmp rbx,rcx
    jg sesh_b

    jmp c_boro
sesh_a: 
   mov [d],rax
   mov rdi,out_fmt
   mov rsi,[d]
   call printf

   pop rbp
   mov rax,0
   ret
sesh_b:
   mov [d],rbx
   mov rdi,out_fmt
   mov rsi,[d]
   call printf

   pop rbp
   mov rax,0
   ret

c_boro:
   mov[d],rcx
   mov rdi,out_fmt
   mov rsi,[d]
   call printf

   pop rbp
   mov rax,0
   ret


   