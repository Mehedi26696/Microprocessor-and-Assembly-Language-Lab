# Task 1: Assembly Language Addition Program

## Assembly Code
```assembly
extern	printf		
extern	scanf		

SECTION .data		

a:	dq	5
b:	dq	2	
c:	dq	0

enter:	db "Enter two numbers: ",0
out_fmt:	db "%ld + %ld =%ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:		db "%d",0
SECTION .text

global main		
main:				
        push    rbp	
        
        mov rax,0
        mov rdi,out_fmt_2
        mov rsi,enter
        call printf
        
        mov rax, 0
    mov rdi, in_fmt
    mov rsi, a
    call scanf
    
    
        mov rax, 0
    mov rdi, in_fmt
    mov rsi, b
    call scanf	
    
    mov	rax,[a]
    mov	rbx,[b]		
    add	rax,rbx
    mov	[c],rax		
    mov	rdi,out_fmt		
    mov	rsi,[a]         
    mov	rdx,[b]        
    mov	rcx,[c]         
    mov	rax,0		
        call    printf		

    pop	rbp		

    mov	rax,0		
    ret			
```

## Detailed Explanation

### 1️⃣ External function declarations
```assembly
extern	printf		
extern	scanf
```

`extern` tells the assembler that `printf` and `scanf` are defined outside this file, in the C standard library.

This allows your assembly code to call C functions for input/output.

### 2️⃣ Data section
```assembly
SECTION .data		

a:	dq	5
b:	dq	2	
c:	dq	0

enter:	db "Enter two numbers: ",0
out_fmt:	db "%ld + %ld =%ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:	db "%d",0
```

- `SECTION .data` — declares a data section for initialized data.
- `a`, `b`, `c` — 64-bit (`dq` = define quadword) memory locations to store numbers. Initial values: a=5, b=2, c=0.
- `enter` — string to prompt the user: "Enter two numbers: ".
- `out_fmt` — format string for printf to display addition result: "%ld + %ld =%ld\n"
  - `%ld` is for long integers (64-bit on x86-64 Linux).
- `out_fmt_2` — format string to print any string: "%s\n"
- `in_fmt` — format string for scanf to read an integer: "%d"

**Note:** Mixing `%d` (32-bit) with 64-bit `dq` variables works but isn't strictly safe; you'll see this later.

### 3️⃣ Text (code) section
```assembly
SECTION .text
global main
main:
```

- `SECTION .text` — marks the code section for instructions.
- `global main` — exposes main as the entry point for the linker.
- `main:` — label marking start of the program.

### 4️⃣ Save base pointer
```assembly
push rbp
```

Saves the base pointer (rbp) on the stack.

Standard practice in function prologue to set up a stack frame.

Even though this program doesn't use the stack heavily, it's good style.

### 5️⃣ Print prompt
```assembly
mov rax,0
mov rdi,out_fmt_2
mov rsi,enter
call printf
```

- `mov rax,0` — Required for variadic functions (printf/scanf) in x86-64 Linux ABI.
  - `rax` = number of floating-point arguments passed in xmm registers; here 0.
- `mov rdi,out_fmt_2` — first argument to printf = format string "%s\n".
- `mov rsi,enter` — second argument = the string to print: "Enter two numbers: "
- `call printf` — calls C library function to print the prompt.

### 6️⃣ Read first number
```assembly
mov rax, 0
mov rdi, in_fmt
mov rsi, a
call scanf
```

- `rax=0` — again, required for variadic function.
- `rdi = in_fmt` — format string "%d"
- `rsi = a` — address of variable a where input is stored
- `call scanf` — reads one integer from user input and stores it at a.

### 7️⃣ Read second number
```assembly
mov rax, 0
mov rdi, in_fmt
mov rsi, b
call scanf
```

Same as above but stores input into `b`.

### 8️⃣ Load values and add
```assembly
mov rax,[a]
mov rbx,[b]		
add rax,rbx
mov [c],rax
```

- `mov rax,[a]` — load value of a into register rax.
- `mov rbx,[b]` — load value of b into register rbx.
- `add rax, rbx` — compute a + b, result in rax.
- `mov [c], rax` — store result into memory location c.

`rax` and `rbx` are general-purpose registers. This is a common pattern: load, compute, store.

### 9️⃣ Print result
```assembly
mov rdi,out_fmt		
mov rsi,[a]         
mov rdx,[b]        
mov rcx,[c]         
mov rax,0		
call printf
```

- `rdi = out_fmt` — format string "%ld + %ld = %ld\n"
- `rsi = [a]` — first number
- `rdx = [b]` — second number
- `rcx = [c]` — sum
- `rax = 0` — required for variadic function
- `call printf` — prints something like "3 + 4 = 7"

**Important:** On x86-64 Linux:
- 1st arg → rdi, 2nd → rsi, 3rd → rdx, 4th → rcx, 5th → r8, 6th → r9
- Variadic functions need rax = # of xmm regs used

### 🔟 Restore base pointer and exit
```assembly
pop rbp
mov rax,0
ret
```

- `pop rbp` — restores the original base pointer, cleaning up stack frame.
- `mov rax,0` — return value 0 for main (success).
- `ret` — return to OS.
