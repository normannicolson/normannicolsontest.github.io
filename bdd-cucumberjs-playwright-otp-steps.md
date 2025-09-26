# Cucumberjs typescript otp steps 

Sep 2025

> Cucumberjs typescript otp steps 

```
import { Given, When, Then, DataTable } from '@cucumber/cucumber';
import { IContext } from '../support/IContext';
import { OtpClient } from '../clients/OtpClient';
import { SmsClient } from '../clients/SmsClient';
import { expect } from '@playwright/test';

When('{string} page fill {string} and enter with {string} email otp', async function (this: IContext, title:string, label: string, email: string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    var otpClient = new OtpClient(this.logger!);

    var milliseconds = 10000;

    for (let i = 0; i < 3; i++) {

        await new Promise(resolve => setTimeout(resolve, milliseconds));

        try {
            var text = await otpClient.GetOtp(email);

            const regex = /\b\d{6}\b/;
            const match = text.match(regex);
            
            if (match)
            {
                var otp = match ? match[0] : '';
                const input = this.page!.getByLabel(label, { exact : true });
                await input!.clear();
                await input!.pressSequentially(otp);
                await input!.press('Enter');

                await new Promise(resolve => setTimeout(resolve, 2000));
                var errors = await CheckForErrors(this);

                if (errors == 0) 
                {
                    // no error 
                    this.logger!.log('Email Code okay');
                    break;
                }
                else
                {
                    // break
                    this.logger!.log('Email Code error');
                }
            }
        } 
        catch (error) {
            this.logger!.log('Loop error');
        }
    }
});

When('{string} page fill {string} and enter with {string} sms otp', async function (this: IContext, title:string, label: string, phoneNumber: string) {

    await expect(this.page!.locator(`h1:has-text('${title}')`)).toHaveText(title);

    var otpClient = new SmsClient(this.logger!);

    var milliseconds = 10000;

    for (let i = 0; i < 3; i++) {

        await new Promise(resolve => setTimeout(resolve, milliseconds));

        try {
            var text = await otpClient.GetOtp(phoneNumber);

            const regex = /\b\d{6}\b/;
            const match = text.match(regex);
            
            if (match)
            {
                var otp = match 
                    ? match[0] 
                    : '';

                this.logger!.log(otp);

                const input = this.page!.getByLabel(label, { exact : true });
                await input!.pressSequentially(otp);
                await input!.press('Enter');

                await new Promise(resolve => setTimeout(resolve, 2000));
                var errors = await CheckForErrors(this);

                if (errors == 0) 
                {
                    // no error 
                    this.logger!.log('Sms Code okay');
                    break;
                }
                else
                {
                    // break
                    this.logger!.log('Sms Code error');
                }
            }

        } 
        catch (error) {
            this.logger!.log('Loop error');
        }
    }
});

async function CheckForErrors(context: IContext): Promise<number>
{
    context.logger!.log("Checking for errors");

    let errors = 0;

    try {
        const visibleAlerts = context.page!.getByRole("alert").filter({ has: context.page!.locator(':visible') });
        
        errors = await visibleAlerts.count();
    } 
    catch (error) 
    {
        errors = 0;
    }

    context.logger!.log(`Error count ${errors}`);

    return errors;
}
```