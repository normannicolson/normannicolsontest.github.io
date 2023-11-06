
Ensure bicep Extension installed 

```
az upgrade 

az bicep install 
```

Or upgrade
```
#az bicep upgrade
```

Login and set active subscription
```
az login --tenant [name].onmicrosoft.com

az account set --subscription "[subscription name]"
```

Create resource group if needed 

```
az group create --name [resource group name] --location uksouth
```

Deploy bicep  

```
az deployment group create --resource-group [resource group name] --template-file app-configuration.bicep --parameters organisation=[organisation] name=[name] env=dev
loc=uks resource=config

az deployment group create --resource-group [resource group name] --template-file insights.bicep --parameters organisation=[organisation] name=[name] env=dev loc=uks resource=insights

az deployment group create --resource-group [resource group name] --template-file files.bicep --parameters organisation=[organisation] name=[name] env=dev loc=uks corsOrigin=https://localhost:5001
```

app-configuration.bicep 
```
@description('Specifies the Azure location where the app configuration store should be created.')
param location string = resourceGroup().location
param organisation string = ''
param env string = ''
param name string = 'items'
param loc string = ''
param resource string = 'config'

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: '${organisation}-${env}-${name}-${loc}-${resource}'
  location: location
  sku: {
    name: 'standard'
  }
}

var featureFlags = [
  {
    id: 'IsAlternativeMode'
    enabled: false
  }
]

resource featureFlagResources 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' = [for i in featureFlags: {
  parent: appConfiguration
  name: '.appconfig.featureflag~2F${i.id}'
  properties: {
    value: string(i)
    contentType: 'application/vnd.microsoft.appconfig.ff+json;charset=utf-8'
  }
}]

var keyValues = [
  {
    name: 'Items:KeyDates:Open'
    value: '2023-01-01T00:00:00+00:00'
  }
  {
    name: 'Items:KeyDates:Close'
    value: '2023-02-02T00:00:00+00:00'
  }
  {
    name: 'Items:KeyDates:Sentinel'
    value: '1'
  }
]
```

app-insights.bicep 
```
@description('Specifies the Azure location where the app configuration store should be created.')
param location string = resourceGroup().location
param organisation string = ''
param env string = ''
param name string = 'items'
param loc string = ''
param resource string = 'insights'

resource workspaceResource 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${organisation}-${env}-${name}-${loc}-${resource}'
  location: location
  properties: {
    sku: {
      name: 'pergb2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${organisation}-${env}-${name}-${loc}-${resource}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceResource.id
  }
}

```

files.bicep 
```
@description('Specifies the Azure location where the app configuration store should be created.')
param location string = resourceGroup().location
param organisation string = ''
param env string = ''
param name string = ''
param loc string = ''
param resource string = ''
param corsOrigin string = ''

resource storageaccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: '${organisation}${env}${name}${loc}${resource}'
  location: location
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource blobs_default 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  parent: storageaccount
  name: 'default'
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: [
        {
          allowedOrigins: [
            corsOrigin
          ]
          allowedMethods: [
            'GET'
            'HEAD'
            'POST'
            'OPTIONS'
            'PUT'
          ]
          maxAgeInSeconds: 0
          exposedHeaders: [
            '*'
          ]
          allowedHeaders: [
            '*'
          ]
        }
      ]
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: true
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
  }
}

resource file_default 'Microsoft.Storage/storageAccounts/fileServices@2022-09-01' = {
  parent: storageaccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource queue_default 'Microsoft.Storage/storageAccounts/queueServices@2022-09-01' = {
  parent: storageaccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource table_default 'Microsoft.Storage/storageAccounts/tableServices@2022-09-01' = {
  parent: storageaccount
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource files_default_templatefiles 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: blobs_default
  name: 'templatefiles'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
}

```

Decompile Arm template to bicep 
```
az bicep decompile --file template.json --force
```