---
layout: post
title: "Cross-Platform C# UI Technologies Part 2"
date: "2020/06/24 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/xplat2/header.jpeg"
image: "/assets/images/blog/xplat2/header.jpeg"
tags: csharp cross-platform avaloniaui uno-platform maui blazor xaml
categories: [dotnet]
permalink: /blog/:title
---

The options for building cross-platform phone, desktop, and web-apps with C# are expanding. I previously [wrote about](/cross-platform-c-ui-technologies/) Uno Platform, Xamarin.Forms, and Avalonia UI. The recent Microsoft Build conference mentioned [Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor), [Uno Platform](https://platform.uno/) and [MAUI](https://visualstudiomagazine.com/articles/2020/05/19/maui.aspx). MAUI is an evolution of [Xamarin.Forms](https://dotnet.microsoft.com/apps/xamarin/xamarin-forms) that targets .NET 5/6. Whether or not Blazor can be considered a genuinely cross-platform technology is complicated. This article compares the technologies and some others and attempts to clarify some confusion around the future of C# cross-platform development.

![Table](/assets/images/blog/xplat2/table.png){:width="100%"}

Check out my talk on these technologies here.
<iframe width="560" height="315" src="https://www.youtube.com/embed/hzbS0lcQXRk" title=".NET Cross-Platform App UI Technologies" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

[MAUI](https://github.com/dotnet/maui)
======================================

![MAUI Overview](/assets/images/blog/xplat2/maui.png){:width="100%"}

MAUI is an evolution of [Xamarin.Forms](https://github.com/xamarin/xamarin.forms) (XF). It is a technology for building native mobile and desktop apps with C# and XAML. There is no preview available yet. This is the [roadmap](https://github.com/dotnet/maui/wiki/Roadmap). However, MAUI should take over from Xamarin.Forms when it is ready. Xamarin.Forms is the flagship Microsoft C# cross-platform technology. It is a mature technology that large organizations have implemented to build many quality mobile applications. MAUI runs on the .NET 5/6 runtime while Xamarin.Forms runs on the Mono runtime for phones. .NET 5 is in preview mode so it could be some time before MAUI itself is production ready or even stable enough to experiment with.

**Platforms:** iOS, Android, Tizen, UWP (WinUI)

**When to use:**

*   Your team already has a Xamarin.Forms app
*   You want the native look and feel of the native platform
*   You need to build a native phone and desktop app from a single codebase
*   You don't need to target the browser

[Uno Platform](https://platform.uno/)
=====================================

![Uno Platform Logo](/assets/images/blog/xplat2/uno.png){:width="100%"}

Uno is a technology for building native mobile, desktop, and WebAssembly (WASM) apps with C# and XAML. It is a bridge for UWP that brings Windows 10 ([WinUI/UWP](https://docs.microsoft.com/en-us/windows/uwp/xaml-platform/)) apps to phones, macOS, and the browser. UWP XAML, which is the purest evolution of the Microsoft XAML technology. Uno Platform has a lot of crossover with MAUI, but one point of distinction is browser support. Uno Platform targets WASM, which allows developers to deploy web-apps from a UWP based codebase. Uno's XAML paradigm closely models itself after. The second point of distinction between MAUI/XF and Uno is that XF apps look like their native platform by default while Uno styles the app to be identical across platforms by default.

Enroll in my course [Introduction To Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661).

**Platforms:** Browsers, iOS, Android, macOS, UWP (WinUI), Linux support on the roadmap

**When to use:**

*   Your team already has a UWP app or is looking to adopt WinUI
*   You need to target the browser
*   Your team is familiar with the XAML paradigm from WPF, Silverlight or UWP
*   You need to build a native browser, phone and desktop app from a single codebase

[Avalonia UI](https://avaloniaui.net/)
======================================

![AvaloniaUI](/assets/images/blog/xplat2/avalonia.jpeg){:width="100%"}

> A cross platform XAML Framework for .NET Framework, .NET Core and Mono

Avalonia allows developers to build native applications across Windows, macOS, and Linux. It embraces the XAML paradigm, which is familiar to C# developers who have built WPF applications. It takes on the unique approach of rendering graphics with Skia on Win32, X11 & Cocoa instead of relying on the platform's native controls. The platform also has experimental support for phones, and this promises to make it a strong contender. WASM support is also on the roadmap, which brings it to browsers.

**Platforms:** Windows, macOS, Linux, experimental iOS and Android, browser and full iOS support on the roadmap

**When to use:**

*   Your team already has a WPF app
*   You need pixel-perfect rendering across platforms
*   You need to build a cross-platform desktop app from a single codebase (especially Linux)
*   You don't need to target the browser

[Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor)
==================================================================

![Blazor](/assets/images/blog/xplat2/blazor.svg){:width="100%"}

Blazor is a browser-based technology that uses WASM or [SignalR](https://dotnet.microsoft.com/apps/aspnet/signalr) to bring .NET code to the browser. Developers define UI with HTML, and style with CSS, but manipulate the HTML DOM with C# instead of JavaScript. Its popularity has recently surged and strikes a chord with web developers because of the familiarity with HTML DOM access. Blazor apps work like JavaScript apps but with C#. Blazor comes with a syntax called [Razor](https://docs.microsoft.com/en-us/aspnet/core/blazor/?view=aspnetcore-3.1), which is familiar to ASP MVC developers. 

Pure Blazor is only a real cross-platform technology insomuch as it runs in most modern browsers. However, Mobile Blazor Bindings (below) bring Blazor's syntax to Xamarin.Forms.

**Platforms:** Browsers 

**When to use:**

*   You need to target the browser
*   You don't need to build a native mobile or desktop app
*   Your team is more familiar with HTML and CSS than XAML
*   You need to migrate an ASP MVC app to a Single Page Application style web-app

[Mobile Blazor Bindings (Xamarin.Forms)](https://github.com/xamarin/MobileBlazorBindings)
=========================================================================================

![Blazor Mobile](/assets/images/blog/xplat2/mobileblazor.png)

These bindings bring Blazor Razor syntax to Xamarin.Forms. .NET developers currently build native Xamarin.Forms UI components with XAML, which facilitates UI definition and data binding. However, the Mobile Blazor Bindings bring Razor syntax, allowing developers to combine UI component definitions with C# code. This syntax will be familiar to developers that combine HTML and JavaScript. However, the bindings don't use HTML. The syntax defines components for the Xamarin.Forms UI object model. 

![Blazor Script](/assets/images/blog/xplat2/script.png){:width="100%"}

**Platforms:** iOS, Android

**When to use:**

*   Your team already has Blazor web-app
*   You need to build a native phone app
*   Your team is used to the ASP .NET Razor syntax
*   You are happy to write two codebases: one for web, and one for phones

How To Choose
=============

**_Do you need native apps and browser support?_**

If so, Uno Platform is probably the clear winner here. It's the only platform that supports WASM, phones, and desktop from the ground up. Users do not have to download an app from the App Store to use your app, but they still have protection from malware.

_Note: Xamarin.Forms and Uno Platform can work_ [_together_](https://github.com/nventive/Uno.Xamarin.Forms)_._

**_Do you need a native look and feel?_**

If so, MAUI may be the right choice. Like Uno platform, MAUI allows UIs to be defined declaratively across platforms but renders the UI based on the native platform. So, the user is not shocked by controls that do not behave in a non-platform-specific way. By default, the styles approximate the platform's native look and feel while Uno Platform tends to look more like Windows 10. However, both MAUI and Uno Platform allow styling for their native platforms. Microsoft mentioned both platforms at the Build Conference, so it seems safe to conclude that both platforms have a strong future.

**_Are you targeting desktop with users who download applications outside of App Stores?_**

If your users prefer a custom fit desktop experience that is pixel-perfect across Linux, Windows, and macOS, Avalonia is your best bet. It is familiar to any WPF developer and is very easy to get running and dive straight in. It has been developed on .NET Core from scratch, so the migration to .NET 5 should be seamless.

**Where does Blazor Fit?**

Use Blazor when targeting the browser is the most important aspect of the decision. The Mobile Blazor Bindings don't allow a single codebase to run in the browser and on phones, but Blazor is in its nascent stage. Mobile Blazor Bindings may merge with vanilla Blazor to build browser apps and phone apps from a single codebase. 

_Full disclosure: I have regular contact with_ [_nventive_](https://nventive.com/)_, who is the owner of Uno Platform. I've done my best to be as objective as possible here, but I am most familiar with Uno Platform._

_Edit: this article was slightly edited to reflect styling on the Uno platform._