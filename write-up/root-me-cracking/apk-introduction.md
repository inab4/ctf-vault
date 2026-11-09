Writeup for (APK - Introduction)[https://www.root-me.org/en/Challenges/Cracking/APK-Introduction?action_solution=voir#ancre_solution]
The challenge wants us to rev the apk file, so I put it inside jadx to analyze the apk's logic.
After wandering around, I bumped into the *MainActivity* folder, where the logic is stored.
I saw the makeFlag function:
```java
public String makeFlag(String s) {
        String a = "" + s.charAt(5);
        String b = s.charAt(2) + "";
        for (int i = 0; i < s.length(); i++) {
            String b2 = b.substring(b.length() - i) + b.substring(i);
            String b3 = i >= 3 ? b + s.charAt(i - 3) + "" : b + s.charAt(s.length() - (3 - i)) + "";
            if (i >= b3.length()) {
                b = b3 + s.charAt(i - b3.length()) + "";
            } else if (s.length() >= b3.length() - i) {
                b = b3 + s.charAt(s.length() - (b3.length() - i)) + "";
            } else {
                b = b3 + s.charAt(s.length() - ((b3.length() - i) - s.length())) + "";
            }
            a = a + b2.charAt((((s.length() + b.length()) * i) + b.length()) % b2.length());
        }
        return a.substring(0, 2) + s.charAt(3) + a.charAt(3) + '0' + a.substring(5, 7);
    }
```
and just below a few lines:
```java
 if (MainActivity.this.ed1.getText().toString().equals(MainActivity.this.makeFlag(seed))) {
                    Toast.makeText(MainActivity.this.getApplicationContext(), "Well played! You can validate now with this password :)", 0).show();
```
This is clear now, the program is a password checker with the encryption of the seed. So getting the seed was the only problem then.
So I used apktool to get the resources of this apk by:
```bash
apktool d basic_rev.apk
```
To get the seed string, I went to /res/values/strings.xml.
The seed is:
```xml
<string name="seed">1dndr@</string>
```
Finally, I ran the java program with this hardcoded seed and got the flag.
