# Create Azure B2c Policy Uploader App Registration

Nov 2021

> Create Azure B2c Policy Uploader App Registration Powershell script using Azure Cli

B2c directorates are not compatible with Azure Resource Manager(ARM) Templates, directories are manually configured, key setup steps are creating Identity Experience Framework application registration and Proxy Identity Experience Framework Application registration they provide ability to use advanced custom policies and connectivity between B2c and AD allowing users to sign in and enrich claims. 

App Registration with Policy.ReadWrite.TrustFramework permissions allows service principle to upload B2c policies - integrate with CI CD pipelines.

Switch Azure Cli to newly created B2c Directory 

## Script

```
$appName = "PolicyUploader"

# Create application
Write-Output "Creating application"
$app = az ad app create --display-name $appName --enable-access-token-issuance false --enable-id-token-issuance false --sign-in-audience AzureADMyOrg | ConvertFrom-Json 
$appId = $app.id 
$appAppId = $app.appId
Start-Sleep -Seconds 10

#Granting app permissions to Graph api
Write-Output "Updating App adding Policy.ReadWrite.TrustFramework permission"
$graphApiAppId = "00000003-0000-0000-c000-000000000000"
$policyReadWriteTrustFrameworkRole = "79a677f7-b79d-40d0-a36a-3e6f8688dd7a"  
$body = @"
{
    'requiredResourceAccess': [
        {
            'resourceAppId': '$graphApiAppId',
            'resourceAccess': [
				{
					'id': '$policyReadWriteTrustFrameworkRole',
					'type': 'Role'
				}
            ]
        }
    ]
}
"@
$body = $body -replace "\n", ""       
$app = az rest --method PATCH --uri "https://graph.microsoft.com/v1.0/applications/$appId" --headers "Content-Type=application/json" --body "$body" | ConvertFrom-Json
Start-Sleep -Seconds 10

#Granting permissions admin consent
Write-Output "Granting permissions admin consent"
az ad app permission admin-consent --id $appId
Start-Sleep -Seconds 10

# Create client secret
Write-Output "Creating client secret"
$passwordBody = @"
{
    'passwordCredential': {'displayName': 'Auto'}
}
"@
$passwordBody = $passwordBody -replace "\n", ""
$password = az rest --method POST --uri "https://graph.microsoft.com/v1.0/applications/$appId/addPassword" --headers "Content-Type=application/json" --body "$passwordBody" | ConvertFrom-Json
$passwordSecretText = $password.secretText
Start-Sleep -Seconds 10

Write-Output "app name: $appName"
Write-Output "app object id: $appId"
Write-Output "app client id: $appAppId"
Write-Output "passwordSecretText: $passwordSecretText"

```

## Use

```
.\azure-b2c-create-policy-uploader-app-using-azure-cli-powershell.ps1
```