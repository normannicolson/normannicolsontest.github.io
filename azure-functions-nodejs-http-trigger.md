# Azure Node Http Trigger Function

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
func init PythonFunctionApp --node
cd NodeFunctionApp
func new --name Invite --template "HTTP trigger" --authlevel anonymous
```

Create class to hold data 

```
export class Invite {
    constructor(
        inviteId = '', 
        email = '') {

        this.inviteId = inviteId;
        this.email = email;
    }
}
```

Function 

```
import { app } from '@azure/functions';
import { Invite } from '../models/invite.js';

app.http('Invite', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);

        try {
            
            const requestBody = await request.json();
            
            const invite = new Invite(
                requestBody.inviteId || '',
                requestBody.email || ''
            );

            const message = `InviteId: ${invite.inviteId}, Email: ${invite.email}`;
                
            context.log(message);
            
            return {
                status: 200,
                jsonBody: { message: message }
            };
        } 
        catch (error) {
            context.log.error('Error processing invite:', error);

            return {
                status: 500,
                jsonBody: { error: 'Internal server error' }
            };
        }
    }
});
```

```
func start 
```

```
curl -i -X POST "http://localhost:7071/api/invite" -H "accept: */*" -H "Content-Type: application/json" --data '{ "inviteId":"123" }'
```

























| Type     | Convention     | Example                       | 
| --       | --             | --                            |
| Class    | PascalCase     | UserManager, PaymentProcessor | 
| Function | lowerCamelCase | sendEmail(), calculateTotal() |
| Variable | lowerCamelCase | userName, totalAmount         |