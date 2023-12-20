

# 
 dotnet new blazorwasm -au IndividualB2C --aad-b2c-instance "sqaauthb2cdev" --client-id " ac6d4172-4cf8-4d0c-a131-2c37053ead05" --domain " [nameofb2c].onmicrosoft.com" -o "Test2" -ssp "1A_SignIn"

https://learn.microsoft.com/en-us/aspnet/core/blazor/security/webassembly/standalone-with-azure-active-directory-b2c?view=aspnetcore-7.0


 # 
 dotnet new blazorwasm -o Test4 -au Individual



 dotnet new blazorwasm -au IndividualB2C --aad-b2c-instance "sqaauthb2cdev" --client-id " ac6d4172-4cf8-4d0c-a131-2c37053ead05" --domain " [nameofb2c].onmicrosoft.com" -o "Test2"









dotnet new blazorwasm -au IndividualB2C --aad-b2c-instance "https://[nameofb2c].b2clogin.com/" --client-id "6f0a9257-de88-45d6-98c5-50d3c33e96b5" --domain "[nameofb2c].onmicrosoft.com" -o StandaloneWithB2c -ssp "B2C_1A_SignIn"

dotnet new blazorwasm -au IndividualB2C --aad-b2c-instance "https://[nameofb2c].b2clogin.com/" --client-id "b8e55aff-582c-4645-b86a-13843b8b5819" --domain "[nameofb2c].onmicrosoft.com" -o StandaloneWithB2cScope -ssp "B2C_1A_SignIn"





B2c 

http POST http://localhost:60426/api/b2c/claims Content-Type:"application/json" ObjectId="6f3c6929-674f-4ef4-b921-f4ddec721fbe"

{
    "posts": "0",
    "centre": "0",
    "centresPortal": "0",
    "defaultPortalUrl": "https://localhost:44398/Account/Account/AccountHome",
    "firstName": "Norman",
    "lastName": "Posts Post Service Controller",
    "sqaInternalUser": false,
    "userType": "internal"





















# WASM Auth 

## Create new project 

## Add Authentication Package 
Add Microsoft.Authentication.WebAssembly.Msal 

## Add Authentication js file 
Add js file ref to index.html
<script src="_content/Microsoft.Authentication.WebAssembly.Msal/AuthenticationService.js"></script> 

## Add appsettings 
{
    "AzureAdB2C": {
        "Authority": "https://[nameofb2c].b2clogin.com/[nameofb2c].onmicrosoft.com/B2C_1A_SignIn",
        "ClientId": "b8e55aff-582c-4645-b86a-13843b8b5819",
        "ValidateAuthority": false
    }
}

## Switch launchSettings.json port so just works with B2c redirect 
```
"applicationUrl": "https://localhost:7082", 
```

## Add authentication Page 
```
@page "/authentication/{action}"
@using Microsoft.AspNetCore.Components.WebAssembly.Authentication
<RemoteAuthenticatorView Action="@Action" />

@code{
    [Parameter] public string? Action { get; set; }
}
```

## Add login display 
```
@using Microsoft.AspNetCore.Components.Authorization
@using Microsoft.AspNetCore.Components.WebAssembly.Authentication

@inject NavigationManager Navigation
@inject SignOutSessionStateManager SignOutManager

<AuthorizeView>
    <Authorized>
        Hello, @context.User.Identity?.Name!
        <button class="nav-link btn btn-link" @onclick="BeginLogout">Log out</button>
    </Authorized>
    <NotAuthorized>
        <a href="authentication/login">Log in</a>
    </NotAuthorized>
</AuthorizeView>

@code {
    private async Task BeginLogout(MouseEventArgs args)
    {
        await SignOutManager.SetSignOutState();
        Navigation.NavigateTo("authentication/logout");
    }
}
```

## Add to main layout 

<LoginDisplay />

## Add to program 
```
//add auth 
builder.Services.AddMsalAuthentication(options =>
{
    builder.Configuration.Bind("AzureAdB2C", options.ProviderOptions.Authentication);

    options.ProviderOptions.DefaultAccessTokenScopes.Add("openid");
    options.ProviderOptions.DefaultAccessTokenScopes.Add("profile");
    options.ProviderOptions.DefaultAccessTokenScopes.Add("offline_access");
    options.ProviderOptions.DefaultAccessTokenScopes.Add("https://[nameofb2c].onmicrosoft.com/postsapi/Post.Create");

    options.ProviderOptions.LoginMode = "redirect";
});
```

## Add cascading parameters to App.Razor 

Global import 

<CascadingAuthenticationState>
    <Router AppAssembly="@typeof(App).Assembly">
        <Found Context="routeData">
            <AuthorizeRouteView RouteData="@routeData" DefaultLayout="@typeof(MainLayout)">
                <NotAuthorized>
                        <p role="alert">You are not authorized to access this 
                </NotAuthorized>
            </AuthorizeRouteView>
            <FocusOnNavigate RouteData="@routeData" Selector="h1" />
        </Found>
        <NotFound>
            <PageTitle>Not found</PageTitle>
            <LayoutView Layout="@typeof(MainLayout)">
                <p role="alert">Sorry, there's nothing at this address.</p>
            </LayoutView>
        </NotFound>
    </Router>
</CascadingAuthenticationState>















https POST http://localhost:55301/blob/00000000-0000-0000-0000-000000000000/documents/NN%20Doc1.docx


https POST http://localhost:55301/blob/8ea96dc7-47e3-4d39-822b-08da8785284b/documents/NN%20Doc1.docx




dotnet new blazorwasm -au IndividualB2C --aad-b2c-instance "https://[nameofb2c].b2clogin.com" --api-client-id "SERVER API APP CLIENT ID" --app-id-uri "SERVER API APP ID URI" --client-id "d7a951b0-291d-4713-ab69-e4b9fe002e0d" --domain "[nameofb2c].onmicrosoft.com" -ho -o "Hosted" -ssp "B2C_1A_SIGNIN"


  "AzureAd": {
    "Instance": "https://[nameofb2c].b2clogin.com",
    "Domain": "[nameofb2c].onmicrosoft.com",
    "TenantId": "a30f8ff7-f325-4884-9ef6-5782dfd2e243",
    "ClientId": "d7a951b0-291d-4713-ab69-e4b9fe002e0d",
    "SignUpSignInPolicyId": "B2C_1A_SIGNIN",
    "ValidateAuthority": false,
    "Authority": "https://[nameofb2c].b2clogin.com/[nameofb2c].onmicrosoft.com/B2C_1A_SignIn"
  },

















https -A bearer -a eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjZCcXNqT2lhUnFvdVBDeDRRMk93ODZrWlRPQjRYdV9YVW52MTA5WmtNX1UifQ.eyJleHAiOjE2Njk4OTg1NDIsIm5iZiI6MTY2OTg5NDk0MiwidmVyIjoiMS4wIiwiaXNzIjoiaHR0cHM6Ly9zcWFhdXRoYjJjZGV2LmIyY2xvZ2luLmNvbS9hMzBmOGZmNy1mMzI1LTQ4ODQtOWVmNi01NzgyZGZkMmUyNDMvdjIuMC8iLCJzdWIiOiI2ZjNjNjkyOS02NzRmLTRlZjQtYjkyMS1mNGRkZWM3MjFmYmUiLCJhdWQiOiJiOGU1NWFmZi01ODJjLTQ2NDUtYjg2YS0xMzg0M2I4YjU4MTkiLCJhY3IiOiJiMmNfMWFfc2lnbmluIiwibm9uY2UiOiI0NjU0YTUyNi1hOWE3LTRkZDgtYjYzNy05ZDQ5MzdmZTU4NGQiLCJpYXQiOjE2Njk4OTQ5NDIsImF1dGhfdGltZSI6MTY2OTg5NDkzOSwidW5pcXVlX25hbWUiOiJub3JtYW4ubmljb2xzb24udGVzdEBtYWlsaW5hdG9yLmNvbSIsIm5hbWUiOiJOb3JtYW4gTGFzdE5hbWUiLCJBdXRoVXNlcklkIjo1NDEsIkNlbnRyZSBVc2VyIFR5cGUiOiIwIiwiQ2VudHJlcyBQb3J0YWwiOiIwIiwiVXNlciBUeXBlIjoiaW50ZXJuYWwiLCJTcWEgSW50ZXJuYWwgVXNlciI6ZmFsc2UsIkZpcnN0IE5hbWUiOiJOb3JtYW4iLCJMYXN0IE5hbWUiOiJBcHBlYWxzIFNxYSBBcHBlYWxzIFNlcnZpY2UgQ29udHJvbGxlciIsIkRlZmF1bHQgUG9ydGFsIFVybCI6Imh0dHBzOi8vZGV2LmNvbm5lY3Quc3FhLm9yZy51ayIsIkFwcGVhbHMgU1FBIjoiMCIsInRpZCI6ImEzMGY4ZmY3LWYzMjUtNDg4NC05ZWY2LTU3ODJkZmQyZTI0MyIsImF0X2hhc2giOiJNRllkU0lrSzFGQU1sUWVpXzJsOFFBIn0.oLaESg09N8HBFluk2zrXqugUSQPKMNNwdygEJmpkhbhZmQi1Oni6GFzsZskfQzQWrahOSOf_aW_mG7QfU3V7dF3nSSSlcfvuEa1lpBpBJtD1R9-iNlcex7ogj824ejYuA3t20j0gQSRn9uyFMJVh4tSbXPFUsm-_U6yNcJSPdYDXpdrvG97S-BxX2GB8qmmNqrOLbjOjKR205YLT8KQElmMGceZjBlKgtTDDrunj84GrX0ivC_Trec_ZerhPuh29JDFWnXFzUrFJ0qk6m9LQ6P2u5fyM5KIiMhT5fE0c5AS-iZYUpcv00lNr-Ers7T5i5E_mK4uUkjCso_gRiTwwuA http://localhost:55301/centers/1010/reports/

