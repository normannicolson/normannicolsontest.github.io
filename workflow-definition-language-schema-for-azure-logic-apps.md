# Workflow Definition Language Schema for Azure Logic Apps

On 23 Feb 2018

Azure logic apps provide flexible serverless workflows. Connect with many systems like Twitter, Facebook, & Sendgrid.

For example trigger on a tweet. Connect with Http Endpoints, Azure Storage and Azure Functions to build rich workflows.

Azure logic apps provide easy to use and easy to lean syntax for defining workflows. Define Logic apps in JSON Workflow Definition Language schema for Azure Logic Apps.

This post aims to demonstrate the basic building blocks of Azure Logic Apps.

Find documentation at https://docs.microsoft.com/en-us/azure/logic-apps/

## Triggers

Run logic apps by invoking a tigger, triggers come in various forms from storage triggers to simplest http triggers. Even trigger on a tweet. We start by creating a logic app thats invoked by an http json request post and responds with an http created status cod

```
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "logicAppName": {
      "type": "string",
      "minLength": 1,
      "maxLength": 80,
      "metadata": {
        "description": "Name of the Logic App."
      }
    },
    "logicAppLocation": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "allowedValues": [
        "[resourceGroup().location]",
        "uksouth",
        "ukwest"
      ],
      "metadata": {
        "description": "Location of the Logic App."
      }
    }
  },
  "variables": {},
  "resources": [
    {
      "name": "[parameters('logicAppName')]",
      "type": "Microsoft.Logic/workflows",
      "location": "[parameters('logicAppLocation')]",
      "tags": {
        "displayName": "LogicApp"
      },
      "apiVersion": "2016-06-01",
      "properties": {
        "definition": {
          "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#",
          "contentVersion": "1.0.0.0",
          "actions": {
            "Response": {
              "type": "Response",
              "inputs": {
                "statusCode": 201
              },
              "runAfter": {}
            }
          },
          "outputs": {},
          "parameters": {},
          "triggers": {
            "manual": {
              "type": "Request",
              "kind": "Http",
              "inputs": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "name": {
                      "type": "string"
                    },
                    "email": {
                      "type": "string"
                    },
                    "phone": {
                      "type": "string"
                    },
                    "message": {
                      "type": "date"
                    },
                    "resource": {
                      "type": "object"
                    }
                  }
                }
              }
            }
          }
        },
        "parameters": {}
      }
    }
  ],
  "outputs": {}
}
```

Majority of the logic app is periphery definition, key elements are triggers and actions.

```
"actions": {
  "Response": {
    "type": "Response",
    "inputs": {
      "statusCode": 201
    },
    "runAfter": {}
  }
},
"outputs": {},
"parameters": {},
"triggers": {
  "manual": {
    "type": "Request",
    "kind": "Http",
    "inputs": {
      "schema": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "email": {
            "type": "string"
          },
          "phone": {
            "type": "string"
          },
          "message": {
            "type": "date"
          },
          "resource": {
            "type": "object"
          }
        }
      }
    }
  }
}
```

Invoke Logic app http trigger like any other http endpoint.

```
[TestMethod]
public async Task Given_valid_enquiry_When_logic_app_is_called_Then_created_returned()
{
    var client = new HttpClient();

    var triggerUrl = "Logic app url";

    var content = new StringContent(
        "{" +
        "\"name\":\"name\"," +
        "\"email\":\"name@example.com\"," +
        "\"phone\":\"1\"," +
        "\"message\":\"message\"," +
        "\"resource\":{\"name\":\"name\"}" +
        "}",
        Encoding.UTF8,
        "application/json");

    var response = await client.PostAsync(triggerUrl, content);

    Assert.AreEqual(System.Net.HttpStatusCode.Created, response.StatusCode);
}
```

For publishing checkout Azure Cli.

## Flow

A Logic App contains many logical steps, each step has an output and referenced by name.

```
@outputs('NameOfStep')
```

Steps can dependant on previous step success or fail

```
"runAfter": {
  "NameOfStep": [
    "Succeeded"
  ]
}
```

## Compose Object

To compose an object we can use the Compose definition.

With compose we can enrich the tigger data with static data. 

```
"AuditCompose": {
  "type": "Compose",
  "inputs": {
    "id": "@{guid()}",
    "action": "Name",
    "client": {
      "id": "Id",
      "name": "Name"
    },
    "actor": {
      "id": "",
      "name": "@outputs('Actor').Name",
      "organisation": "@outputs('Actor').Organisation"
    },
    "resource": "@triggerBody()",
    "created": "@{utcnow()}"
  },
  "runAfter": {
    "ActorCompose": [
      "Succeeded"
    ]
  }
},
```

## Call Http Endpoint
We use the Http definition to call Rest Apis.

```
"AuditHttp": {
  "type": "Http",
  "inputs": {
    "method": "POST",
    "uri": "[parameters('auditEndpoint')]",
    "headers": {
      "Authorization": "WRAP @{outputs('ActorCompose').Token}"
    }
    "body": "@outputs('AuditCompose')"
  },
  "runAfter": {
    "AuditCompose": [
      "Succeeded"
    ]
  }
},
```

## Call Http Trigger Azure Function

To call an Azure Function we use the Function definition or an Http definition.

```
"AuditHttp": {
  "type": "Function",
  "inputs": {
    "body": "@outputs('AuditCompose')",
    "method": "post",
    "functionApp": {
      "id": "[parameters('audit_function')]"
    },
    "uri": "[parameters('audit_function_uri')]"
  },
  "runAfter": {
    "AuditCompose": [
      "Succeeded"
    ]
  }
},
```

## Call Application Insights

No out of the box support for writing to application insights.

## Call Key Vault

Key vault access is configured under connections element.

## Loop

Loop by using ForEach definition.  

```
"NotificationApproversForeach": {
  "actions": {
    "NotificationForeachSendEmail": {
      "inputs": {
        "body": {
          "To": "@item()",
          "Subject": "Subject",
          "Message": "Message"
        },
        "function": {
          "id": "[parameters('send_email_function_name')]"
        },
        "headers": {
        }
      },
      "runAfter": {},
      "type": "Function"
    }
  },
  "foreach": "@body('NotificationGetApprovers')",
  "runAfter": {
    "NotificationGetApprovers": [
      "Succeeded"
    ]
  },
  "type": "Foreach"
},
```

## If

Add condition by using If definition.

```
"Condition": {
  "type": "If",
  "expression": "@equal(triggerBody()?['state'], 'rejected')",
  "actions": {
  },
  "runAfter": {}
}
```

## Switch

Add Switch condition by using Switch definition.

```
"Switch": {
  "type": "Switch",
  "expression": "@triggerBody()?['state']",
  "cases": {
    "SwitchRejected": {
      "case": "rejected",
      "actions": {
      }
    },
    "SwitchApproved": {
      "case": "approved",
      "actions": {
      }
    }
  },
  "default": {
    "actions": {}
  },
  "runAfter": {}
}
```