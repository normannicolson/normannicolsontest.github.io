# Using SqlPackage.exe to Deploy Legacy Database Projects (.dacpac)

Aug 2020

> Using SqlPackage.exe to deploy legacy database projects .dacpac from command line in powershell and cmd.

I recommend using Migrations for database continuous delivery practice, database projects are great for describing the current schema but don’t describe how we get there.

The migrations approach executes a collection of individual scripts in predefined order, once script executes information about script is stored in database and ignored in subsequent runs, scripts can be written to move data form Table A Column A to Column B and Column B to Column C, every releases will follow same process.

Databases should work with previous and current codebase for Canary/Blue Green Deploys. So example might not be that applicable.

Dacpac describe the Schema Table A with only Column C: Column A and Column B both been dropped and Column C created the data in Column A and Column B have both been lost, this will only happen if many changes are shipped together using Dacpac approach.

## Build Database Project

```
& "C:\Path\msbuild.exe" C:\Path\Database.sln
```

Building project will create dacpac.

## Publish

```
& "C:\Path\SqlPackage.exe" /Action:Publish /SourceFile:"C:\Path\Database.dacpac" /TargetConnectionString:"ConnectionString"
```

Add variables

```
& "C:\Path\SqlPackage.exe" /Action:Publish /SourceFile:"C:\Path\Database.dacpac" /TargetConnectionString:"ConnectionString" /V:Name1=Value1 /V:Name2=Value2 /V:Name3=Value3
```

## Export & Extract

Export database with data

```
& "C:\Path\SqlPackage.exe" /Action:Export /SourceConnectionString:"ConnectionString" /TargetFile:"C:\Path\Database.bacpac"
Extract Just schema
```

```
& "C:\Path\SqlPackage.exe" /Action:Extract /SourceConnectionString:"ConnectionString" /TargetFile:"C:\Path\Database.dacpac"
```