# Using Sed to Token Replace on Mac

Jul 2018

> Sed command to string replace useful for transforming files like b2c policies on mac.

Following Octopus Deploy we use {#name} variable replacement notation.

input.txt

```
The {#foxSpeed} brown fox jumps over the lazy dog
```

For example, to replace all occurrences of '{#foxSpeed}' to 'quick' from input.txt file and output to output.txt.

```
sed 's/{#foxSpeed}/quick/g' input.txt > output.txt
```

Output.txt

```
The quick brown fox jumps over the lazy dog
```

Replace to console.

```
sed 's/{#foxSpeed}/quick/g' input.txt
```

Replace in file and backup original input.
txt file to input.txt.bck.

```
sed -i .bck 's/{#foxSpeed}/quick/' input.txt
```

input.txt

```
The quick brown fox jumps over the lazy dog
```

input.txt.bck

```
The {#foxSpeed} brown fox jumps over the lazy dog
```