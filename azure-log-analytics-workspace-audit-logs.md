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