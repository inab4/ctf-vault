First, I decompile the executable file by using gdsdecomp. It gives me stuff like src, dst (iirc) and many other resources inside the exe file.
According to the description, there is a flag on the island (which players cannot hypothetically reach) so I open Godot engine and run the island.tscn scene.

Inside the scene, there is a script:
```
func _ready():
        var key = [119, 104, 52, 116, 52, 114, 51, 121, 48, 117, 100, 48, 49, 110, 103, 63]
        var enc = [32, 13, 88, 24, 20, 22, 92, 23, 85, 89, 68, 68, 89, 11, 71, 89, 27, 9, 83, 84, 93, 1, 57, 42, 83, 7, 13, 96, 69, 29, 86, 81, 52, 4, 7, 64, 70]
        text = ""
        for i in range(len(enc)):
                text += char(enc[i] ^ key[i % len(key)])
extends Node2D
func _ready():
        OS.set_window_maximized(true)
```
This is undoubtedly the encryption of the key. So I convert it to Python then I can run the code on my computer:
```
from pwn import *
def _ready():
        var key = [119, 104, 52, 116, 52, 114, 51, 121, 48, 117, 100, 48, 49, 110, 103, 63]
        var enc = [32, 13, 88, 24, 20, 22, 92, 23, 85, 89, 68, 68, 89, 11, 71, 89, 27, 9, 83, 84, 93, 1, 57, 42, 83, 7, 13, 96, 69, 29, 86, 81, 52, 4, 7, 64, 70]
        text = ''
        for i in range(len(enc)):
                text += chr(int.from_bytes(xor(enc[i] ^ key[i % len(key)])))
        print(text)
ready()

```
Then we got the key!
