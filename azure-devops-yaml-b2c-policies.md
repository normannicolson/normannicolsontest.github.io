# Azure Dev Ops Yml Build steps for B2c Policies

Oct 2018

> Yaml Azure DevOps B2c Policy build pipleline

Build B2c Policies into build artefacts.

```
- task: CopyFiles@2
  displayName: "Copy Policies"
  inputs:
    SourceFolder: 'src/policies'
    Contents: '**'
    TargetFolder: 'publish_output/policies'

- task: PublishBuildArtifacts@1
  displayName: "Publish Artifact"
  inputs:
    PathtoPublish: 'publish_output'
    ArtifactName: 'drop'
    publishLocation: 'Container'
```