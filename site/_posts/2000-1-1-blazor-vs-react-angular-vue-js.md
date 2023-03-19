---
layout: post
title: "Blazor vs. React / Angular / Vue.js"
date: "2020/06/04 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/blazor/blazorjscsharp.png"
image: "/assets/images/blog/blazor/blazorjscsharp.png"
tags: blazor web
categories: dotnet
permalink: /blog/:title
---

Blazor is a new Microsoft technology that allows developers to write code for browsers in C#. This article compares Blazor to three other common SPA frameworks: React, Angular, and Vue.js. JavaScript is currently the most popular language for browser-based Single Page Applications (SPAs) because up until recently, it's been the only language that runs inside the browser. These frameworks compile or transpile from JavaScript or TypeScript. This article asks whether developers need to depend on JavaScript and whether we can start building SPA apps with C# yet.

Support this blog by signing up for my course [Introduction to Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661)

**What is Blazor?**
-------------------

Blazor is .NET based SPA framework for web and mobile and part of the ASP.NET Core web framework.  Blazor uses the existing and familiar HTML Document Object Model (DOM) with CSS styling to present and process UI components. However, instead of JavaScript, Blazor uses C# for processing so developers can share code across platforms. Blazor declares HTML with Razor script, which is familiar to ASP .NET Core developers. Razor brings the developer close to HTML by maintaining a light syntax that allows direct HTML definitions but allows for data [binding](https://docs.microsoft.com/en-us/aspnet/core/blazor/data-binding?view=aspnetcore-3.1), iterations, and variable definitions.

![Sample App](/assets/images/blog/blazor/sample.png){:width="100%"}

Processing occurs on the .NET runtime on the server or client-side. In the case of the server-side, the HTML DOM is rendered on the server and then fed to the browser with [Signal-R](https://dotnet.microsoft.com/apps/aspnet/signalr). The full .NET Core runtime is available. On the client-side, Mono runs on [WebAssembly](http://WASM - https://webassembly.org/) inside the browser.  Mono on WASM is due for an upgrade to .NET 5 soon. WASM opens up the full power of .NET without needing server-side rendering or additional browser plugins.

Blazor brings technology that allows developers to bundle Blazor UI into desktop and mobile apps. [Electron](https://www.electronjs.org/) allows developers to build desktop apps with HTML and CSS. [Electron.Net](https://github.com/ElectronNET/Electron.NET) is one technology that bridges the gap and allows this to work with Blazor. Microsoft has built [experimental bindings](https://docs.microsoft.com/en-us/mobile-blazor-bindings/) for native mobile apps. This is probably an indication that Blazor apps are going to run on platforms such as iOS and Android.

![SignalR](/assets/images/blog/blazor/diagram.png){:width="100%"}

**Features of Blazor**
----------------------

*   Build Web UIs with C# instead of JavaScript or TypeScript
*   Build Progressive Web Apps (PWAs)
*   Create and use reusable components written in C#
*   Full debugging support on the server-side and debugging with some limitations on the client-side
*   Data binding with the HTML DOM (limited two-way binding)
*   Share code between client and server in C#
*   Works in all modern web browsers including mobile browsers
*   Blazor code has the same security sandbox as JavaScript
*   Use JavaScript interop to call JavaScript frameworks and libraries
*   Open-source

**What is WebAssembly?**
------------------------

According to WebAssembly.org it

> is a binary instruction format for a stack-based virtual machine. Wasm is designed as a portable target for compilation of high-level languages like C/C++/Rust, enabling deployment on the web for client and server applications.

[https://webassembly.org/](https://webassembly.org/)

Essentially, it allows the compilation of code for the web browser.  In the past, technologies like Adobe Flash or Microsoft Silverlight achieved this by forcing the user to install plugins. These technologies are no longer required, and runtimes like .NET can now run on top of WebAssembly.

**What is React?**
------------------

React is a JavaScript-based UI framework owned and maintained by Facebook. React doesn't attempt to give the developer all the tools they need to build a modern web app. Instead, it focuses on the crucial aspect of UI and allows developers to pick and choose the best of breed components for the other aspects of development. It sounds like a modest goal, but it isn't. JavaScript UI libraries have come and gone over the years, but React has attracted a massive following as the #1 for UI libraries. React is primarily a JavaScript library, but can easily be used with TypeScript.

**React Features**
------------------

*   Build Web UIs with JavaScript or TypeScript
*   Build Progressive Web Apps (PWA)
*   Works in all modern web browsers including mobile browsers
*   Large community
*   Open-source
*   Full debugging support in IDEs like VS Code

**Blazor vs. React**
--------------------

JavaScript has a steep learning curve for C# developers and is not a statically typed language. Many team leads would have experienced the problem of hiring back-end and front-end developers. It's tough to find developers that are good at both JavaScript and C#. If Blazor is the technology of choice, back-end C# developers automatically have a degree of knowledge about front-end development with Blazor. Back-end developers can switch gears easily to fix bugs on the front-end or be skilled up to build front-end applications.

Blazor is not yet as mature as React, but Microsoft is likely to build on the framework to make it a first-class citizen in the SPA space. Client-side debugging is the primary feature that is missing but should come in time. If your business needs a production-ready SPA right now and has the JavaScript expertise, React would be a better choice than Blazor, but, if the team comprises C# developers and there is some room for the SPA to evolve, consider Blazor. There is a good chance of Blazor yielding more maintainable code over time in this case.

While there is still some debate about whether statically typed languages are generally better, many developers would say that statically typed languages are better for large projects. It might make C# a preferable choice compared to JavaScript.

**What is Angular?**
--------------------

Angular is a popular TypeScript based web and mobile SPA framework written and maintained by Google. It is set apart from Angular because it is a complete framework. TypeScript is a statically typed language like C# and transpiles to JavaScript. [TypeScript](https://www.typescriptlang.org/) follows a similar paradigm to C# and has some similarity to C# because Microsoft maintains it. Later versions of Angular also support server-side rendering in a similar way to Blazor the template syntax allows developers to declare HTML DOM UI components with data binding in a similar way to the razor syntax.

Angular is familiar to web developers because it leverages existing JavaScript frameworks and comes from a JavaScript background. It has a vibrant community and is mature.

**Features of Angular**
-----------------------

*   Build Web UIs with TypeScript
*   Build Progressive Web Apps (PWA)
*   Two-way data binding with the HTML DOM
*   Works in all modern web browsers including mobile browsers
*   Large community
*   Open-source
*   Full debugging support in IDEs like VS Code
*   A full set of built-in APIs for common app tasks

**Blazor Vs. Angular**
----------------------

Many of the same points about React are true about the comparison between Angular and Blazor. Angular is also a mature framework with a vast community, while Blazor is still bleeding edge. However, Angular embraces the TypeScript paradigm, which is more natural for C# developers to adapt to than JavaScript. Angular is far more comprehensive than React and advertises itself as a framework instead of a UI library. Angular doesn't just do UI components. It encourages the developers to use components out of the box, so code becomes more uniform.

**What is Vue.js?**
-------------------

Vue comes from a similar background to Angular. Developers build apps with JavaScript. It sits between React and Angular because it scales between a UI library and a framework. It is a more boutique framework but remains a trustworthy competitor to React and Angular. As with React, developers can use TypeScript, but the focus is on JavaScript.

**Vue.js Features**
-------------------

*   Build Web UIs with JavaScript or TypeScript
*   Build Progressive Web Apps (PWA)
*   Two-way data binding with the HTML DOM
*   Works in all modern web browsers including mobile browsers
*   Medium-sized community
*   Open-source
*   Full debugging support in IDEs like VS Code
*   A full set of built-in APIs for everyday app tasks

**Blazor vs. Vue.js**
---------------------

Many of the comparison-points from Angular and React also apply to Vue.js. Vus.js could be a happy compromise for developers that want more than just a UI library but without the heaviness of the full Angular framework. Several comparisons between Angular and Vue.js tend to suggest that Vue.js does fair between on the [performance front](https://vuejs.org/v2/guide/comparison.html#Runtime-Performance-1). So, Vue.js may be another good choice for teams that need to develop a SPA right now, but again, embracing C# with Blazor may yield better results for teams with a C# background.

**Summary**
-----------

C# developers now have many options when it comes to building UI. Blazor brings the familiar HTML DOM to C# and provides web developers the ability to use C#. It has the potential for building desktop and mobile applications and has traction in the Microsoft development community. Consider this technology when evaluating technology for your next SPA.

**Progress Telerik**
--------------------

_Sponsored_

Tooling is an essential part of the technology decision. Progress Telerik have a long history of building quality C# UI components in all the frameworks above.

Telerik UI for Blazor components has been built from the ground-up to ensure you experience shorter development cycles, quick iterations, and cut time to market. Try the [Telerik UI for Blazor components](https://www.telerik.com/blazor-ui?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=blazor-awareness-product) today to see what is possible with Blazor UI.

You can also check out:

[Progress KendoReact](https://www.telerik.com/kendo-react-ui/?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=react-awareness-product)

[Progress Kendo UI for Vue](https://www.telerik.com/kendo-vue-ui?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=vue-awareness-product)

[Progress Kendo UI for Angular](https://www.telerik.com/kendo-angular-ui?utm_source=findlay-blog&utm_medium=cpm&utm_campaign=kendo-ui-angular-awareness-product)
