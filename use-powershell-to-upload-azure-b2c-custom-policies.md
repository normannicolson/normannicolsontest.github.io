# Use Powershell to Upload Azure B2c Custom Policies

Oct 2018

> Automate upload of azure b2c polices enabling continues integration.

## Separate Writing from Building Policies

The same approach of compiling code can be applied to writing B2c policies, write B2c policies with placeholders then compile/build replacing placeholders with target tenant values.

## Use Replacement Variables in Xml Policy Files

```
<TrustFrameworkPolicy
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns="http://schemas.microsoft.com/online/cpim/schemas/2013/06"
  PolicySchemaVersion="0.3.0.0"
  TenantId="#{Hub.Policy.TenantId}#"
  PolicyId="B2C_1A_Base"
  PublicPolicyUri="#{Hub.Policy.PublicPolicyUri}#"
  DeploymentMode="#{Hub.Policy.DeploymentMode}#">
```

## Build Script by Replacing Variables

Following Powershell policy-build.ps1 is used to replace policy variable placeholders with values from Csv file containing replacement values into drop directory.

```
param(
    [string] $variablesFile
)

Write-Output 'Building b2c policies'

$path = (Get-Location).Path
$rootPath = $(Get-Item $path).Parent.FullName
$sourcePath = $rootPath + '\src\Project.Hub.Policy'
$outputPath = $rootPath + '\drop\Project.Hub.Policy'
$variables = Import-Csv $variablesFile;

if (Test-Path $outputPath)
{
    Remove-Item -Path $outputPath -Recurse
} 

Copy-Item -Path $sourcePath -Filter '*.xml' -Recurse -Destination $outputPath -Container

$files = Get-ChildItem $outputPath -Recurse

foreach ($file in $files)
{
    $content = (Get-Content $file.FullName);

    foreach ($variable in $variables) 
    {
        $content = $content -replace ("#{" + $variable.Name + "}#"), $variable.Value
    }

    $content = $content -replace "\s$", "";

    Set-Content ($file).FullName ($content -join "`n") -NoNewline -Force
}
```

## Variables in Csv File

Sample Csv file structure. 

```
"Name", "Value"
"Hub.Policy.TenantId", "TenantId"
"Hub.Policy.PublicPolicyUri", "PublicPolicyUri"
"Hub.Policy.DeploymentMode", "DeploymentMode"
```

## Run Powershell script policy-build.ps1

Use Poweshell policy-build.ps1 & Csv file containing replacement values to build policies into drop directory.

```
.\policy-build.ps1 -variablesFile C:\Path\policy-variables.csv
```

## Policies Built and Available for Upload

Parsed Policies are dropped into drop directory and ready for upload.

```
<TrustFrameworkPolicy
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns="http://schemas.microsoft.com/online/cpim/schemas/2013/06"
  PolicySchemaVersion="0.3.0.0"
  TenantId="TenantId"
  PolicyId="B2C_1A_Base"
  PublicPolicyUri="PublicPolicyUri"
  DeploymentMode="DeploymentMode">
```

Upload Policy

Create user in directory with upload permissions.

```
az ad user create --display-name --password --user-principal-name
```

## Deploy Script

Accepts arguments and uploads xml files in specified directory using specified user and tenant.

```
param(
    [string] $folderPath,
    [string] $strUserId,
    [string] $strPassword,
    [string] $strTenant
)

function UploadB2CPolicy([string] $strFilePath)
{
    $context = Get-AzureRmContext

    $token = $context.TokenCache.ReadItems() | Select-Object -First 1

    $strAccessToken = $token.AccessToken
    $tenantId = $context.Tenant

    Add-Type -AssemblyName System.Web

    $strPolicy = (Get-Content -Path $strFilePath) -join "`n"
    $strBody = "<string xmlns=`"http://schemas.microsoft.com/2003/10/Serialization/`">$([System.Web.HttpUtility]::HtmlEncode($strPolicy))</string>"

    $htHeaders = @{ "Authorization" = "Bearer $strAccessToken" }

    $response = Invoke-WebRequest -Uri "https://main.b2cadmin.ext.azure.com/api/trustframework?tenantId=$tenantId&overwriteIfExists=true" -Method POST -Body $strBody -ContentType "application/xml" -Headers $htHeaders -UseBasicParsing

    if ($response.StatusCode -ge 200 -and $response.StatusCode -le 299)
    {
        $date = Get-Date -Format g

        Write-Output "Policy successfully uploaded at: $date $strFilePath"
    }
    else
    {
        Write-Output "Failed to upload policy $strFilePath"
    }
}

function UploadB2CPolicies([string] $folderPath)
{
    $policies = Get-ChildItem $folderPath -recurse -include *.xml 

    foreach($policy in $($Policies | Where-Object {$_ -like "*-base*"}))
    {
        UploadB2CPolicy -strFilePath $policy.FullName;
    }

    foreach($policy in $($Policies | Where-Object {$_ -like "*base*"}))
    {
        UploadB2CPolicy -strFilePath $policy.FullName;
    }
    foreach ($policy in $($Policies | Where-Object {$_ -like "*extension*"}))
    {
        UploadB2CPolicy -strFilePath $policy.FullName;
    }
    foreach ($policy in $($Policies | Where-Object {$_ -notlike "*base*" -And $_ -notlike "*extension*"})) 
    {
        UploadB2CPolicy -strFilePath $policy.FullName;
    }
}

$securePassword = ConvertTo-SecureString $strPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($strUserId, $securePassword)

Install-Module -Name AzureRM -Scope CurrentUser -RequiredVersion 5.7.0 -Force -AllowClobber 

Connect-AzureRmAccount -Credential $credential

Set-AzureRmContext -TenantId $strTenant

UploadB2CPolicies -folderPath $folderPath
```

## Run Powershell script policy-deploy.ps1

Use Poweshell policy-deploy.ps1 to upload policies from drop directory.

```
.\policy-deploy.ps1 -folderPath 'C:\path\drop' -strUserId 'username' -strPassword 'password' -strTenant 'tenant'
```