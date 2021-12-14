# Create Web Proxy Using Yarp

Oct 2021

> Using Yarp to Reverse Proxy

```
install package Yarp.ReverseProxy
```

Program.cs
```
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"));

var app = builder.Build();

app.MapReverseProxy();

app.Run();
```

appsettings.json

```
{
  "Urls": "http://localhost:5000;https://localhost:5001",
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Information"
    }
  },
  "AllowedHosts": "*",
  "ReverseProxy": {
    "Routes": {
      "Route1": {
        "ClusterId": "ClusterName1",
        "Match": {
          "Path": "api/users/{**remainder}"
        }
      }
    },
    "Clusters": {
      "ClusterName1": {
        "Destinations": {
          "Name": {
            "Address": "https://users.example.com"
          }
        }
      }
    }
  }
}
```