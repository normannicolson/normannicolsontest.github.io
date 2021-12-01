# Umbraco store Media on Azure Storage

Sep 2017

> Azure cloud friendly media folder how to store files and images in azure storage.

UmbracoFileSystemProviders.Azure

https://our.umbraco.org/projects/collaboration/umbracofilesystemprovidersazure

\config\FileSystemProviders.config

```
<?xml version="1.0"?>
<FileSystemProviders>
  <!-- Media -->
  <Provider alias="media" type="Our.Umbraco.FileSystemProviders.Azure.AzureBlobFileSystem, Our.Umbraco.FileSystemProviders.Azure">
  	<Parameters>
  		<add key="containerName" value="media"/>
  		<add key="rootUrl" value="http://[myAccountName].blob.core.windows.net/"/>
  		<add key="connectionString" value="DefaultEndpointsProtocol=https;AccountName=[myAccountName];AccountKey=[myAccountKey]"/>
  		<!--
        Optional configuration value determining the maximum number of days to cache items in the browser.
        Defaults to 365 days.
      -->
  		<add key="maxDays" value="365"/>
  		<!--
        When true this allows the VirtualPathProvider to use the deafult "media" route prefix regardless 
        of the container name.
      -->
  		<add key="useDefaultRoute" value="true"/>
  		<!--
        When true blob containers will be private instead of public what means that you can't access the original blob file directly from its blob url.
      -->
  		<add key="usePrivateContainer" value="false"/>
  	</Parameters>
  </Provider>
</FileSystemProviders>
```

FileSystemProviders.config can be reconfigured to allow settings in web.config

```
<?xml version="1.0"?>
<FileSystemProviders>
  <Provider alias="media" type="Our.Umbraco.FileSystemProviders.Azure.AzureBlobFileSystem, Our.Umbraco.FileSystemProviders.Azure">
    <Parameters>
      <add key="alias" value="media"/>
    </Parameters>
  </Provider>
</FileSystemProviders>
```

\Web.config

```
<appSettings>
  <add key="AzureBlobFileSystem.ConnectionString:media" value="DefaultEndpointsProtocol=https;AccountName={AccountName};AccountKey={AccountKey}"/>
  <add key="AzureBlobFileSystem.ContainerName:media" value="media"/>
  <add key="AzureBlobFileSystem.RootUrl:media" value="https://{AccountName}.blob.core.windows.net/"/>
  <add key="AzureBlobFileSystem.MaxDays:media" value="365"/>
  <add key="AzureBlobFileSystem.UseDefaultRoute:media" value="true"/>
</appSettings>
```