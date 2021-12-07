# Filter Azure Cli Responses using JmesPath Queries 

Oct 2021

> JmesPath Examples with Azure Cli rest command

## Cli Account for azure subscription information

Cli command

```
az account list
```

Example response 

```
[  
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "**********",
    "id": "**********",
    "isDefault": false,
    "managedByTenants": [],
    "name": "Subscription 1",
    "state": "Enabled",
    "tenantId": "**********",
    "user": {
      "name": "**********",
      "type": "user"
    }
  },
  ...
  {
    "cloudName": "AzureCloud",
    "id": "**********",
    "isDefault": false,
    "name": "N/A(tenant level account)",
    "state": "Enabled",
    "tenantId": "",
    "user": {
      "name": "**********",
      "type": "user"
    }
  }
]

```

Only dispay name and user name 

```
az account list --query "[].{Name:name, User:user.name}"
```

Response 

```
[
  {
    "Name": "Subscription 1",
    "User": "**********"
  },
  ...
  {
    "Name": "N/A(tenant level account)",
    "User": "**********"
  }
]
```

Find by name

```
az account list --query "[?contains(name, 'Subscription')].{Name:name, User:user.name}"
```

Response

```
[
  {
    "Name": "Subscription 1",
    "User": "**********"
  }
]
```

## Cli Account for azure application information

List applications

```
az rest --method GET --uri "https://graph.microsoft.com/v1.0/applications" --headers "Content-Type=application/json" --query "value[][appId, id, displayName]"
```

```
  [
    "**********",
    "**********",
    "IdentityExperienceFramework"
  ],
  ...
  [
    "**********",
    "**********",
    "WebApp"
  ]
]
```

Display ExperienceFramework application properties

```
#!/bin/bash

az rest --method GET --uri "https://graph.microsoft.com/v1.0/applications" --headers "Content-Type=application/json" --query "value[?contains(displayName, 'ExperienceFramework')][appId, id, displayName]"
```

```
[
  [
    "**********",
    "**********",
    "ProxyIdentityExperienceFramework"
  ],
  [
    "**********",
    "**********",
    "IdentityExperienceFramework"
  ]
]
```
https://docs.microsoft.com/en-us/cli/azure/use-cli-effectively

https://docs.microsoft.com/en-us/cli/azure/query-azure-cli