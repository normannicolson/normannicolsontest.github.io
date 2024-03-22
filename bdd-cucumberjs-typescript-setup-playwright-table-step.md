# Cucumberjs typescript table step 

Mar 2024

> Cucumberjs typescript table step 

```
Scenario: Lists Centre Assets 
    When logged in as "<email>"
    And on "/centres/1009/assets" page
    Then table displays
        | Id | Name   |
        | 1  | Fridge |
        Examples:
        | email                                          | password     | 
        | example.asset.centre.dev.assets@mailinator.com | Password@123 |
```

```
import { Given, When, Then, DataTable } from '@cucumber/cucumber';
import { expect } from '@playwright/test';
import { ICustomWorld } from '../support/ICustomWorld';

Then('table displays', async function (this:ICustomWorld, table:DataTable) {

    const tableLocator = this.page!.locator(`table`);
    const rows = table.raw();

    for (let rowIndex = 0; rowIndex < rows.length; rowIndex++) {
        
        const cols = rows[rowIndex];
        const rowLocator = tableLocator.locator(`tr`).nth(rowIndex);

        for (let colIndex = 0; colIndex < cols.length; colIndex++) {

            const expected = cols[colIndex];
            const locator = (rowIndex == 0) 
                ? 'th' 
                : 'td';
            const colLocator = rowLocator.locator(locator).nth(colIndex);

            if (expected.length > 0)
            {
                const inputTextLocator = await colLocator.locator("input[type=text]");
                const inputNumberLocator = await colLocator.locator("input[type=number]");

                if (await inputTextLocator.count() == 1)
                {
                    await expect(inputTextLocator).toHaveValue(expected);
                }
                else if (await inputNumberLocator.count() == 1)
                {
                    await expect(inputNumberLocator).toHaveValue(expected);
                }
                else 
                {
                    await expect(colLocator).toContainText(expected);
                }
            }
            else
            {
                await expect(0).toEqual(expected.length);
            }
        };
    };

    await expect(tableLocator.locator(`tr`)).toHaveCount(rows.length)
});
```