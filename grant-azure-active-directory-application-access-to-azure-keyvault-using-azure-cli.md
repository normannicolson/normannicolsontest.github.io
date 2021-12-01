# Grant Azure Active Directory Application access to Azure KeyVault using Azure Cli

Jul 2018

> Grant access to key vault secrets and or keys, managing application credentials in one place.

```
az keyvault set-policy --name
    [--certificate-permissions {create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, setissuers, update}]
    [--key-permissions {backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify, wrapKey}]
    [--object-id]
    [--resource-group]
    [--secret-permissions {backup, delete, get, list, purge, recover, restore, set}]
    [--spn]
    [--upn]
```