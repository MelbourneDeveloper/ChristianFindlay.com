---
layout: post
title: "C# and gRPC Part One"
date: 2019-05-26 00:00:00 +0000
tags: grpc csharp
categories: [dotnet]
author: "Christian Findlay"
post_image: "/assets/images/blog/grpc/header.png"
permalink: /blog/:title
---

[gRPC](https://grpc.io/) is a modern open source RPC framework created by Google. It is based on Google's modern [Protocol Buffer](https://developers.google.com/protocol-buffers/) serialization engine but is not tied to it. C# developers who have used [WCF](https://docs.microsoft.com/en-us/dotnet/framework/wcf/whats-wcf) in the past, or anyone building C# backend services should take a look at this. gRPC has most of the functionality that WCF has, but you can build on .NET Core. This article will introduce gRPC, explain why WCF developers should pay attention, and talk about why it could be used for any service. According to Scott Hunter at Microsoft:

> If you are a remoting or WCF Server developer and want to build a new application on .NET Core, we would recommend either ASP.NET Core Web APIs or gRPC

<https://devblogs.microsoft.com/dotnet/net-core-is-the-future-of-net/>

This is huge. Many developers invested in WCF as a communication layer over the last ten years. To make a long story short, it was a great technology for building RPC style programming in C#. However, WCF has not yet been ported to .NET Core. This means that any services build for .NET Framework cannot be ported to .NET Core directly. Many services are languishing on .NET Framework. However, gRPC may offer a pathway to move off .NET Framework for these services. It's also a lot more simple to get up and running and configure than WCF.

gRPC may or may not have been developed as a replacement for WCF, but it is a good fit for WCF developers because its messaging system is similar to WCF's DataContract and OperationContract system. gRPC calls and messages are defined in a simple markup language like so:

![proto](/assets/images/blog/grpc/proto1.png){:width="100%"}

Those who are familiar will see that this is also the same markup language as Google Protocol Buffers. This language is platform agnostic, but can be rendered out to any language. Languages that are already supported for both server side, and client side, include Ruby, Python, Objective C, Node JS, C++ and more. The code can be shared across the backend and the front end. This is one of the features that will make gRPC familiar for WCF developers. However, what makes this even better is that the same markup code can be used to create clients for many different languages and platforms. The net effect is similar to [svcutil](https://docs.microsoft.com/en-us/dotnet/framework/wcf/servicemodel-metadata-utility-tool-svcutil-exe), but for any platform so your service can be consumed by just about anything.

C# examples can be found in the [gRPC Github repo](https://github.com/grpc/grpc) along with other language examples. This is a great starting point. If you open up the Hello World sample, you can jump straight in and change the various declared RPC calls and messages. As soon as you compile the shared project, the changes are rendered out to the client server projects.

I have built a sample application here in about one day: [DBTogRPC](https://github.com/MelbourneDeveloper/DBTogRPC). It will change over time, so I have tagged it with "BlogPostPartOne". For this sample, I focused sending message of any type across the wire, mapping it on to database entities, and then saving that in a database and retrieving it. It uses SQLite with Entity Framework Core on the backend, but uses abstraction so that a different type of data layer could be used. On the client side, this is the code for connecting to the service and saving a person:

![Save Person](/assets/images/blog/grpc/csharp1.png){:width="100%"}

After that, more database operations can be called with the same methods

![Load](/assets/images/blog/grpc/csharp2.png){:width="100%"}

Here is a snippet of the backend:

![Backend](/assets/images/blog/grpc/backend.png){:width="100%"}

It was pretty incredible that this came together so quickly with no knowledge of gRPC. I was never able to build WCF services this quickly. I can also say that building ASP .NET Core Web APIs never comes together this quickly. [Mark Rendle](https://twitter.com/markrendle) has put together an [article](https://unwcf.com/posts/wcf-vs-grpc/) on moving from WCF, but more importantly, he is working on a tool which should help with the migration process. You should check this out if your services are built on WCF.

In future articles I will delve in to this sample further, explain why dynamic typing (Any) is so important for RPC programming, and how this may even create a shift away from hand crafting REST services in future. Personally, I think that gRPC is going to shake up the backend ecosystem. It means that developers are not forced to be concerned with low level basics like http verbs and so on. Developers can focus on building what is important for them: good quality RPC services.