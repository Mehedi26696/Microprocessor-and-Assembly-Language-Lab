; ========================================
; PROBLEM 1: Binary Search Tree Inorder Traversal
; ========================================
; DESCRIPTION:
;   Build a Binary Search Tree (BST) by inserting integers one by one
;   following standard BST insertion rules. After constructing the BST,
;   output the inorder traversal of the tree.
;
; BINARY SEARCH TREE PROPERTIES:
;   - For each node, all values in the left subtree are smaller
;   - For each node, all values in the right subtree are larger
;   - This property recursively applies to all subtrees
;   - Inorder traversal (Left -> Root -> Right) produces sorted output
;
; ALGORITHM:
;   1. Read N integers from input
;   2. For each integer, insert into BST:
;      - If tree is empty, create root node
;      - If value < current node, go left
;      - If value > current node, go right
;      - If value == current node, skip (duplicates not allowed)
;   3. Perform inorder traversal (recursive):
;      - Visit left subtree
;      - Visit current node (print value)
;      - Visit right subtree
;   4. Output produces sorted sequence of all inserted values
;
; INPUT FORMAT:
;   - First line: integer N (number of elements, 1 ≤ N ≤ 10^5)
;   - Second line: N space-separated integers (distinct values, -10^9 ≤ Ai ≤ 10^9)
;
; OUTPUT FORMAT:
;   - Single line with space-separated integers in ascending order
;   - Result of inorder traversal of the constructed BST
;
; EXAMPLE:
;   Input:  7 50 30 20 40 70 60 80
;   
;   BST Structure:
;           50
;          /  \
;        30    70
;       /  \   / \
;      20  40 60  80
;   
;   Output: 20 30 40 50 60 70 80
;
; COMPLEXITY:
;   - Time: O(N log N) average, O(N²) worst case (skewed tree)
;   - Space: O(N) for tree nodes + O(N) for input array
; ========================================

extern printf
extern scanf
extern malloc
extern free

; ========================================
; DATA SECTION: Read-only initialized data
; ========================================
section .data
    inFmt db "%ld", 0           ; scanf format for reading signed long (64-bit) integers
    outFmt db "%ld", 0          ; printf format for outputting signed long integers
    space db " ", 0             ; space character used as separator between output numbers
    newline db 0xA, 0           ; newline character (ASCII 10) for final line break
    first_num db 1              ; boolean flag: 1=first number (no leading space), 0=subsequent numbers

; ========================================
; BSS SECTION: Uninitialized data (zero-initialized at runtime)
; ========================================
section .bss
    n resq 1                    ; number of elements to insert (1 qword = 8 bytes)
    arr resq 1000               ; input array buffer (max 1000 elements × 8 bytes = 8000 bytes)
    root resq 1                 ; pointer to root node of BST (NULL initially, then points to allocated memory)
    output_count resq 1         ; counter for number of elements printed during traversal

; ========================================
; BST NODE STRUCTURE (48 bytes per node):
;   Offset 0-7:   value (qword)       - the integer value stored in this node
;   Offset 8-15:  left child (qword)  - pointer to left subtree node (or NULL)
;   Offset 16-23: right child (qword) - pointer to right subtree node (or NULL)
;   Offset 24-47: unused padding      - reserved for alignment/future use
; ========================================

; ========================================
; TEXT SECTION: Executable code
; ========================================
section .text
    global main

; ========================================
; MAIN FUNCTION
; Entry point of the program
; ========================================
main:
    ; === Function Prologue ===
    push rbp                    ; save caller's base pointer on stack
    mov rbp, rsp                ; set up new stack frame for main function
    
    ; === Initialize Variables ===
    mov qword [root], 0         ; root = NULL (empty tree initially)
    mov qword [output_count], 0 ; initialize output counter to 0
    mov byte [first_num], 1     ; set flag: next print will be first number
    
    ; === Read N (number of elements) ===
    ; System V AMD64 ABI calling convention:
    ;   1st arg (rdi): format string
    ;   2nd arg (rsi): address to store input
    ;   Return (rax): number of items successfully read
    mov rdi, inFmt              ; rdi = pointer to "%ld" format string
    mov rsi, n                  ; rsi = address of variable n (where to store input)
    xor eax, eax                ; rax = 0 (no floating point args for scanf)
    call scanf                  ; scanf("%ld", &n) - read number of elements
    
    ; === Read All Elements into Array ===
    ; We read all N integers first, then insert them into BST
    ; This approach allows us to validate input before tree construction
    mov rcx, [n]                ; rcx = n (loop counter for 'loop' instruction)
    mov rbx, arr                ; rbx = pointer to arr[0] (current array position)
    
.read_loop:                     ; Label: loop to read each element
    ; Save registers that will be modified by scanf
    push rcx                    ; preserve loop counter (scanf modifies rcx)
    push rbx                    ; preserve array pointer (scanf modifies rbx)
    
    ; Call scanf to read one integer
    mov rdi, inFmt              ; rdi = "%ld" format string
    mov rsi, rbx                ; rsi = address of current array element
    xor eax, eax                ; rax = 0 (no floating point args)
    call scanf                  ; scanf("%ld", &arr[i])
    
    ; Restore registers and prepare for next iteration
    pop rbx                     ; restore array pointer
    pop rcx                     ; restore loop counter
    add rbx, 8                  ; move pointer to next element (qword = 8 bytes)
    loop .read_loop             ; decrement rcx and jump to .read_loop if rcx != 0
    
    ; === Insert All Elements into BST ===
    ; Now that all elements are in the array, insert them one by one
    ; Each insertion follows BST rules: left for smaller, right for larger
    mov rcx, [n]                ; rcx = n (loop counter for n insertions)
    mov rbx, arr                ; rbx = pointer to arr[0] (traverse array)
    
.insert_loop:                   ; Label: loop to insert each element into BST
    ; Preserve registers before function call
    push rcx                    ; save loop counter
    push rbx                    ; save array pointer
    
    ; Prepare parameters for insert_bst function
    mov rdi, [rbx]              ; rdi = arr[i] (value to insert, 1st parameter)
    mov rsi, [root]             ; rsi = root pointer (2nd parameter - current tree root)
    call insert_bst             ; insert_bst(value, root) - returns new/updated root in rax
    
    mov [root], rax             ; update root pointer (may change if tree was empty)
    
    ; Restore registers and advance to next element
    pop rbx                     ; restore array pointer
    pop rcx                     ; restore loop counter
    add rbx, 8                  ; advance to next array element (8 bytes per qword)
    loop .insert_loop           ; decrement rcx, continue if more elements remain
    
    ; === Perform Inorder Traversal and Print Results ===
    ; Inorder traversal visits nodes in order: Left subtree -> Node -> Right subtree
    ; For a BST, this produces values in ascending (sorted) order
    mov rdi, [root]             ; rdi = root pointer (1st parameter to inorder_traverse)
    call inorder_traverse       ; recursively traverse and print: Left -> Root -> Right
    
    ; === Print Final Newline ===
    ; After all numbers are printed with spaces, end the line
    mov rdi, newline            ; rdi = pointer to newline character
    xor eax, eax                ; rax = 0 (no floating point args)
    call printf                 ; printf("\n") - print newline
    
    ; === Function Epilogue ===
    ; Clean up stack and return to operating system
    mov rsp, rbp                ; restore stack pointer to base pointer
    pop rbp                     ; restore caller's base pointer
    ret                         ; return from main (exit code 0 in rax)

; ========================================
; FUNCTION: insert_bst
; Insert a value into Binary Search Tree (recursive)
;
; PARAMETERS:
;   rdi = value to insert (64-bit signed integer)
;   rsi = current node pointer (NULL or pointer to node structure)
;
; RETURNS:
;   rax = pointer to node (either newly created or existing node)
;
; ALGORITHM:
;   1. Base case: If current node is NULL
;      - Allocate memory for new node
;      - Initialize: value, left=NULL, right=NULL
;      - Return pointer to new node
;   2. Recursive case: If current node exists
;      - If value < node.value: recursively insert into left subtree
;      - If value > node.value: recursively insert into right subtree
;      - If value == node.value: skip (no duplicates in BST)
;      - Return pointer to current node (unchanged)
;
; REGISTER USAGE:
;   r12 = value to insert (preserved across calls)
;   r13 = current node pointer (preserved across calls)
;   rbx = temporary for new node pointer
;   rax = return value (node pointer)
; ========================================
insert_bst:
    ; === Function Prologue ===
    push rbp                    ; save caller's base pointer
    mov rbp, rsp                ; set up stack frame
    push rbx                    ; save callee-saved register rbx
    push r12                    ; save r12 (will hold value)
    push r13                    ; save r13 (will hold current node pointer)
    
    ; === Save Parameters in Callee-Saved Registers ===
    ; rdi and rsi are caller-saved, so we move them to r12/r13
    ; This allows us to make recursive calls without losing our parameters
    mov r12, rdi                ; r12 = value to insert (safe across function calls)
    mov r13, rsi                ; r13 = current node pointer (safe across calls)
    
    ; === Base Case: Current Node is NULL ===
    ; If we've reached a NULL node, this is where we insert the new value
    cmp r13, 0                  ; compare current node with NULL (0)
    jne .insert_else            ; if node != NULL, go to recursive case
    
    ; === Allocate Memory for New Node ===
    ; malloc returns pointer to allocated memory in rax
    mov rdi, 48                 ; rdi = 48 bytes (size to allocate)
                                ; Node structure: 8 bytes value + 8 bytes left ptr + 8 bytes right ptr
                                ; Extra 24 bytes for alignment and future use
    call malloc                 ; malloc(48) - allocate memory on heap
    mov rbx, rax                ; rbx = pointer to newly allocated node
    
    ; === Initialize New Node ===
    ; Set up the node structure with value and NULL children
    mov [rbx], r12              ; *(node + 0) = value (store at offset 0)
    mov qword [rbx + 8], 0      ; *(node + 8) = NULL (left child pointer at offset 8)
    mov qword [rbx + 16], 0     ; *(node + 16) = NULL (right child pointer at offset 16)
    
    ; === Return New Node Pointer ===
    mov rax, rbx                ; rax = pointer to new node (return value)
    jmp .insert_end             ; jump to function epilogue
    
.insert_else:                   ; Label: Recursive case - node exists
    ; === Compare Value with Current Node ===
    ; BST property: left subtree < node < right subtree
    cmp r12, [r13]              ; compare value with current node's value
    je .insert_end              ; if equal: duplicate found, don't insert (BST has unique values)
    
    jl .insert_left             ; if value < node.value: jump to insert in left subtree
    
    ; === Insert to Right Subtree ===
    ; value > current node's value, so it belongs in right subtree
    mov rdi, r12                ; rdi = value to insert (1st parameter)
    mov rsi, [r13 + 16]         ; rsi = node.right (pointer at offset 16, 2nd parameter)
    call insert_bst             ; recursively insert_bst(value, node.right)
    mov [r13 + 16], rax         ; update node.right with returned pointer
                                ; (connects new node or returns existing subtree root)
    mov rax, r13                ; rax = current node pointer (return current node)
    jmp .insert_end             ; jump to function epilogue
    
.insert_left:                   ; Label: Insert into left subtree
    ; === Insert to Left Subtree ===
    ; value < current node's value, so it belongs in left subtree
    mov rdi, r12                ; rdi = value to insert (1st parameter)
    mov rsi, [r13 + 8]          ; rsi = node.left (pointer at offset 8, 2nd parameter)
    call insert_bst             ; recursively insert_bst(value, node.left)
    mov [r13 + 8], rax          ; update node.left with returned pointer
                                ; (connects new node or returns existing subtree root)
    mov rax, r13                ; rax = current node pointer (return current node)
    
.insert_end:                    ; Label: Function epilogue
    ; === Restore Callee-Saved Registers ===
    ; Must pop in reverse order of push (LIFO - Last In First Out)
    pop r13                     ; restore r13 (current node pointer)
    pop r12                     ; restore r12 (value to insert)
    pop rbx                     ; restore rbx (temporary node pointer)
    pop rbp                     ; restore caller's base pointer
    ret                         ; return to caller with rax = node pointer

; ========================================
; FUNCTION: inorder_traverse
; Perform inorder traversal of BST and print values
;
; PARAMETERS:
;   rdi = node pointer (NULL or pointer to current node)
;
; RETURNS:
;   void (no return value, side effect is printing)
;
; ALGORITHM (Recursive):
;   1. Base case: If node is NULL, return immediately
;   2. Recursive case:
;      a) Recursively traverse LEFT subtree (smaller values)
;      b) VISIT current node (print its value)
;      c) Recursively traverse RIGHT subtree (larger values)
;   
;   This Left-Root-Right order produces sorted output for BST!
;
; EXAMPLE:
;       50
;      /  \
;    30    70
;   /  \   /  \
;  20  40 60  80
;   
;   Traversal order: 20, 30, 40, 50, 60, 70, 80 (sorted)
;
; REGISTER USAGE:
;   r12 = current node pointer (preserved across recursive calls)
; ========================================
inorder_traverse:
    ; === Function Prologue ===
    push rbp                    ; save caller's base pointer
    mov rbp, rsp                ; set up stack frame
    push rbx                    ; save callee-saved register rbx
    push r12                    ; save r12 (will hold current node)
    
    ; === Save Parameter in Callee-Saved Register ===
    mov r12, rdi                ; r12 = current node pointer (safe across calls)
    
    ; === Base Case: Node is NULL ===
    ; If we've reached a NULL node, there's nothing to traverse
    cmp r12, 0                  ; compare node pointer with NULL (0)
    je .traverse_end            ; if node == NULL, return immediately
    
    ; === Step 1: Traverse LEFT Subtree ===
    ; Visit all nodes with values smaller than current node
    mov rdi, [r12 + 8]          ; rdi = node.left (pointer at offset 8)
    call inorder_traverse       ; recursively traverse left subtree
                                ; This processes all smaller values first
    
    ; === Step 2: Visit CURRENT Node (Print Value) ===
    ; After left subtree is complete, print this node's value
    mov rdi, [r12]              ; rdi = node.value (value at offset 0)
    call print_number           ; print_number(node.value) - prints with proper spacing
    
    ; === Step 3: Traverse RIGHT Subtree ===
    ; Visit all nodes with values larger than current node
    mov rdi, [r12 + 16]         ; rdi = node.right (pointer at offset 16)
    call inorder_traverse       ; recursively traverse right subtree
                                ; This processes all larger values last
    
.traverse_end:                  ; Label: Function epilogue
    ; === Restore Callee-Saved Registers ===
    ; Pop in reverse order of push (LIFO)
    pop r12                     ; restore r12 (current node pointer)
    pop rbx                     ; restore rbx
    pop rbp                     ; restore caller's base pointer
    ret                         ; return to caller

; ========================================
; FUNCTION: print_number
; Print a number with proper space separator formatting
;
; PARAMETERS:
;   rdi = number to print (64-bit signed integer)
;
; RETURNS:
;   void (no return value, side effect is printing)
;
; BEHAVIOR:
;   - First number: print without leading space
;   - Subsequent numbers: print space then number
;   This produces output like: "20 30 40 50 60 70 80"
;   Instead of: " 20 30 40 50 60 70 80" (unwanted leading space)
;   Or: "20 30 40 50 60 70 80 " (unwanted trailing space)
;
; IMPLEMENTATION:
;   Uses global flag 'first_num' to track if this is first print
;   Flag is 1 initially, set to 0 after first number is printed
; ========================================
print_number:
    ; === Function Prologue ===
    push rbp                    ; save caller's base pointer
    mov rbp, rsp                ; set up stack frame
    push rbx                    ; save callee-saved register rbx
    
    ; === Save Parameter ===
    mov rbx, rdi                ; rbx = number to print (safe across printf calls)
    
    ; === Check if This is First Number ===
    ; first_num flag: 1 = first number (no space before), 0 = not first (space before)
    cmp byte [first_num], 0     ; compare first_num with 0
    je .print_with_space        ; if first_num == 0, jump to print with space
    
    ; === Path 1: Print First Number (No Leading Space) ===
    mov byte [first_num], 0     ; set first_num = 0 (subsequent numbers will have space)
    mov rdi, outFmt             ; rdi = "%ld" format string
    mov rsi, rbx                ; rsi = number to print
    xor eax, eax                ; rax = 0 (no floating point args)
    call printf                 ; printf("%ld", number) - print without leading space
    jmp .print_end              ; skip the space-printing code
    
.print_with_space:              ; Label: Print subsequent numbers with space
    ; === Path 2: Print Space Then Number ===
    ; For all numbers after the first, print space separator first
    mov rdi, space              ; rdi = pointer to " " (space character)
    xor eax, eax                ; rax = 0
    call printf                 ; printf(" ") - print space separator
    
    ; Now print the number itself
    mov rdi, outFmt             ; rdi = "%ld" format string
    mov rsi, rbx                ; rsi = number to print
    xor eax, eax                ; rax = 0
    call printf                 ; printf("%ld", number) - print the number
    
.print_end:                     ; Label: Function epilogue
    ; === Restore Callee-Saved Registers ===
    pop rbx                     ; restore rbx (number we printed)
    pop rbp                     ; restore caller's base pointer
    ret                         ; return to caller
