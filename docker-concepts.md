Docker key concepts 
Conatainers 
Images 
Orchestrators 

# What are Containers 

Key terms are Images and Containers 

## Images
Image is application and its dependencies 

## Container
Container is an instance of an image running on a Docker host 

Docker image will work same on every DockerHost 

# Images
Images are made up of muliple layers
Images can be layered on each other

Images are readonly 

Nginx
Debian

Images are configured in Dockerfiles

Images can be published to container registries to share public like Docker hub or private like Azure container registry 

# Container runs on Docker host

Works the same everywhere 
Provides Memory and CPU
Ports 
Disk access only within image 
Stop Start 
Multiple containers form same image 

# Container Data storage 
Container should not store data (allthough they can)
Approch is to use volumes, Volums are outside of container 

# Networking 
Publish a port
Port mapping 

# Enviomanet Vairables 
Container contain there own envioment vairables 

# Windows & Linux
Windows 10 
Windows Subsystem for Linuc (WSL 2)
can run Linux and Windows containers side by side 

# Docker Benifts 
Isolation 
Portability 
Efficiency 

# Docker Versus VMs 

Containers have share layers lower memory requirments
Containers start faster no OS boot 
Containers are disposable 

# Orchestration 
## Clusters 
Multiple machines multiple containers how to manage 

Orchestratiors fit in 
Kubernetetes
Service Fabric 

Declare in Yaml


Hosting on Azure options 

Iaas
ACI - serverless 
Azure Web Apps for containers 
Azure Service Fabric 
Azure Kubernetes Service 
Mangaged Kubernetes cluster 


# Using Docker locally 

## docker run
Run docker image  

docker run [image name]:[tag]
```
docker run -p 6379:6379 -d --name cache redis
```
-p Port mapping

-d Run detached 

https://docs.docker.com/engine/reference/run/

## docker ps
View what containers are running 

```
docker ps
```

Outputs
```
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                    NAMES
398059d256c3   redis     "docker-entrypoint.s…"   7 seconds ago   Up 7 seconds   0.0.0.0:6379->6379/tcp   cache
```

## docker logs
View container logs

```
docker logs cache
```

Outputs
```
1:C 31 Oct 2023 11:20:47.744 # WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. Being disabled, it can also cause failures without low memory condition, see https://github.com/jemalloc/jemalloc/issues/1328. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
1:C 31 Oct 2023 11:20:47.745 * oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 31 Oct 2023 11:20:47.745 * Redis version=7.2.2, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 31 Oct 2023 11:20:47.745 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
1:M 31 Oct 2023 11:20:47.745 * monotonic clock: POSIX clock_gettime
1:M 31 Oct 2023 11:20:47.745 * Running mode=standalone, port=6379.
1:M 31 Oct 2023 11:20:47.745 * Server initialized
1:M 31 Oct 2023 11:20:47.746 * Ready to accept connections tcp
```

## docker exec 
run command within a container 

```
docker exec -it cache sh
```

-it interactice terminal 

Terminal ```ls -al```

Outputs 
```
# ls -al
total 8
drwxr-xr-x 2 redis redis 4096 Oct 19 01:03 .
drwxr-xr-x 1 root  root  4096 Oct 31 11:20 ..  
```

Terminal  ```redis-cli``````

Using redis-cli within interactive terminal 
```
# redis-cli
127.0.0.1:6379> ping
PONG
127.0.0.1:6379> set name 'hello world'
OK
127.0.0.1:6379> get name
"hello world"
127.0.0.1:6379>

exit
```
## docker stop 
Stop running container 

```
docker stop cache 
```

## docker rm
remove docker container 

```
docker rm cache 
```

Force to stop and remove container  
```
docker rm cache -f
```

## docker images 
Manage images on system 

List running images on system
```
docker image ls
```

List all imaages on syetem 
```
docker image ls -a   
```

Remove image from system
```
docker image rm redis 
```

## docker volumes

```
docker volume ls
```
Manage volumns on system 

docker volume inspect normansql
-v 


Create sql https://hub.docker.com/_/microsoft-mssql-server

```
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=yourStrong@!Password" -p 1433:1433 -d -v normansql:/var/opt/mssql/data mcr.microsoft.com/mssql/server:2022-latest
```



https://docs.docker.com/storage/volumes/









# Copy files into container
COPY Nlist.Infrastructure.Database/wait-for-it.sh /var/opt/mssql/data
COPY Nlist.Infrastructure.Database/setup.sh /var/opt/mssql/data
COPY Nlist.Infrastructure.Database/create-database.sql /var/opt/mssql/data
COPY Nlist.Infrastructure.Database/appeals-database.sql /var/opt/mssql/data

# Right most task is the foreground process, because this process controls the life of the container. If it exits, the container will shut down.
CMD ./setup.sh & /opt/mssql/bin/sqlservr



```











# Azure Hosting Options 
Azure Container Instances (ACI)
Azure Web Apps for Containers 
Azure Service Fabric
Azure Kubernetes Service (AKS) Container Orchestration



https://hub.docker.com
https://mcr.microsoft.com/
