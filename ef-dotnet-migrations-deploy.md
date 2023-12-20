# EF Dotnet Migrations Deploy

> Useful EF Dotnet Migration deploy 

Install EF core tool (not shipped with .NET SDK)

Repository structure 
```
 src\Nlist.Reserve.API
 src\Nlist.Reserve.Core
 src\Nlist.Reserve.Infrastructure.Data
```

From root of repository install tools 
```
dotnet new tool-manifest --force
dotnet tool install --local dotnet-ef
```

Build projects 
```
```

Bundle migrations
```
dotnet ef migrations bundle --output efbundle.exe --no-build --force --context Context --startup-project src\Nlist.Reserve.API --project src\Nlist.Reserve.Infrastructure.Data
```



Update Migrations (From the src folder)
```
dotnet ef database update --project Nlist.Reserve.Infrastructure.Data --startup-project Nlist.Reserve.API --context Context --verbose
```

Generate DB script (From the src folder)
```
dotnet ef migrations script --project Nlist.Reserve.Infrastructure.Data --startup-project Nlist.Reserve.API --context Context --verbose --idempotent --verbose --output Nlist.Reserve.Infrastructure.Database\database.sql
```

Generate Migration (From the src folder)
```
dotnet ef migrations add Schema --project Nlist.Reserve.Infrastructure.Data --startup-project Nlist.Reserve.API --context Context --verbose
```

List Migrations (From the src folder)
```
dotnet ef migrations list --project Nlist.Reserve.Infrastructure.Data --startup-project Nlist.Reserve.API --context Context --verbose
```

Remove last migrations (From the src folder)
```
dotnet ef migrations remove --project Nlist.Reserve.Infrastructure.Data --startup-project Nlist.Reserve.API --context Context --verbose
```

Rollback to migrations (From the src folder)
```
dotnet ef migrations update [NameOfMigration] --project Nlist.Reserve.Infrastructure.Data --startup-project Nlist.Reserve.API --context Context --verbose
```