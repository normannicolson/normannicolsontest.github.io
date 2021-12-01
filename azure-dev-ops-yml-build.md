# Azure Dev Ops Yml Build

Oct 2018

> Source control azure dev ops build pipeline using yml.

```
name: 1.0.$(Year:yyyy)$(Month)$(DayOfMonth)$(Rev:.r)

resources:
- repo: self
queue:
  name: Hosted VS2017
variables:
  BuildConfiguration: 'Release'

steps:
- task: DotNetCoreCLI@2
  displayName: Restore
  inputs:
    command: restore
    projects: '**/*.csproj'
    vstsFeed: '{id}'
    includeNuGetOrg: false  

- task: DotNetCoreCLI@2
  displayName: Build
  inputs:
    projects: '**/*.csproj'
    arguments: '--configuration $(BuildConfiguration) --no-restore'

- task: DotNetCoreCLI@2
  displayName: Test
  inputs:
    command: test
    projects: '**/*.Test.csproj'
    arguments: '--configuration $(BuildConfiguration) --no-restore --no-build'

- task: DotNetCoreCLI@2
  displayName: Publish
  inputs:
    command: publish
    publishWebProjects: false
    projects: '**/*.csproj'
    arguments: '--configuration $(BuildConfiguration) --output $(build.artifactstagingdirectory) --no-restore --no-build'
    zipAfterPublish: True

- task: DotNetCoreCLI@2
  displayName: Pack
  inputs:
    command: pack
    packagesToPack: '{**/ProjectName.csproj}'
    nobuild: true
    versioningScheme: byBuildNumber

- task: DotNetCoreCLI@2
  displayName: 'Nuget Push'
  inputs:
    command: push
    publishVstsFeed: '{id}'

- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact'
  inputs:
    PathtoPublish: '$(build.artifactstagingdirectory)'
```