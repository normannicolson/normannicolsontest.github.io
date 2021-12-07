# Structured logging using ApplicationInsights *

Jan 2018

> Implement request correlation across cloud services get near real time feedback.

Every request should contain a unique request id (CorrelationId )or user journey id. 

IOC to create CorrelationId per request lifetime.

```
var query = new
            {
                query = $@"traces
                    | where operation_Name == 'POST Controller/Action'
                    | where message == 'Name'
                    | extend properties = todynamic(tostring(customDimensions.Properties))
                    | where properties.correlationId == '{((dynamic)this.model).CorrelationId}'
                    | where timestamp >= todatetime('{this.start.ToString("u", CultureInfo.CurrentCulture)}') and timestamp <= todatetime('{this.start.AddMinutes(10).ToString("u", CultureInfo.CurrentCulture)}')
                    | order by timestamp desc"
            };

            dynamic result;
            var logged = false;

            for (var i = 0; i <= 30; i++)
            {
                System.Threading.Thread.Sleep(10000);

                result = await "https://api.applicationinsights.io/v1/apps/{id}/query"
                    .WithHeader("X-API-Key", "{key id}")
                    .PostJsonAsync(query)
                    .ReceiveJson();

                logged = result.tables.Count > 0;

                if (logged)
                {
                    break;
                }
            }

            Assert.IsTrue(logged);

            return this;
```