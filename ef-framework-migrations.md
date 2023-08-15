
#  EF Framework Migrations

> Useful EF Framework Migration commands 

Example Project Structure 

```
 src\Nlist.Reserve.API
 src\Nlist.Reserve.Core
 src\Nlist.Reserve.Infrastructure.Data
```

Prerequisites

- EntityFramework package 
- Context class ```public class Context : DbContext```

Open Package manager console

Add support for Migrations creates DbMigrationsConfiguration class enter command into package manager console

```
Enable-Migrations
```

Add Migration

```
Add-Migration -ProjectName Nlist.Reserve.Infrastructure.Data -StartUpProjectName Nlist.Reserve.Api -Verbose
```

Update-Database 

```
Update-Database -ProjectName Nlist.Reserve.Infrastructure.Data -StartUpProjectName Nlist.Reserve.Api -Verbose
```

Rollback 

```
Update-Database -TargetMigration:"MigrationName1" -Verbose
```

```
$(Build.SourcesDirectory)\packages\EntityFramework.6.4.4\tools\net45\any\ef6.exe database update --script --assembly $(Build.StagingDirectory)\Nlist.Reserve.Infrastructure.Data.dll --config $(Build.SourcesDirectory)\Nlist.Api\Web.config --source 0 --prefix-output | where { $_.StartsWith('data:') } | foreach { $_.Substring(9) } > $(Build.ArtifactStagingDirectory)\migration.sql
```

Create Database in docker

```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Password@123' -p 1433:1433 -d mcr.microsoft.com/mssql/server
```

Connection String 

```
Data Source=localhost,1433;Initial Catalog=SQADataContextB2c;integrated security=false;MultipleActiveResultSets=True;User Id=sa;Password=Password@123;TrustServerCertificate=true;
```