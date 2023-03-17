---
layout: post
title: "Why .NET Standard Is Still Relevant"
date: "2020/12/21 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/netstandard/header.png"
tags: dotnet-standard cross-platform
categories: dotnet
permalink: /blog/:title
---

[.NET Standard](https://dotnet.microsoft.com/platform/dotnet-standard) is a .NET formal specification or API contract that is available across many .NET implementations. It exists because there are many .NET implementations on many platforms. Targeting .NET Standard 2.0 gives your library the most extensive reach possible, and enables almost all of the modern .NET features such as C# 9, `IAsyncEnumerable` etc., so all libraries should target this platform where it is not a hindrance to maintaining the library. 

> [The motivation behind .NET Standard was to establish greater uniformity in the .NET ecosystem](https://docs.microsoft.com/en-us/dotnet/standard/net-standard)

And, this statement still rings true.

Background
----------

[.NET Framework](https://en.wikipedia.org/wiki/.NET_Framework) is not a cross-platform technology. Unlike [Java,](https://en.wikipedia.org/wiki/Java_(programming_language)) Microsoft built .NET for Windows. .NET Framework is an implementation of the cross-platform [Common Language Infrastructure](https://en.wikipedia.org/wiki/Common_Language_Infrastructure). After the release of .NET Framework, several implementations of .NET such as [Mono](https://en.wikipedia.org/wiki/Mono_(software)) and [Unity](https://unity.com/) appeared on other platforms. Microsoft also released many other implementations such as [UWP](https://docs.microsoft.com/en-us/windows/uwp/get-started/universal-application-platform-guide), [Silverlight](https://www.microsoft.com/silverlight/), and most recently [.NET Core](https://en.wikipedia.org/wiki/.NET_Core). .NET Core which Microsoft renamed to .NET 5 is the most significant because it is a true cross-platform implementation of .NET by Microsoft and Microsoft intends on maintaining this platform.

Microsoft introduced [Portable Class Libraries](https://docs.microsoft.com/en-us/xamarin/cross-platform/app-fundamentals/pcl?tabs=windows) and eventually .NET Standard so that different implementations could share a common set of APIs. This means that .NET code is compatible across platforms, and you can use compiled code on any of the implementations. According to Microsoft, .NET Core, .NET 5, .NET Framework, Mono, Xamarin.iOS, Xamarin.Mac, Xamarin.Android, Universal Windows Platform and Unity all support .NET Standard in some way. However, .NET 5 does not yet run all these platforms.

In the future, we should see some of the other .NET implementations dropping away because Microsoft is "[actively developing](https://docs.microsoft.com/en-us/dotnet/standard/net-standard#net-5-and-net-standard)" .NET (.NET 5+) for platforms like iOS and Android. So:

> [.NET 5 is a single product with a uniform set of capabilities and APIs that can be used for Windows desktop apps and cross-platform console apps, cloud services, and websites](https://docs.microsoft.com/en-us/dotnet/standard/net-standard#net-5-and-net-standard)

However, for the time being, .NET Standard is the only target that spans most .NET implementations. If you want to build libraries that run on all these platforms, you need to target .NET Standard 2.0. Here is a table of implementations and which version of .NET Standard that they support:

![](/assets/images/blog/netstandard/table.png){:width="100%"}

The Future of .NET Standard
---------------------------

.NET Standard may become partly redundant, but [.NET 5 does not replace .NET Standard](https://docs.microsoft.com/en-us/dotnet/core/dotnet-five#net-50-doesnt-replace-net-standard). .NET 5 may run on phones and Windows desktop apps. However, runtimes like Unity and Mono still exist, and developers use them heavily. They will probably choose to continue using them. Moreover, there are thousands of legacy codebases still stuck on .NET Framework. If you target .NET Standard 2.0, you guarantee that these codebases can use your library. .NET Standard will be around for a while and .NET Standard 2.0 gives you the best reach.

In Immo Landwerth's words:

> [So, what should you do? My expectation is that widely used libraries will end up multi-targeting for both .NET Standard 2.0 and .NET 5: supporting .NET Standard 2.0 gives you the most reach while supporting .NET 5 ensures you can leverage the latest platform features for customers that are already on .NET 5.](https://devblogs.microsoft.com/dotnet/the-future-of-net-standard/)

How to Use Modern .NET Features with a Project that Multi-targets .NET Standard 2.0 and .NET 5+
-----------------------------------------------------------------------------------------------

You can use most modern .NET features with .NET Standard 2.0. Adding some NuGet packages can add much of the functionality like C# 9, not-nullable reference types, [IAsyncEnumerable](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.iasyncenumerable-1?view=dotnet-plat-ext-5.0), [Span](https://docs.microsoft.com/en-us/dotnet/api/system.span-1?view=net-5.0), System.Text.Json serialization and much more. The advantage of doing this is enormous. You can use all these features to provide rich functionality to developers who are stuck on platforms like .NET Framework. 

This csproj file targets .NET Standard 2.0 and .NET 5. You get the best of both worlds. The consumer gets all the benefits of .NET 5 if they can use it, but you don't exclude them if they are stuck on .NET Framework.

<script src="https://gist.github.com/MelbourneDeveloper/4b7f1c8626dcbb3b1537f8a04ca4cc31.js"></script>

Here is some example code from the project. This targets .NET Standard 2.0 and .NET 5, but runs on a .NET 4.6.1 console app. You can clone the project or see all the code [here](https://github.com/MelbourneDeveloper/Samples/tree/master/DotNetStandardSample). You can see the newer C# / .NET Features. .NET Standard 2.0 is not very limiting.

<script src="https://gist.github.com/MelbourneDeveloper/a8877827d366204831762a1ca8540e5c.js"></script>

This is a .NET 4.6.1 console app that uses the library:

<script src="https://gist.github.com/MelbourneDeveloper/259c7bcdd104db6362459d3bf2f5ff58.js"></script>

But, Open Source Maintainers are Doing This For Free
----------------------------------------------------

Yes, that's true. If they choose to abandon older targets, that's their choice. They are under no obligation to target older frameworks. However, as I have pointed out, it's usually not too hard to target .NET Standard 2.0 as well as .NET 5. I certainly see this as worthwhile for [Device.Net](https://github.com/MelbourneDeveloper/Device.Net) and [RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net) because I consider it important that as many users as possible can use these frameworks. This also raises the larger question of why we work in an ecosystem where we expect open-source developers to work for free in the first place. We should not expect anything from people who work for free. We need to address this as a separate issue, but that doesn't change the fact that Xamarin, UWP, Unity and other .NET implementations will be poorer if maintainers abandon the platforms.

I would hope that maintainers who are tired of working for free would target .NET Standard, but not provide guaranteed technical support for other implementations of .NET.

What about Tech Support?
------------------------

If you produce a library where you offer guaranteed support, the situation becomes a little different. Consumers may expect a level of guaranteed quality, and you may need to provide fixes in some timeframe. You cannot guarantee that .NET Standard code that runs on .NET 5 will run correctly on .NET Framework. This may be a reason to abandon targeting the older platform. However, maintainers can specify which platforms they guarantee for technical support. In my opinion, this is a better option than abandoning older platforms. It means that consumers use the library at their own risk and cannot expect the same quality level as newer .NET implementations. This is a business decision and entirely up to the maintainer of the library. 

Wrap-Up
-------

This is a kind of personal plea to developers to continue targeting .NET Standard 2.0. I have documented some ways to use modern features while targeting .NET Standard 2 and .NET 5. It might be easier to do this than you think. I understand if maintainers don't want to support other implementations of .NET. Still, I ask you to consider targeting .NET Standard 2.0 for the sake of the ecosystem - at least until WinRT and Xamarin fully support .NET 5/6. 