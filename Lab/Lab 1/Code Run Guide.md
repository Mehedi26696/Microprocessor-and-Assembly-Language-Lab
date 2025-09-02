# Assembly Code Run Guide (Linux)

## 1. Writing Assembly Code

We write our assembly code using a text editor (e.g., `vim`, `nano`, `gedit`). Save the file with a `.asm` extension.

### Example 1: `hello.asm`

```asm
section .data
    msg db 'Hello, Linux!', 0xA   ; Message with newline
    len equ $ - msg               ; Message length

section .text
    global _start

_start:
    mov eax, 4        ; syscall number for sys_write
    mov ebx, 1        ; file descriptor 1 (stdout)
    mov ecx, msg      ; pointer to message
    mov edx, len      ; message length
    int 0x80          ; call kernel

    mov eax, 1        ; syscall number for sys_exit
    xor ebx, ebx      ; exit code 0
    int 0x80
```

#### Code Explanation

| Line/Section         | Meaning                                                                 |
|----------------------|-------------------------------------------------------------------------|
| `section .data`      | Data segment for variables and messages                                 |
| `msg db ...`         | Define a string message                                                 |
| `len equ $ - msg`    | Calculate message length                                                |
| `section .text`      | Code segment                                                           |
| `global _start`      | Entry point for the linker                                              |
| `_start:`            | Program entry label                                                     |
| `mov eax, 4`         | Set syscall number for `write`                                          |
| `mov ebx, 1`         | Set file descriptor (1 = stdout)                                        |
| `mov ecx, msg`       | Set pointer to message                                                  |
| `mov edx, len`       | Set message length                                                      |
| `int 0x80`           | Interrupt to invoke syscall                                             |
| `mov eax, 1`         | Set syscall number for `exit`                                           |
| `xor ebx, ebx`       | Set exit code to 0                                                      |
| `int 0x80`           | Interrupt to invoke syscall                                             |

---

### Example 2: Using `printf` from C Library

```asm
extern  printf

SECTION .data

a:      dq  5
b:      dq  2
c:      dq  0
fmt:    db "a=%ld, b=%ld c=%ld", 10, 0

SECTION .text

global main
main:
        push    rbp

        mov     rax,[a]
        mov     rbx,[b]
        add     rax,rbx
        mov     [c],rax
        mov     rdi,fmt
        mov     rsi,[a]
        mov     rdx,[b]
        mov     rcx,[c]
        mov     rax,0
        call    printf

        pop     rbp

        mov     rax,0
        ret
```

#### Code Explanation

| Line/Section         | Meaning                                                                 |
|----------------------|-------------------------------------------------------------------------|
| `extern printf`      | Declare external C function `printf`                                    |
| `a`, `b`, `c`        | Define 64-bit integers                                                  |
| `fmt`                | Format string for `printf`                                              |
| `main:`              | Program entry point                                                     |
| `mov rax,[a]`        | Load value of `a` into `rax`                                            |
| `mov rbx,[b]`        | Load value of `b` into `rbx`                                            |
| `add rax,rbx`        | Add `a` and `b`                                                         |
| `mov [c],rax`        | Store result in `c`                                                     |
| `mov rdi,fmt`        | First argument: format string                                           |
| `mov rsi,[a]`        | Second argument: value of `a`                                           |
| `mov rdx,[b]`        | Third argument: value of `b`                                            |
| `mov rcx,[c]`        | Fourth argument: value of `c`                                           |
| `call printf`        | Call C library `printf`                                                 |
| `ret`                | Return from `main`                                                      |

---

## 2. Assembling the Code

We use `nasm` to assemble our code.

- **32-bit:**
    ```bash
    nasm -f elf32 hello.asm -o hello.o
    ```
- **64-bit:**
    ```bash
    nasm -f elf64 hello.asm -o hello.o
    ```

---

## 3. Linking the Object File

- **32-bit:**
    ```bash
    ld -m elf_i386 hello.o -o hello
    ```
- **64-bit:**
    ```bash
    ld hello.o -o hello
    ```

---

## 4. Running the Executable

```bash
./hello
```
### One-liner Command

We can assemble, link, and run our program in one line:

```bash
nasm -f elf64 hello.asm -o hello.o && ld hello.o -o hello && ./hello
```
---

## 5. Using C Library Functions (e.g., `printf`)

If our assembly code calls C library functions, we must link with GCC:

```bash
nasm -f elf64 hello.asm -o hello.o && gcc -no-pie -o hello hello.o && ./hello
```

### What does `-no-pie` do?

- By default, modern GCC links executables as PIE (Position Independent Executable) for security.
- `-no-pie` tells GCC to create a traditional, non-PIE executable, which is required for most hand-written assembly programs that expect a fixed entry point.

---

## 6. Quick Reference Table

| Step                | 32-bit Command                                      | 64-bit Command (syscalls)                        | 64-bit Command (C library)                       |
|---------------------|-----------------------------------------------------|--------------------------------------------------|--------------------------------------------------|
| Assemble            | `nasm -f elf32 hello.asm -o hello.o`                | `nasm -f elf64 hello.asm -o hello.o`             | `nasm -f elf64 hello.asm -o hello.o`             |
| Link                | `ld -m elf_i386 hello.o -o hello`                   | `ld hello.o -o hello`                            | `gcc -no-pie -o hello hello.o`                   |
| Run                 | `./hello`                                           | `./hello`                                        | `./hello`                                        |

---

**Tip:** Always use `-no-pie` with GCC when linking assembly that does not support PIE.

---

## 7. About the `.note.GNU-stack` Warning

When assembling with NASM and linking, we may see this warning:

```
/usr/bin/ld: warning: hello.o: missing .note.GNU-stack section implies executable stack
/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
```

**What does it mean?**

- NASM does not add a `.note.GNU-stack` section by default.
- Without it, the linker assumes your program's stack is executable, which is a security risk.
- Modern linkers want this section to explicitly mark the stack as non-executable.

**How to fix:**

Add the following line at the end of your `.asm` file:

```asm
section .note.GNU-stack noalloc noexec nowrite align=1
```

This tells the linker your stack should *not* be executable, removing the warning and improving security.

