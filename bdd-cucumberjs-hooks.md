# Cucumberjs typescript hooks

Sep 2025

> Cucumberjs typescript hooks

```
import dotenv from 'dotenv';
import { BeforeAll, Before, After, AfterAll, setWorldConstructor, setDefaultTimeout, AfterStep } from "@cucumber/cucumber";
import { chromium, ChromiumBrowser, FirefoxBrowser, WebKitBrowser } from '@playwright/test';
import { IConfig } from './IConfig';
import { IContext } from './IContext';
import { Config } from './Config';
import { Context } from './Context';
import fs from 'fs';
import { TokenClient } from "../clients/TokenClient";
import { GraphClient } from "../clients/GraphClient";
import { AccountsApi } from "../generated-client/api/accountsApi";
import { HttpBearerAuth } from "../generated-client/api";
import { ClientFactory } from '../clients/ClientFactory';
import { Logger } from './Logger';

let config: IConfig;
let clientFactory: ClientFactory;
let browser: ChromiumBrowser;// | FirefoxBrowser | WebKitBrowser;

dotenv.config();

setWorldConstructor(Context);
setDefaultTimeout(120000);

BeforeAll(async function () {

    config = new Config();

    clientFactory = new ClientFactory(config);

    browser = await chromium.launch({
        headless: config.headless!,
        timeout: config.timeout! 
    });
});

Before(async function (this:IContext, scenario:any) {

    this.scenario = scenario;

    this.config = config;

    this.clientFactory = clientFactory;

    this.browserContext = await browser.newContext({ 
        ignoreHTTPSErrors: config.ignoreHTTPSErrors!
    });

    this.page = await this.browserContext.newPage();

    this.logger = new Logger('./logs/test.log');

    this.logger.log(`Starting scenario: ${scenario.pickle.name}`);
});

AfterStep(async function () {
    
  await new Promise(resolve => setTimeout(resolve, 1000)); // 1 second delay after every step
});

After(async function (this:IContext) {

    await new Promise(resolve => setTimeout(resolve, 10000));// 10 second delay after every scenario

    await this.page?.close();
    await this.browserContext?.close();
});

AfterAll(async function () {

    await browser.close();
});
```