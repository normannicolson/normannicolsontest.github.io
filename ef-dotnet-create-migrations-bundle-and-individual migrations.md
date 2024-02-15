# Create Migrations bundle and individual Migrations

> Powershel script to create migrations bundle and individual migrations

```
param (
    [string]$output,
    [bool]$noBuild = $true
)

#From repo root
#.\pipelines\build-migrations.ps1 -output publish-output

Try
{
    $publishOutput = $output
    $bundleOutput = 'bundle-output'
    $migrationsOutput = 'migrations-output'

    dotnet new tool-manifest --force 
    #For versions https://www.nuget.org/packages/dotnet-ef
    dotnet tool install --local dotnet-ef

    # Create $publishOutput folder if folder missing 
    Write-Host 'Creating $publishOutput folder if folder missing'
    if (-Not (Test-Path $publishOutput))
    {
      New-Item -ItemType Directory -Name $publishOutput
    } 

    # Create empty $bundleOutput folder 
    Write-Host 'Creating empty $bundleOutput folder'
    if (Test-Path $bundleOutput)
    {
      Remove-Item $bundleOutput -Recurse
    }
    New-Item -ItemType Directory -Name $bundleOutput

    # Create migrations bundle
    Write-Host 'Creating migrations bundle'
    dotnet ef migrations bundle --output $bundleOutput\efbundle.exe --self-contained --context Context --startup-project src\Nlist.API --project src\Nlist.Infrastructure.Data --verbose

    # Create migrations bundle appsettings.json
    @("{") + `
    @("  `"ConnectionStrings`": {") + `
    @("    `"List`": `"Server=(localdb)\\mssqllocaldb;Database=List;Trusted_Connection=True;`"") + `
    @("  },") + `
    @("}") | Set-Content .\$bundleOutput\appsettings.json

    # Pack migrations bundle
    Write-Host 'Packing Bundle'
    $files = Get-ChildItem $bundleOutput | Sort-Object name
    foreach ($file in $files) 
    {
      Compress-Archive -update $file.FullName $publishOutput\Nlist.Infrastructure.Data.zip
    }

    # Cleanup $bundleOutput
    if (Test-Path $bundleOutput)
    {
      Remove-Item $bundleOutput -Recurse
    }

    # Create migration files
    Write-Host 'Creating migration files'

    $migrations = dotnet ef migrations list --no-build --project src\Nlist.Infrastructure.Data --context Context --startup-project src\Nlist.API --prefix-output --json |
        Where-Object { $_.StartsWith('data:') } |  
        ForEach-Object { $_.Substring(5) } | 
        ConvertFrom-Json

    if (Test-Path $migrationsOutput)
    {
        Remove-Item $migrationsOutput -Recurse
    }
    New-Item -ItemType Directory -Name $migrationsOutput

    $fromMigrationName = "0"
    $zipName = "$publishOutput\Nlist.Infrastructure.Data.Migrations.zip"

    # Create __EFMigrationsHistory migration.
    @("SET XACT_ABORT ON") + `
    @("") + `
    @("IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL") + `
    @("BEGIN") + `
    @("    CREATE TABLE [__EFMigrationsHistory] (") + `
    @("        [MigrationId] nvarchar(150) NOT NULL,") + `
    @("        [ProductVersion] nvarchar(32) NOT NULL,") + `
    @("        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])") + `
    @("    )") + `
    @("END") + `
    @("GO") | Set-Content "$migrationsOutput\00000000000000_EFMigrationsHistory.sql"
    
    Compress-Archive -update "$migrationsOutput\00000000000000_EFMigrationsHistory.sql" $zipName

    # Create individual migrations.
    foreach ($migration in $migrations) 
    {
        $toMigrationName = "$($migration.name)"
        $toMigrationOutput = "$migrationsOutput\$($migration.id).sql"
        
        Write-Host "Adding $toMigrationName Migration"

        dotnet ef migrations script "$fromMigrationName" "$toMigrationName" --no-build --idempotent --output "$toMigrationOutput" --context Context --startup-project src\Nlist.API --project src\Nlist.Infrastructure.Data

        @("SET XACT_ABORT ON") + `
        @("") + `
        (Get-Content "$toMigrationOutput") | Set-Content "$toMigrationOutput"

        Compress-Archive -update $toMigrationOutput $zipName

        $fromMigrationName = $toMigrationName
    }

    # Cleanup $migrationsOutput
    if (Test-Path $migrationsOutput)
    {
        Remove-Item $migrationsOutput -Recurse
    }

    exit 0
}
Catch
{
    Write-Output "Something threw an exception"
    Write-Output $_

    exit 1
}
```