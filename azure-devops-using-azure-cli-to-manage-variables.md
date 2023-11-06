# Azure DevOps Using Azure Cli to Manage Variables

Oct 2023

> Using Azure Cli to manage variables

Ymal pipelines steps can call external apis and populate variables, We can use pipeline variables to store variables.

## Create variables using Cli

```
az login --tenant name.onmicrosoft.com 
 
az pipelines variable create --pipeline-name develop --project items --secret false --name KeyName --value 'KeyValue'
```

### Install pipelines cli extension

```
az upgrade    
az extension list-available --output table
az extension add --name azure-devops  
```

### List variables 

```
az pipelines variable list --pipeline-name develop
```

Or
```
az pipelines variable list --pipeline-name develop --output table
```

Outputs

```
{
  "KeyName": {
    "allowOverride": null,
    "isSecret": null,
    "value": "KeyValue"
  },
  "KeyName1": {
    "allowOverride": null,
    "isSecret": null,
    "value": "KeyValue1"
  }
}
```