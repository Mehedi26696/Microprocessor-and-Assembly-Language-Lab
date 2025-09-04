extern	printf		
extern	scanf		

SECTION .data		
x:      dq 0

prompt:	db "Enter a positive integer: ",0
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
        mov rsi,prompt
        mov rax,0
        call printf

        ; read x
        mov rax,0
        mov rdi,in_fmt
        mov rsi,x
        mov rax,0
        call scanf

        ; initialize registers: rax = sum, rbx = i, rcx = x
        mov rax,0       ; sum = 0
        mov rbx,1          ; i = 1
        mov rcx,[x]        ; rcx = x (upper limit)

loop_start:
        cmp rbx,rcx
        jg loop_end        ; if i > x, exit

        add rax,rbx        ; sum += i
        inc rbx            ; i++

        jmp loop_start

loop_end:
        ; print result
        mov rdi,out_fmt
        mov rsi,rcx        ; x
        mov rdx,rax        ; sum
        mov rax,0
        call printf

        pop	rbp		
        mov	rax,0		
        ret

