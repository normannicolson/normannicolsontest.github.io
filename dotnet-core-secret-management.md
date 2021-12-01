# Dotnet Core Secret Management

Oct 2018

> How to configure dotnet core projects to use secret appsettings file keeping configuration values outside source control.

Storing secrets in source control is bad practice, even if only for development environment, source control history is maintained for lifetime of project and can leak security details. 

With asp core secrets can be stored outside source control. 

```
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.ApplicationInsights.AspNetCore" Version="2.3.0" />
    <PackageReference Include="Microsoft.AspNetCore.App" Version="2.1.1" />
    <PackageReference Include="Microsoft.CodeAnalysis.FxCopAnalyzers" Version="2.6.1" />
    <PackageReference Include="SecurityCodeScan" Version="2.7.1" />
    <PackageReference Include="StyleCop.Analyzers" Version="1.0.2" />
  </ItemGroup>

  <PropertyGroup>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <UserSecretsId>FolderName</UserSecretsId>
  </PropertyGroup>

  <PropertyGroup>
    <CodeAnalysisRuleSet>../.analyzersettings/Sitekit.ruleset</CodeAnalysisRuleSet>
  </PropertyGroup>

  <ItemGroup>
    <AdditionalFiles Include="../.analyzersettings/StyleCop.json" Link="StyleCop.json" />
  </ItemGroup>

  <ItemGroup>
    <Folder Include="wwwroot\" />
  </ItemGroup>

</Project>
```

```
var builder = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile(SettingsNames.AppSettingsFile)
    .AddUserSecrets<T>();

this.configuration = builder.Build();
```