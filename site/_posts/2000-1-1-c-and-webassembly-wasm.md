---
layout: post
title: "C# and WebAssembly (Wasm)"
date: 2019/06/29 00:00:00 +0000
categories: [dotnet]
tags: web blazor xaml csharp
author: "Christian Findlay"
post_image: "/assets/images/blog/wasm/header.png"
image: "/assets/images/blog/wasm/header.png"
permalink: /blog/:title
---

WebAssembly may be the most exciting technology for C# developers to emerge in recent times. Browser based applications have been developed in JavaScript, or languages that transpile to JavaScript since the early days of the web. This has meant that C# developers have either needed to work with two or more different languages, or avoid browser based development altogether. Wasm may change all of this by being a bridge for .NET based development in browsers.

> WebAssembly (abbreviated _Wasm_) is a binary instruction format for a stack-based virtual machine. Wasm is designed as a portable target for compilation \[...\] enabling deployment on the web for client and server applications.

[https://webassembly.org](https://webassembly.org)

## Background
HTML was originally [developed by](https://en.wikipedia.org/wiki/HTML#History) Tim Berners-Lee and released around 1995. It's original goal was to display static, formatted text and image content that could be displayed in a web browser. Several companies implemented browsers based on the HTML standard. In an attempt to make web content more dynamic, [JavaScript was created](https://en.wikipedia.org/wiki/JavaScript#Beginnings_at_Netscape) as a "glue language" where code could be written to dynamically manipulate the HTML [document object model](https://en.wikipedia.org/wiki/Document_Object_Model). This was first added to Netscape Navigator and was loosely based on the [Java](https://en.wikipedia.org/wiki/Java_(programming_language)) syntax. Other browsers added dynamic languages, and Microsoft added [JScript](https://en.wikipedia.org/wiki/JScript) to their Internet Explorer browser.

Earlier, the [Java](https://en.wikipedia.org/wiki/Java_(programming_language)#History) runtime environment and programming language had been created which allowed for cross-platform code to be run on the major operating systems. [Java Applets](https://en.wikipedia.org/wiki/Java_applet#Embedding_into_a_web_page) were compiled bundles that could be embedded in a web page. Browsers gave control of a slice of the browser's canvas for graphics rendering. Java differed from JavaScript in the sense that it did not need to manipulate the HTML DOM. It could render its own graphics and avoid rendering deviance between different OSs and browsers. However, Java applets did not gain much traction in the web community after the early days.

For many years, browser plugin based runtime technologies like [Adobe Flash](https://en.wikipedia.org/wiki/Adobe_Flash_Player) (1996) and [Microsoft Silverlight](https://en.wikipedia.org/wiki/Microsoft_Silverlight) (2007) were popular ways of deploying rich web applications in to the browser. These technologies operated in the same way as Java applets. The web browser gave control of the canvas to these plugins and also gave them ability to manipulate the HTML DOM via JavaScript. This meant that developers could code in the language of their choice and render pixel perfect UIs across different platforms.

Around 2012 Apple [announced](https://www.huffpost.com/entry/apple-drops-java-mac_n_1989623) that it would drop the automatic shipping of Java with its OSX. They did not publicize the reason for this but it is widely considered to be because of [security](https://en.wikipedia.org/wiki/Java_security) concerns. After this point, plugin based runtimes went out of favor and most browsers are in the process of dropping support for plugin such as Silverlight and Flash.  This leaves a hole where runtime plugins had previously been.

In 2015, WebAssembly [was first announced](https://en.wikipedia.org/wiki/WebAssembly#History).  The first demo of Wasm was with the game [Angry Bots](https://beta.unity3d.com/jonas/AngryBots/) which is based on Unity with [WebGL](https://en.wikipedia.org/wiki/WebGL). This demo is a fully functional 3D environment inside the browser. Once again, browsers were opened up to using languages other than JavaScript, and it was again possible to compile code to a modular binary format. Since then, the [W3C has put its support](https://www.w3.org/community/webassembly/) behind Wasm, there is [consensus](https://webassembly.org/roadmap/) among the four browsers Chrome, Firefox, Safari, and Edge that the MVP is complete, and Wasm is now being shipped in all new versions of these browsers.

Wasm provides a runtime environment with many of the benefits of compiled technologies like Java, Silverlight, and Adobe Flash, but with a

sandboxed execution environment that may even be implemented inside existing JavaScript virtual machines. When embedded in the web, WebAssembly will enforce the same-origin and permissions security policies of the browser.

The good news is that C# can already be run on Wasm. There is currently no direct C# to Wasm compiler. However, the current approach is to compile the mono runtime along with CIL assemblies in to Wasm bytecode. This allows for existing C# code to be run on Wasm inside the browser. More detail can be found in the [mono-wasm Github repo](https://github.com/migueldeicaza/mono-wasm).

## [Uno Platform](https://platform.uno/) , [Avalonia](https://github.com/AvaloniaUI/Avalonia/issues/1387) & [Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/client)
Uno Platform is an ambitious project that aims at providing a C# / XAML based platform for developing apps that target all platforms. This includes browsers,  and native iOS/Android. Uno allows developers to define their UI in the platform agnostic markup language XAML, which in turn renders out to the platform's native UI architecture such as the HTML DOM in browsers. This amazing [sample](http://windowstoolkit-wasm.platform.uno/) application is a port of the [Windows Community Toolkit](https://github.com/windows-toolkit/WindowsCommunityToolkit). It allows direct XAML editing, and binding to manipulate and create UI elements.

Blazor "lets you build interactive web UIs using C# instead of JavaScript. Blazor apps are composed of reusable web UI components implemented using C#, HTML, and CSS. Both client and server code is written in C#, allowing you to share code and libraries". Blazor provides C# developers with a smooth pathway to convert existing JavaScript applications to C#. This impressive [sample](http://playground.nethereum.com/) allows C# code to be edited and run inside the browser for the [Ethereum](https://www.ethereum.org/) blockchain with the popular [Nethereum](https://nethereum.com/) C# library.

In short, these platforms allow C# developers to jump straight in and build web applications with C#. These applications are sandboxed, and fast. However, both these technologies render the UI out to HTML components. C# can be used to manipulate the components, but rendering is still performed by the browser's inbuilt engine.

Avalonia is a UI API based on Microsoft's WPF UI API. It doesn't yet support Wasm. However, this technology stands out as a [strong candidate](https://github.com/AvaloniaUI/Avalonia/issues/1387) for a UI library that would allow for non HTML DOM rendering inside the browser. This technology may once again allow line of business apps to be built and deployed inside the browser with pixel perfect rendering. The result should be very similar to Microsoft Silverlight.

[This article](cross-platform-c-ui-technologies) talks about cross platform C# UI technologies in some depth.

## Back end and App Development
While browser based front end development is the obvious use case for C# developers, Wasm will not stop there. As mentioned on the website, Wasm is also aimed at "deployment on the web for client and server applications". This has big implications for C# developers. Wasm is now being deployed to nearly every device in circulation. All new devices will have the Wasm runtime as part of their browser deployment. Even phones such as iPhones and Android phones will have Wasm installed. This means that Wasm is probably already installed on more devices than technologies like [Mono](https://www.mono-project.com/). This cannot be said for .NET Core.

It is highly likely that Wasm platforms for building apps outside the browser ([non-web embeddings](https://webassembly.org/docs/non-web/)) will emerge, and server side technology will be developed on Wasm. It is also likely that a C# to Wasm compiler will emerge. Wasm may challenge .NET and mono for uptake. Wasm has a long way to go, but it is possible that we may see an ecosystem where modules are built for Wasm and shared across the back end and front end of systems. It will probably mean that modules will be built in various languages such as Rust, and C in the same way that .NET assemblies can currently be built with multiple languages like Python, and Visual Basic. Developers may find themselves on teams where APIs are being built in separate languages concurrently.

## Conclusion
It's time to start experimenting with Wasm and feeling out what can be built with C#. Wasm is likely to change the web development landscape and compiled languages like C# are likely to be at the forefront. C# may once again look like an attractive technology for front end web development. This may well be the next phase of web development that C# developers have been waiting for.

See [this article](https://www.christianfindlay.com/blog/restclient-net-on-webassembly-c) for an Uno Platform sample app.