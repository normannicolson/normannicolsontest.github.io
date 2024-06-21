# Azure Cli Keyvault & Monitor

Jun 2024

> Azure cli create key vault & log analytics workspace

Run Azure CLI within Docker container

```
docker run -it mcr.microsoft.com/azure-cli
```

Login 
```
az login 
```

Create resource group 

```
az group create --name "nlistlearn" --location "WestEurope"
```

Create keyvault 

```
az keyvault create --name "nlistlearnkeyvault" --resource-group "nlistlearn" --enable-rbac-authorization
```

Create storage account 

```
az storage account create --name "nlistlearnstorage" --resource-group "nlistlearn" --sku "Standard_LRS"

```

Create log analytics workspace

```
az monitor log-analytics workspace create --name "nlistlearnloganalytics" --resource-group "nlistlearn"
```

Enable Key Vault logging

```
$kv_id=$(az keyvault show --name "nlistlearnkeyvault" | jq .id)
echo $kv_id

st_id=$(az storage account show --name "nlistlearnstorage" | jq .id)
echo $st_id

ws_id=$(az monitor log-analytics workspace show --resource-group "nlistlearn" --name "nlistlearnloganalytics" | jq .id)
echo $ws_id

az monitor diagnostic-settings create --storage-account $st_id --workspace $ws_id --resource $kv_id --name "Key vault logs" --logs '[{"category": "AuditEvent","enabled": true}]' --metrics '[{"category": "AllMetrics","enabled": true}]'
```

```
az monitor diagnostic-settings create --resource "/subscriptions/***/resourceGroups/nlistlearn/providers/Microsoft.KeyVault/vaults/nlistlearnkeyvault" --name "Key vault logs" --logs '[{"category": "AuditEvent","enabled": true}]' --metrics '[{"category": "AllMetrics","enabled": true}]' --storage-account "/subscriptions/***/resourceGroups/nlistlearn/providers/Microsoft.Storage/storageAccounts/nlistlearnstorage" --workspace "/subscriptions/***/resourceGroups/nlistlearn/providers/Microsoft.OperationalInsights/workspaces/nlistlearnloganalytics" 
```

To create secrets Use RBAC Key Vault Secrets Officer 

Create secret 

```
az keyvault secret set --vault-name "nlistlearnkeyvault" --name MySecretName1 --value MyValue1
```

List secrets

```
az keyvault secret list --vault-name "nlistlearnkeyvault" 
```

View secrets  
```
az keyvault secret show --vault-name "nlistlearnkeyvault" --name MySecretName1 
```

```
az keyvault secret set --vault-name "nlistlearnkeyvault" --name MySecretName2 --value MyValue2
az keyvault secret set --vault-name "nlistlearnkeyvault" --name MySecretName3 --value MyValue3
az keyvault secret set --vault-name "nlistlearnkeyvault" --name MySecretName4 --value MyValue4
az keyvault secret set --vault-name "nlistlearnkeyvault" --name MySecretName5 --value MyValue5
```

```
az keyvault secret delete --vault-name "nlistlearnkeyvault" --name MySecretName5
```

```
az keyvault secret list --vault-name "nlistlearnkeyvault" 
```

To view audit use RBAC Storage Blob Data Contributor

Log 

```
az monitor log-analytics workspace show --resource-group "nlistlearn" --name nlistlearnloganalytics 
```

```
az monitor log-analytics query --workspace "ad115491-10c8-4365-a182-fadaaf6ace91" --analytics-query "AzureDiagnostics | where ResourceType == 'VAULTS' | where OperationName == 'SecretDelete' | where TimeGenerated >= ago(1h) | take 5" 
```