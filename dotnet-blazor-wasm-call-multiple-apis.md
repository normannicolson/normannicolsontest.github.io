# Dotnet Blazor Web Assembly Call multiple api secured by Azure B2c 

Oct 2023

> How to configure dotnet blazor web assembly to obtain tokens 

Blazor Web Assembly project using OpenId Connect PKCE Flow

Ui Project calls two Api both protected by Azure B2c SubjectApi & CentreApi

::: mermaid
classDiagram
    Ui ..> B2c
    Ui ..> SubjectApi
    Ui ..> CentreApi
:::

## Add Msal and ConfigurationExtensions Packages to UI Project 

```
Microsoft.Authentication.WebAssembly.Msal
Microsoft.Extensions.Options.ConfigurationExtensions
```

### appsettings.json

Separate options for protected scope and base address.

```
{
  "AzureAdB2C": {
    "Authority": "https://tenant.b2clogin.com/tenant.onmicrosoft.com/B2C_1A_SIGNIN",
    "ClientId": "00000000-0000-0000-0000-0000000000001",
    "ValidateAuthority": true,
    "Scopes": "openid profile offline_access"
  },
  "SubjectProtectedApiOptions": {
    "BaseAddress": "https://localhost:55302",
    "Scope": "https://tenant.onmicrosoft.com/00000000-0000-0000-0000-0000000000002/Subjects"
  },
  "CentreProtectedApiOptions": {
    "BaseAddress": "https://localhost:55303",
    "Scope": "https://tenant.onmicrosoft.com/00000000-0000-0000-0000-0000000000003/Centres"
  }
}
```

### Program.cs 

```
builder.Services
    .AddMsalAuthentication(options =>
        {
            builder.Configuration.Bind("AzureAdB2C", options.ProviderOptions.Authentication);
            options.ProviderOptions.LoginMode = "redirect";
        });

builder.Services
    .AddProtectedApiHttpClient<SubjectProtectedApiOptions>(builder.Configuration);

builder.Services
    .AddProtectedApiHttpClient<CentreProtectedApiOptions>(builder.Configuration);
```

### Strongly type poco options

ProtectedApiOptions.cs

```
public class ProtectedApiOptions
{
    public string BaseAddress { get; set; } = String.Empty;

    public string Scope { get; set; } = String.Empty;
}
```

SubjectProtectedApiOptions.cs

```
public class SubjectProtectedApiOptions : ProtectedApiOptions
{
}
```

CentreProtectedApiOptions.cs

```
public class CentreProtectedApiOptions : ProtectedApiOptions
{
}
```

Options registration and client AuthorizationMessageHandler registration within extension

ProtectedApiExtensions will configure and register AuthorizationMessageHandler for specified BaseAddress and scope

### ProtectedApiExtensions.cs 

```
public static class ProtectedApiExtensions
{
    public static IServiceCollection AddProtectedApiHttpClient<T>(
        this IServiceCollection services,
        IConfiguration configuration)
        where T : ProtectedApiOptions, new()
    {
        var options = new T();

        var configurationKey = options.GetType().Name;

        configuration.GetSection(configurationKey).Bind(options);

        services
            .Configure<T>(
                configuration.GetSection(configurationKey));

        services
            .AddTransient<ProtectedApiAuthorizationMessageHandler<T>>();

        services
            .AddHttpClient(
                options.BaseAddress,
                client => client.BaseAddress = new Uri(options.BaseAddress)
            )
            .AddHttpMessageHandler<ProtectedApiAuthorizationMessageHandler<T>>();

        return services;
    }
}
```

#### ProtectedApiAuthorizationMessageHandler.cs

AuthorizationMessageHandler acquires and caches tokens, Msal will automatically obtain and cache tokens.

```
public class ProtectedApiAuthorizationMessageHandler<T> : AuthorizationMessageHandler
    where T : ProtectedApiOptions
{
    public ProtectedApiAuthorizationMessageHandler(
        IAccessTokenProvider provider,
        NavigationManager navigation,
        IOptions<T> options)
        : base(provider, navigation)
    {
        ConfigureHandler(
            authorizedUrls: new[] {
                options.Value.BaseAddress
            },
            scopes: new[] { options.Value.Scope });
    }
}
```