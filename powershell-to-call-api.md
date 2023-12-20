# Powershell to call Apis and react to response

Aug 2023

> Script to call api.

Script to call api and loop each item in collection 

```
$apps = az rest --method GET --uri "https://graph.microsoft.com/v1.0/applications" --headers "Content-Type=application/json" | ConvertFrom-Json

foreach ($app in $apps.value) {
    
    Write-Host "app: $($app.displayName)"
}
```