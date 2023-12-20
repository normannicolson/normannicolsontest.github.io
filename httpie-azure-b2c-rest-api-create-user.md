# Request Access Token using Httpie

Oct 2021 

> Request Access Token using Httpie

Httpie (https://httpie.io/cli) is a JSON first command-line HTTP and API client, intuitive and easy to use over CURL, add ability to source control scripts over gui applications for maintainability and learnability.

## Prerequisites 

Web and api Applications registered

### Create Web Application Registration

In Azure b2c create Web application registration for implicit flow.

To create an web application registration navigate to directory, "App Registrations" page and click "New Registration"

"Register an application" screen displayed

1. "Name":

    Enter a useful display name for "Name" this is what users will see when signing in.

1. For "Supported account types":

    Check "Accounts in any identity provider or organizational directory (for authenticating users with user flows)"

1. "Redirect URI (recommended)":

    Add "Web" Platform Configuration with application redirect url https://jwt.ms

1. Enable Implicit grant and hybrid flows

    * Access tokens (used for implicit flows) check
    * ID tokens (used for implicit and hybrid flows) check
    
Click "Register" to create application registration

### Create Api Application Registration

To create an api application registration navigate to directory, "App Registrations" page and click "New Registration"

"Register an application" screen displayed

1. "Name":

    Enter a useful display name for "Name" this is what users will see when signing in.

1. For "Supported account types":

    Check "Accounts in any identity provider or organizational directory (for authenticating users with user flows)"

1. "Redirect URI (recommended)":

    Don't select a platform as creating api application registration we dont want the abiliry to sign into api.

1. "Permissions":

    Remove check Grant admin consent to openid and offline_access permissions

Click "Register" to create application registration

Once Application Created 




https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications?tabs=app-reg-ga 


After creating application 

congi

API permissions section 

Click Add a permiss


* Access tokens (used for implicit flows) checked 
* ID tokens (used for implicit and hybrid flows) checked 

API permissions section:




Exchange id token for access token 

id_token=######







Get access token using Httpie

```
http --form POST https://login.microsoftonline.com/{tennant id}/oauth2/v2.0/token grant_type="client_credentials" client_id="{client id}" client_secret="{client secret}" scope="https://graph.microsoft.com/.default" | jq -r ".access_token"
```

Graph api call to create user using raw JSON approach

```
echo -n "{\"displayName\":\"Display Name\",\"identities\":[{\"signInType\":\"emailAddress\",\"issuer\":\"tenant.onmicrosoft.com\",\"issuerAssignedId\":\"name@example.app\"}],\"passwordProfile\":{\"password\":\"Password\",\"forceChangePasswordNextSignIn\":false}}" | http POST https://graph.microsoft.com/beta/users Authorization:"Bearer {token}" Content-Type:"application/json"
```

Script Together

```
read token <<< $(http --form POST https://login.microsoftonline.com/{tennant id}/oauth2/v2.0/token grant_type="client_credentials" client_id="{client id}" client_secret="{client secret}" scope="https://graph.microsoft.com/.default" | jq -r ".access_token")

echo -n "{\"displayName\":\"Display Name\",\"identities\":[{\"signInType\":\"emailAddress\",\"issuer\":\"tenant.onmicrosoft.com\",\"issuerAssignedId\":\"name@example.com\"}],\"passwordProfile\":{\"password\":\"Password\",\"forceChangePasswordNextSignIn\":false}}" | http POST https://graph.microsoft.com/beta/users Authorization:"Bearer $token" Content-Type:"application/json"
```