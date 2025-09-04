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
        mov rax,0
        call printf

        mov rax, 0
        mov rdi, in_fmt
        mov rsi, a
        mov rax,0
        call scanf

        mov rax, 0
        mov rdi, in_fmt
        mov rsi, b
        mov rax,0
        call scanf

        mov rax, 0
        mov rdi, in_fmt
        mov rsi, c
        mov rax,0
        call scanf

        ; compute 2a + 3b + c using shift
        mov rax,[a]
        shl rax,1             ; 2a
        mov rbx,[b]
        mov rcx,rbx
        shl rcx,1             ; 2b
        add rcx,rbx           ; 3b
        add rax,rcx
        add rax,[c]
        mov [d],rax         

        mov rdi,out_fmt
        mov rsi,[a]         
        mov rdx,[b]        
        mov rcx,[c]  
        mov r8, [d]       
        mov rax,0		
        call printf		

        pop	rbp		
        mov	rax,0		
        ret
