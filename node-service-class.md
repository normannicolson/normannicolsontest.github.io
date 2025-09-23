# Node MsGraph Client Service Class

Sep 2025

> NodeJs Service Class load data and ODATA Microsoft Graph query. 

Query Azure B2C users via Microsoft Graph API. 

```
import axios from 'axios';
import fs from 'fs';
import csv from 'csv-parser';
import { once } from 'events';

export class QueryService {

    constructor(logger, clients) {
        this.logger = logger;
        this.clients = clients;
    }

    async sleep(milliseconds) {
        return new Promise(resolve => setTimeout(resolve, milliseconds));
    }

    async readCSV() {
        const results = [];

        const stream = fs.createReadStream('data.csv')
            .pipe(csv())
            .on('data', (data) => results.push(data));
        
        await once(stream, 'end');

        return results;
    }

    async getuserByEmail(email) 
    {
        const graphToken = await this.clients.getGraphToken();

        const url =  `https://graph.microsoft.com/beta/nlist.onmicrosoft.com/users?$filter=(identities/any(i:i/issuer eq 'nlist.onmicrosoft.com' and i/issuerAssignedId eq '${email}'))`
            + '&$select=id,identities,createdDateTime,displayName,givenName,surname,signInActivity';

        const response = await axios.get(url, {
            headers: {
                'Authorization': `Bearer ${graphToken}`,
                'Content-Type': 'application/json'
            }
        });

        return response.data;
    }

    async processCSV() {
        const data = (await this.readCSV()); // For testing, limit to first 10 rows

        for (const row of data) {

            let email = row.Email;

            const apiResponse = await this.getuserByEmail(email);

            if (apiResponse.value.length > 0) 
            {
                const item = apiResponse.value[0];
                const emailAddress = item.identities[0].issuerAssignedId;
                const lastSignInDateTime = item.signInActivity?.lastSignInDateTime ?? "";

                this.logger.log(`"${email}","${emailAddress}","${lastSignInDateTime}"`);
            }   
            else
            {
                this.logger.log(`"${email}",not in B2c,`);
            }
        }
    }
}
```

Usage

```
import { Logger } from './clients/logger.js';
import { clients } from './clients/clients.js';
import { ReportService } from './report-service.js';

const clients = new clients();
const logger = new Logger();
const queryService = new QueryService(logger, clients);

console.log("\nRunning...");
await queryService.processCSV();
```