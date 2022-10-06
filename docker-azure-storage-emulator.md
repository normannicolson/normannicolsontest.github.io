# Docker Azure Storage Emulator

Sep 2022

> Docker Azure Storage Emulator.

Pull image command 
```
docker pull mcr.microsoft.com/azure-storage/azurite
```

Run container detached terminal 
```
docker run -d -p 10000:10000 -p 10001:10001 -p 10002:10002 --name azurite mcr.microsoft.com/azure-storage/azurite 
```

Stop container
```
docker stop azurite
```

Remove container
```
docker rm azurite
```

https://hub.docker.com/_/microsoft-azure-storage-azurite 

https://learn.microsoft.com/en-us/azure/storage/blobs/use-azurite-to-run-automated-tests 