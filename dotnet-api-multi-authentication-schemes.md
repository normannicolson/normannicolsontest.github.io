# Dotnet support two authentication schemes  

Jul 2025

> Dotnet support two authentication bearer schemes  

Protect api from two issuers 

```
builder.Services.AddAuthentication("AzureAdB2C1")
    .AddMicrosoftIdentityWebApi(
        jwtOptions =>
        {
            builder.Configuration.Bind("AzureAdB2C1", jwtOptions);
            jwtOptions.IncludeErrorDetails = false;
        },
        identityOptions => { 
            builder.Configuration.Bind("AzureAdB2C1", identityOptions); 
        },
        jwtBearerScheme: "AzureAdB2C1");

builder.Services.AddAuthentication()
    .AddMicrosoftIdentityWebApi(
        jwtOptions => { 
            builder.Configuration.Bind("AzureAdB2C2", jwtOptions); 
        },
        identityOptions => { 
            builder.Configuration.Bind("AzureAdB2C2", identityOptions); 
        },
        jwtBearerScheme: "AzureAdB2C2");
```

Usage 
```
builder.Services.AddAuthorization(options =>
{
    options.DefaultPolicy = new AuthorizationPolicyBuilder()
        .RequireAuthenticatedUser()
        .AddAuthenticationSchemes("AzureAdB2C1", "AzureAdB2C2")
        .Build();
});
```