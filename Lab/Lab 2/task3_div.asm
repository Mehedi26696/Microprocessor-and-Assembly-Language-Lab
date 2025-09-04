extern	printf		
extern	scanf		

SECTION .data		

x:      dq 0
sum:    dq 0

enter:	db "Enter a positive integer: ",0
out_fmt:	db "Sum from 1 to %ld = %ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:	db "%ld",0

SECTION .text

global main		
main:				
        push    rbp	

        ; print prompt
        mov rax,0
        mov rdi,out_fmt_2
        mov rsi,enter
        mov rax,0
        call printf

        ; read x
        mov rax,0
        mov rdi,in_fmt
        mov rsi,x
        mov rax,0
        call scanf

        ; compute sum = x*(x+1)/2
        mov rax,[x]
        mov rbx,rax
        add rbx,1          ; rbx = x+1
        imul rax,rbx       ; rax = x*(x+1)
        mov rbx,2
        cqo                 ; extend rax to rdx:rax
        idiv rbx            ; rax = rax / 2
        mov [sum],rax

        ; print result
        mov rdi,out_fmt
        mov rsi,[x]
        mov rdx,[sum]
        mov rax,0
        call printf

        pop	rbp		
        mov	rax,0		
        ret
