---
layout: post
title: "Cross-Platform C# UI Technologies"
date: 2019-05-11 00:00:00 +0000
author: "Christian Findlay"
post_image: "/assets/images/blog/xplat1/header.jpg"
image: "/assets/images/blog/xplat1/header.jpg"
categories: [dotnet]
tags: cross-platform csharp avaloniaui uno-platform xaml
permalink: /blog/:title
---

*Several UI technologies can be used to build Cross-Platform apps in C# or other .NET based languages such as Visual Basic (VB). This article looks at three technologies and discusses, for which cases developers could use these technologies. This article gives you a baseline understanding of technologies that are available for building front-end applications in C#, and will answers questions like which platforms are available? Can it run in a browser? Will it have a native look and feel? Also, can it be deployed to the app stores?* [Read part 2 of this article](csharp-crossplatform-2) or watch this talk on newer technologies (10th August 2020)

Background
----------

[.NET Framework](https://en.wikipedia.org/wiki/.NET_Framework) is a technology created in the early 2000s primarily for Windows desktop apps. The main two languages at the time were [C#](https://en.wikipedia.org/wiki/C_Sharp_(programming_language)) and [VB](https://en.wikipedia.org/wiki/Visual_Basic). These languages compile to [Common Intermediate Language](https://en.wikipedia.org/wiki/Common_Intermediate_Language) (CIL - formerly known as Microsoft Intermediate Language MSIL). At the time, the main competitor to .NET was [Java](https://en.wikipedia.org/wiki/Java_(programming_language)). It is similar to .NET but was designed for Cross-Platform compatibility from the ground up. Java included the cross-platform UI framework [Swing](https://en.wikipedia.org/wiki/Swing_(Java)). Soon after the release of .NET, the [Mono](https://en.wikipedia.org/wiki/Mono_(software)) platform was released in 2004. This Framework allows libraries to be compiled to CIL and run on platforms like Linux. However, UI technologies like [Windows Forms](https://en.wikipedia.org/wiki/Windows_Forms) built on .NET could not be run on other platforms because they relied on native components of the Windows operating system. The Mono platform evolved, and developers created several UI components for each platform, but no single Cross-Platform UI component became a *de facto* standard. Microsoft does not push any UI technology as the answer for all platforms.

Modern Ecosystem
----------------

Things have changed a lot since the early days of .NET. There are now at least five major operating systems that people use daily: Windows (desktop/tablet), OSX (desktop), Android (phone/tablet), iOS (phone/tablet), Linux (mostly desktop). There is also a raft of other platforms to drive devices like wristwatch and TV components such as [Tizen](https://www.tizen.org/). The deployment mechanism for apps is also quickly changing with the advent of App Stores. The standard method of deploying apps to phones is now via the various App Stores, and people are coming to expect that their phones and tablets be able to run the same applications that their desktops run.

***Security is now a huge consideration*** when it comes to app development deployment. Desktops are lagging behind phones in that many applications still require the user to download the application as an installer and then install it manually. It is a colossal problem, and any developer that ignores this issue does so at their peril. If a user is forced to download apps from the internet, they get exposed to Malware. They lose control of application-level permissions and open their computers up to spyware. No authority vets the software. As users become more savvy, less and less are tolerating this situation and are opting for apps that are deployed via the App Stores or in a browser.

The point is this:

***You need to deploy your app securely, and you need to do so on as many platforms as possible***.

Modern Runtimes: Mono/Xamarin, .NET Core, Web Assembly
------------------------------------------------------

[Xamarin ](https://en.wikipedia.org/wiki/Xamarin)is a company whose engineers created the Mono platform to run CIL across many platforms. In 2016 Xamarin was acquired by Microsoft. They still maintain the Mono platform, which allows C# code to run on iOS, Android, and other platforms. Developers often use Xamarin as a synonym for Mono, but Xamarin is also a suite of CIL libraries that drive apps on non-Windows platforms.

[.NET Core](https://en.wikipedia.org/wiki/.NET_Core) is a modern desktop runtime environment that is similar to .NET Framework. It runs on operating systems like OSX, Linux, and Windows. Since its inception, developers built several UI frameworks on top of the Mono platform, so the ability to build front-end applications that run across platforms has become a reality. Some of these UI frameworks also run on Mono. It means that the ability to build apps that are pixel perfect in similarity across platforms is now a possibility.

Developers cannot overlook [Web Assembly](https://webassembly.org/) (Wasm). It is an emerging technology built into browsers and supported by the [W3C](https://www.w3.org/wasm/). This technology essentially allows a developer to compile code that can run inside a browser in a way that is as safe to run as JavaScript. Most importantly, it is a language-independent "binary instruction format for a stack-based virtual machine". C# compiles to this instruction format, and therefore a new world of UI capabilities is opened up for C# developers. C# code can runs inside a browser in a similar way to [Silverlight, ](https://en.wikipedia.org/wiki/Microsoft_Silverlight)which is now defunct.

[XAML ](https://en.wikipedia.org/wiki/Extensible_Application_Markup_Language)also requires a mention here. XAML is the markup language that is used to define UI across most C# based UI frameworks declaratively. The three platforms mentioned here all support XAML. XAML is to C# what HTML is to JavaScript. However, XAML goes a lot further than HTML in that it includes styling like CSS, but also extremely powerful data binding out of the box.

Here are the UI technologies based on these runtimes.

[Uno Platform](https://platform.uno/)
Enroll in my free course [Introduction To Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661).

![Uno Platform](/assets/images/blog/xplat1/uno.png)

[Image Source](https://platform.uno/code-samples/)

Uno Platform is an open-source XAML based UI library and platform that runs on iOS, Android, and Web Assembly. It renders to native controls but attempts to emulate the Windows UWP graphics library on non-Windows 10 platforms. It has a modern Windows 10 look and feel and is easily customizable with XAML styling.

"Universal Windows Platform Bridge to allow UWP based code to run on iOS, Android, and WebAssembly".

https://github.com/nventive/Uno

**Platforms:** iOS, Android, WebAssembly, Windows (As UWP)

**App Stores:** Apple Store, Google Play, Microsoft Store (When compiled with UWP)

**Render Type:** Native. The behavior of controls remains as they do on the native platform. However, by default, controls are styled like a Windows 10 app and be close to pixel perfect the same. Styling can be changed to appear more like the native platform.

[Xamarin.Forms](https://docs.microsoft.com/en-us/xamarin/xamarin-forms/)

![Xamarin.Forms](/assets/images/blog/xplat1/xf.png){:width="100%"}

[Image Source](https://developer.xamarin.com/samples/mobile/Weather/)

Xamarin.Forms is an open-source XAML based toolkit that supports Android, iOS, Windows UWP, preview OSX out of the box, and is likely to support Linux in the future. It is a phone driven UI technology but bridges the gap between phone, tablet, and desktop by rendering declarative XAML out to native UI components.

Xamarin.Forms exposes a complete cross-platform UI toolkit for .NET developers. Build fully native Android, iOS, and Universal Windows Platform apps using C# in Visual Studio.

https://docs.microsoft.com/en-us/xamarin/xamarin-forms/

**Platforms:** iOS, Android, Tizen, Windows (As UWP). Other platforms are in [preview](https://github.com/xamarin/Xamarin.Forms/wiki/Platform-Support).

**App Stores:** Apple Store, Google Play, Microsoft Store

**Render Type:** Native. Apps built for iOS look and behave like iOS apps. Android apps look and behave like Android apps.

## [Avalonia](http://avaloniaui.net/)
![Avalonia](/assets/images/blog/xplat1/avalonia.jpeg){:width="100%"}

[Image Source](https://devdigest.today/post/358)

Avalonia is an open-source XAML based UI library and platform that runs on Windows, Linux, and OSX. The community based it on the Windows [WPF ](https://en.wikipedia.org/wiki/Windows_Presentation_Foundation)UI framework. As such, it is mainly targeted for desktop usage and will probably not be a good fit for mobile applications.

We support Windows, Linux and OSX with experimental mobile support for Android and iOS.

http://avaloniaui.net/

**Platforms:** Windows, Linux, and OSX, and experimental support for iOS, and Android. The technology is mainly .NET Core based.

**App Stores:** Unknown. Releasing an Avalonia app via the App Stores is probably going to be possible in the future. However, currently, there is no clear documentation or pathway for doing this.

**Render Type:** Pixel Perfect. The platform takes control of rendering and does not rely on native components to render.

How To Choose
-------------

***Do you need browser support?***

If so, Uno Platform is probably the clear winner here. It's the only platform that supports Wasm from the ground up. Building an app with browser support from the ground up is a smart choice because it guarantees maximum penetration. Users do not have to download an app from the App Store to use your app, but they have protection from Malware.

*Note: Xamarin.Forms and Uno Platform can work *[*together*](https://github.com/nventive/Uno.Xamarin.Forms)*.*

***Do you need native look and feel?***

If so, Xamarin.Forms may be the right choice. Like Uno platform, Xamarin.Forms allows UIs to be defined declaratively across platforms but renders the UI based on the native platform. So, the user is not shocked by controls that do not behave in a platform-specific way. By default, the styles approximate the platform's native look and feel while Uno Platform tends to look more like Windows 10. However, both Xamarin.Forms and Uno Platform allow styling for their native platforms.

Xamarin.Forms currently has the full support of Microsoft, so there is guaranteed support for the near future. However, Uno Platform is an impressive platform that is certainly a worthy competitor for Xamarin.Forms. If you are going to build a native app, you need to try out both Uno Platform and Xamarin.Forms to see what suits your project best.

***Are you targeting desktop with users who download applications outside of App Stores?***

It is, in a sense, a rhetorical question. As mentioned earlier, you shouldn't expect your users to download apps outside of the store or browser. However, there are legitimate cases where your users may prefer a custom fit desktop experience that is pixel-perfect across Linux, Windows, and OSX with all the power of the .NET Core runtime. When this is the case, Avalonia is your best bet.

As a UI library though, Avalonia should not be underestimated. It is familiar to any WPF developer and is very easy to get running and dive straight in. The robust platform .NET Core makes it a convincing choice.

Note: This article has been edited for clarity. Also, there are several other C# technologies that have not been mentioned here. They will be part of a follow up article.