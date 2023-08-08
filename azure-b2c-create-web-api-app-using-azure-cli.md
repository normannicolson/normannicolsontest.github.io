# Create Azure B2c Api Application Registration using Azure Cli

Nov 2021

> Create Api Application Registration using Azure Cli

Mashup of Azure CLi, Powershell and Graph Api 

Login and select tenant as working tenant (isDefault true). 

Replace nameofb2c with name of your directory.

```
az login --tenant [nameofb2c].onmicrosoft.com --allow-no-subscriptions
```

For application name I typically use primary domain name.

Create Api App 

```
az ad app create --display-name your-api-name.com
```

### Create application

```
$app = az ad app create --display-name $appName --sign-in-audience AzureADandPersonalMicrosoftAccount | ConvertFrom-Json
$appId = $app.id
$appAppId = $app.appId
```

### Add Scopes

```
postCreateId = New-Guid

$body = @"
{ 
    'identifierUris': [ 'https://$($tenant).onmicrosoft.com/$appAppId' ], 
    'api': { 
        'acceptMappedClaims': null, 
        'knownClientApplications': [], 
        'oauth2PermissionScopes': [ 
            { 
                'id': '$postCreateId', 
                'adminConsentDescription': 'Post.Create', 
                'adminConsentDisplayName': 'Post.Create',
                'isEnabled': true, 
                'type': 'Admin', 
                'userConsentDescription': 'Post.Create', 
                'userConsentDisplayName': 'Post.Create', 
                'value': 'Post.Create'
            },
        ], 
        'preAuthorizedApplications': [], 
        'requestedAccessTokenVersion': 2 
    },
}
"@
$body = $body -replace "\n", ""
az rest --method PATCH --uri "https://graph.microsoft.com/v1.0/applications/$appId" --headers "Content-Type=application/json" --body "$body"
```

### Grant graph app permissions
```
$graphApiAppId = "00000003-0000-0000-c000-000000000000"
$openidScopeId = "37f7f235-527c-4136-accd-4a02d197296e"
$offline_accessScopeId = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182"

az ad app permission add --id $appId --api $graphApiAppId --api-permissions 37f7f235-527c-4136-accd-4a02d197296e=Scope
az ad app permission add --id $appId --api $graphApiAppId --api-permissions 7427e0e9-2fba-42fe-b0c0-848c9e6a8182=Scope
```

### Create service principle
```
az ad sp create --id $appAppId
```

### Grant app admin consent for permissions
```
az ad app permission admin-consent --id $appId
```