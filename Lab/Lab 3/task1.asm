extern	printf		
extern	scanf		

SECTION .data		

a:	dq	0
b:	dq	0

enter:	db "Enter two numbers: ",0
out_fmt_2: db "%s",10,0
gcd_fmt: db "GCD of %ld and %ld is %ld", 10, 0
in_fmt:	db "%ld",0

SECTION .text

global main		
main:				
    push rbp ; base pointer register save kortechi
    
    
    ; out_fmt_2 ta print kortechi
    mov rax, 0
    mov rdi, out_fmt_2
    mov rsi, enter
    call printf
    
    ; a er value input nitechi and memory location labeled a te store kortechi
    mov rax, 0
    mov rdi, in_fmt
    mov rsi, a
    call scanf


    ; b er value input nitechi and memory location labeled b te store kortechi
    mov rax, 0
    mov rdi, in_fmt
    mov rsi, b
    call scanf

    
    ; rax a  a er value and rbx a b er value load kortechi 
    mov rax, [a]    ; rax = a
    mov rbx, [b]    ; rbx = b
    
    
    ; comparing rax and rbx 
    cmp rax, rbx
    jl .choto_ta_paichi  ; rax(a) is smaller than rbx(b)

    mov rax, rbx    ; rax(a) is greater or equal to rbx(b)

    ; so, rax now holding the minimum
    
.choto_ta_paichi:
    mov rcx, rax    ;  rcx a minimum value ta nilam

.gcd_loop:
    cmp rcx, 0      ; checking if rcx is 0 
    je .gcd_peye_gechi    ;  break loop (means rcx holding the gcd value)
    
    ; Check if rcx divides a
    mov rax, [a]
    mov rdx, 0
    div rcx
    cmp rdx, 0      ; check kortechi rax(a) ke rcx diye vag kora jay kina (rdx store remainder)
    jne .rcx_komate_hobe
    
    ; Check if rcx divides b
    mov rax, [b]
    mov rdx, 0
    div rcx
    cmp rdx, 0      ; check kortechi rax(b) ke rcx diye vag kora jay kina
    jne .rcx_komate_hobe
    
    ; a and b duitakei vag kora jacche
    jmp .gcd_peye_gechi

.rcx_komate_hobe:
    dec rcx         ; rcx komaitechi
    jmp .gcd_loop

.gcd_peye_gechi:
    ; rcx now contains the GCD
    mov rdi, gcd_fmt
    mov rsi, [a]
    mov rdx, [b]
    mov r8, rcx     ; GCD result
    mov rax, 0
    call printf

    pop rbp
    mov rax, 0
    ret
