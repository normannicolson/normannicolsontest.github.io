# Azure Dev Ops Yml Pipeline conditions

Sep 2023

> Yaml Azure DevOps pipleline conditions

Conditional build steps.

```
trigger:
- main

name: build

variables:
  one: initialValue 

stages:
- stage: runtime_expression
  jobs: 
  - job: runtime_expression
    variables:
      var: false
    steps:
      - ${{ if ne(variables['Build.Reason'], 'PullRequest') }}: 
        - script: echo Build.Reason = $(Build.Reason) 

      - ${{ if eq(variables['Build.Reason'], 'PullRequest') }}: 
        - script: echo Build.Reason is PR

      - script: echo $(var)
        displayName: var is false
        condition: and(succeeded(), eq(variables.var, false))
        
      - script: echo $(var)
        displayName: var

      - bash: echo "##vso[task.setvariable variable=var]true"
        displayName: set var to true

      - script: echo $(var)
        displayName: var

      - script: echo $(var)
        displayName: var is true
        condition: and(succeeded(), eq(variables.var, true))
```