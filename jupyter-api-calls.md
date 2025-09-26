# Jupyter Notebooks useful for manual api testing

Feb 2025

> Jupyter Notebooks useful for manual api testing

Sample of various notebooks requests useful for manual api testing

Get token 

```
import requests

def get_token():

    tenant_id=""
    client_id=""
    client_secret=""
    extension_prefix=""
    scope=""

    data = {
        "grant_type":"client_credentials",
        "client_id":f"{client_id}", 
        "client_secret":f"{client_secret}", 
        "scope":f"{scope}", 
    }

    headers = {
        "Content-Type": "application/x-www-form-urlencoded" 
    }

    url = f"https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token"

    response = requests.post(url, data=data, headers=headers)

    token = ""

    if(response.status_code == 200):
        token = response.json()["access_token"]
    
    return token

json=get_token()

print(json)
```

Post

```
import requests
import json

def v1_validate_user_credentials(name:str, password: str, correlation_id: str):

    url = "https://localhost:5001/api/temperatures"
    
    token = get_token()
       
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {token}"
    }
    
    data = {
        "name": name,
        "correlationId": correlation_id
    }

    response = requests.post(url, data=json.dumps(data), headers=headers, verify=False)

    print(url)
    print(response)

    data = response.json()
    
    print(json.dumps(data, indent=4))

post_api("15")
```

Get

```
def v1_get_accounts_by_account_number(account_number:str, correlation_id: str):

    url = "https://localhost:5001/api/temperatures"
    
    token = get_token()
       
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {token}"
    }

    response = requests.get(url, headers=headers, verify=False)

    print(url)
    print(response)

    data = response.json()
    
    print(json.dumps(data, indent=4))
```