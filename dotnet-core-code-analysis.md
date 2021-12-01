# Dotnet Core Code Analysis

Oct 2018

> How to configure dotnet core projects to use code analysis rules.

Code analysis is a useful tool tool to analyse code for know defects in performance and security and ensuing code syntax style. 

```
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore.App" />
    <PackageReference Include="Microsoft.CodeAnalysis.FxCopAnalyzers" Version="2.6.1" />
    <PackageReference Include="SecurityCodeScan" Version="2.7.1" />
    <PackageReference Include="StyleCop.Analyzers" Version="1.0.2" />
  </ItemGroup>

  <PropertyGroup>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
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