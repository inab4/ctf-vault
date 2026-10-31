This level just requires me to write a simple program that can terminate itself.

```
.intel_syntax noprefix
.global _start

_start:
      mov rdi, 0
      mov rax, 0x3c
      syscall
```
