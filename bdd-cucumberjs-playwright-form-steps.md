# Cucumberjs typescript form steps 

Sep 2025

> Cucumberjs typescript form steps 

```
import { Given, When, Then, DataTable } from '@cucumber/cucumber';
import { IContext } from '../support/IContext';
import { expect } from '@playwright/test';

When('{string} page click {string} button', async function (this:IContext, title:string, text:string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    const input = this.page!.getByRole('button', { name: text });

    await input!.click();
});

When('{string} page click {string} link', async function (this:IContext, title:string, text:string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    await this.page!.locator(`a >> text="${text}"`).click();
});

When('{string} page fill {string} with {string}', async function (this:IContext, title:string, label: string, text: string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    const input = this.page!.getByLabel(label, { exact : true });
    await input!.pressSequentially(text);
});

When('{string} page fill {string} placeholder with {string}', async function (this:IContext, title:string, label: string, text: string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    const input = this.page!.getByPlaceholder(label, { exact : true });
    await input!.pressSequentially(text);
});

When('{string} page select {string} with {string}', async function (this:IContext, title:string, label: string, text: string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    const input = this.page!.getByLabel(label, { exact : true });
    await input!.selectOption(text);
});

When('{string} page select {string} with {string} 2', async function (this:IContext, title:string, label: string, text: string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    const inputs = this.page!.getByLabel(label);
    await inputs!.first().selectOption(text);
});

Then('{string} title displayed', async function (this:IContext, title: string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);
});

Then('{string} error panel displayed', async function (this:IContext, text: string) {

    const panel = this.page!.getByRole("alert");
    await expect(panel).toHaveText(text);
});

Then('{string} text displayed', async function (this:IContext, text: string) {

    const panel = this.page!.getByText(text);
    await expect(panel).toBeTruthy();
});
```