# Azure .Net Http Trigger Function

Jul 2025

> Code sample creating an azure function app with http trigger 

Using VSCode ensure "Azure Tools" installed 

install "Azure Tools" extension ms-vscode.vscode-node-azure-pack

Navigate to your desired directory and create a new function app

```
dotnet new func --name NetFunctionApp
cd NetFunctionApp
func new `--name Invite --template "HTTP trigger" --authlevel "anonymous"
```

Create class to hold data 

```
namespace NetFunctionApp.Models;

public class Invite
{
    public string InviteId { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;
}
```

Function 

```
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace NetFunctionApp;

public class InviteFunction
{
    private readonly ILogger<InviteFunction> _logger;

    public InviteFunction(ILogger<InviteFunction> logger)
    {
        _logger = logger;
    }

    [Function("Invite")]
    public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequest req)
    {
        var invite = await JsonSerializer.DeserializeAsync<NetFunctionApp.Models.Invite>(req.Body);

        var message = $"InviteId: {invite.InviteId}, Email: {invite.Email}";

        _logger.LogInformation(message);

        return new OkObjectResult(message);
    }
}
```

```
func start 
```

```
curl -i -X POST "http://localhost:7071/api/invite" -H "accept: */*" -H "Content-Type: application/json" --data '{ "inviteId":"123" }'
```