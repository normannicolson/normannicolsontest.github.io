# Using DefaultAzureCredential For Managed Service Identity  

Jun 2024

> Use DefaultAzureCredential locally making use of RBAC assignments 

Create ```.runsettings``` file

Test framework will set EnvironmentVariables

```
<?xml version="1.0" encoding="utf-8"?>
<!-- File name extension must be .runsettings -->
<RunSettings>
  <RunConfiguration>
    <EnvironmentVariables>
      <!-- List of environment variables we want to set-->
      <AZURE_CLIENT_ID>********-****-****-****-************</AZURE_CLIENT_ID>
      <AZURE_CLIENT_SECRET>****************************************</AZURE_CLIENT_SECRET>
      <AZURE_TENANT_ID>********-****-****-****-************</AZURE_TENANT_ID>
    </EnvironmentVariables>
  </RunConfiguration>
</RunSettings>
```

```
<ItemGroup>
  <PackageReference Include="Azure.Identity" Version="1.11.3" />
  <PackageReference Include="Microsoft.Graph" Version="5.55.0" />
</ItemGroup>
``

```
this.credential = new DefaultAzureCredential();
```

```
var graphServiceClient = new GraphServiceClient(
    this.credential, scopes);
```