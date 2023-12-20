# Patch User using Graph Api 

Jul 2023

Login and select tenant as working tenant (isDefault true). 

Replace nameofb2c with name of your directory.

```
az login --tenant [nameofb2c].onmicrosoft.com --allow-no-subscriptions
```

## Get User
```
$userId = ""

az rest --method GET --uri "https://graph.microsoft.com/beta/users/$userId" --headers "Content-Type=application/json"
```

## Set Extension property 

```
$webBody = @"
{
    "extension_00000000000000000000000000000000_requiresMigration": true
}
"@
$webBody = $webBody -replace "\n", ""

az rest --method PATCH --uri "https://graph.microsoft.com/beta/users/$userId" --headers "Content-Type=application/json" --body "$webBody"
```