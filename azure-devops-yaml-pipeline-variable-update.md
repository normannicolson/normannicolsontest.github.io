# Azure Dev Ops Yml Variable Update

Sep 2023

> Yaml Azure DevOps variable update

Variable update.

```
trigger:
- main

name: build

variables:
- name: one
  value: initialValue 

stages:
- stage: update_variables
  jobs:
  - job: update_variables
    steps:
    - script: |
        echo ${{ variables.one }} outputs initialValue as using template expression gets processed at compile time before runtime starts.
        echo $(one) outputs initialValue as has not been updated.
      displayName: First variable pass

    - bash: echo "##vso[task.setvariable variable=one]secondValue"
      displayName: Set new variable value

    - script: |
        echo ${{ variables.one }} outputs initialValue as using template expression gets processed at compile time before runtime starts.
        echo $(one) outputs secondValue as using macro gets processed during runtime before a task runs, variable updated from initialValue to secondValue in previous task.
      displayName: Second variable pass
```