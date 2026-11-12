Write-up for [ELF x86 - No breakpoints]().

WIP

key ^ edx = checksum -> key = checksum ^ edx


```python
#!/usr/bin/python3

from pwn import *

checksum = [
  184,   4,   0,   0,   0, 187,   1,   0,   0,   0,
  185, 161, 145,   4,   8, 186,  38,   0,   0,   0,
  205, 128, 184,   3,   0,   0,   0,  49, 219, 185,
  136, 145,   4,   8, 186,  51,   0,   0,   0, 205,
  128,  49, 201, 184, 128, 128,   4,   8, 187,  35,
  129,   4,   8, 232,  91,   0,   0,   0, 137, 202,
  185,  25,   0,   0,   0, 184,  85, 145,   4,   8,
  187, 136, 145,   4,   8, 209, 202, 138,  68,   8,
  255, 138,  92,  11, 255,  48, 216,  48, 208, 117,
   27,  73, 117, 227, 184,   4,   0,   0,   0, 187,
    1,   0,   0,   0, 185,  36, 145,   4,   8, 186,
   38,   0,   0,   0, 205, 128, 235,  22, 184,   4,
    0,   0,   0, 187,   1,   0,   0,   0, 185,  74,
  145,   4,   8, 186,  11,   0,   0,   0, 205, 128,
  184,   1,   0,   0,   0,  49, 219, 205, 128,  41,
  195,  49, 201,   2,   8, 193, 193,   3,  64,  75,
  117, 247, 195
]
print(len(xor_key))
checksum = 0

for i in range(len(xor_key)):
    checksum = (checksum & 0xFFFFFF00) | ((checksum + xor_key[i]) & 0xFF)
    checksum = fiddling.rol(checksum, 3, word_size = 32)

print(ecx)
al = [
    '\x1e', '\xcd', '\x2a', '\xd5', '\x34',
    '\x87', '\xfc', '\x78', '\x64', '\x35',
    '\x9d', 236   , 222   , 21    , 172   ,
    151   , 153   , 175   , 150   , 218   ,
    121   , 38    ,  79   , 50    , 224
]

edx = checksum
key = ''
for i in range (24, -1, -1):
    edx = fiddling.ror(edx, 1, word_size = 32)
    print(i)
    key += (chr(int.from_bytes(xor(edx & 0xFF, al[i]))))
print(key[::-1])
```
