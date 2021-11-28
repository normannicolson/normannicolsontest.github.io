
GitHub SHH Key Setup 

Log into GitHub

From profile menu navigate to Settings - then SSH and GPG keys 
https://github.com/settings/keys

Scroll to SHH Key section - then click Create new SHH Key

Add New Key Page is displayed with Title and Key fields
https://github.com/settings/ssh/new

Give usefull name in Title field
And enter public key in Key field

You may have a key already in user root folder ~/.shh

Looking for two called 
id_dsa or id_rsa and a matching file with a .pub extension. 

The .pub file is your public key, and the other file is the corresponding private key. 

Copy values of id_rsa.pub into Key field

More into 
https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key

Enter password if prompted

Then enter 

Now can push files without needed to renter credititals =

## Add cert to Mac ced store
ssh-add ~/.ssh/id_rsa 

Enter passphase if prompted.

## Create Rsa key on Mac Linux
ssh-keygen -t rsa -b 4096 -C "<mailAddress>"

Enter file name when prompted 

Enter file in which to save the key (/Users/<username>/.ssh/id_rsa):

Saves file to teminal directory 


fatal: Authentication failed for 'https://github.com/normannicolsonnlist/normannicolsontest.github.io.git/'

git remote
git pull origin

git push origin main 

https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/




https://docs.github.com/en/authentication/connecting-to-github-with-ssh/checking-for-existing-ssh-keys

ls -al ~/.ssh
drwx------   5 normannicolson  staff   160 14 Dec  2020 .
drwxr-xr-x+ 44 normannicolson  staff  1408 20 Nov 11:07 ..
-rw-------@  1 normannicolson  staff  2675 14 Dec  2020 id_rsa
-rw-r--r--@  1 normannicolson  staff   580 14 Dec  2020 id_rsa.pub
-rw-r--r--@  1 normannicolson  staff  1631  9 Feb  2021 known_hosts

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

open ~/.ssh/config

touch ~/.ssh/config

open ~/.ssh/config

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa

ssh-add ~/.ssh/id_rsa 

https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account