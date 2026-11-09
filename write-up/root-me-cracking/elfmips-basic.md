Write up for [ELF MIPS - Basic Crackme](https://www.root-me.org/en/Challenges/Cracking/ELF-MIPS-Basic-Crackme?action_solution=voir&debut_affiche_solutions=0#pagination_affiche_solutions)

]In this challenge, we are given a bin file.
First, I ran 
```bash
file *
```
to check the file type, and it is ELF32 with MIPS32 and stripped.
So I decided to put it in IDA, then I ran the pseudo code by pressing F5:
```c
  int i; // [sp+18h] [+18h] BYREF
  char s[4]; // [sp+1Ch] [+1Ch] BYREF cc ad ne tf
  char v6; // [sp+20h] [+20h]
  char v7; // [sp+21h] [+21h]
  char v8; // [sp+22h] [+22h]
  char v9; // [sp+23h] [+23h]
  char v10; // [sp+2Dh] [+2Dh]
  char v11; // [sp+2Eh] [+2Eh]
  int v12; // [sp+60h] [+60h]
  int v13; // [sp+64h] [+64h]

  puts("crack-me for Root-me by s4r");
  puts("Enter password please");
  fgets(s, 64, stdin);
  s[strlen(s) - 1] = 0;
  if ( strlen(s) != 19 )
    goto exit;
  for ( i = 8; i < 17; ++i )
  {
    if ( s[i] != 'i' )
      goto exit;
  }
  if ( v11 == 's'
    && v10 == 'p'
    && v9 == 'm'
    && s[2] == 'n'
    && v8 == 'n'
    && s[0] == 'c'
    && s[1] == 'a'
    && s[3] == 't'
    && v6 == 'r'
    && v7 == v6 + 3 )                           // v7 = u
  {
    sub_4007C0();
  }
  else
  {
exit:
    sub_400814();
    v12 = 0;
    return 0;
  }
  return v13;
}
```
So this program will take our input and compare it with 19-char key.
Noticing that the code declared the s array with 4 chars, so I took a look at the condition inside the loop
```c
 if ( v11 == 's'
    && v10 == 'p'
    && v9 == 'm'
    && s[2] == 'n'
    && v8 == 'n'
    && s[0] == 'c'
    && s[1] == 'a'
    && s[3] == 't'
    && v6 == 'r'
    && v7 == v6 + 3 )                           // v7 = u
  {
```
and got the first 4 characters: *cant*
After that, I looked at the addresses of those initialized var and map it into the 19-char key and I got:
????????*********??
And the loop offered:
```c
 for ( i = 8; i < 17; ++i )
  {
    if ( s[i] != 'i' )
      goto exit;
  }
```
s[8] to s[16] is 'i'. Replace * with it.

Perfect, we got the key.
