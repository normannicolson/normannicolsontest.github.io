# Create SSH key for GitHub BitBucket etc

Jun 2024

> Create SSH key and Upload to Git 

Echo open ssl version 

```
ssh -V
```

Navigate to home directory 

```
cd ~
```

Create elliptic curve key

```
ssh-keygen -t ed25519 -b 4096 -C "{email address}" -f {ssh-key-name}
```

{ssh-key-name} is the output filename for the keys. 

ssh-keygen will output two files:

{ssh-key-name} — the private key.
{ssh-key-name}.pub — the public key.

Store files in .ssh folder

```
mv ~/{ssh-key-name} ~/.ssh/{ssh-key-name}
mv ~/{ssh-key-name}.pub ~/.ssh/{ssh-key-name}.pub
```

```
ssh-add ~/.ssh/{ssh-key-name}
```

Create SSH Config file 

```
touch config
```

Config file content 

```
Host bitbucket.org
  AddKeysToAgent yes
  IdentityFile ~/.ssh/{ssh-key-name}
```

Optional open config file in VS Code

```
code config 
```

Copy file contents to upload

```
cat ~/.ssh/nlist.pub | pbcopy .
```

Add Identity

```
ssh-add ~/.ssh/nlist
```

Key can be entered into GitHub or Bitbucket SSH keys 

- https://github.com/settings/keys
- https://bitbucket.org/account/settings/ssh-keys/