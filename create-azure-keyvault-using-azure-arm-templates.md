# Create Azure KeyVault using Azure Arm Templates

Jun 2018

> Azure resource manager template creating azure keyvault service.

## Arm structure

```
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
  },
  "variables": {
  },
  "resources": [
  ],
  "outputs": {
  }
}
```

Create KeyVault with applications with access

```
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "location": {
      "type": "string",
      "defaultValue": "[resourcegroup().location]"
    },
    "baseResourceName": {
      "type": "string",
      "defaultValue": "nlistconcept"
    },
    "environment": {
      "type": "string",
      "defaultValue": "dev"
    },
    "tenantId": {
      "type": "string",
      "defaultValue": "********-****-****-****-************"
    }
  },
  "variables": {
    "name": "[concat(parameters('baseResourceName'), parameters('environment'), 'vault')]"
  },
  "resources": [
    {
      "type": "Microsoft.KeyVault/vaults",
      "name": "[variables('name')]",
      "apiVersion": "2016-10-01",
      "location": "[parameters('location')]",
      "tags": { },
      "properties": {
        "tenantId": "[parameters('tenantId')]",
        "sku": {
          "family": "A",
          "name": "standard"
        },
        "accessPolicies": [
        ],
        "enabledForDeployment": true
      }
    }
  ]
}
```

Cli command

```
az group deployment create --name deployment1 --resource-group nlist --template-file keyvault.json
```

More information from https://docs.microsoft.com/en-us/cli/azure/group/deployment?view=azure-cli-latest  