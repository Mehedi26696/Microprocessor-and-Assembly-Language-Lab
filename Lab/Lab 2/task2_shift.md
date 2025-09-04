# Task 2: Assembly Language Multiplication Using Shift Operations

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
- `out_fmt_2` — format string to print any string: "%s\n"
- `in_fmt` — format string for scanf to read a 64-bit integer: "%ld"

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

Saves the base pointer (rbp) on the stack for proper stack frame management.

### 5️⃣ Print prompt
```assembly
mov rax,0
mov rdi,out_fmt_2
mov rsi,enter
mov rax,0
call printf
```

- `mov rax,0` — Required for variadic functions in x86-64 ABI (number of XMM registers used)
- `mov rdi,out_fmt_2` — first argument: format string "%s\n"
- `mov rsi,enter` — second argument: "Enter three numbers: "
- `call printf` — display the prompt

**Note:** `mov rax,0` is set twice here, which is redundant but doesn't affect functionality.

### 6️⃣ Read first number (a)
```assembly
mov rax, 0
mov rdi, in_fmt
mov rsi, a
mov rax,0
call scanf
```

- `mov rdi, in_fmt` — format string "%ld"
- `mov rsi, a` — address of variable `a` where input will be stored
- `mov rax,0` — required for variadic function
- `call scanf` — read 64-bit integer into `a`

### 7️⃣ Read second number (b)
```assembly
mov rax, 0
mov rdi, in_fmt
mov rsi, b
mov rax,0
call scanf
```

Same pattern as above but stores input into `b`.

### 8️⃣ Read third number (c)
```assembly
mov rax, 0
mov rdi, in_fmt
mov rsi, c
mov rax,0
call scanf
```

Same pattern as above but stores input into `c`.

### 9️⃣ Compute 2a + 3b + c using shift operations
```assembly
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
```

**This is the core arithmetic section using bit shifting:**

1. `mov rax,[a]` — load value of `a` into register `rax`
2. `shl rax,1` — **shift left by 1 bit** (equivalent to multiplying by 2)
   - `shl` = Shift Left
   - Shifting left by 1 bit doubles the value: `a × 2¹ = 2a`
3. `mov rbx,[b]` — load value of `b` into register `rbx`
4. `mov rcx,rbx` — copy value of `b` to `rcx` (now we have `b` in both `rbx` and `rcx`)
5. `shl rcx,1` — shift `rcx` left by 1 bit (so `rcx` = 2b)
6. `add rcx,rbx` — add original `b` to `2b` (so `rcx` = 2b + b = 3b)
7. `add rax,rcx` — add `3b` to `2a` (so `rax` = 2a + 3b)
8. `add rax,[c]` — add value of `c` directly (so `rax` = 2a + 3b + c)
9. `mov [d],rax` — store final result in memory location `d`

### 🔟 Print result
```assembly
mov rdi,out_fmt
mov rsi,[a]         
mov rdx,[b]        
mov rcx,[c]  
mov r8, [d]       
mov rax,0		
call printf
```

- `mov rdi,out_fmt` — format string "2*%ld + 3*%ld + %ld = %ld\n"
- `mov rsi,[a]` — first number (value of a)
- `mov rdx,[b]` — second number (value of b)
- `mov rcx,[c]` — third number (value of c)
- `mov r8,[d]` — result (2*a + 3*b + c)
- `mov rax,0` — required for variadic function
- `call printf` — display result like "2*5 + 3*4 + 3 = 25"

### 1️⃣1️⃣ Restore base pointer and exit
```assembly
pop rbp		
mov rax,0		
ret
```

- `pop rbp` — restore original base pointer
- `mov rax,0` — return 0 (success)
- `ret` — return to operating system

## Key Concept: Bit Shifting for Multiplication

### Shift Left (SHL) - Multiplication by Powers of 2

```assembly
shl reg, n    ; Multiply by 2^n
```

**How it works:**
- Each left shift multiplies the number by 2
- `shl rax, 1` → multiply by 2¹ = 2
- `shl rax, 2` → multiply by 2² = 4
- `shl rax, 3` → multiply by 2³ = 8

**Binary example:**
```
Original: 5 = 0101 (binary)
shl 1:   10 = 1010 (binary) = 5 × 2 = 10
```

### Why Use Shift Instead of IMUL?

1. **Performance**: Bit shifting is faster than multiplication
2. **Efficiency**: Shift operations are single-cycle on most processors
3. **Power of 2 only**: Only works for multiplying by 2, 4, 8, 16, etc.

### Calculating 3b Using Shifts

Since 3 is not a power of 2, we use the formula: **3b = 2b + b**

```assembly
mov rbx,[b]       ; rbx = b
mov rcx,rbx       ; rcx = b  
shl rcx,1         ; rcx = 2b (shift left = multiply by 2)
add rcx,rbx       ; rcx = 2b + b = 3b
```

This is more efficient than using `imul rbx, 3` for multiplication by 3.

## Comparison with IMUL Version

| Operation | Shift Version | IMUL Version |
|-----------|---------------|--------------|
| 2×a | `shl rax,1` | `imul rax,2` |
| 3×b | `shl rcx,1; add rcx,rbx` | `imul rbx,3` |
| Performance | Faster | Slower |
| Flexibility | Powers of 2 only | Any integer |

## Program Flow Summary

1. **Setup**: Save stack frame
2. **Input**: Read three 64-bit integers (a, b, c)
3. **Calculate**: Use bit shifts to compute 2*a + 3*b + c
   - Shift `a` left by 1 to get 2*a
   - Shift `b` left by 1 and add original `b` to get 3*b
   - Add all components together
4. **Output**: Display the formula and result
5. **Cleanup**: Restore stack and exit

This program demonstrates how bit shifting can be used as an efficient alternative to multiplication for powers of 2, and how to combine shifts with addition to achieve multiplication by other small integers.
