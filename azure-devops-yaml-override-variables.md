Variables

```

trigger:
- main

name: auth-centre-b2c-release

variables:
  variable1: 'value1pipeline'
  variable1-pipeline: 'value1pipeline'

stages:
- stage: override_variables
  variables:
    variable1: 'value1stage'
    variable1-stage: 'value1stage'
  jobs:
  - job: variable-scope
    variables:
      variable1: 'value1job'
      variable1-job: 'value1job'
    pool:
      vmImage: 'windows-latest'
    steps:
    - script: |
        echo $(variable1)
        echo $(variable1-pipeline)
        echo $(variable1-stage)
        echo $(variable1-job)
      displayName: 'variable scope'
      
```
