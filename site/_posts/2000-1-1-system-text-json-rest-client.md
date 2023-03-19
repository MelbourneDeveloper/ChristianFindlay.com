---
layout: post
title: System.Text.Json Rest Client
date: "2020/01/21 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/json/header.svg"
image: "/assets/images/blog/json/header.svg"
tags: restclient-net csharp
categories: dotnet
post_image_size: width:50%
permalink: /blog/:title
---

> The System.Text.Json namespace provides high-performance, low-allocating, and standards-compliant capabilities to process JavaScript Object Notation (JSON), which includes serializing objects to JSON text and deserializing JSON text to objects, with UTF-8 support built-in. It also provides types to read and write JSON text encoded as UTF-8, and to create an in-memory document object model (DOM) for random access of the JSON elements within a structured view of the data.

[System.Text.Json Namespace Documentation](https://docs.microsoft.com/en-us/dotnet/api/system.text.json?view=netcore-3.1)

Newtonsoft has dominated the JSON serialization space for a long time. It is the most downloaded NuGet package around, but there are now alternatives. [RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net) implements the Microsoft .NET Core JSON Serializer belonging to the System.Text.Json namespace by default. A default serializer is a new feature for RestClient.Net because it does not depend on any 3rd party libraries. 

Microsoft is now encouraging developers to use this serializer, but it's essential to understand that it may not necessarily behave in the same way as Newtsonsoft. For example, Newtonsoft defaults to case insensitive properties. It makes it compatible with more backend services, but this impacts performance. My initial tests seem to show that System.Json.Text tends to be slower than Newtonsoft when properties are case insensitive. However, when case sensitivity is on, System.Json.Text seems to be faster than Newtonsoft. Full benchmarking of these two libraries is outside the scope of this library. But, I am doing some investigation to determine the fastest way to consume REST services. 

Usage on .NET Core
------------------

```csharp
var client = new Client(new Uri("https://restcountries.eu/rest/v2/"));   var response = await client.GetAsync>();
```

There is full documentation about it [here](https://github.com/MelbourneDeveloper/RestClient.Net/wiki/Serialization-and-Deserialization-With-ISerializationAdapter#default-json-serialization-adapter).

JsonSerializationAdapter
------------------------

[This](https://github.com/MelbourneDeveloper/RestClient.Net/blob/master/RestClient.Net.Abstractions/JsonSerializationAdapter.cs) is the default serialization adapter on .NET Core. Notice that the options can be changed by passing them into the constructor. 

Wrap Up
-------

Please see the full documentation [here](https://github.com/MelbourneDeveloper/RestClient.Net/wiki/Serialization-and-Deserialization-With-ISerializationAdapter). I'm hoping to hear about your experience with System.Text.Json. Are you experiencing issues with it? Are you experiencing performance degradation or improvement with it? Please check out the issues section on Github and let me know how it works for your project.