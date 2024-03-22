# Docker Create Database 

Mar 2024

> Docker Create Database and Push to Container Registry


Create Sql Server Container  

```
docker run -d -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=yourStrong@!Password" -p 1433:1433 --name assets-database mcr.microsoft.com/mssql/server:2022-latest
```

Create Database - run SqlCmd in container
```
docker exec -it assets-database sh

/opt/mssql-tools/bin/sqlcmd -S . -U "sa" -P "yourStrong@!Password" -Q "CREATE DATABASE Assets"

exit
```

Build migrations

```
dotnet ef migrations bundle --output efbundle.exe --self-contained --context Context --startup-project src\Nlist.Assets.API --project src\Nlist.Assets.Infrastructure.Data --verbose
```

Run migrations 

```
.\efbundle.exe --connection "Data Source=localhost,1433;Initial Catalog=Assets;integrated security=false;MultipleActiveResultSets=True;User Id=sa;Password=yourStrong@!Password;TrustServerCertificate=Yes;"
```

List running containers 

```
docker ps
```

Commit container using name of container registry

```
docker commit 2772fa85e49c nlistcontainerregistry.azurecr.io/assets-empty:20240304
```

List images 

```
docker image ld
```

Login to container registry

```
az login
az acr login --name nlistcontainerregistry
```

Push image to container registry
```
docker push nlistcontainerregistry.azurecr.io/assets-empty:20240304
```

## Pull from Repository 

```
nlistcontainerregistry
docker pull nlistcontainerregistry.azurecr.io/assets-empty:20240304
```

Notice data retained 
```
docker run -d -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=yourStrong@!Password" -p 1433:1433 --name assets-database-new nlistcontainerregistry.azurecr.io/assets-empty:20240304
```