# NodeJs ODATA Microsoft Graph Client

Sep 2025

> NodeJs ODATA Microsoft Graph query. 

Query Azure B2C users via Microsoft Graph API. 

```
import axios from 'axios';
import { clients } from './clients/clients.js';

export class QueryService {

    constructor(logger, clients) {
        this.logger = logger;
        this.clients = clients;
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

const data = await queryService.getUserByEmail("norman@example.com");

console.log(data);
```