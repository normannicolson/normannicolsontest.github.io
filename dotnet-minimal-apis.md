# Dotnet cli Create Minimal Api

July 2025

> Dotnet cli create minimal api


Create project
```
dotnet new webapi --use-minimal-apis
```

Add Authentication packages
```
dotnet add package Microsoft.Identity.Web
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer
```

Add Docker packages
```
dotnet add package Microsoft.VisualStudio.Azure.Containers.Tools.Targets
```

Run project 
```
dotnet run
```

For development with hot reload
```
dotnet watch run
```