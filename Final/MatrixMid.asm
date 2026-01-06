; ========================================
; PROBLEM 3: Matrix Multiplication (A × B - D)
; ========================================
; Perform standard matrix multiplication C = A × B - D.
;
; Input: 
;   - First line: r1 c1 c2
;   - Next r1×c1 integers for A
;   - Next c1×c2 integers for B
;   - Next r1×c2 integers for D
;
; Output: 
;   - Matrix C in row-major order
;
; Example:
;   Input: r1=2, c1=3, c2=2
;          A = [[1,2,3], [4,5,6]]
;          B = [[7,8], [9,10], [11,12]]
;          D = [[1,0], [0,1]]
;   Output: 57 64
;           139 153
;   Explanation: A×B = [[58,64], [139,154]]
;                A×B-D = [[57,64], [139,153]]
; ========================================

extern printf               ; external C function for printing
extern scanf                ; external C function for reading input

section .data
    inFmt db "%ld", 0       ; input format for long integer
    outFmt db "%ld ", 0     ; output format: number with space
    newline db 0xA, 0       ; newline character

section .bss
    r1 resq 1               ; rows of matrix A
    c1 resq 1               ; columns of A / rows of B
    c2 resq 1               ; columns of matrix B
    A resq 10000            ; matrix A (max 100×100)
    B resq 10000            ; matrix B (max 100×100)
    D resq 10000            ; matrix D (max 100×100)
    C resq 10000            ; result matrix C (max 100×100)

section .text
    global main             ; program entry point

main:
    push rbp                ; save base pointer
    mov rbp, rsp            ; set up stack frame
    
    ; read matrix dimensions
    mov rdi, inFmt          ; format
    mov rsi, r1             ; address of r1
    xor eax, eax
    call scanf
    
    mov rdi, inFmt
    mov rsi, c1             ; address of c1
    xor eax, eax
    call scanf
    
    mov rdi, inFmt
    mov rsi, c2             ; address of c2
    xor eax, eax
    call scanf
    
    ; read matrix A (r1 × c1)
    mov rax, [r1]           ; rax = r1
    imul rax, [c1]          ; rax = r1 × c1 (total elements)
    mov rcx, rax            ; loop counter
    mov rbx, A              ; rbx = address of A[0]

.read_A:
    push rcx
    push rbx
    mov rdi, inFmt
    mov rsi, rbx
    xor eax, eax
    call scanf
    pop rbx
    pop rcx
    add rbx, 8
    loop .read_A
    
    ; read matrix B (c1 × c2)
    mov rax, [c1]           ; rax = c1
    imul rax, [c2]          ; rax = c1 × c2
    mov rcx, rax
    mov rbx, B

.read_B:
    push rcx
    push rbx
    mov rdi, inFmt
    mov rsi, rbx
    xor eax, eax
    call scanf
    pop rbx
    pop rcx
    add rbx, 8
    loop .read_B
    
    ; read matrix D (r1 × c2)
    mov rax, [r1]           ; rax = r1
    imul rax, [c2]          ; rax = r1 × c2
    mov rcx, rax
    mov rbx, D

.read_D:
    push rcx
    push rbx
    mov rdi, inFmt
    mov rsi, rbx
    xor eax, eax
    call scanf
    pop rbx
    pop rcx
    add rbx, 8
    loop .read_D
    
    ; call matrix_multiply function
    call matrix_multiply    ; C = A × B - D
    
    ; print result matrix C
    call print_matrix       ; display results

    mov rsp, rbp            ; restore stack pointer
    pop rbp                 ; restore base pointer
    xor eax, eax
    ret                     ; exit program


; ========================================
; Function: matrix_multiply
; ========================================
; Purpose: Compute C = A × B - D
; Parameters: Uses global arrays A, B, D, C and dimensions r1, c1, c2
; Returns: Result stored in array C
; Algorithm:
;   1. For each element C[i][j]:
;   2.   Sum = 0
;   3.   For k from 0 to c1-1:
;   4.     Sum += A[i][k] × B[k][j]
;   5.   C[i][j] = Sum - D[i][j]
; ========================================
matrix_multiply:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    
    xor r12, r12            ; r12 = i (row index of A/C)
    
.row_loop:
    mov rax, [r1]
    cmp r12, rax            ; check if i >= r1
    jge .done
    
    xor r13, r13            ; r13 = j (column index of B/C)
    
.col_loop:
    mov rax, [c2]
    cmp r13, rax            ; check if j >= c2
    jge .next_row
    
    xor r14, r14            ; r14 = sum
    xor r15, r15            ; r15 = k (index for multiplication)
    
.mul_loop:
    mov rax, [c1]
    cmp r15, rax            ; check if k >= c1
    jge .store_result
    
    ; compute A[i][k] × B[k][j]
    ; A[i][k] is at A + (i×c1 + k)×8
    mov rax, r12            ; rax = i
    imul rax, [c1]          ; rax = i×c1
    add rax, r15            ; rax = i×c1 + k
    mov rbx, [A + rax*8]    ; rbx = A[i][k]
    
    ; B[k][j] is at B + (k×c2 + j)×8
    mov rax, r15            ; rax = k
    imul rax, [c2]          ; rax = k×c2
    add rax, r13            ; rax = k×c2 + j
    mov rcx, [B + rax*8]    ; rcx = B[k][j]
    
    imul rbx, rcx           ; rbx = A[i][k] × B[k][j]
    add r14, rbx            ; sum += A[i][k] × B[k][j]
    
    inc r15                 ; k++
    jmp .mul_loop
    
.store_result:
    ; compute C[i][j] = sum - D[i][j]
    ; D[i][j] is at D + (i×c2 + j)×8
    mov rax, r12            ; rax = i
    imul rax, [c2]          ; rax = i×c2
    add rax, r13            ; rax = i×c2 + j
    mov rbx, [D + rax*8]    ; rbx = D[i][j]
    
    sub r14, rbx            ; result = sum - D[i][j]
    mov [C + rax*8], r14    ; store in C[i][j]
    
    inc r13                 ; j++
    jmp .col_loop
    
.next_row:
    inc r12                 ; i++
    jmp .row_loop
    
.done:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


; ========================================
; Function: print_matrix
; ========================================
; Purpose: Print matrix C in row-major order
; ========================================
print_matrix:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    
    xor r12, r12            ; r12 = i (row index)
    
.print_row_loop:
    mov rax, [r1]
    cmp r12, rax
    jge .print_done
    
    xor r13, r13            ; r13 = j (column index)
    
.print_col_loop:
    mov rax, [c2]
    cmp r13, rax
    jge .print_newline
    
    ; print C[i][j]
    mov rax, r12
    imul rax, [c2]
    add rax, r13
    
    push r12
    push r13
    mov rdi, outFmt
    mov rsi, [C + rax*8]
    xor eax, eax
    call printf
    pop r13
    pop r12
    
    inc r13
    jmp .print_col_loop
    
.print_newline:
    push r12
    mov rdi, newline
    xor eax, eax
    call printf
    pop r12
    
    inc r12
    jmp .print_row_loop
    
.print_done:
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret