Conditions 

```

trigger:
- main

name: auth-centre-b2c-release

variables:
  one: initialValue 

stages:
- stage: runtime_expression
  jobs: 
  - job: runtime_expression
    variables:
      var: false
    steps:
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