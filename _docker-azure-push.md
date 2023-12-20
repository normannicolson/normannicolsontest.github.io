
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli


az config set core.allow_broker=true
az account clear
az login


az acr login --name myregistry


az acr login --name normannicolson



docker ps

CONTAINER ID   IMAGE                                     COMMAND                  CREATED          STATUS          PORTS                                           NAMES
8e205f40a9a4   dockercompose6627046938699081999-db       "/opt/mssql/bin/perm…"   22 minutes ago   Up 22 minutes   0.0.0.0:1433->1433/tcp                          appealsdb  

Commit docker container 
docker commit appealsdb

PS C:\Repositories\GitHub\notes> docker commit appealsdb
sha256:d9a30be3def60ad096deafd2381326206d5c26c9f793e302d4091384b9d5d159

docker images -a
PS C:\Repositories\GitHub\notes> docker images -a
REPOSITORY                                TAG               IMAGE ID       CREATED              SIZE  
<none>                                    <none>            d9a30be3def6   About a minute ago   1.76GB
dockercompose6627046938699081999-db       latest            6637c63cbb23   34 minutes ago       1.6GB 



docker tag d9a30be3def6 normannicolsonsqa.azurecr.io/appeals-db


docker push normannicolsonsqa.azurecr.io/appeals-db



