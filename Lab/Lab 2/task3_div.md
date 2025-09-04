# Task 3: Assembly Language Division Program (Sum Formula)

## Assembly Code
```assembly
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

x:      dq 0
sum:    dq 0

enter:	db "Enter a positive integer: ",0
out_fmt:	db "Sum from 1 to %ld = %ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:	db "%ld",0
```

- `SECTION .data` — declares a data section for initialized data.
- `x` — 64-bit (`dq` = define quadword) memory location to store the input number. Initialized to 0.
- `sum` — 64-bit memory location to store the calculated sum result. Initialized to 0.
- `enter` — string to prompt the user: "Enter a positive integer: ".
- `out_fmt` — format string for printf to display result: "Sum from 1 to %ld = %ld\n"
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
; print prompt
mov rax,0
mov rdi,out_fmt_2
mov rsi,enter
mov rax,0
call printf
```

- `mov rax,0` — Required for variadic functions in x86-64 ABI
- `mov rdi,out_fmt_2` — first argument: format string "%s\n"
- `mov rsi,enter` — second argument: "Enter a positive integer: "
- `call printf` — display the prompt

**Note:** `mov rax,0` is set twice here, which is redundant but doesn't affect functionality.

### 6️⃣ Read input number
```assembly
; read x
mov rax,0
mov rdi,in_fmt
mov rsi,x
mov rax,0
call scanf
```

- `mov rdi,in_fmt` — format string "%ld"
- `mov rsi,x` — address of variable `x` where input will be stored
- `mov rax,0` — required for variadic function
- `call scanf` — read 64-bit integer into `x`

### 7️⃣ Compute sum using mathematical formula
```assembly
; compute sum = x*(x+1)/2
mov rax,[x]
mov rbx,rax
add rbx,1          ; rbx = x+1
imul rax,rbx       ; rax = x*(x+1)
mov rbx,2
cqo                 ; extend rax to rdx:rax
idiv rbx            ; rax = rax / 2
mov [sum],rax
```

**This is the core mathematical computation using the sum formula:**

1. `mov rax,[x]` — load value of `x` into register `rax`
2. `mov rbx,rax` — copy `x` to `rbx` (now both `rax` and `rbx` contain `x`)
3. `add rbx,1` — add 1 to `rbx` (so `rbx` = x+1)
4. `imul rax,rbx` — multiply `rax` by `rbx` (so `rax` = x × (x+1))
5. `mov rbx,2` — load divisor 2 into `rbx`
6. `cqo` — **Convert Quadword to Octword** - extends `rax` to `rdx:rax`
7. `idiv rbx` — signed divide `rdx:rax` by `rbx` (result in `rax` = x×(x+1)/2)
8. `mov [sum],rax` — store final result in memory location `sum`

### 8️⃣ Print result
```assembly
; print result
mov rdi,out_fmt
mov rsi,[x]
mov rdx,[sum]
mov rax,0
call printf
```

- `mov rdi,out_fmt` — format string "Sum from 1 to %ld = %ld\n"
- `mov rsi,[x]` — the input number (value of x)
- `mov rdx,[sum]` — the calculated sum
- `mov rax,0` — required for variadic function
- `call printf` — display result like "Sum from 1 to 5 = 15"

### 9️⃣ Restore base pointer and exit
```assembly
pop rbp		
mov rax,0		
ret
```

- `pop rbp` — restore original base pointer
- `mov rax,0` — return 0 (success)
- `ret` — return to operating system

## Key Concept: Division in Assembly Language

### The Sum Formula: S = n(n+1)/2

This program calculates the sum of integers from 1 to n using the mathematical formula:
**Sum = 1 + 2 + 3 + ... + n = n(n+1)/2**

**Examples:**
- n=5: Sum = 5×6/2 = 15 (which is 1+2+3+4+5)
- n=10: Sum = 10×11/2 = 55 (which is 1+2+3+...+10)

### Division Instructions: IDIV vs DIV

```assembly
idiv divisor    ; Signed division
div divisor     ; Unsigned division
```

**Our program uses `idiv` (signed division):**
- Works with both positive and negative numbers
- Divides `rdx:rax` (128-bit) by the divisor
- Quotient stored in `rax`
- Remainder stored in `rdx`

### The CQO Instruction - Critical for Division

```assembly
cqo    ; Convert Quadword to Octword
```

**What CQO does:**
- Extends the sign of `rax` into `rdx`
- Creates a 128-bit dividend in `rdx:rax`
- **Essential before IDIV** to avoid unpredictable results

**How it works:**
- If `rax` is positive: `rdx` becomes 0
- If `rax` is negative: `rdx` becomes -1 (0xFFFFFFFFFFFFFFFF)

**Example:**
```assembly
mov rax, 100        ; rax = 100
cqo                 ; rdx = 0, rdx:rax = 100
mov rbx, 3
idiv rbx            ; 100 ÷ 3 = 33 remainder 1
                    ; rax = 33, rdx = 1
```

### Why CQO is Necessary

**Without CQO (DANGEROUS):**
```assembly
mov rax, 100        ; rax = 100
; rdx contains garbage value, let's say 0x123456789ABCDEF0
mov rbx, 3
idiv rbx            ; Divides garbage:100 by 3 = unpredictable result!
```

**With CQO (CORRECT):**
```assembly
mov rax, 100        ; rax = 100
cqo                 ; rdx = 0, making rdx:rax = 100
mov rbx, 3
idiv rbx            ; Divides 100 by 3 = 33 remainder 1
```

### Division Operation Breakdown

In our program:
```assembly
mov rax,[x]         ; Let's say x = 5, so rax = 5
mov rbx,rax         ; rbx = 5
add rbx,1           ; rbx = 6
imul rax,rbx        ; rax = 5 × 6 = 30
mov rbx,2           ; rbx = 2
cqo                 ; rdx = 0, rdx:rax = 30
idiv rbx            ; 30 ÷ 2 = 15, so rax = 15
```

Result: Sum from 1 to 5 = 15 ✓

## Alternative Division Methods

### Method 1: Using SHR (Shift Right) for Division by Powers of 2
```assembly
; For division by 2, we could use:
shr rax, 1          ; Right shift = divide by 2
```
**Note:** This only works for positive numbers and powers of 2.

### Method 2: Using the Formula Differently
```assembly
; Could compute as: sum = ((x+1)*x)/2
mov rax,[x]
add rax,1           ; rax = x+1
imul rax,[x]        ; rax = (x+1)*x
mov rbx,2
cqo
idiv rbx            ; rax = (x+1)*x/2
```

## Performance Analysis

| Method | Operations | Efficiency |
|--------|------------|------------|
| Loop (1+2+3+...+n) | n additions | O(n) |
| Formula n(n+1)/2 | 1 multiply + 1 divide | O(1) |
| Our approach | Most efficient | Constant time |

## Program Flow Summary

1. **Setup**: Save stack frame
2. **Input**: Prompt and read a positive integer n
3. **Calculate**: Use the mathematical formula n(n+1)/2
   - Multiply n by (n+1)
   - Divide result by 2 using proper division setup
4. **Output**: Display the input and calculated sum
5. **Cleanup**: Restore stack and exit

This program demonstrates efficient mathematical computation in assembly language, proper division techniques, and the importance of the CQO instruction for signed division operations.
