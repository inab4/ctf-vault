Write up for [ELF x86 - CrackPass](https://www.root-me.org/fr/Challenges/Cracking/ELF-x86-CrackPass)

The program is just simply a password checker in ELF32. So I decide to pass it to IDA.
IDA analyzes that the program will take our argv[1] and compare it with, not plain string, the runtime generated password.
So I can retrieve the password easily by dynamic analysis. However, the program prevent this by stripping and ptrace, per se.
Ptrace:
```c
if ( ptrace(PTRACE_TRACEME, 0, 1, 0) < 0 )
  {
    puts("Don't use a debuguer !");
    abort();
  }
```
Stripped:
```x86asm
0x080483ac  abort@plt
0x080483bc  sprintf@plt
0x080483cc  __gmon_start__@plt
0x080483dc  ptrace@plt
0x080483ec  __libc_start_main@plt
0x080483fc  __ctype_b_loc@plt
0x0804840c  printf@plt
0x0804841c  puts@plt
0x0804842c  strcmp@plt ; no main at all!!
```
The only solution I thought of was only patching. Breakpoint on ptrace must be set in order to bypass the debugger detector:
```bash
break ptrace
Breakpoint 1 at 0x80483dc
```
Finish it and set $eax = 0 to trick the conditional jump.
Without main, the program is kinda ambiguous (ig?), which I cannot disas. So I print instructions from my current instruction pointer instead:
```bash
x/128i 0x8048534
=> 0x8048534:   test   al,al
   0x8048536:   je     0x8048572
   0x8048538:   mov    ebx,0x1
   0x804853d:   mov    edx,0x1
   0x8048542:   sub    al,bl
   0x8048544:   mov    BYTE PTR [ecx],al
   0x8048546:   lea    edx,[esi+edx*1-0x1]
   0x804854a:   xor    al,BYTE PTR [edx]
   0x804854c:   mov    BYTE PTR [ecx],al
   0x804854e:   add    al,BYTE PTR [edx]
   0x8048550:   mov    BYTE PTR [ecx],al
   0x8048552:   xor    al,BYTE PTR [edx]
   0x8048554:   mov    BYTE PTR [ecx],al
   0x8048556:   xor    al,BYTE PTR [esi+0x8]
   0x8048559:   mov    BYTE PTR [ecx],al
   0x804855b:   test   al,al
   0x804855d:   jne    0x8048562
   0x804855f:   mov    BYTE PTR [ecx],0x1
   0x8048562:   add    ebx,0x1
   0x8048565:   mov    edx,ebx
   0x8048567:   lea    ecx,[esi+ebx*1]
   0x804856a:   movzx  eax,BYTE PTR [esi+ebx*1]
   0x804856e:   test   al,al
   0x8048570:   jne    0x8048542
   0x8048572:   movzx  eax,BYTE PTR [esi]
   0x8048575:   test   al,al
   0x8048577:   je     0x804859d
   0x8048579:   movzx  eax,al
   0x804857c:   mov    DWORD PTR [esp+0x8],eax
   0x8048580:   mov    DWORD PTR [esp+0x4],0x80487a0
   0x8048588:   mov    DWORD PTR [esp],edi
   0x804858b:   call   0x80483bc <sprintf@plt>
   0x8048590:   add    edi,0x2
   0x8048593:   add    esi,0x1
   0x8048596:   movzx  eax,BYTE PTR [esi]
   0x8048599:   test   al,al
   0x804859b:   jne    0x8048579
   0x804859d:   add    esp,0xc
   0x80485a0:   pop    ebx
   0x80485a1:   pop    esi
   0x80485a2:   pop    edi
   0x80485a3:   pop    ebp
   0x80485a4:   ret
   0x80485a5:   push   ebp
   0x80485a6:   mov    ebp,esp
   0x80485a8:   push   esi
   0x80485a9:   push   ebx
   0x80485aa:   sub    esp,0x1090
   0x80485b0:   mov    esi,DWORD PTR [ebp+0x8]
   0x80485b3:   movzx  ebx,BYTE PTR [esi]
   0x80485b6:   test   bl,bl
   0x80485b8:   je     0x80485e8
   0x80485ba:   call   0x80483fc <__ctype_b_loc@plt>
   0x80485bf:   mov    ecx,DWORD PTR [eax]
   0x80485c1:   mov    edx,esi
   0x80485c3:   movsx  eax,bl
   0x80485c6:   test   BYTE PTR [ecx+eax*2],0x8
   0x80485ca:   jne    0x80485dd
   0x80485cc:   mov    DWORD PTR [esp],0x80487a5
   0x80485d3:   call   0x804841c <puts@plt>
   0x80485d8:   call   0x80483ac <abort@plt>
   0x80485dd:   movzx  ebx,BYTE PTR [edx+0x1]
   0x80485e1:   add    edx,0x1
   0x80485e4:   test   bl,bl
   0x80485e6:   jne    0x80485c3
   0x80485e8:   mov    DWORD PTR [esp+0x4],esi
   0x80485ec:   lea    esi,[ebp-0x1008]
   0x80485f2:   mov    DWORD PTR [esp],esi
   0x80485f5:   call   0x80484f4
   0x80485fa:   lea    ebx,[ebp-0x1088]
   0x8048600:   mov    DWORD PTR [esp+0x4],ebx
   0x8048604:   mov    DWORD PTR [esp],0x8049960
   0x804860b:   call   0x804851c
   0x8048610:   mov    DWORD PTR [esp+0x4],esi
   0x8048614:   mov    DWORD PTR [esp],ebx
   0x8048617:   call   0x804842c <strcmp@plt>
   0x804861c:   test   eax,eax
   0x804861e:   jne    0x8048632
   0x8048620:   mov    DWORD PTR [esp+0x4],ebx
   0x8048624:   mov    DWORD PTR [esp],0x80487e8
   0x804862b:   call   0x804840c <printf@plt>
   0x8048630:   jmp    0x804863e
   0x8048632:   mov    DWORD PTR [esp],0x80487b4
   0x8048639:   call   0x804841c <puts@plt>
   0x804863e:   add    esp,0x1090
   0x8048644:   pop    ebx
   0x8048645:   pop    esi
   0x8048646:   pop    ebp
   0x8048647:   ret
   0x8048648:   lea    ecx,[esp+0x4]
   0x804864c:   and    esp,0xfffffff0
   0x804864f:   push   DWORD PTR [ecx-0x4]
   0x8048652:   push   ebp
   0x8048653:   mov    ebp,esp
   0x8048655:   sub    esp,0x28
   0x8048658:   mov    DWORD PTR [ebp-0xc],ecx
   0x804865b:   mov    DWORD PTR [ebp-0x8],ebx
   0x804865e:   mov    DWORD PTR [ebp-0x4],esi
   0x8048661:   mov    ebx,DWORD PTR [ecx]
   0x8048663:   mov    esi,DWORD PTR [ecx+0x4]
   0x8048666:   mov    DWORD PTR [esp+0xc],0x0
   0x804866e:   mov    DWORD PTR [esp+0x8],0x1
   0x8048676:   mov    DWORD PTR [esp+0x4],0x0
```
Finally, we got our precious strcmp address, break it and retrieve the password!
