# Request Access Token using Httpie

Oct 2021 

> Request Access Token using Httpie

Httpie (https://httpie.io/cli) is a JSON first command-line HTTP and API client, intuitive and easy to use over CURL.

Use client_credentials flow for machine to machine applications.

Example request for access_token

```
http --form POST https://login.microsoftonline.com/{tennant id}/oauth2/v2.0/token grant_type="client_credentials" client_id="{client id}" client_secret="{client secret}" scope="https://graph.microsoft.com/.default"
```

Mix with Jq (https://stedolan.github.io/jq) to parse and extract responses for example extract access token from response

```
http --form POST https://login.microsoftonline.com/{tennant id}/oauth2/v2.0/token grant_type="client_credentials" client_id="{client id}" client_secret="{client secret}" scope="https://graph.microsoft.com/.default" | jq -r ".access_token"
```




