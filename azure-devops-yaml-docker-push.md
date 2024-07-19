# Azure DevOps Yaml Docker Build & Push to Azure Container Registry

Jul 2024

> Azure DevOps Yaml pipline Build and Push to Azure Docker Container Registry tasks

Give Azure DevOps connectivity to Azure Container Registry

## Add Service Connection 

Within Azure Dev Ops project navigate to service connections 

Click ```New service connection``` action 

From New Service Connection screen 

Select ```Docker Registry```

In New Docker Registry service connection window 

Check ```Azure Container Registry```

Authentication Type select ```Service Principal```

Enter name

```Save``` will create container registration 

## Locate service connection application container registration

Application registration name probally ```org-project-guid``` format

## Grant Application container registration permission 

From container registry Access control section grant Application container registration AcrPush Role assignment.

## Add Pipeline variables  

Create application secret 

Add Pipeline variables to hold

- ClientId
- ClientSecret
- TenantId

## Pipeline Task

Build image & Push image to container registry.

```
- script: |
    docker build --tag project:$(Build.BuildId) .
    docker tag project:$(Build.BuildId) nlist.azurecr.io/project:$(Build.BuildId)

    az login --service-principal -u $(ClientId) -p $(lientSecret) --tenant $(TenantId)
    az acr login --name nlist

    docker push nlist.azurecr.io/project:$(Build.BuildId)
  displayName: 'docker push'
  workingDirectory: '$(Build.SourcesDirectory)/src/project'
```
