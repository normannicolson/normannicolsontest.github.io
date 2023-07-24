# Cucumberjs typescript setup 

Feb 2022

> Cucumberjs typescript Playwright setup 

Cucumberjs and typescript installed 

## Add playwright 

Add playwright and install packages 

```
npm install @playwright/test --save-dev

npx playwright install
```

Create context to contain isolated scope for each scenario to hold browser and scenario context (world in cucumber)

```
cd ..\..

mkdir src/support

touch ICustomWorld.ts
touch CustomWorld.ts
```

ICustomWorld.ts interface 
```
import { IWorldOptions, World } from "@cucumber/cucumber";
import { BrowserContext, Page } from "@playwright/test";

export interface ICustomWorld 
    extends World {
        
    page?: Page;
    context?: BrowserContext;
}
```

CustomWorld.ts
```
import { IWorldOptions, World } from "@cucumber/cucumber";
import { BrowserContext, Page } from "@playwright/test";
import { ICustomWorld } from './ICustomWorld';

export class CustomWorld 
    extends World 
    implements ICustomWorld {

    constructor(options: IWorldOptions) {
        super(options);
    }

    public page?: Page;
    public context?: BrowserContext;
}
```

Test context classes created to hold data shared between steps.

Create classes to contain cucumber hooks: on before all, before, after and after all.

Launch new browser on before all hook 

```
touch hooks.ts
```

hooks.ts
```
import { Before, After, BeforeAll, AfterAll, setWorldConstructor, setDefaultTimeout} from "@cucumber/cucumber";
import { chromium, ChromiumBrowser, FirefoxBrowser, WebKitBrowser } from '@playwright/test';
import { ICustomWorld } from './ICustomWorld';
import { CustomWorld } from './CustomWorld';
//import { Config } from './Config';
import fs from 'fs';

let browser: ChromiumBrowser;// | FirefoxBrowser | WebKitBrowser;

setWorldConstructor(CustomWorld);
//setDefaultTimeout(1240 * 1000);
setDefaultTimeout(240 * 1000);

BeforeAll(async function () {

    browser = await chromium.launch({
        headless: false,
        timeout: 60000 
    });

    //config = JSON.parse(fs.readFileSync('config.json', 'utf8')); 
});

Before(async function (this:ICustomWorld, scenario:any) {

    //this.scenario = scenario;

    let context = await browser.newContext({ 
        ignoreHTTPSErrors: true 
    });
    
    //this.config = config;

    this.page = await context.newPage();
    this.context = context;
});

After(async function (this:ICustomWorld) {

    await this.page?.close();
    await this.context?.close();
});

AfterAll(async function (this:ICustomWorld) {

    await browser.close();
});
```

```
npm test
```

```
> showcase@1.0.0 test
> cucumber-js --publish-quiet --require-module ts-node/register --require src/**/**/*.ts    

.P.

Warnings:

1) Scenario: Navigate to homepage # features\hello-world.feature:3
   √ Before # src\support\hooks.ts:29
   ? When navigate to homepage # src\navigate.ts:3
       Pending
   √ After # src\support\hooks.ts:40

1 scenario (1 pending)
1 step (1 pending)
0m05.852s (executing steps: 0m02.905s)
```

Implement step 
```
import { Given, When, Then, DataTable } from '@cucumber/cucumber';
import { ICustomWorld } from '../support/ICustomWorld';

When('navigate to homepage', async function(this:ICustomWorld) {
    await this.page?.goto("https://www.google.co.uk");
});
```

Browser launched 

```
> showcase@1.0.0 test
> cucumber-js --publish-quiet --require-module ts-node/register --require src/**/**/*.ts    

...

1 scenario (1 passed)
1 step (1 passed)
0m01.829s (executing steps: 0m01.005s)
```