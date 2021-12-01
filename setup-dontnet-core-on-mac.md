# Setup .Net Core on Mac

Nov 2017

> Guide to getting started building .net core on mac.

To get up and running with .Net core on a Mac we first need to install some dependencies.
Install NodeJs download from https://nodejs.org.

NodeJs will also install Node Package Manager Npm https://www.npmjs.com.

Once installed open terminal and navigate to directory or repository where site will be created.

```
npm -version
```

Update Npm globally, terminal and run the following command.

Run the following terminal command to conform 

```
npm update -g
```

Download core from https://www.microsoft.com/net/learn/get-started/macos and install.

Run the dotnet cli to determine what version dotnet core cli was installed.  

```
dotnet --version
```

## Now we can Create

Now we have Node, Npm and Core installed we have the foundations for building .net core applications.

To make it easer download and install Visual Studio Code https://code.visualstudio.com. 

## Optionally

Optionally we can use additional Cli like Yeoman to scaffold our various projects. 

Install Yeoman from Npm, to install globally we need to run as Admin so we use sudo prefix in our commands.

```
sudo npm install yeoman -g
```

Install Yeoman .Net generators.

```
sudo npm install -g generator-aspnet
```

Install angular cli

```
sudo npm install angular/cli -g
```

It failed for me so needed to instal from repository.

```
sudo npm install https://github.com/angular/angular-cli.git -g
```