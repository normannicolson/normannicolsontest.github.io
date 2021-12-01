# Create Azure KeyVault using Azure Cli

Jun 2018

> Azure cli script to create azure keyvault.

The default role for a service principal is contributor. Contributors can create, edit & delete. 

To create a service principle run.

```
az ad sp create-for-rbac --name {Name} --password {Password}
```

Will output.

```
{
  "appId": "AppId",
  "displayName": "Name",
  "name": "http://Name",
  "password": "Password",
  "tenant": "Tenant"
}
```

Service principles are created in default directory. View service principles by navigating in portal to default directory, select active directory, view app registrations, then view all applications.

Login using service principle.

```
az login --service-principal -username {Name} --password {Password} --tenant {Tenant}
```

Create keyvault.

```
az keyvault create --name {Name} --resource-group {ResourceGroupName} --location {location} --sku {Sku}
```

Outputs.
```
{
  "id": "**********",
  "location": "uksouth",
  "name": "**********",
  "properties": {
    "accessPolicies": [
      {
        "applicationId": null,
        "objectId": "**********",
        "permissions": {
          "certificates": [
            "get",
            "list",
            "delete",
            "create",
            "import",
            "update",
            "managecontacts",
            "getissuers",
            "listissuers",
            "setissuers",
            "deleteissuers",
            "manageissuers",
            "recover"
          ],
          "keys": [
            "get",
            "create",
            "delete",
            "list",
            "update",
            "import",
            "backup",
            "restore",
            "recover"
          ],
          "secrets": [
            "get",
            "list",
            "set",
            "delete",
            "backup",
            "restore",
            "recover"
          ],
          "storage": [
            "get",
            "list",
            "delete",
            "set",
            "update",
            "regeneratekey",
            "setsas",
            "listsas",
            "getsas",
            "deletesas"
          ]
        },
        "tenantId": "**********"
      }
    ],
    "createMode": null,
    "enableSoftDelete": null,
    "enabledForDeployment": false,
    "enabledForDiskEncryption": null,
    "enabledForTemplateDeployment": null,
    "sku": {
      "name": "standard"
    },
    "tenantId": "**********",
    "vaultUri": "https://**********"
  },
  "resourceGroup": "**********",
  "tags": {},
  "type": "Microsoft.KeyVault/vaults"
}
```

More info at https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest