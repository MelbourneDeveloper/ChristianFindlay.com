---
layout: post
title: "RestClient.Net 4"
date: "2020/06/17 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/restclientdotnet/logo.png"
image: "/assets/images/blog/restclientdotnet/logo.png"
tags: restclient-net
categories: [dotnet]
permalink: /blog/:title
---

[RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net) is a cross-platform rest-client for .NET Core, .NET Framework, iOS, Android, WASM and UWP. It puts a wrapper over the .NET HttpClient API and allows you to write Rest client code that runs on any of the platforms. Version 4.0 of this library has been released, and I'd like to hear your feedback.

Major Changes
-------------

This is the Github [release notes page](https://github.com/MelbourneDeveloper/RestClient.Net/projects/3) that lists the issues the were fixed. The [main problem](https://github.com/MelbourneDeveloper/RestClient.Net/issues/68) with the previous version was that the client would attempt to deserialize responses that were non-successful. The library has been overhauled so that a useful exception is thrown instead. 

Mocking has been [made simpler](https://github.com/MelbourneDeveloper/RestClient.Net/issues/60) by adding setters on all properties of requests and responses. This means that unit testing is more accessible.

Factories are now [injected as delegates instead of interfaces](https://github.com/MelbourneDeveloper/RestClient.Net/issues/69). This is a breaking change This reduces boilerplate code. Check out [this article](c-delegates-with-ioc-containers-and-dependency-injection/) about the approach.

All platforms now use System.Json.Text [by default](https://github.com/MelbourneDeveloper/RestClient.Net/issues/62). This means that it is not necessary to create a serialization adapter unless you explicitly need to use Newtonsoft.

Using the Library
-----------------

Check out the quick launch documentation and unit tests.

Why use RestClient.Net?
-----------------------

*   It's fast! [Initial tests](https://codereview.stackexchange.com/questions/235804/c-rest-client-benchmarking) show that it is faster than RestSharp and is one of the faster .NET Rest Clients available.
*   Designed for Dependency Injection, Unit Testing and use with IoC Containers
*   Async friendly. All operations use async, await keywords.
*   Integrates with [Polly](https://github.com/MelbourneDeveloper/RestClient.Net/wiki/Integration-With-Polly) resilience and transient-fault-handling
*   Automatic serialization with any method (JSON, Binary, SOAP, [Google Protocol Buffers](https://developers.google.com/protocol-buffers))
*   Installation from NuGet is easy on any platform
*   Uses strong types with content body
*   Supports [WebAssembly](https://github.com/MelbourneDeveloper/RestClient.Net/wiki/Web-Assembly-Support), Android, iOS, Windows 10, .NET Framework 4.5+, .NET Core (.NET Standard 2.0)
*   Supports GET, POST, PUT, PATCH, DELETE with ability to use less common HTTP methods