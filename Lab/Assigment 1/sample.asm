
; Import C standard library functions for input/output
extern    printf        ; Print formatted output
extern    scanf         ; Scan formatted input

SECTION .data        ; Initialized data section

cnt:    dq    0        ; Counter for number of inputs/array index
c:      dq    0        ; Temporary variable to store input value
sum:    dq    0        ; Variable to store sum of all inputs
out_fmt: db "%ld", 10, 0    ; Output format string for printf (prints integer with newline)
in_fmt:  db "%ld",0         ; Input format string for scanf (reads integer)

SECTION .bss         ; Uninitialized data section
arr: resq 21         ; Reserve space for 21 64-bit integers (array)

SECTION .text        ; Code section

global main          ; Entry point for C programs
main:
    push    rbp                ; Save base pointer (function prologue)

; === Input Loop: Read 20 integers from user ===
Loop:                           ; while(counter < 20)
    mov rdi, in_fmt             ; Format string for scanf
    mov rsi, c                  ; Address to store input value
    call scanf                  ; Read integer from user
    mov rax, [c]                ; Load input value

    add [sum], rax              ; Add input value to sum

    mov rcx, [cnt]              ; Get current counter value
    mov [arr+8*rcx], rax        ; Store input value in array at index counter

    add rcx, 1                  ; Increment counter
    mov [cnt], rcx

    cmp rcx, 20                 ; Check if 20 numbers have been read
    jnz Loop                    ; If not, repeat loop

    mov rax, 0
    mov [cnt], rax              ; Reset counter for printing

; === Output the sum ===
    mov rdi, out_fmt            ; Format string for printf
    mov rsi, [sum]              ; Value to print (sum)
    mov rax, 0                  ; Clear rax for variadic function call
    call printf                 ; Print sum

; === Print all array elements ===
print:
    mov rcx, [cnt]              ; Get current index
    mov rdx, [arr+8*rcx]        ; Load value at arr[index]

    mov rdi, out_fmt            ; Format string for printf
    mov rsi, rdx                ; Value to print (array element)
    mov rax, 0                  ; Clear rax for variadic function call
    call printf                 ; Print array element

    mov rcx, [cnt]
    add rcx, 1                  ; Increment index
    mov [cnt], rcx

    cmp rcx, 20                 ; Check if all 20 elements printed
    jnz print                   ; If not, repeat print loop

    pop    rbp                  ; Restore base pointer (function epilogue)
    mov    rax, 0               ; Return 0 from main
    ret