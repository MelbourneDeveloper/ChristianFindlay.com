---
layout: post
title: "Choose ASP.NET Core in 2021"
date: "2021/02/26 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/dotnet/logo.svg"
image: "/assets/images/blog/dotnet/logo.svg"
tags: csharp web
categories: dotnet
permalink: /blog/:title
---

ASP.NET Core is the most up-to-date Microsoft technology for building web apps. You can build Web APIs for your SPA front-end or traditional web-apps in the MVC style. .NET is Microsoft’s flagship technology and is ideal for building modern applications on-premise or in the cloud. This article discusses why ASP.NET Core is the right choice for your web-app.

### What is ASP.NET Core?

[ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/?tabs=windows&view=aspnetcore-5.0) should not be confused with the two earlier iterations of ASP. Microsoft released the [original ASP platform](https://en.wikipedia.org/wiki/Active_Server_Pages) in 1996. They upgraded the platform to use .NET in 2002 with [ASP.NET](https://en.wikipedia.org/wiki/ASP.NET). The platform supported several programming models such as Model View Controller (MVC), Web Forms, and Web APIs. In 2016, Microsoft released [ASP.NET Core](https://en.wikipedia.org/wiki/ASP.NET_Core) which supports many of the same programming models such as MVC but is distinct from ASP.NET. Initially, this platform ran on the .NET Framework, which is an older Microsoft framework. It now exclusively runs on the more recent .NET Core framework.

It contains tools and libraries specifically for building web apps. The framework processes web requests with C# or F# and has a templating syntax called Razor to create dynamic web pages. It handles authentication for simple logins, multi-factor authentication, external authentication, and OAuth authentication for systems like Google and Twitter.

### What is .NET?

.NET (sometimes referred to as .NET Core) is a free, genuinely cross-platform, open-source development framework. It runs on Windows, Linux, and macOS natively and has compatibility with many other platforms. It is the backbone of ASP.NET Core, and Microsoft is continually improving the framework. At the time of writing, .NET is at iteration 5, which boasts a vast set of [performance enhancements](https://devblogs.microsoft.com/dotnet/performance-improvements-in-net-5/) over the previous version.

.NET Core is a considerable aspect of the overall decision. While Java claimed the top position as the most common cross-platform back-end platform for many years, .NET Core is also a true cross-platform technology. It runs on Linux, macOS, and Windows, and all of the cloud providers support it.

### Which Languages?

You can build ASP.NET Core apps with [C#](https://docs.microsoft.com/en-us/dotnet/csharp/getting-started/) or [F#](https://fsharp.org/). C# is a modern, type-safe object-oriented language with a host of functional-style programming features and is one of the [top 10](https://www.jetbrains.com/lp/devecosystem-2019/) languages used by developers today. It was [released](https://en.wikipedia.org/wiki/C_Sharp_(programming_language)#History) alongside .NET Framework in 2002 and has become Microsoft’s go-to language. The latest iteration (9) boasts many [improvements](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-9). It has a C-like syntax that is instantly recognizable by developers who use C++, Java, and other similar languages. Many large corporations such as Microsoft use C# for developing large systems, and Github hosts an abundance of C# code for open-source projects.

F# is a modern, open-source, functional-first programming language. The language brings purer functional programming to the .NET ecosystem and offers an alternative to the object-oriented, imperative approach of C#. Many teams find [productivity gains](https://fsharp.org/testimonials/) from embracing the functional approach to building systems. .NET allows you to mix and C# libraries with F# libraries, so you get the best of both worlds.  

Language makes a big difference when it comes to building web apps. You want a mature language that has years of features carefully crafted for the needs of web development. For example, languages like Go are popular but can lack critical language infrastructure like [generics, which](https://medium.com/hackernoon/why-go-doesnt-have-generics-b40ef9e69833) can make larger projects harder to maintain. While languages like PHP are great for building websites quickly, nearly every aspect of PHP is non-standard from the point of view of traditional programming languages, and many developers find this [shocking](https://eev.ee/2012/04/09/php-a-fractal-of-bad-design/) and hard to adjust to.

### Amazing Tooling

The .NET ecosystem comes with the Juggernaught IDE [Visual Studio](https://visualstudio.microsoft.com/). It has a complete feature set and evolved over many years to serve .NET developers and runs on Windows and Mac. There are several price tiers with more advanced features. You can still work for free with the Community Edition, which has all the features needed, such as refactoring, cross-platform development, multi-targeting, code metrics, performance diagnostics, and more.

![](/assets/images/blog/dotnet/vs.png){:width="100%"}

You can also use [Visual Studio Code](https://code.visualstudio.com/), which is quickly becoming one of the web’s go-to IDEs. It runs on Windows, Linux, and macOS. While C# supporting is getting better, it is already a fantastic tool for writing JavaScript, TypeScript, and HTML/CSS. Jetbrains [Rider](https://www.jetbrains.com/rider/) gives you an alternative IDE, which is packed with code productivity and refactoring features. It runs on macOS and Windows but also adds Linux support. This means that you can have a full-fledged.NET development environment on Linux.

### Easy to Learn and Start Developing

C# and F# are both easy languages to learn. Hundreds of books have been written about them, and there is no shortage of material. Microsoft provides excellent online documentation resources and an incredible [online tutorial system](https://docs.microsoft.com/en-us/dotnet/csharp/tutorials/). You can type C# code and execute it in the browser. This makes learning the language far more accessible since you do not need to download the entire development environment to get started.

ASP.NET Core is a very streamlined technology. When Microsoft rewrote ASP from the ground up, they didn’t bring the years of bloat that weighed down earlier frameworks. This is key to making ASP.NET Core easy to learn and understand. New ASP.NET Core projects have minimal boilerplate code. When you create a new Web API project, it only comes with a few files, and here is an example Controller. A controller is a class that is responsible for receiving HTTP requests and returning responses. You can create a new Web API with a few clicks.

![](/assets/images/blog/dotnet/createnew.png){:width="100%"}

```csharp
using Microsoft.AspNetCore.Mvc;

namespace WebApplication1.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PersonController : ControllerBase
    {
        [HttpGet]
        public string Get(string firstName, string lastName) => $"{firstName} {lastName}";
    }
}
```

You can see from the above minimal sample how you would respond to a GET HTTP request. You receive query string parameters or a body as an object, process those, and then return a primitive object or a Task. This is how straightforward Web APIs are in ASP.NET Core. When we run the app, we can see the result directly.

![](/assets/images/blog/dotnet/browser.png){:width="100%"}

The [eShopOnWeb](https://github.com/dotnet-architecture/eShopOnWeb) reference application is a Github repo that showcases many of the features of ASP.NET Core. This industrial-grade system gives developers a benchmark and a template for building a robust, modern system. The code is freely available under the permissive MIT license to take as much as you need to replicate the functionality of the system. The [NorthwindTraders](https://github.com/jasontaylordev/NorthwindTraders) application also provides reference code for using the Clean architectural style with ASP.Net Core.

### A Stable Framework and Detailed Roadmap

Your technology decision should depend on frameworks that are heavily tested and have a secure future. ASP.NET Core has a [clear roadmap](https://github.com/dotnet/aspnetcore/issues/27883). No technology has every feature you need, but good technology keeps the issue list open, allows contributors to make pull requests, and lists the important features under active development. ASP.NET Core ticks all these boxes. This means that you are aware of what is currently missing but allows you to plan for future functionality when it is available.

### Cloud Compatibility

All the major cloud providers support .NET, and [Microsoft Azure](https://azure.microsoft.com/en-us/) treats it as the [primary technology](https://azure.microsoft.com/en-au/develop/net/). You can rest assured that your code will be portable to [Google Cloud](https://cloud.google.com/dotnet), [IBM Cloud](https://cloud.ibm.com/docs/cloud-foundry?topic=cloud-foundry-getting_started-dotnet), and [AWS](https://aws.amazon.com/developer/language/net/?whats-new-dotnet.sort-by=item.additionalFields.postDateTime&whats-new-dotnet.sort-order=desc). This is a critical factor when deciding on web technologies.

![](/assets/images/blog/dotnet/table.png){:width="100%"}

### Robust UI Components

The most important part of any technology decision is the user experience. UI components are the aspect of the technology that the user sees and interacts with. ASP.NET Core components minimize the amount of JavaScript that you need to write and often provide a rich set of controls to create a common look and feel for your app. The user interacts with the controls, and the UI components handle the data transfer between the client and the server. ASP.NET Core has open-source components for data grids, data pickers, gauges, charts, QR, and a raft of other features.

_Sponsored_

Explore [Telerik UI for ASP.NET Core](https://www.telerik.com/aspnet-core-ui?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=core-awareness-product-feb21). This suite of ASP.NET Core Components provides everything you need to develop modern web applications with minimal friction. The comprehensive set of demos allows you to evaluate the components inside the browser. See ASP.NET Core in action with a cohesive set of components.

### Blazor

Blazor is a [game-changer](blazor-vs-traditional-web-apps/) for ASP.NET Core web apps. Blazor allows you to build web front-end end SPA apps with C# instead of JavaScript. Blazor is a part of the ASP.NET Core ecosystem and shares the page rendering razor syntax with MVC. When your application requires a full SPA experience, you can write the view with Blazor. This modern framework competes with the likes of React and Angular.

### Wrap-up

ASP.NET Core is a robust web-development framework. It is an excellent solution for apps running in the cloud, and all the major cloud providers support it. The framework’s longevity is guaranteed because the framework is open-source, and Microsoft backs the framework as its flagship back-end web framework.