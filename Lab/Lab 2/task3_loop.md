# Task 3: Assembly Language Loop Program (Iterative Sum)

## Assembly Code
```assembly
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

prompt:	db "Enter a positive integer: ",0
out_fmt:	db "Sum from 1 to %ld = %ld", 10, 0	
out_fmt_2:	db "%s",10,0
in_fmt:	db "%ld",0
```

- `SECTION .data` — declares a data section for initialized data.
- `x` — 64-bit (`dq` = define quadword) memory location to store the input number. Initialized to 0.
- `prompt` — string to prompt the user: "Enter a positive integer: ".
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
mov rsi,prompt
mov rax,0
call printf
```

- `mov rax,0` — Required for variadic functions in x86-64 ABI
- `mov rdi,out_fmt_2` — first argument: format string "%s\n"
- `mov rsi,prompt` — second argument: "Enter a positive integer: "
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

### 7️⃣ Initialize loop variables
```assembly
; initialize registers: rax = sum, rbx = i, rcx = x
mov rax,0       ; sum = 0
mov rbx,1          ; i = 1
mov rcx,[x]        ; rcx = x (upper limit)
```

**Register allocation for the loop:**
- `rax` — accumulator for the sum (starts at 0)
- `rbx` — loop counter `i` (starts at 1)
- `rcx` — upper limit (value of x from user input)

This is equivalent to the C code:
```c
int sum = 0;     // rax
int i = 1;       // rbx  
int limit = x;   // rcx
```

### 8️⃣ Loop implementation
```assembly
loop_start:
        cmp rbx,rcx
        jg loop_end        ; if i > x, exit

        add rax,rbx        ; sum += i
        inc rbx            ; i++

        jmp loop_start

loop_end:
```

**This is the core loop structure:**

1. `loop_start:` — label marking the beginning of the loop
2. `cmp rbx,rcx` — compare `i` (rbx) with `x` (rcx)
3. `jg loop_end` — **jump if greater** - if i > x, exit the loop
4. `add rax,rbx` — add current `i` to the sum: sum += i
5. `inc rbx` — increment `i` by 1: i++
6. `jmp loop_start` — unconditional jump back to start of loop

**Equivalent C code:**
```c
for (int i = 1; i <= x; i++) {
    sum += i;
}
```

### 9️⃣ Print result
```assembly
; print result
mov rdi,out_fmt
mov rsi,rcx        ; x
mov rdx,rax        ; sum
mov rax,0
call printf
```

- `mov rdi,out_fmt` — format string "Sum from 1 to %ld = %ld\n"
- `mov rsi,rcx` — the input number (value of x, stored in rcx)
- `mov rdx,rax` — the calculated sum (accumulated in rax)
- `mov rax,0` — required for variadic function
- `call printf` — display result like "Sum from 1 to 5 = 15"

### 🔟 Restore base pointer and exit
```assembly
pop rbp		
mov rax,0		
ret
```

- `pop rbp` — restore original base pointer
- `mov rax,0` — return 0 (success)
- `ret` — return to operating system

## Key Concept: Loop Control in Assembly Language

### Loop Structure Components

1. **Initialization** - Set up loop variables
2. **Condition Check** - Test if loop should continue
3. **Loop Body** - Execute the actual work
4. **Update** - Modify loop variables
5. **Jump Back** - Return to condition check

### Comparison Instructions and Conditional Jumps

```assembly
cmp operand1, operand2    ; Compare two values
```

**Common conditional jumps:**
- `je` / `jz` — Jump if Equal / Jump if Zero
- `jne` / `jnz` — Jump if Not Equal / Jump if Not Zero
- `jg` / `jnle` — Jump if Greater / Jump if Not Less or Equal
- `jl` / `jnge` — Jump if Less / Jump if Not Greater or Equal
- `jge` / `jnl` — Jump if Greater or Equal / Jump if Not Less
- `jle` / `jng` — Jump if Less or Equal / Jump if Not Greater

### Our Loop Logic Analysis

```assembly
cmp rbx,rcx     ; Compare i with x
jg loop_end     ; If i > x, exit loop
```

**Truth table for our condition:**
| i | x | i > x | Action |
|---|---|-------|--------|
| 1 | 5 | false | Continue loop |
| 2 | 5 | false | Continue loop |
| 5 | 5 | false | Continue loop |
| 6 | 5 | true  | Exit loop |

### Loop Execution Example (x = 5)

| Iteration | rbx (i) | rcx (x) | rax (sum) | Action |
|-----------|---------|---------|-----------|---------|
| Initial   | 1       | 5       | 0         | Start |
| 1         | 1       | 5       | 1         | sum += 1 |
| 2         | 2       | 5       | 3         | sum += 2 |
| 3         | 3       | 5       | 6         | sum += 3 |
| 4         | 4       | 5       | 10        | sum += 4 |
| 5         | 5       | 5       | 15        | sum += 5 |
| 6         | 6       | 5       | 15        | i > x, exit |

**Final result:** Sum from 1 to 5 = 15 ✓

### Register Usage Strategy

**Why we chose these registers:**
- `rax` — Accumulator register, natural choice for sum
- `rbx` — General-purpose register, good for loop counter
- `rcx` — Counter register, traditional for loop limits
- Avoids conflicts with function call registers (rdi, rsi, rdx for printf)

### Alternative Loop Structures

#### Method 1: Countdown Loop
```assembly
mov rbx,[x]         ; Start from x
mov rax,0           ; sum = 0

countdown_loop:
    cmp rbx,0
    jle countdown_end   ; if i <= 0, exit
    add rax,rbx         ; sum += i
    dec rbx             ; i--
    jmp countdown_loop
countdown_end:
```

#### Method 2: Using Loop Instruction
```assembly
mov rcx,[x]         ; Loop counter
mov rax,0           ; sum = 0
mov rbx,1           ; i = 1

repeat_loop:
    add rax,rbx         ; sum += i
    inc rbx             ; i++
    loop repeat_loop    ; Decrements rcx and jumps if rcx != 0
```

## Performance Comparison

| Method | Time Complexity | Space | Instructions per iteration |
|--------|----------------|-------|----------------------------|
| Loop (this program) | O(n) | O(1) | 4 (cmp, jg, add, inc) |
| Formula n(n+1)/2 | O(1) | O(1) | 1 (constant time) |

**Trade-offs:**
- **Loop**: Easier to understand, mimics high-level language loops
- **Formula**: Much faster for large numbers, more efficient

### When to Use Each Approach

**Use Loop when:**
- Learning assembly language concepts
- Need to perform operations on each number individually
- Formula is complex or unknown

**Use Formula when:**
- Performance is critical
- Working with large numbers
- Mathematical formula exists

## Program Flow Summary

1. **Setup**: Save stack frame
2. **Input**: Prompt and read a positive integer n
3. **Initialize**: Set sum=0, counter=1, limit=n
4. **Loop**: 
   - Check if counter > limit
   - Add counter to sum
   - Increment counter
   - Repeat until counter > limit
5. **Output**: Display the input and calculated sum
6. **Cleanup**: Restore stack and exit

This program demonstrates fundamental loop control structures in assembly language, register management, and iterative computation techniques. It provides a clear example of how high-level loop constructs translate to low-level assembly instructions.
