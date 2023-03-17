---
layout: post
title: "How to Use and Unit Test ILogger"
date: "2020/07/03 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/ilogger/header.jpg"
tags: csharp ilogger
categories: dotnet
permalink: /blog/:title
---

[ILogger](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger?view=dotnet-plat-ext-3.1) is at the heart of the ASP.NET Core infrastructure and works well when you use it correctly. If you approach it the wrong way, it is easy to go down a rabbit hole and burn lots of time trying to implement basic functionality. Follow these tips instead. This article gives you the basics on how to use and verify mocked calls without having to implement a class yourself.

Here are some pointers in case you've been doing it wrong. Read on to understand the justification for these tips.

*   Only use `ILogger` or [ILoggerFactory](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.iloggerfactory?view=dotnet-plat-ext-3.1) in your implementations. Avoid making direct API calls to the logging library
*   Use an off-the-shelf library. Don't create a class that implements `ILogger` unless you explicitly want to build your own logging infrastructure. 
*   Choose the library based on the logging infrastructure you choose to use. You will probably need to log to a cloud system. You need to compare and evaluate the functionality and cost with other systems before you go live
*   Log with the [extension methods](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger?view=dotnet-plat-ext-3.1#extension-methods) (LogInformation, LogWarning, and LogError). Don't use the `ILogger`'s Log method directly. 
*   Use [BeginScope](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.loggerextensions.beginscope?view=dotnet-plat-ext-3.1) with a message template and properties. You can also achieve the same by sending  Dictionary<string, object> to ensure that all log calls log the custom properties you want to show up in the logging system.
*   Use named string parameters. Don't use string interpolation for logging messages. 
*   Verify the output of the logging calls with a mocking framework such as Moq in your unit tests.
*   Read through the [official documentation](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-3.1).

The Goal
--------

Ultimately, the logger should write log messages to whichever system you choose to use. You will also want to write key/value pairs as part of the log messages so that you can later query the data. For example, you may want to mark a message with a "RecordType" property with a value of "Person". It would allow you to search for all messages where the "RecordType" is "Person". You will probably want to be able to search on things like record Ids. This type of query is invaluable for pinpointing information in a vast sea of logs when the system gets bigger.

Choosing the right logging system is outside the scope of this article, but you also need to ensure that you don't blow your budget on logging. Make sure that you take some time to choose the best place to send your logs.

Injecting an ILogger
--------------------

For simple scenarios, inject an `ILogger` instance into your class via the constructor. It is usually best practice to pass the class's type as a generic argument on `ILogger`. This is an example from the [official Microsoft documentation](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-3.1#create-logs).

```csharp
public class AboutModel : PageModel
{
    private readonly ILogger _logger;

    public AboutModel(ILogger<AboutModel> logger)
    {
        _logger = logger;
    }

    //[...]
}
```

For more complex scenarios, you will need to create a separate `ILogger` for each category and inject `ILoggerFactory` into the class. Categories allow different levels of filtering. Here is an example using `ILoggerFactory`

```csharp
public class TestClass
{
    private readonly ILogger _logger;

    public TestClass(ILoggerFactory loggerFactory)
    {
        _logger = loggerFactory.CreateLogger("Category1");
    }
}
```

Logging System
--------------

Start with file or console logging. Here is a bare minimum sample for an ASP.NET Core app with console logging:

Check out the full code [example here](https://github.com/MelbourneDeveloper/Samples/blob/650ba4bc6cba631da651c2c6732bce337e6a7d8e/ILoggerSamples/ILoggerSamples/ILoggerTests.cs#L77).

```csharp
public void TestConsoleLoggingWithBeginScope()
{
    var hostBuilder = Host.CreateDefaultBuilder().
    ConfigureLogging((builderContext, loggingBuilder) =>
    {
        loggingBuilder.AddConsole((options) =>
        {
            //This displays arguments from the scope
            options.IncludeScopes = true;
        });
    });

    var host = hostBuilder.Build();
    var logger = host.Services.GetRequiredService<ILogger<LogTest>>();

    //This specifies that every time a log message is logged, the correlation id will be logged as part of it
    using (logger.BeginScope("Correlation ID: {correlationID}", 123))
    {
        logger.LogInformation("Test");
        logger.LogInformation("Test2");
    }
}
```

You may use an off the shelf library like [NLog](https://nlog-project.org/), [log4net](https://logging.apache.org/log4net/), or [serilog](https://serilog.net/) to get up and running quickly. Configure one of these libraries using their documentation to log directly to a text file. This allows you to see log output while you are building the app. As long as you use dependency injection as above, you can change the library at any point in time. You will not be locked in. 

The next decision is where to put your logs. Some logging libraries will support these systems out of the box. However, you may need to use the specific SDKs from these systems. Here are some of the logging systems from the larger players: 

*   [Azure Monitor (Formerly Application Insights)](https://azure.microsoft.com/en-au/services/monitor/)
*   [Google Cloud Logging](https://cloud.google.com/logging)
*   [AWS CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)

Here are some things to consider:

*   How much will it cost?
*   What is the bandwidth transfer be like? I.e., will log messages send unnecessary data?
*   Is privacy an issue? Is the service GDPR compliant? Will the service log the IP address of users?
*   Is it easy to query logs? What's the syntax for querying like?
*   Is there a lag between logging the message and when it shows up in a query?

The most important thing here is testing. Build your application and regularly trial sending logs to candidate logging systems. Test that the system allows you to find and search for logs easily, and check price estimations. If your app is going to log a lot of data, the chances are that logging will get expensive. Try multiple systems and compare them. The cost will come back to bite you if you don't.

Using ILogger
-------------

Use the ILogger [extension methods](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger?view=dotnet-plat-ext-3.1#extension-methods). You shouldn't directly use the [main Log method](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger.log?view=dotnet-plat-ext-3.1#Microsoft_Extensions_Logging_ILogger_Log__1_Microsoft_Extensions_Logging_LogLevel_Microsoft_Extensions_Logging_EventId___0_System_Exception_System_Func___0_System_Exception_System_String__) on the ILogger interface. The extension methods take care of the plumbing for you, and you should focus on writing useful information to the logging system. Just call one of these:

*   LogCritical
*   LogDebug
*   LogError
*   LogInformation
*   LogTrace
*   LogWarning

E.g. 

```csharp
_logger.LogInformation("Log message");
```

Message Templates and Properties
--------------------------------

Message templates allow you to specify a message with templated information like named properties. The templating syntax can get quite sophisticated. Named properties are important for logging. If you use string interpolation for messages, the processing of the string will strip the name of the properties before the logger processes the message, and the name of the properties will be lost. As an example, named properties show up in Application Insights as custom dimensions which means you can query these by name.

**Good**
```csharp
var count = 1;   logger.LogInformation("Count: {count}", count);
```

**Bad**
```csharp
var count = 1;   logger.LogInformation("Count: {count}", count);
```

If you want to attach properties to each log message, use BeginScope

```csharp
using (logger.BeginScope("Correlation ID: {correlationID}", 123))   {        logger.LogInformation("Test");        logger.LogInformation("Test2");   }
```

Console output:

Console output:  
info: ILoggerSamples.LogTest\[0\]  
\=> Correlation ID: 123  
Test  
info: ILoggerSamples.LogTest\[0\]  
\=> Correlation ID: 123  
Test2

This would allow you query the logs by correlation Id on the other side.

Unit Testing ILogger
--------------------

You should verify that your code is sending log messages. You don't need to prove that the message ends up on the log server. You only need to prove that the correct Log call occurs. Unit testing `ILogger` is a little tricky because of the Log method's structure on the `ILogger` interface, but it is possible with [Moq](https://github.com/moq/moq4). This verifies that a log call happened, that the severity is Information, and that the log only occurred once. 

Check out the full code [example here](https://github.com/MelbourneDeveloper/Samples/blob/650ba4bc6cba631da651c2c6732bce337e6a7d8e/ILoggerSamples/ILoggerSamples/ILoggerTests.cs#L32).

But, we need a lot more than this to know that logging is correct. With this example, we can verify that the message gets sent, the original message is correct, and we can check which scoped arguments get sent. Here is a set of methods to help you Verify log messages.

[Usage](https://github.com/MelbourneDeveloper/RestClient.Net/blob/6762a4510495f2fceb3c3ae6c7b81eae65f546ee/src/RestClient.Net.UnitTests/MainUnitTests.cs#L465)

```csharp
_logger.VerifyLog((state, t) => state.CheckValue("{OriginalFormat}", Messages.InfoSendReturnedNoException), LogLevel.Information, 1);

_logger.VerifyLog((state, t) =>
state.CheckValue<IRequest>("request", (a) => a.Uri == RestCountriesAllUri && a.HttpRequestMethod == HttpRequestMethod.Get) &&
state.CheckValue("{OriginalFormat}", Messages.InfoAttemptingToSend)
, LogLevel.Trace, 1);

_logger.VerifyLog((state, t) =>
state.CheckValue("{OriginalFormat}", Messages.TraceResponseProcessed) &&
state.CheckValue<Response>("response", (a) => a.RequestUri == RestCountriesAllUri && a.StatusCode == 200)
, LogLevel.Trace, 1);
```

Wrap-up
-------

Logging is critical, but it doesn't have to be difficult. `ILogger` is your friend and not your enemy. If you find yourself writing lots of code to get it working, something has gone wrong. Keep your config code in the startup of your app, and avoid it in your services. Above all, pay close attention to the logging system you are working with.

<sub><sup>[Photo by Maria Ilaria Piras from Pexels](https://www.pexels.com/photo/brown-firewood-122588)</sup></sub>