# Web.Config Transforms

Sep 2017

> Transform Web.Config to replace dev element values with replace tokens for continuous deployment

```
<?xml version="1.0"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <appSettings>  
    <add key="ida:Tenant" value="__ida_Tenant__"
      xdt:Transform="Replace" xdt:Locator="Match(key)" />
    <add key="ida:ClientId" value="__ida_ClientId__"
      xdt:Transform="Replace" xdt:Locator="Match(key)" />
    <add key="ida:AadInstance" value="__ida_AadInstance__"
      xdt:Transform="Replace" xdt:Locator="Match(key)" />
    <add key="ida:RedirectUri" value="__ida_RedirectUri__"
      xdt:Transform="Replace" xdt:Locator="Match(key)" />
    <add key="ida:SignInPolicyId" value="__ida_SignInPolicyId__"
      xdt:Transform="Replace" xdt:Locator="Match(key)" />
    <add key="ida:Scope" value="__ida_Scope__"
      xdt:Transform="Replace" xdt:Locator="Match(key)" />    
    <add key="UserProfile.Client.Endpoint" value="__UserProfile_Client_Endpoint__"
      xdt:Transform="Replace" xdt:Locator="Match(key)" />
  </appSettings>
  <system.web>
    <compilation xdt:Transform="RemoveAttributes(debug)" />
  </system.web>
</configuration>
```