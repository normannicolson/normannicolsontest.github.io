# Azure Cli list all filenames in Storage

Sep 2021

> Azure cli example to retrieve all files names in Azure storage container using connection string

```
az storage blob list --container-name <Name> --connection-string '<ConnectionString>' --timeout 240 --num-results 200000 --query '[].{name:name}' --output tsv > filenames.txt
```