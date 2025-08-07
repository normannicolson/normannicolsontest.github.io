# Azure Python Http Trigger Function

Jul 2025

> Code sample creating an azure function app with http trigger 

Using VSCode ensure "Azure Tools" installed 

install "Azure Tools" extension ms-vscode.vscode-node-azure-pack

Navigate to your desired directory and create a new function app

Install tools globally 

```
npm install -g azure-functions-core-tools@4
```

```
func init PythonFunctionApp --python
cd PythonFunctionApp
func new --name Invite --template "HTTP trigger" --authlevel anonymous
```

Create class to hold data 

```
from dataclasses import dataclass

@dataclass
class Invite:
    invite_id: str
    email: str
```

Function 

```
import azure.functions as func
import datetime
import json
import logging
import models.invite

app = func.FunctionApp()

@app.function_name("Invite")
@app.route(route="invite", auth_level=func.AuthLevel.ANONYMOUS, methods=["POST"])
def invite_function(req: func.HttpRequest) -> func.HttpResponse:

    try:
        req_body = req.get_json()
        
        invite = models.invite.Invite(
            # Deserialize JSON data to Invite model
            invite_id=req_body.get('inviteId', ''),
            email=req_body.get('email', '')
        )
                
        message = f"InviteId: {invite.invite_id}, Email: {invite.email}"
        
        logging.info(message)
        
        return func.HttpResponse(
            json.dumps({"message": message}),
            status_code=200,
            mimetype="application/json"
        )
        
    except ValueError as e:
        logging.error(f"Validation error: {str(e)}")
        return func.HttpResponse(
            json.dumps({"error": str(e)}),
            status_code=400,
            mimetype="application/json"
        )
    except Exception as e:
        logging.error(f"Error processing invite: {str(e)}")
        return func.HttpResponse(
            json.dumps({"error": "Internal server error"}),
            status_code=500,
            mimetype="application/json"
        )
```

```
func start 
```

```
curl -i -X POST "http://localhost:7071/api/invite" -H "accept: */*" -H "Content-Type: application/json" --data '{ "inviteId":"123" }'
```

| Type     | Convention | Example                         | 
| --       | --         | --                              |
| Class    | PascalCase | UserManager, PaymentProcessor   | 
| Function | snake_case | send_email(), calculate_total() |
| Variable | snake_case | user_name, total_amount         |