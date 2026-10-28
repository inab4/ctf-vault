        .intel_syntax noprefix
        .global _start
_start:
        mov rdi, 0
        mov r8, 0x0
        mov r9, 0x0
        mov rax, 0x0
        mov rdx, [rsp]
        sub rdx, 0x1
        cmp rdx, 0x0
        je special_case
        lea rsi, [rip+buf]
loop_start_positive:
        mov rcx, [rsp+16+8*r9]
        cmp BYTE PTR [rcx], 0x2d
        je loop_start_negative
        xor r8, r8
inner_loop_positive:
        movsx r11, BYTE PTR [rcx+r8]
        sub r11, 0x30
        imul rax, 0xa
        add rax, r11
        inc r8
        cmp BYTE PTR [rcx+r8], 0x0
        jne inner_loop_positive
        add rdi, rax
        xor rax, rax
        inc r9
        cmp r9, rdx
        jne loop_start_positive
        jmp itoa
loop_start_negative:
        mov rcx, [rsp+16+8*r9]
        cmp BYTE PTR [rcx], 0x2d
        jne loop_start_positive
        mov r8, 1
inner_loop_negative:
        movsx r11, BYTE PTR [rcx+r8]
        sub r11, 0x30
        imul rax, 0xa
        add rax, r11
        inc r8
        cmp BYTE PTR [rcx+r8], 0x0
        jne inner_loop_negative
        sub rdi, rax
        xor rax, rax
        inc r9
        cmp r9, rdx
        jne loop_start_negative
        jmp itoa
itoa:
        mov rcx, 0xa
        mov rax, rdi
        mov r8, 0x0
        mov r9, 0x0
        xor rdx, rdx
        cmp rdi, 0x0
        je special_case
        cmp rdi, 0x0
        jl negative
loop:
        div rcx
        add rdx, 0x30
        push rdx
        cmp rax, 0x0
        je loop2
        xor rdx, rdx
        inc r9
        jmp loop

loop2:
        pop r10
        mov [rsi+r8], r10b
        cmp r8, r9
        je no_quo
        inc r8
        jmp loop2
no_quo:
        mov rax, r8
        inc rax
        jmp exit
        
special_case:
        push 0x30
        mov rdi, 1
        mov rsi, rsp
        mov rdx, 1
        mov rax, 1
        syscall
        mov rdi, 0x0
        mov rax, 0x3c
        syscall
negative:
        mov BYTE PTR [rsi], 0x2d
        inc r8
        inc r9
        imul rax, -1
        jmp loop

exit:
        mov rdi, 1
        mov rsi, rsi
        mov rdx, rax
        mov rax, 1
        syscall
        mov rdi, 0
        mov rax, 0x3c
        syscall

.section .bss
buf:
        .skip 32
