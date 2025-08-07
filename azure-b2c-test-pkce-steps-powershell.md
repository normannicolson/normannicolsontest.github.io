# Login journey PKCE using Powershell

Jul 2025

> Powershell step by step PKCE flow useful for isolating b2c journeys 

```Powershell 
$tenant="tenant"
$policy="B2C_1A_SIGNINSIGNUP"
$nonce="defaultNonce1234"
$clientId="1ab7f29a-6d82-4620-8479-d26475947778"
$apiScope="https%3A%2F%2F$tenant.onmicrosoft.com%2Fossapi%2FcommAdminAPI"
$redirectUri="https%3A%2F%2Fjwt.ms"
$codeChallenge="ThisIsntRandomButItNeedsToBe43CharactersLong"

$url="https://$tenant.b2clogin.com/$tenant.onmicrosoft.com/$policy/oauth2/v2.0/authorize?client_id=$clientId&response_type=code&response_mode=query&redirect_uri=$redirectUri&scope=offline_access%20$apiScope&code_challenge=$codeChallenge"

$url

[System.Diagnostics.Process]::Start("chrome.exe","--incognito $url")
```

Then Extract code from url

```
https://jwt.ms/?code=eyJraWQiOiJLRW....
```

```Powershell 
$code="eyJraWQiOiJLRW...."
```

Get Access token with Code 

```Powershell 
$tenant="tenant"
$policy="B2C_1A_SIGNINSIGNUP"
$nonce="defaultNonce1234"
$clientId="1ab7f29a-6d82-4620-8479-d26475947778"
$apiScope="https%3A%2F%2F$tenant.onmicrosoft.com%2Fossapi%2FcommAdminAPI"
$redirectUri="https%3A%2F%2Fjwt.ms"
$codeChallenge="ThisIsntRandomButItNeedsToBe43CharactersLong"

$resp=(curl.exe -X POST "https://$tenant.b2clogin.com/$tenant.onmicrosoft.com/$policy/oauth2/v2.0/token" -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=authorization_code" -d "client_id=$clientId" -d "scope=offline_access $apiScope" -d "code=$code" -d "redirect_uri=$redirectUri" -d "code_verifier=$codeChallenge") | ConvertFrom-Json

$resp.access_token
```