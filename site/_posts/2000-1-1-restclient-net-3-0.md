---
layout: post
title: RestClient.Net 3.0
date: "2020/01/03 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/restclientdotnet/logo.png"
categories: [dotnet]
tags: restclient-net
permalink: /blog/:title
---

REST Client Framework for all .NET Platforms
--------------------------------------------

### The most simple task-based async, strongly typed, cross-platform .NET REST Client

RestClient.Net is a REST client framework built in C#. Version 3 brings a complete structural overhaul that makes it a solid choice for any .NET based cross-platform project. Modern design patterns such as dependency injection and task-based async are part of the foundation. To skip the pep talk, visit the documentation [here](https://github.com/MelbourneDeveloper/RestClient.Net/wiki).

*   Designed for Dependency Injection, Unit Testing and use with IoC Containers
*   Async friendly. All operations use async, await keywords.
*   Integrates with [Polly](https://github.com/MelbourneDeveloper/RestClient.Net/wiki/Integration-With-Polly) resilience and transient-fault-handling
*   Automatic serialization with any method (JSON, Binary, SOAP, [Google Protocol Buffers](https://developers.google.com/protocol-buffers))
*   Installation from NuGet is easy on any platform
*   Uses strong types with content body
*   Supports [WebAssembly](https://github.com/MelbourneDeveloper/RestClient.Net/wiki/Web-Assembly-Support), Android, iOS, Windows 10, .NET Framework 4.5+, .NET Core (.NET Standard 2.0)
*   Supports GET, POST, PUT, PATCH, DELETE with ability to use less common HTTP methods

Here is an incomplete list of fixes and features since V2.

*   Helper methods for setting authentication headers and other repetitive actions
*   Ability to send headers per call instead of at the client level
*   Serialization and deserialization can access header values such as Content-Type
*   Logging with `ILogger` means that DI can use 3rd party logging libraries
*   Responses contain more information like HTTP status codes
*   Namespaces have had a cleanup
*   IHttpClientFactory creates all HttpClient instances, which make it easy to implement good HttpClient practices ([Make HTTP requests using IHttpClientFactory in ASP.NET Core](https://docs.microsoft.com/en-gb/aspnet/core/fundamentals/http-requests?view=aspnetcore-2.1)).
*   The SendAsync method can be injected for call retries.
*   Support from .NET 4.5 to 4.7 was improved
*   XML Doc was improved
*   Parameter ordering was improved, and default values added in useful places
*   The iOS, Android, and WebAssembly samples are all running

.NET doesn't come with a standard REST client framework out of the box. HttpClient is the closest thing to a framework that .NET has. HttpClient suffers from some design issues that make it problematic in many cases. RestClient.Net includes a layer of abstraction for dependency injection and unit test mocking. It deals with serialization, the plumbing of HTTP calls, and integrates with fault handling frameworks like Polly.

All types of serialization are supported but do not bloat the framework. The client can achieve JSON, Protobuffer, WCF DataContract, or other serialization by adding a small adapter class to the project. It decouples apps from JSON so that the app can save on performance and bandwidth or keep compatibility with other types of serialization. Strong typing of the body on Http requests and responses makes it easy to send and receive objects without having to write plumbing code. The await keyword can be used on all methods so that calls are not blocking.

All of the above allows developers to focus on the essential parts of building applications instead of spending time on HTTP specifics. RPC style programming inspires the design. The latest version further removes the developer from the underlying HTTP transport. The patterns place more emphasis on what is achieved rather than how to achieve it. Underlying mechanisms like serialization are replaceable without having to rip up the floorboards of the application.

Try It Out!
===========

Most software teams are using HttpClient in weird and unpredictable ways. This framework provides an easy pathway to decouple your application from this nastiness. The abstractions mean that you can reuse the existing HttpClient code from your app.

Reach out via the issues section. The community is happy to help with implementing the functionality. We'd love to hear about your experience, and hear about what we can do to make REST communication easier in .NET.