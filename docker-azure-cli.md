# Azure Cli via Docker

Sep 2022

> Create docker container with Azure cli pre-installed  

Create container with interactive terminal with mapped volume.

Enter following command into terminal to download and run image:
```
docker run -it -v azure-cli:/export --name cli mcr.microsoft.com/azure-cli
```

Once running terminal will switch to container terminal
```
bash-5.1# 
```

To list command to list folders and files within container:
```
ls 
```

Local azure-cli folder is *mapped* to *export* folder in container so having the ability to easily drag and drop files to and from container
```
bin     dev     etc     export  home    lib     lib64   media   mnt     opt     proc    root    run     sbin    srv     sys     tmp     usr     var
```

Windows local volume folder located at   \\\\wsl$\docker-desktop-data\data\docker\volumes  

Exit terminal using exit keyword, this will stop container:
```
exit 
```

To start created container in interactive terminal mode 
```
docker start cli -i
```

https://hub.docker.com/_/microsoft-azure-cli 

https://learn.microsoft.com/en-us/cli/azure/run-azure-cli-docker 