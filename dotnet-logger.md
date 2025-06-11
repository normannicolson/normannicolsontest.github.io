# Using ILogger

March 2025

> Structure dotnet logging 

Create ```.runsettings``` file

Loging in dotnet is super simple and can be unstructured, logged information are trace messages.

To create quick and easy structure wrap ILogger with some stucture  

Usage

```
this.logger.LogInformationWithStructure(
    correlationId, 
    "Start", 
    args:[
        maskedEmail
    ]);
```

Use as Extensions or as an injected class 

```
using System;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using Microsoft.Extensions.Logging;

namespace Nlist.Infrastructure.Telemetry.Extensions;

public static class LoggerExtensions
{
    public static void LogInformationWithStructure(
        this ILogger logger, 
        string correlationId,
        string message, 
        [CallerMemberName] string methodName = "",
        [CallerFilePath] string sourceFilePath = "",
        [CallerLineNumber] int sourceLineNumber = 0,
        params object[] args)
    {
        string className = System.IO.Path.GetFileNameWithoutExtension(sourceFilePath);

        var extendedArgs = args.ToList();

        extendedArgs.AddRange(new object[] 
        { 
            className, 
            methodName, 
            sourceLineNumber
        });

        logger.LogInformation(
            "CorrelationId: {correlationId}, {message} - Class: {className}, Method: {methodName}, Line: {sourceLineNumber}", 
            correlationId,
            message, 
            className, 
            methodName, 
            sourceLineNumber, 
            args
            );
    }

    public static void LogErrorWithStructure(
        this ILogger logger, 
        Exception? exception,
        string correlationId,
        string message, 
        [CallerMemberName] string methodName = "",
        [CallerFilePath] string sourceFilePath = "",
        [CallerLineNumber] int sourceLineNumber = 0,
        params object[] args)
    {
        string className = System.IO.Path.GetFileNameWithoutExtension(sourceFilePath);

        var extendedArgs = args.ToList();

        extendedArgs.AddRange(new object[] 
        { 
            className, 
            methodName, 
            sourceLineNumber
        });

        logger.LogError(
            exception, 
            "CorrelationId: {correlationId}, {message} - Class: {className}, Method: {methodName}, Line: {sourceLineNumber}", 
            correlationId,
            message, 
            className, 
            methodName, 
            sourceLineNumber,
            args
            );
    }
}
```