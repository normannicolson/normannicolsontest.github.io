# Log Analytics AuditLog useful queries

Jun 2025

> Use kql to query audit logs

View tokens issued to application

```
let audits = AuditLogs
| where Resource == 'Microsoft.aadiam'
| where TimeGenerated > ago(1h)
| where Category !in ('DirectoryManagement', 'ResourceManagement')
| summarize Count=count() by Category, OperationName, Resource, bin(TimeGenerated, 1m);

audits
| where Category == 'Authentication' and OperationName == 'Issue an id_token to the application'
| render columnchart with(title='Issue token to application');
```

Get Token issued with user id 

```
let audits = AuditLogs
| where Resource == 'Microsoft.aadiam'
| where TimeGenerated > ago(3d)
| where Category !in ('DirectoryManagement', 'ResourceManagement')
| extend UserId = tostring(TargetResources[0].id)
| where Category == 'Authentication' and OperationName == 'Issue an id_token to the application'
| summarize Count=count() by Category, OperationName, Resource, UserId, bin(TimeGenerated, 1d);

audits;
```

View token usage activity

```
let startDate = todatetime('2025-065-01T00:00:00Z');
let endDate = todatetime('2025-06-11T23:59:59Z');

let dailyStats = AuditLogs
| where Resource == 'Microsoft.aadiam'
| where TimeGenerated between (startDate .. endDate)
| where Category == 'Authentication' and OperationName == 'Issue an id_token to the application'
| extend UserId = tostring(TargetResources[0].id)
| extend Day = bin(TimeGenerated, 1h)
| summarize TotalTokens=count() by Day, UserId
| extend ActivityLevel = iff(TotalTokens < 3, "Low", "High")
| summarize 
    LowActivityUsers = countif(ActivityLevel == "Low"),
    HighActivityUsers = countif(ActivityLevel == "High"),
    TotalLowActivityTokens = sumif(TotalTokens, ActivityLevel == "Low"),
    TotalHighActivityTokens = sumif(TotalTokens, ActivityLevel == "High"),
    TotalUniqueUsers = dcount(UserId),
    AvgTokensPerUser = avg(TotalTokens)
by Day;

let dailyStatsPercentage = dailyStats
| extend HighActivityPercentage = round((HighActivityUsers * 100.0 / TotalUniqueUsers), 2)
| order by Day asc;

dailyStatsPercentage;
```

Get top Issue an id_token to the application users 

``` 
let startDate = todatetime('2025-06-14T09:00:00Z');
let endDate = todatetime('2025-06-14T10:00:00Z');

AuditLogs
| where Resource == 'Microsoft.aadiam'
| where TimeGenerated between (startDate .. endDate)
| where Category == 'Authentication' and OperationName == 'Issue an id_token to the application'
| extend UserId = tostring(TargetResources[0].id)
| extend Hour = bin(TimeGenerated, 1h)
| summarize TotalTokens=count() by Hour, UserId
```

Requests 

```
let currentDate = todatetime('2025-07-02T00:00:00Z');
let currentEndDate = todatetime('2025-07-02T23:59:59Z');
let previousDate = todatetime('2025-07-01T00:00:00Z');
let previousEndDate = todatetime('2025-07-01T23:59:59Z');

let currentDay = AppRequests
| where TimeGenerated between (currentDate .. currentEndDate)
| where Url startswith "http://example.com/api/"
| where Name != "POST Endpoint"
| where Success == false
| summarize 
    RequestCount = sum(ItemCount),
    AvgDuration = round(avg(DurationMs), 2),
    MaxDuration = max(DurationMs),
    MinDuration = min(DurationMs) by Name, bin(TimeGenerated, 1h)
| extend Day = "Current";

let previousDay = AppRequests
| where TimeGenerated between (previousDate .. previousEndDate)
| where Url startswith "http://example.com/api/"
| summarize 
    RequestCount = count(),
    AvgDuration = round(avg(DurationMs), 2),
    MaxDuration = max(DurationMs),
    MinDuration = min(DurationMs) by Name, bin(TimeGenerated, 1h)
| extend Day = "Previous";

currentDay
```

```
AuditLogs
| where TimeGenerated between (todatetime('2025-02-01T00:00:00Z') .. todatetime('2025-03-01T00:00:00Z'))
| where OperationName == "Send SMS to verify phone number"
| summarize count()
```

MAU
```
AuditLogs
| where Resource == 'Microsoft.aadiam'
| where TimeGenerated between (todatetime('2025-03-01T00:00:00Z') .. todatetime('2025-04-01T00:00:00Z'))
| where Category == 'Authentication' and OperationName == 'Issue an id_token to the application'
| extend UserId = tostring(TargetResources[0].id)
| summarize UniqueUsers = dcount(UserId)

AuditLogs
| where Resource == 'Microsoft.aadiam'
| where TimeGenerated between (todatetime('2025-03-01T00:00:00Z') .. todatetime('2025-04-01T00:00:00Z'))
| where Category == 'Authentication'
| extend UserId = tostring(TargetResources[0].id)
| summarize UniqueUsers = dcount(UserId)
```