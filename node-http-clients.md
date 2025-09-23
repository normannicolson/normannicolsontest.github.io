# Log Analytics AuditLog useful queries

Jun 2025

> NodeJs http client 

Using axios to ccreate custom rest api requests

```
import axios from 'axios';
import dotenv from 'dotenv';
import qs from 'qs';

export class clients {

    constructor() {
        dotenv.config();
    }

    graphToken = "";
    apiToken = "";
    graphTokenStartTime = new Date(0);
    apiTokenStartTime = new Date(0);

    checkTimeExceeded(startTime) {
        const currentTime = new Date();
        const elapsedMinutes = (currentTime - startTime) / (1000 * 60);
        
        if (elapsedMinutes > 45) {
            return true;
        } 
        else {
            return false;
        }
    }

    async getGraphToken() {
  
        if (this.graphToken == "" || this.checkTimeExceeded(this.graphTokenStartTime))
        {
            const graphTokenData = {
                grant_type: 'client_credentials',
                client_id: process.env.GRAPH_CLIENT_SETTINGS__CLIENT_ID,
                client_secret: process.env.GRAPH_CLIENT_SETTINGS__CLIENT_SECRET,
                scope: process.env.GRAPH_CLIENT_SETTINGS__SCOPE
            };
        
            const graphTokenResponse = await axios
                .post(
                    process.env.GRAPH_CLIENT_SETTINGS__TOKEN_URL, 
                    qs.stringify(graphTokenData), 
                    {
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    });
        
            this.graphToken = graphTokenResponse.data.access_token;
            this.graphTokenStartTime = new Date();
        }

        return this.graphToken
    }

    async getApiToken() {
    
        if (this.apiToken == "" || this.checkTimeExceeded(this.apiTokenStartTime))
        {
            const apiTokenData = {
                grant_type: 'client_credentials',
                client_id: process.env.UTILS_CLIENT_SETTINGS__CLIENT_ID,
                client_secret: process.env.UTILS_CLIENT_SETTINGS__CLIENT_SECRET,
                scope: process.env.UTILS_CLIENT_SETTINGS__SCOPE
            };
        
            const apiTokenResponse = await axios
                .post(
                    process.env.UTILS_CLIENT_SETTINGS__TOKEN_URL, 
                    qs.stringify(apiTokenData), 
                    {
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }
                    });
        
            this.apiToken = apiTokenResponse.data.access_token;
            this.apiTokenStartTime = new Date();
        }

        return this.apiToken;
    }

    async getApiResponse(url) {
    
        const token = await this.getApiToken();

        let data = this.getResponse(url, token);
    
        return data;
    }

    async getGraphResponse(url) {
    
        const token = await this.getGraphToken();

        let data = this.getResponse(url, token);
    
        return data;
    }

    async getResponse(url, token) {
    
        let data = {};
    
        try
        {
            const apiResponse = await axios
                .get(
                    url, 
                    {
                        headers: {
                            'Authorization': `Bearer ${token}`,
                            'Content-Type': 'application/json'
                        }
                    });
    
            data = apiResponse.data;
    
        }
        catch(error)
        {
            console.log("error");
            
            data = error.response.data;
            // if (error.response) 
            // {
            //     console.log(url)
            //     console.log(error.response.data);
            //     console.log(error.response.status);
            // }
        }
    
        return data;
    }
}
```