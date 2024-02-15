# Azure Dev Ops Yml Build steps for B2c Templates

Feb 2024

> Yaml Azure DevOps B2c Template Manual Validation step

Step to manual continue pipeline, automatically fails on timeout.

deploy-approval.yml

```
parameters:
  environment: 'dev'
  timeoutInMinutes: 1440

jobs:
- job: ${{ parameters.environment }}_manual_approval
  condition: succeeded()
  pool: server
  steps:
  - task: ManualValidation@0  
    inputs:    
      instructions: 'Manually approve that release is ready for next stage'
      notifyUsers: ''
      timeoutInMinutes: ${{ parameters.timeoutInMinutes }}
```

Use template from pipelines

```
  - stage: test6_pre_deployment_approval 
    dependsOn: dev
    condition: succeeded()
    jobs:

      - template: /pipelines/deploy-approval.yml
        parameters:
          environment: qa
```