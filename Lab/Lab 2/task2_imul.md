# Task 2: Assembly Language Multiplication Program (IMUL)

## Assembly Code
```assembly
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
    mov [d],rax           ; store result in d

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
```

## Detailed Explanation

### 1️⃣ External function declarations
```assembly
extern	printf		
extern	scanf
```

Same as Task 1: `extern` tells the assembler that `printf` and `scanf` are defined outside this file, in the C standard library.

This allows your assembly code to call C functions for input/output.

### 2️⃣ Data section
```assembly
SECTION .data		

a:	dq	0
b:	dq	0	
c:	dq	0
d:  dq  0

enter:	db "Enter three numbers: ",0
out_fmt:	db "2*%ld + 3*%ld + %ld = %ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:	db "%ld",0
```

- `SECTION .data` — declares a data section for initialized data.
- `a`, `b`, `c`, `d` — 64-bit (`dq` = define quadword) memory locations to store numbers. All initialized to 0.
- `enter` — string to prompt the user: "Enter three numbers: ".
- `out_fmt` — format string for printf to display calculation result: "2*%ld + 3*%ld + %ld = %ld\n"
  - Shows the formula being calculated with actual values
- `out_fmt_2` — format string to print any string: "%s\n"
- `in_fmt` — format string for scanf to read a 64-bit integer: "%ld"

**Note:** This program correctly uses `%ld` format specifier with 64-bit `dq` variables for consistency.

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

### 5️⃣ Print prompt
```assembly
mov rax,0
mov rdi,out_fmt_2
mov rsi,enter
call printf
```

- `mov rax,0` — Required for variadic functions (printf/scanf) in x86-64 Linux ABI.
- `mov rdi,out_fmt_2` — first argument to printf = format string "%s\n".
- `mov rsi,enter` — second argument = the string to print: "Enter three numbers: "
- `call printf` — calls C library function to print the prompt.

### 6️⃣ Read first number (a)
```assembly
mov rdi, in_fmt
mov rsi, a
mov rax,0
call scanf
```

- `mov rdi, in_fmt` — format string "%ld"
- `mov rsi, a` — address of variable `a` where input is stored
- `mov rax,0` — required for variadic function
- `call scanf` — reads one 64-bit integer from user input and stores it at `a`

### 7️⃣ Read second number (b)
```assembly
mov rdi, in_fmt
mov rsi, b
mov rax,0
call scanf
```

Same pattern as above but stores input into `b`.

### 8️⃣ Read third number (c)
```assembly
mov rdi, in_fmt
mov rsi, c
mov rax,0
call scanf
```

Same pattern as above but stores input into `c`.

### 9️⃣ Compute 2a + 3b + c using IMUL
```assembly
; compute 2a + 3b + c using IMUL
mov rax,[a]
imul rax,2
mov rbx,[b]
imul rbx,3
add rax,rbx
add rax,[c]
mov [d],rax           ; store result in d
```

**This is the core arithmetic section:**

1. `mov rax,[a]` — load value of `a` into register `rax`
2. `imul rax,2` — multiply `rax` by 2 (so `rax` = 2*a)
3. `mov rbx,[b]` — load value of `b` into register `rbx`
4. `imul rbx,3` — multiply `rbx` by 3 (so `rbx` = 3*b)
5. `add rax,rbx` — add `rbx` to `rax` (so `rax` = 2*a + 3*b)
6. `add rax,[c]` — add value of `c` directly to `rax` (so `rax` = 2*a + 3*b + c)
7. `mov [d],rax` — store final result into memory location `d`

**IMUL Instruction:**
- `imul` = signed integer multiplication
- Can multiply a register by an immediate value or another register
- Result is stored in the destination operand

### 🔟 Print result
```assembly
mov rdi,out_fmt
mov rsi,[a]         
mov rdx,[b]        
mov rcx,[c]
mov r8,[d]
mov rax,0		
call printf
```

- `mov rdi,out_fmt` — format string "2*%ld + 3*%ld + %ld = %ld\n"
- `mov rsi,[a]` — first number (a)
- `mov rdx,[b]` — second number (b)
- `mov rcx,[c]` — third number (c)
- `mov r8,[d]` — result (2*a + 3*b + c)
- `mov rax,0` — required for variadic function
- `call printf` — prints something like "2*5 + 3*4 + 3 = 25"

**x86-64 Calling Convention:**
- 1st arg → rdi, 2nd → rsi, 3rd → rdx, 4th → rcx, 5th → r8, 6th → r9
- This function uses 5 arguments, so we use r8 for the 5th parameter

### 1️⃣1️⃣ Restore base pointer and exit
```assembly
pop rbp		
mov rax,0		
ret
```

- `pop rbp` — restores the original base pointer, cleaning up stack frame
- `mov rax,0` — return value 0 for main (success)
- `ret` — return to OS

## Key Concept: `d` vs `[d]` - Address vs Value

This is a fundamental concept in assembly language:

### Address (`d`)
```assembly
mov rsi, a      ; Move ADDRESS of variable 'a' into rsi
lea rdi, [b]    ; Load Effective Address of 'b' into rdi
```
- `d` refers to the **memory address** where variable `d` is stored
- Used when you need to pass a pointer/address to functions like `scanf`
- `scanf` needs the address so it knows WHERE to store the input

### Value (`[d]`)
```assembly
mov rax, [a]    ; Move VALUE stored at address 'a' into rax
mov [d], rax    ; Move value in rax to the memory location 'd'
```
- `[d]` refers to the **value stored** at the memory address `d`
- Square brackets `[]` mean "dereference" - get the value at this address
- Used when you want to work with the actual data

### Example in our code:
```assembly
mov rsi, a      ; Pass ADDRESS of 'a' to scanf (so scanf can store input there)
call scanf

mov rax, [a]    ; Load VALUE of 'a' into rax for calculation
imul rax, 2     ; Multiply the VALUE by 2

mov [d], rax    ; Store the calculated VALUE into memory location 'd'

mov r8, [d]     ; Load VALUE of 'd' to pass to printf for display
```

**Memory Analogy:**
- Think of `d` as a house address (e.g., "123 Main St")
- Think of `[d]` as what's inside the house at that address
- `scanf` needs the address to know where to deliver the mail
- Mathematical operations need the actual values inside the house

## Program Flow Summary

1. **Setup**: Save stack frame
2. **Input**: Prompt user and read three 64-bit integers
3. **Calculate**: Use `imul` to compute 2*a + 3*b + c
4. **Output**: Display the formula and result
5. **Cleanup**: Restore stack and exit

This program demonstrates signed integer multiplication (`imul`) and handling multiple inputs/outputs in assembly language.
