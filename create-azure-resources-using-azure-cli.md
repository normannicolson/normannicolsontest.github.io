# Create Azure Resources using Azure Cli

Jan 2018

> Azure cli is useful tool for provisioning, modifying and publishing azure resources via a command line across various os.

Azure cli provides an easy to use script for creating azure resources. 

Use login command to login and setup session, login command will output a url and code into terminal, then manually navigate to url and enter code and login.

```
az login
```

List subscriptions.

```
az account list
```

Set session subscription.

```
az account set --subscription "{Name}"
```

Just add standard -h arg for help.

```
az account -h
```

Create resource group in selected subscription.

```
az group create --name {Name} --location "Uk South"
```

Create service plan.

```
az appservice plan create --name {Name} --resource-group {Name} --sku FREE
```

Create web app.

```
az webapp create --resource-group {name} --plan {name} --name {name} --runtime "aspnet|v4.7"
```

Now a site has been created on azure.