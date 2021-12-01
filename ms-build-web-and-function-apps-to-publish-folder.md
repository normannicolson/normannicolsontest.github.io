# Ms Build Web & Function Apps to Publish Folder

Sep 2017

> Ms build script to build and deploy web and class library project to a specified output directory.

```
Param(
  [string]$artifactStagingDirectory
)

&'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\amd64\msbuild.exe' /t:build /p:Configuration=Release /p:DeployOnBuild=True /p:DeployDefaultTarget=WebPublish /p:WebPublishMethod=FileSystem /p:DeleteExistingFiles=True /p:publishUrl="$($artifactStagingDirectory)\Web" ..\src\Web\Web.csproj

&'C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\amd64\msbuild.exe' /t:build /p:Configuration=Release /p:OutDir="$($artifactStagingDirectory)\Function" ..\src\Function\Function.csproj
```