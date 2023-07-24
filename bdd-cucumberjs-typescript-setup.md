# Cucumberjs typescript setup 

Feb 2022

> Cucumberjs typescript setup 

Create project

Oper terminal in folder and create project 

```
npm init 
```

Or create using own package.json 
```
{
  "name": "cucumberjs-typescript",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC"
}
```

Install packages as dev dependencies
```
npm install typescript --save-dev
npm install ts-node --save-dev
npm install @cucumber/cucumber --save-dev
```

Add tsconfig file 
```
npx tsc --init
```

All dependences now installed run cucumber-js

```
npx cucumber-js
```

Terminal output 
```
> npx cucumber-js


0 scenarios
0 steps
0m00.000s (executing steps: 0m00.000s)
┌──────────────────────────────────────────────────────────────────────────────┐
│ Share your Cucumber Report with your team at https://reports.cucumber.io     │
│                                                                              │
│ Command line option:    --publish                                            │
│ Environment variable:   CUCUMBER_PUBLISH_ENABLED=true                        │
│                                                                              │
│ More information at https://cucumber.io/docs/cucumber/environment-variables/ │
│                                                                              │
│ To disable this message, add this to your ./cucumber.js:                     │
│ module.exports = { default: '--publish-quiet' }                              │
└──────────────────────────────────────────────────────────────────────────────┘
> 
```

Create Cucumber script to alias npx script arguments cucumber-js --publish-quiet --require-module ts-node/register --require src/**/**/*.ts 

Add script to package.json file
```
  "scripts": {
    "test": "cucumber-js --publish-quiet --require-module ts-node/register --require src/**/**/*.ts"
  },

```

Run script 
```
npm test
```

Terminal output 
```
> npm test

> cucumberjs-typescript2@1.0.0 test
> cucumber-js --publish-quiet --require-module ts-node/register --require src/**/**/*.ts



0 scenarios
0 steps
0m00.000s (executing steps: 0m00.000s)
> 
```

Create scenario 

Create /features/hello-world.feature file 

```
mkdir features
cd features
touch hello-world.feature
```

```
Feature: Hello world

Scenario: Navigate to homepage     
	When navigate to homepage
```

Run tests again 
```
npm test
```

Terminal output 
```
> npm test

> cucumberjs-typescript2@1.0.0 test
> cucumber-js --publish-quiet --require-module ts-node/register --require src/**/**/*.ts

U

Failures:

1) Scenario: Navigate to homepage # features\hello-world.feature:3
   ? When navigate to homepage
       Undefined. Implement with the following snippet:

         When('navigate to homepage', function () {
           // Write code here that turns the phrase above into concrete actions       
           return 'pending';
         });


1 scenario (1 undefined)
1 step (1 undefined)
0m00.002s (executing steps: 0m00.000s)
```

Create /src/steps/navigate.ts to contain your navigation steps.

```
mkdir src/steps

cd  src/steps

touch navigate.ts
```

```
import { Given, When, Then, DataTable } from '@cucumber/cucumber';

When('navigate to homepage', function () {
    // Write code here that turns the phrase above into concrete actions
    return 'pending';
});
```

```
npm run test
```

Notice output in terminal has changed  
```
> cucumberjs-typescript@1.0.0 test
> cucumber-js --publish-quiet --require-module ts-node/register --require src/**/**/*.ts

P

Warnings:

1) Scenario: Navigate to homepage # features\hello-world.feature:3      
   ? When navigate to homepage # src\steps\navigate.ts:3
       Pending

1 scenario (1 pending)
1 step (1 pending)
0m00.005s (executing steps: 0m00.000s)
PS C:\Repositories\TFS\cucumberjs-typescript> 
```

Application ready to add hooks and browser support such as playwright.