extern	printf		
extern	scanf		

SECTION .data		

a:	dq	0
b:	dq	0	
c:	dq	0
d:  dq  0

enter:	db "Enter three numbers: ",0
out_fmt:	db "2*%ld + 3*%ld + %ld = %ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:	db "%ld",0

SECTION .text

global main		
main:				
    push    rbp	

    mov rax,0
    mov rdi,out_fmt_2
    mov rsi,enter
    call printf

    mov rdi, in_fmt
    mov rsi, a
    mov rax,0
    call scanf

    mov rdi, in_fmt
    mov rsi, b
    mov rax,0
    call scanf

    mov rdi, in_fmt
    mov rsi, c
    mov rax,0
    call scanf

    ; compute 2a + 3b + c using IMUL
    mov rax,[a]
    imul rax,2
    mov rbx,[b]
    imul rbx,3
    add rax,rbx
    add rax,[c]
    mov [d],rax           ; store result in r8

    mov rdi,out_fmt
    mov rsi,[a]         
    mov rdx,[b]        
    mov rcx,[c]
    mov r8,[d]
    mov rax,0		
    call printf		

    pop	rbp		
    mov	rax,0		
    ret
