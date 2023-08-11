# Create Azure B2c Policy Uploader App Registration

Nov 2021

> Create Azure B2c Policy Uploader App Registration Powershell script using Azure Cli

B2c directorates are not compatible with Azure Resource Manager(ARM) Templates, directories are manually configured, key setup steps are creating Identity Experience Framework application registration and Proxy Identity Experience Framework Application registration they provide ability to use advanced custom policies and connectivity between B2c and AD allowing users to sign in and enrich claims. 

App Registration with ReadWriteAll permissions allows service principle to create users - useful for migrating users from external identity service to azure b2c  .

Switch Azure Cli to newly created B2c Directory 

## Script

```

$appName = "PreMigration"

# Create application
Write-Output "Creating application"
$app = az ad app create --display-name $appName --sign-in-audience AzureADMyOrg | ConvertFrom-Json
$appId = $app.id 
$appAppId = $app.appId
Start-Sleep -Seconds 10

#Granting app permissions to Graph api
Write-Output "Granting app permissions to Graph api"
$graphApiAppId = "00000003-0000-0000-c000-000000000000"
$directoryReadWriteAllRole = "19dbc75e-c2e2-444c-a770-ec69d8559fc7"
$permissionBody = @"
{
    'requiredResourceAccess': [
		{
			'resourceAppId': '$graphApiAppId',
			'resourceAccess': [
				{
					'id': '$directoryReadWriteAllRole',
					'type': 'Role'
				}
			]
		}
	]
}
"@
$permissionBody = $permissionBody -replace "\n", ""
$permission = az rest --method PATCH --uri "https://graph.microsoft.com/v1.0/applications/$appId" --headers "Content-Type=application/json" --body "$permissionBody" | ConvertFrom-Json
Start-Sleep -Seconds 10

#Granting permissions admin consent
Write-Output "Granting app admin consent for permissions"
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
.\azure-b2c-create-pre-migration-app-using-azure-cli-powershell.ps1
```