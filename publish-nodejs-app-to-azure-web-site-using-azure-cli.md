# Publish NodeJs app to Azure Web Site using Azure Cli

Jan 2018

> Walkthough publishing nodejs, webpack or angular app to azure web site.

Microsoft (as expected) have a relay good walk though on publishing Node or static site to Azure using Azure Cli 

More info at: https://docs.microsoft.com/en-us/azure/app-service/app-service-web-get-started-nodejs 

I've used Azure Cli to publish https://github.com/thoughtworks/build-your-own-radar here is how:

Compile to output dist folder.

```
npm run build
```

Zip dist folder, 

```
cd /path

zip -r -X name.zip path/dist
```

Publish to azure using azure cli.

```
az webapp deployment source config-zip -g {resource group name} -n {web app name} --src /path/path/name.zip
```