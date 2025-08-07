# Jupyter Notebook source control api requests 

Jul 2025

> Jupyter Notebook source control and run code block like api requests etc

Create new Guid

```
import uuid
value = uuid.uuid4()

print(value)
```

Obtain client_credentials flow token

```
import requests

def get_token():

    tenantId=""
    clientId=""
    clientSecret=""
    scope=""

    data = {
        "grant_type":"client_credentials",
        "client_id":f"{clientId}", 
        "client_secret":f"{clientSecret}", 
        "scope":f"{scope}"
    }

    headers = {
        "Content-Type": "application/x-www-form-urlencoded" 
    }

    url = f"https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/token"

    response = requests.post(url, data=data, headers=headers)

    token = ""

    if(response.status_code == 200):
        token = response.json()["access_token"]
    
    return token

json=get_token()

print(json)
```