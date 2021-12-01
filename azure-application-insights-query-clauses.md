# Azure Application Insights Query Clauses

Jun 2018

> Application insight query filters.

Application insight query filtering

```
exceptions 
| where timestamp >= datetime(2018-06-08T13:00:00.000Z)
| where details has 'value'
| order by timestamp desc
```

```
traces
| where operation_Name == 'POST Telemetry/Information'
| extend properties = todynamic(tostring(customDimensions.Properties))
| where properties.correlationId == '1cb3edac-aaf4-42ad-aa5f-610a73060e77'
| where timestamp >= todatetime('2018-06-08T13:00:00.000Z') and timestamp <= todatetime('2018-06-08T14:00:00.000Z')
| order by timestamp desc
```

Api Call

```
https://api.applicationinsights.io/v1/apps/e4083300-f31d-45b6-bc40-8d50c2eb2fbc/metrics/requests/count
```

Unit Test

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