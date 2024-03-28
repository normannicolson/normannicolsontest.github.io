B2c Upload B2c Policies from Desktop

Dec 2021

> B2c Upload B2c Policies from Desktop

```
cd $PSScriptRoot

$outputDirName ="output"

Remove-Item -Path "${outputDirName}\*.xml" -ErrorAction Ignore -Force
New-Item -Name $outputDirName -ItemType "directory" -Force

Copy-Item demo\*.xml $outputDirName

.\b2c-replace-placeholder.ps1 -folder $outputDirName -placeholder '__PolicyTenant__' -value ''
.\b2c-replace-placeholder.ps1 -folder $outputDirName -placeholder '__PolicyDeploymentMode__' -value 'Development'
.\b2c-replace-placeholder.ps1 -folder $outputDirName -placeholder '__PolicyProxyIdentityExperienceFrameworkClientId__' -value ''
.\b2c-replace-placeholder.ps1 -folder $outputDirName -placeholder '__PolicyIdentityExperienceFrameworkClientId__' -value ''
.\b2c-replace-placeholder.ps1 -folder $outputDirName -placeholder '__PolicySuffix__' -value '_NN'
.\b2c-replace-placeholder.ps1 -folder $outputDirName -placeholder '__PolicyClaimsEndpoint__' -value 'https://example.com'

$Folder = Join-Path $PSScriptRoot "\${outputDirName}\"

.\b2c-upload-policies.ps1 -ClientID '' -ClientSecret '' -TenantId 'sqaauthcentreb2cdev.onmicrosoft.com' -Folder $Folder -Files 'TrustFrameworkBaseDev.xml,TrustFrameworkLocalizationDev.xml,TrustFrameworkExtensionsDev.xml,SignUpOrSigninDev.xml'
```