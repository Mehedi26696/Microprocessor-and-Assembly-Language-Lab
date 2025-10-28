# 64-bit Assembly Language with NASM  

A comprehensive guide to learning x86-64 assembly programming on Linux using the Netwide Assembler (NASM).

## Table of Contents
1. [CPU Registers (x86-64)](#1-cpu-registers-x86-64)
2. [Memory Organization & Sections](#2-memory-organization--sections)
3. [Fundamental Instructions](#3-fundamental-instructions)
4. [Linux System Calls](#4-linux-system-calls)
5. [C Function Integration](#5-c-function-integration)
6. [Stack Management & Alignment](#6-stack-management--alignment)
7. [Programming Best Practices](#7-programming-best-practices)

---

## 1. CPU Registers (x86-64)

The x86-64 architecture provides a rich set of 64-bit registers for various programming tasks.

### 1.1 General Purpose Registers

These 8 primary registers are 64 bits wide and serve specific conventional purposes:

| Register | Primary Use | Description |
|----------|-------------|-------------|
| `rax` | **Accumulator** | Mathematical operations, function return values |
| `rbx` | **Base** | General-purpose storage, base addressing |
| `rcx` | **Counter** | Loop counters, shift operations, 4th function argument |
| `rdx` | **Data** | I/O operations, multiplication/division, 3rd function argument |
| `rsi` | **Source Index** | String operations source, 2nd function argument |
| `rdi` | **Destination Index** | String operations destination, 1st function argument |
| `rbp` | **Base Pointer** | Stack frame base, function scope management |
| `rsp` | **Stack Pointer** | Current stack top (critical - never modify directly) |

### 1.2 Extended Registers

Additional general-purpose registers available in 64-bit mode:

- `r8` through `r15` - Extra general-purpose registers for increased flexibility

### 1.3 Special Registers

- `rip` - **Instruction Pointer**: Points to the next instruction to execute (managed automatically by CPU)

### 1.4 Register Subsections

Each register can be accessed at different bit widths for compatibility and efficiency:

```assembly
; Example with RAX register:
rax    ; 64-bit: 0x0123456789ABCDEF
eax    ; 32-bit: 0x89ABCDEF (lower 32 bits)
ax     ; 16-bit: 0xCDEF (lower 16 bits)
al     ; 8-bit:  0xEF (lower 8 bits)
ah     ; 8-bit:  0xCD (bits 8-15 of AX)
```

**Important Notes:**
- Writing to 32-bit registers (e.g., `eax`) automatically zeros the upper 32 bits of the 64-bit register
- Writing to 8/16-bit registers preserves the upper bits

---

## 2. Memory Organization & Sections

NASM organizes programs into distinct sections, each serving a specific purpose.

### 2.1 Section Types

#### `.data` Section - Initialized Data
Contains variables with initial values known at compile time.

```assembly
section .data
    welcome_msg  db "Hello, Assembly World!", 0xA, 0  ; String with newline and null terminator
    number       dq 42                                 ; 64-bit integer
    pi           dd 3.14159                           ; 32-bit float
    array        dw 1, 2, 3, 4, 5                    ; Array of 16-bit words
```

**Detailed Explanation of Data Type Directives:**

**`db` (Define Byte)** - Allocates 1 byte (8 bits) of memory
- Used for: Characters, small integers (0-255), byte arrays
- Example breakdown: `"Hello, Assembly World!"` - each character occupies 1 byte
- Can store: ASCII characters, small numbers, or raw byte data

**`dw` (Define Word)** - Allocates 2 bytes (16 bits) of memory  
- Used for: Small integers (-32,768 to 32,767 signed, 0-65,535 unsigned)
- Example: `dw 1, 2, 3, 4, 5` creates 5 consecutive 16-bit values (total: 10 bytes)
- Perfect for: Array indices, small counters, port numbers

**`dd` (Define Double Word)** - Allocates 4 bytes (32 bits) of memory
- Used for: Standard integers, single-precision floating-point numbers
- Example: `dd 3.14159` stores a 32-bit float representation of π
- Common for: Most integer operations, memory addresses in 32-bit mode

**`dq` (Define Quad Word)** - Allocates 8 bytes (64 bits) of memory
- Used for: Large integers, double-precision floats, 64-bit pointers
- Example: `dq 42` stores the number 42 as a 64-bit integer
- Essential for: 64-bit arithmetic, memory addresses in 64-bit mode

**Special Values Explained:**

**`0xA`** (Hexadecimal for 10):
- Represents the **newline character** (Line Feed - LF)
- Equivalent to `\n` in C/C++ or other high-level languages
- When printed, causes the cursor to move to the beginning of the next line
- Essential for proper text formatting in console output

**`0`** (Null Terminator):
- Marks the **end of a C-style string**
- Critical for string functions to know where the string ends
- Without it, functions like `printf` would continue reading memory until randomly encountering a zero byte
- Always required when interfacing with C functions or system calls that expect null-terminated strings

**Memory Layout Visualization:**
```
welcome_msg: [H][e][l][l][o][,][ ][A][s][s][e][m][b][l][y][ ][W][o][r][l][d][!][0xA][0]
             │                    Each character = 1 byte                     │ \n │\0│
             └─────────────────── 22 characters ──────────────────────────────┘
```

**Important Notes:**
- The order matters! `0xA, 0` means newline first, then null terminator
- This sequence prints the message, moves to the next line, then properly terminates the string
- Each data type directive can accept multiple values separated by commas
- Mixing data types in a single directive is allowed: `db 'A', 65, 0x41` (all represent 'A')

#### `.bss` Section - Uninitialized Data
Reserves space for variables that will be initialized at runtime.

```assembly
section .bss
    user_input   resb 256    ; Reserve 256 bytes for user input
    temp_buffer  resq 10     ; Reserve space for 10 quadwords (64-bit)
    result       resd 1      ; Reserve space for 1 doubleword (32-bit)
```

The `.bss` section is used for declaring uninitialized variables that will be allocated memory space but not given initial values in the executable file. This section is automatically zeroed out when the program loads.

**Key Characteristics:**
- Memory is allocated but not initialized in the executable
- Variables are automatically set to zero at program startup
- More memory-efficient than storing zeros in the executable file
- Perfect for buffers, temporary storage, and variables that will be set at runtime

**Reservation Directives:**
- `resb` (reserve bytes) - Allocates 1-byte units
- `resw` (reserve words) - Allocates 2-byte units (16-bit)
- `resd` (reserve doublewords) - Allocates 4-byte units (32-bit)
- `resq` (reserve quadwords) - Allocates 8-byte units (64-bit)

**Example Breakdown:**
- `user_input resb 256` - Creates a 256-byte buffer for string input
- `temp_buffer resq 10` - Allocates 80 bytes (10 × 8 bytes) for 64-bit values
- `result resd 1` - Allocates 4 bytes for a single 32-bit integer

**Gotcha:** Unlike the `.data` section, you cannot initialize values here. Use `.data` for variables that need initial values.

#### `.text` Section - Executable Code
Contains the actual program instructions.

```assembly
section .text
    global _start           ; Make _start visible to linker
_start:
    ; Program code goes here
    mov rax, 1             ; System call number for sys_write
    ; ... more instructions
```

### 2.2 Data Type Declarations

| Directive | Size | Description | Example |
|-----------|------|-------------|---------|
| `db` | 1 byte | Define byte | `db 'A', 0x41, 65` |
| `dw` | 2 bytes | Define word | `dw 1000, 0x1234` |
| `dd` | 4 bytes | Define doubleword | `dd 100000, 3.14` |
| `dq` | 8 bytes | Define quadword | `dq 1000000000` |

### 2.3 Memory Reservation

| Directive | Size | Description | Example |
|-----------|------|-------------|---------|
| `resb` | 1 byte | Reserve bytes | `resb 100` |
| `resw` | 2 bytes | Reserve words | `resw 50` |
| `resd` | 4 bytes | Reserve doublewords | `resd 25` |
| `resq` | 8 bytes | Reserve quadwords | `resq 10` |

---

## 3. Fundamental Instructions

### 3.1 Data Movement Instructions

#### Basic Movement
```assembly
mov rax, rbx        ; Copy contents of rbx to rax
mov rax, 42         ; Load immediate value 42 into rax
mov [memory], rax   ; Store rax contents to memory location
mov rax, [memory]   ; Load from memory location into rax
```

#### Address Loading
```assembly
lea rax, [variable] ; Load Effective Address - gets the address of variable
lea rsi, [rdi + 8]  ; Calculate address: rdi + 8, store in rsi
```

### 3.2 Arithmetic Instructions

#### Basic Arithmetic
```assembly
add rax, rbx        ; rax = rax + rbx
add rax, 10         ; rax = rax + 10
sub rax, rbx        ; rax = rax - rbx
sub rax, 5          ; rax = rax - 5

inc rax             ; rax = rax + 1 (more efficient than add rax, 1)
dec rax             ; rax = rax - 1 (more efficient than sub rax, 1)
```

#### Multiplication and Division
```assembly
; Signed multiplication
imul rax, rbx       ; rax = rax * rbx
imul rax, rbx, 5    ; rax = rbx * 5

; Signed division (rdx:rax ÷ operand)
mov rax, 100        ; Dividend
cqo                 ; Sign-extend rax into rdx:rax
idiv rbx            ; rax = quotient, rdx = remainder

Explanation
This performs a signed division using idiv.

- mov rax, 100 — load dividend into RAX.
- cqo — sign-extend RAX into RDX:RAX (RDX = 0 if RAX >= 0; RDX = -1 if RAX < 0).
- idiv rbx — divide signed 128-bit value RDX:RAX by RBX; quotient → RAX, remainder → RDX.
- Exceptions — divide-by-zero or quotient overflow raises a CPU exception (#DE).

Example
If RAX = 100 and RBX = 25, then after execution:
RAX = 4    ; Quotient
RDX = 0    ; Remainder
```

### 3.3 Logical Instructions

```assembly
; Bitwise AND - Both bits must be 1 to result in 1
and rax, rbx        ; Bitwise AND
; Example: rax = 0b1100 (12), rbx = 0b1010 (10)
; Result:  rax = 0b1000 (8)   - only bits 3 are 1 in both

or  rax, rbx        ; Bitwise OR - Either bit can be 1 to result in 1
; Example: rax = 0b1100 (12), rbx = 0b0011 (3)
; Result:  rax = 0b1111 (15)  - combines all 1 bits

xor rax, rbx        ; Bitwise XOR - Bits must be different to result in 1
; Example: rax = 0b1100 (12), rbx = 0b1010 (10)
; Result:  rax = 0b0110 (6)   - only differing bits become 1

not rax             ; Bitwise NOT - Flips all bits (one's complement)
; Example: rax = 0b00001100 (12)
; Result:  rax = 0b11110011 (243 in 8-bit) - all bits inverted

; Bit shifting operations
shl rax, 2          ; Shift left by 2 bits (multiply by 4)
; Example: rax = 0b00000101 (5)
; Result:  rax = 0b00010100 (20) - equivalent to 5 * 2^2 = 5 * 4

shr rax, 1          ; Shift right by 1 bit (divide by 2, unsigned)
; Example: rax = 0b00001100 (12)
; Result:  rax = 0b00000110 (6)  - equivalent to 12 / 2^1 = 12 / 2
```

### 3.4 Comparison and Testing

```assembly
cmp rax, rbx        ; Compare rax with rbx (sets flags)
cmp rax, 0          ; Compare rax with zero
test rax, rax       ; Test if rax is zero (more efficient than cmp rax, 0)
test rax, rbx       ; Bitwise AND for testing (doesn't modify operands)
```

### 3.5 Control Flow Instructions

#### Unconditional Jumps
```assembly
jmp label           ; Always jump to label
call function       ; Call function (pushes return address)
ret                 ; Return from function
```

#### Conditional Jumps (used after cmp or test)
```assembly
je  label           ; Jump if Equal (ZF=1)
jne label           ; Jump if Not Equal (ZF=0)
jg  label           ; Jump if Greater (signed)
jl  label           ; Jump if Less (signed)
jge label           ; Jump if Greater or Equal (signed)
jle label           ; Jump if Less or Equal (signed)
ja  label           ; Jump if Above (unsigned)
jb  label           ; Jump if Below (unsigned)
```

### 3.6 Stack Operations

```assembly
push rax            ; Push rax onto stack (rsp decreases by 8)
pop  rax            ; Pop from stack into rax (rsp increases by 8)
push 42             ; Push immediate value
```

---

## 4. Linux System Calls

Linux 64-bit uses the `syscall` instruction instead of the legacy `int 0x80` interrupt.

### 4.1 System Call Convention

**Register Usage:**
- `rax` - System call number
- `rdi` - 1st argument
- `rsi` - 2nd argument  
- `rdx` - 3rd argument
- `r10` - 4th argument
- `r8`  - 5th argument
- `r9`  - 6th argument
- **Return value:** `rax`

### 4.2 Common System Call Numbers

| System Call | Number | Purpose |
|-------------|--------|---------|
| `sys_read` | 0 | Read from file descriptor |
| `sys_write` | 1 | Write to file descriptor |
| `sys_open` | 2 | Open file |
| `sys_close` | 3 | Close file |
| `sys_exit` | 60 | Exit program |

### 4.3 Complete Example: Hello World

```assembly
section .data
    hello_msg db "Hello, 64-bit Assembly!", 0xA    ; Message with newline
    msg_len   equ $ - hello_msg                    ; Calculate length

section .text
    global _start

_start:
    ; sys_write(stdout, hello_msg, msg_len)
    mov rax, 1          ; sys_write system call
    mov rdi, 1          ; file descriptor 1 (stdout)
    mov rsi, hello_msg  ; pointer to message
    mov rdx, msg_len    ; number of bytes to write
    syscall             ; invoke system call
    
    ; sys_exit(0)
    mov rax, 60         ; sys_exit system call
    xor rdi, rdi        ; exit status 0 (success)
    syscall             ; invoke system call
```

### 4.4 Error Handling

System calls return negative values on error:

```assembly
    syscall
    test rax, rax       ; Check if return value is negative
    js   error_handler  ; Jump if sign flag is set (negative)
    ; Success path continues here
```

---

## 5. C Function Integration

### 5.1 System V AMD64 ABI (Application Binary Interface)

**Parameter Passing Convention:**
1. `rdi` - 1st argument
2. `rsi` - 2nd argument
3. `rdx` - 3rd argument
4. `rcx` - 4th argument
5. `r8`  - 5th argument
6. `r9`  - 6th argument
7. Additional arguments pushed onto stack (right-to-left)

**Special Rules:**
- **Variadic functions** (like `printf`): Set `rax` to 0 before calling
- **Return value**: Returned in `rax`
- **Caller-saved registers**: `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`-`r11`
- **Callee-saved registers**: `rbx`, `rbp`, `r12`-`r15`

### 5.2 Complete printf Example

```assembly
extern printf                   ; Declare external C function

section .data
    format_str db "x=%ld, y=%ld, sum=%ld", 0xA, 0  ; Format string with newline
    x          dq 15            ; First number
    y          dq 27            ; Second number
    result     dq 0             ; Will store the sum

section .text
    global main                 ; Entry point for C runtime

main:
    ; Function prologue - set up stack frame
    push rbp                    ; Save old base pointer
    mov  rbp, rsp              ; Set new base pointer
    sub  rsp, 8                ; Align stack to 16-byte boundary

    ; Calculate sum
    mov rax, [x]               ; Load x into rax
    add rax, [y]               ; Add y to rax
    mov [result], rax          ; Store sum in result

    ; Prepare arguments for printf
    mov rdi, format_str        ; 1st arg: format string
    mov rsi, [x]               ; 2nd arg: value of x
    mov rdx, [y]               ; 3rd arg: value of y
    mov rcx, [result]          ; 4th arg: calculated sum
    xor rax, rax               ; rax = 0 (required for variadic functions)
    
    call printf                ; Call printf function

    ; Function epilogue - restore stack
    add rsp, 8                 ; Restore stack pointer
    mov rsp, rbp               ; Restore stack pointer
    pop rbp                    ; Restore old base pointer
    
    mov rax, 0                 ; Return 0 (success)
    ret                        ; Return to caller
```

### 5.3 Compilation and Linking

```bash
# Assemble the source file
nasm -f elf64 program.asm -o program.o

# Link with C runtime library
gcc -no-pie program.o -o program

# or 
ld program.o -o program

# Run the program
./program
```

---

## 6. Stack Management & Alignment

### 6.1 Stack Alignment Rule

**Critical Rule:** Before calling any C function, `rsp` must be aligned to a 16-byte boundary.

### 6.2 Why Alignment Matters

- **Performance**: Aligned memory access is faster
- **SSE/AVX Instructions**: Require 16-byte aligned data
- **ABI Compliance**: Required by System V AMD64 ABI

### 6.3 Alignment Strategies

#### Strategy 1: Simple Adjustment
```assembly
main:
    push rbp                ; rsp is now misaligned (rsp % 16 = 8)
    mov  rbp, rsp
    sub  rsp, 8             ; Realign to 16-byte boundary
    
    ; ... function calls here ...
    
    add  rsp, 8             ; Restore stack
    pop  rbp
    ret
```

#### Strategy 2: Reserve Local Variables
```assembly
main:
    push rbp                ; Save base pointer
    mov  rbp, rsp          ; Set new base pointer
    sub  rsp, 32           ; Reserve 32 bytes (maintains alignment)
    
    ; Use [rbp-8], [rbp-16], etc. for local variables
    
    mov  rsp, rbp          ; Restore stack pointer
    pop  rbp               ; Restore base pointer
    ret
```

### 6.4 Stack Frame Layout

```
High Memory
+------------------+
| Return Address   |  <-- Pushed by 'call'
+------------------+
| Old RBP          |  <-- rbp points here after push rbp
+------------------+
| Local Variables  |  <-- rsp points here after sub rsp, N
+------------------+
| Alignment Padding|
+------------------+  <-- rsp (16-byte aligned)
Low Memory
```

---

## 7. Programming Best Practices

### 7.1 Code Organization

```assembly
; Standard program structure
section .data
    ; Initialized data here

section .bss
    ; Uninitialized data here

section .text
    global _start          ; For standalone programs
    ; or
    global main           ; For programs linked with C runtime

_start:                   ; Program entry point
    ; Main program logic
    
    ; Exit cleanly
    mov rax, 60           ; sys_exit
    xor rdi, rdi          ; exit code 0
    syscall
```

### 7.2 Register Usage Guidelines

1. **Preserve callee-saved registers** (`rbx`, `rbp`, `r12`-`r15`) in functions
2. **Use appropriate registers** for their conventional purposes
3. **Clear upper bits** when working with smaller data types
4. **Save/restore registers** around function calls if needed

### 7.3 Memory Management

```assembly
; Good: Clear register before use with smaller data
xor eax, eax              ; Clears all of rax efficiently
mov al, [byte_var]        ; Load byte, rax is clean

; Good: Proper string handling
mov rsi, source_string    ; Source
mov rdi, dest_buffer      ; Destination  
mov rcx, string_length    ; Count
rep movsb                 ; Copy bytes
```

### 7.4 Error Handling

```assembly
; Always check system call return values
    syscall
    test rax, rax
    js   error_exit        ; Jump on error (negative return)
    
error_exit:
    mov rax, 60            ; sys_exit
    mov rdi, 1             ; exit code 1 (error)
    syscall
```
 
---

## Summary

This guide covers the essential concepts for 64-bit assembly programming with NASM on Linux:

1. **Registers**: Understanding the x86-64 register set and their conventional uses
2. **Memory**: Organizing code and data using NASM sections
3. **Instructions**: Core instruction types for data movement, arithmetic, and control flow
4. **System Calls**: Interfacing with the Linux kernel using the 64-bit syscall convention
5. **C Integration**: Calling C functions following the System V AMD64 ABI
6. **Stack Management**: Maintaining proper stack alignment for function calls 
