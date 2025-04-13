---
layout: post
title: "Blazor Vs. Traditional Web Apps"
date: "Jul 9, 2020"
author: "Christian Findlay"
post_image: "/assets/images/blog/blazor/logo.jpg"
image: "/assets/images/blog/blazor/logo.jpg"
tags: blazor web wasm
categories: dotnet
permalink: /blog/:title
redirect_from: 
    - /2020/07/09/blazor-vs-traditional-web-apps
---

Blazor is a new Single Page Application (SPA) technology by Microsoft. It is a comparable technology to [React, Angular, and Vue.js](blazor-vs-react-angular-vue-js) but uses C# instead of JavaScript. It brings C# to the world of SPAs and challenges traditional web apps frameworks such as ASP .NET Web Forms and ASP .NET Core MVC for building web apps. This article discusses the choice between SPAs and traditional web apps and explains the difference between server-side and client-side rendering. 

What are Traditional Web Apps?
==============================

Traditional web apps are apps that have little or no client-side processing. HTML is rendered server-side and passed to the browser. They mostly center around static text and filling out forms, and most interactions require a full page refresh. Browsers send data to the server via HTML forms, and the server handles the processing. Technologies like [ASP](https://en.wikipedia.org/wiki/Active_Server_Pages#History) (including all flavors such as classic, and MVC) and  [PHP](https://en.wikipedia.org/wiki/PHP) facilitate the transfer of data between the client and server and handle server-side processing. They mix server-side and client-side logic by allowing developers to declare the client-side UI with HTML alongside code that runs on the server. Forms can be developed quickly with no separation between APIs and front-end code. Traditional web app workflow typically presents the user with a form, a submit button, and a full-page response is received from the server after they click the button. The result is usually a disjointed and unsatisfactory user experience.

In the approach, APIs are typically not made as first-class citizens. Traditional web apps usually require developers to build a separate set of APIs for consumption by 3rd parties or other apps such as phone apps. It often leads to code duplication.

ASP Web Forms is an example of a traditional web app technology. It is possible to build SOAP Web Services, but it does not support designing modern Web APIs. Microsoft introduced ASP.NET Core for flexibility. It supports everything from modern Web APIs to traditional web apps. The MVC flavor of ASP.NET Core is a framework for building traditional web apps.

What are Single Page Apps?
==========================

[Single page apps](https://en.wikipedia.org/wiki/Single-page_application) are web-based apps where UI is dynamically modified based on data transfer with the server via API calls. SPAs render the HTML DOM on the client-side. They are analogous to native phone or desktop apps. The server generally transfers all HTML, JavaScript, and CSS or WebAssembly code at the beginning of the session and does not transfer these as part of subsequent API calls. The browser modifies the HTML DOM instead of requesting the full HTML from the server.

[Ajax](https://en.wikipedia.org/wiki/Ajax_(programming)) was the first step toward SPA frameworks. The approach became popular in the early 2000s. It uses JavaScript to call server-side APIs and so on to allow for asynchronous partial page refreshes. It provides a radical user experience improvement over traditional web apps. The browser can perform partial updates of data on the screen, and there is no HTML transfer on each call. Many traditional web apps started partially integrating Ajax. Developers added Web services to the back-end, and JavaScript code was served to the browser to call the endpoints. It meant that most traditional apps ended up becoming a mixture of server-side HTML rendering and client-side DOM manipulation with JavaScript. 

JavaScript module bundlers such as [webpack](https://webpack.js.org/) simplify the process of building pure JavaScript applications. They bundle an application in a similar way to a compiled native application. When coupled with frameworks such as Vue.js, Angular, and React, SPAs are easy to build and deploy. Developers build APIs as first-class citizens in parallel with SPA front-ends. Native app developers and 3rd parties can reuse the APIs so that all applications in the ecosystem depend on the same APIs. Modern systems frequently target platforms such as iOS and Android, so it is critical to reuse back-end infrastructure as much as possible. 

![Diagram](/assets/images/blog/blazor/traditionaldiagram.jpeg){:width="100%"}

What is Blazor?
===============

Blazor is a SPA framework that uses compiled C# to manipulate the HTML DOM instead of JavaScript. Blazor allows for server-side or client-side hosting models, but in either case, the browser manipulates HTML DOM client-side. The app remains a SPA app because the user does not experience full page refreshes.

Non-Blazor SPA frameworks may have a steep learning curve for C# programmers. Typescript has some similarities to C#, but the programming paradigm is quite different. Blazor allows C# developers to build and debug with Visual Studio while TypeScript mostly ties the developer to VS Code. The Visual Studio toolset is usually much more familiar to C# developers and more comprehensive.

C# programmers can start developing Blazor web apps with almost no learning curve, and this is particularly true if C# programmers already use ASP MVC. Blazor syntax is very similar to ASP MVC syntax and therefore provides an ideal pathway for developers to enter the SPA space. If your team has an MVC codebase, the transition to Blazor will be easier.

<script src="https://gist.github.com/MelbourneDeveloper/b0f38a505be00ffcd1d55a9296dd6267.js"></script>

When to Build a Single Page Application
=======================================

SPAs are suitable for internal and external customers. They can provide benefits to small business audiences but can quickly scale up to large enterprise scenarios. 

Build a SPA when 

*   Users expect a modern, rich user experience with a focus on interactivity
*   The target audience is up to date with modern browsers, and those browsers support scripting
*   The application is likely to be a data transfer heavy
*   The development team is familiar with the relevant languages and tech (TypeScript/JavaScript or C# for Blazor)
*   Web APIs need to be first-class citizens

When to Build a Traditional Web App
===================================

Traditional web apps are suitable for simple forms and portals exposed publicly. It may be appropriate to build an MVC app on top of an existing C# back-end to accept feedback or requests. Also, pages targeting older phones may work better with server-side rendering.

Build a traditional web app when

*   The app needs to support browsers without scripting, or the target browsers are out of date
*   The app needs to support older phones where scripting may run slowly
*   The app mostly serves static content or simple forms
*   The development team does not have experience with the relevant languages and tech. Note that Blazor brings C# to the web and somewhat alleviates this problem for developers who already use C#
*   Web APIs external apps do not need to reuse Web APIs built as part of the back-end.

Blazor Hosting Models
=====================

It's important to distinguish between Blazor [hosting models](https://docs.microsoft.com/en-us/aspnet/core/blazor/hosting-models?view=aspnetcore-3.1) and page rendering. In the client-side model, Blazor runs on [WebAssembly](https://webassembly.org/) (WASM) inside the browser. In the server-side model, Blazor runs on the server and transfers HTML to the client via [Signal-R](https://dotnet.microsoft.com/apps/aspnet/signalr). Both models result in a user experience comparable to SPA frameworks like React, Vue.js, or Angular. However, there are some differences.

Server-side hosting does not require WASM support in the browser, and this means that some older browsers may work with the server-side hosting model. 

![Diagram](/assets/images/blog/blazor/signalr2.png)

Client-side hosting is the less mature option, but will become the recommended approach as .NET on WASM becomes more popular. It runs entirely self contained inside the browser and only communicates with servers via API calls.

![Diagram](/assets/images/blog/blazor/stack.png)

**Server-side Hosting Pros**

*   Initial page download can be significantly smaller
*   Processing can take advantage of installed server-side components
*   Visual Studio has full support for debugging with the server-side model

**Server-side Hosting Cons**

*   No offline capability. When the internet is disconnected, processing stops.
*   Latency is increased

**Client-side Hosting Pros**

*   Client UI processing does not place load on the server
*   The server does not have to manage web socket connections with many users. This can create difficulties when there are many users.

**Client-side Hosting Cons**

*   .NET on WASM has not reached its full performance potential. This can sometimes create sluggish UI, but [AOT compilation](https://visualstudiomagazine.com/articles/2020/05/22/blazor-future.aspx) promises to increase performance dramatically in the near future. 
*   Interaction is restricted to the capabilities of the browser
*   The initial app download is slow because the .NET runtime must download
*   Debugging client-side Blazor apps is subject to some [limitations and issues](https://visualstudiomagazine.com/articles/2020/04/16/blazor-preview-4.aspx). 

Wrap-Up
=======

Users generally expect SPA type functionality from modern web applications. Traditional web apps may be suitable for some scenarios where legacy infrastructure is involved, or simplicity is the key. However, users may be unforgiving of traditional web apps if they provide a disjointed experience where the whole page reloads. Development teams with C# experience should consider Blazor for their next web app. Blazor may mean that training staff to use JavaScript or TypeScript is not necessary. The hosting model flexibility may allow older browsers to work well without much processing power or updated browsing capability.

**Progress Telerik**
--------------------

_Sponsored_

Tooling is an essential part of the technology decision. Progress Telerik has a long history of building quality C# UI components for SPA frameworks. Telerik UI for Blazor components has been built from the ground-up to ensure you experience shorter development cycles, quick iterations, and cut time to market. Try the [Telerik UI for Blazor components](https://www.telerik.com/blazor-ui?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=blazor-awareness-product) today to see what is possible with Blazor UI.

You can also check out:

[Telerik UI for ASP.NET MVC](https://www.telerik.com/aspnet-mvc?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=mvc-awareness-product)

[Telerik UI for ASP.NET Core](https://www.telerik.com/aspnet-core-ui?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=core-awareness-product)

[Telerik UI for ASP.NET AJAX](https://www.telerik.com/products/aspnet-ajax.aspx?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=ajax-awareness-product)