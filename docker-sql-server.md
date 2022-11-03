# Docker Sql server for local development

Jul 2022

> Use Docker Sql server for development  

Create container with volume 

```
docker run --name sqlserver -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=yourStrong!Passw0rd' -p 1433:1433 -v sqlvolume:/var/opt/mssql -d mcr.microsoft.com/mssql/server:2022-latest
```

Connect to Database using Azure Data Studio or other tool

```
Server: localhost,1433
Authentication type: SQL Login
User name: sa 
Password: yourStrong!Passw0rd
```

Create Database 

```
CREATE DATABASE Example
```

Database files added to local folder \\\\wsl$\docker-desktop-data\data\docker\volumes\sqlvolume\\_data\data

```
Example.mdf
Example_log.ldf
```

Connection string

```
Data Source=localhost,1044; Initial Catalog=Example;integrated security=false; MultipleActiveResultSets=True; User Id=sa; Password=yourStrong(!)Password;
```

Create image from container changes

```
docker commit customsqlserver
```

## Dockerfile approach  

Dockerfile 

```
# base image on SQL 2022 latest image
FROM mcr.microsoft.com/mssql/server:2022-latest
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=yourStrong(!)Password
ENV MSSQL_TCP_PORT=1433
EXPOSE 1433

WORKDIR /var/opt/mssql/data

# copy into container
COPY create-db.sh /var/opt/mssql/data

# use the ENTRYPOINT command to execute the script and start SQL Server
ENTRYPOINT /var/opt/mssql/data/create-db.sh & /opt/mssql/bin/sqlservr
```

create-db.sh

```
sleep 15s
 
/opt/mssql-tools/bin/sqlcmd -S . -U "sa" -P "yourStrong(!)Password" -Q "CREATE DATABASE Example"
```

Create image from Dockerfile in directory 
```
docker build -t customsqlserver . 
```

Create container from image 
```
docker run --name customsqlserver -p 1433:1433 customsqlserver
```

## Dockerfile approach with sqlmgt with input file 

Dockerfile 
```
# base image on SQL 2022 latest image
FROM mcr.microsoft.com/mssql/server:2022-latest
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=yourStrong(!)Password
ENV MSSQL_TCP_PORT=1433
EXPOSE 1433

WORKDIR /var/opt/mssql/data

# copy into container
COPY src/create-db.sh /var/opt/mssql/data
COPY src/sql.sql /var/opt/mssql/data

# use the ENTRYPOINT command to execute the script and start SQL Server
ENTRYPOINT /var/opt/mssql/data/create-db.sh & /opt/mssql/bin/sqlservr
```

create-db.sh
```
sleep 15s

/opt/mssql-tools/bin/sqlcmd -S "localhost" -U "sa" -P "yourStrong(!)Password" -i "sql.sql"
```

sql.sql
```
CREATE DATABASE Example

GO

USE Example

CREATE TABLE Posts
(
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Name] NVARCHAR(128) NOT NULL
)
```

Create image from Dockerfile in directory 
```
docker build -t customsqlserver . 
```

Create container from image 
```
docker run --name customsqlserver -p 1433:1433 customsqlserver
```

## Dockerfile approach attach database with mdf ldf files 

Dockerfile
```
# base image on SQL 2022 latest image
FROM mcr.microsoft.com/mssql/server:2022-latest
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=yourStrong(!)Password
ENV MSSQL_TCP_PORT=1433
EXPOSE 1433

WORKDIR /var/opt/mssql/data

# copy into container
COPY --chown=mssql ./src/. /var/opt/mssql/data/

# use the ENTRYPOINT command to execute the script and start SQL Server
ENTRYPOINT /var/opt/mssql/data/attach-db.sh & /opt/mssql/bin/sqlservr
```

attach-db.sh
```
sleep 15s

ls -lan

/opt/mssql-tools/bin/sqlcmd -S "localhost" -U "sa" -P "yourStrong(!)Password" -i "attach-db.sql"
```

attach-db.sql
```
CREATE DATABASE [Example] 
ON (FILENAME = '/var/opt/mssql/data/Example.mdf'), (FILENAME = '/var/opt/mssql/data/Example_log.ldf') FOR ATTACH

GO

USE [Example] 

CREATE TABLE Posts
(
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Name2] NVARCHAR(128) NOT NULL
)
```

Create image from Dockerfile in directory 
```
docker build -t customsqlserver . 
```

Create container from image 
```
docker run --name customsqlserver -p 1433:1433 customsqlserver
```

