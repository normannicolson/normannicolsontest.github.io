# Create Azure B2c Spa Application Registration using Azure Cli

Nov 2021

> Create Spa Application Registration using Azure Cli

Mashup of Azure CLi, Powershell and Graph Api 

Login and select tenant as working tenant (isDefault true). 

Replace nameofb2c with name of your directory.

```
az login --tenant [nameofb2c].onmicrosoft.com --allow-no-subscriptions
```

For application name I typically use primary domain name.

Create App 

```
$app = az ad app create --display-name $appName --sign-in-audience AzureADandPersonalMicrosoftAccount | ConvertFrom-Json
$appId = $app.id
$appAppId = $app.appId
```

Add Spa Platform Settings

```
{
    'web': {
         'homePageUrl': null,
         'implicitGrantSettings': {
             'enableAccessTokenIssuance': false,
             'enableIdTokenIssuance': true
         },
         'logoutUrl': '$appLogoutUrl',
         'redirectUriSettings': [],
         'redirectUris': []
     },
    'spa': {
        'redirectUris': [
            '$appRedirectUri',
            'https://jwt.ms'
        ]
    }
}
```

### Grant graph app permissions
```
$graphApiAppId = "00000003-0000-0000-c000-000000000000"
$openidScopeId = "37f7f235-527c-4136-accd-4a02d197296e"
$offline_accessScopeId = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182"

az ad app permission add --id $appId --api $graphApiAppId --api-permissions 37f7f235-527c-4136-accd-4a02d197296e=Scope
az ad app permission add --id $appId --api $graphApiAppId --api-permissions 7427e0e9-2fba-42fe-b0c0-848c9e6a8182=Scope
```

### Grant api app scope permissions
```
$api = "your-api-name.com"
$scopeName = "scope-name"

$apiApp = az rest --method GET --uri "https://graph.microsoft.com/v1.0/applications" --headers "Content-Type=application/json" --query "value[?displayName == '$api']" | ConvertFrom-Json
$apiAppId = $apiApp.appId

$scope = $apiApp.api.oauth2PermissionScopes | Where-Object value -eq $scopeName
$scopeId = $scope.id

az ad app permission add --id $appId --api $apiAppId --api-permissions $scopeId=Scope | ConvertFrom-Json
```

### Create service principle
```
az ad sp create --id $appAppId
```

### Grant app admin consent for permissions
```
az ad app permission admin-consent --id $appId
```