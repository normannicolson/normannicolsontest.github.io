# Request Access Token using Httpie

Oct 2021 

> Request Access Token using Httpie

Httpie (https://httpie.io/cli) is a JSON first command-line HTTP and API client, intuitive and easy to use over CURL, source control scripts over gui applications.

Get access token using Httpie

```
http --form POST https://login.microsoftonline.com/{tennant id}/oauth2/v2.0/token grant_type="client_credentials" client_id="{client id}" client_secret="{client secret}" scope="https://graph.microsoft.com/.default" | jq -r ".access_token"
```

Graph api call to create user using raw JSON approach

```
echo -n "{\"displayName\":\"Display Name\",\"identities\":[{\"signInType\":\"emailAddress\",\"issuer\":\"tenant.onmicrosoft.com\",\"issuerAssignedId\":\"name@example.app\"}],\"passwordProfile\":{\"password\":\"Password\",\"forceChangePasswordNextSignIn\":false}}" | http POST https://graph.microsoft.com/beta/users Authorization:"Bearer {token}" Content-Type:"application/json"
```

Script together

```
read token <<< $(http --form POST https://login.microsoftonline.com/{tennant id}/oauth2/v2.0/token grant_type="client_credentials" client_id="{client id}" client_secret="{client secret}" scope="https://graph.microsoft.com/.default" | jq -r ".access_token")

echo -n "{\"displayName\":\"Display Name\",\"identities\":[{\"signInType\":\"emailAddress\",\"issuer\":\"tenant.onmicrosoft.com\",\"issuerAssignedId\":\"name@example.com\"}],\"passwordProfile\":{\"password\":\"Password\",\"forceChangePasswordNextSignIn\":false}}" | http POST https://graph.microsoft.com/beta/users Authorization:"Bearer $token" Content-Type:"application/json"
```