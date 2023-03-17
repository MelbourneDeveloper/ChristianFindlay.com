---
layout: post
title: "Cross-Platform Vs. Native Apps"
date: "2022/07/21 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/crossplatform/header.jpg"
tags: cross-platform
categories: [software development]
permalink: /blog/:title
---

Once in a while, I get into a Twitter debate about cross-platform vs. native apps. It's a difficult conversation because people have very strong opinions about this. Native proponents point out that native apps tend to be smaller and more performant than apps built with cross-platform toolkits. It's a fair point, but that's not the end of the story. Here are my thoughts, and I hope I can shed some light on the subject.  

A Brief History of Cross Platform
---------------------------------

Cross-platform is not a new phenomenon, although we often talk about it like it is something new. If you had used the internet in the late 90s, you would have experienced [Java Applets](https://en.wikipedia.org/wiki/Java_applet). These were small cross-platform apps that run in the browser. Applets were not a big success in the long run, but the underlying Java technology was. You could build a UI and run it on any desktop and expect it to look and behave the same everywhere. We still use this technology today. If you use Jetbrains [IntelliJ IDEA](https://github.com/JetBrains/intellij-community) or any derivatives like [Android Studio](https://developer.android.com/studio) or [Rider](https://www.jetbrains.com/rider/), you are using a cross-platform app built with the original Java Swing library. This is the same library we built Java Applets with back in the day.   

Many cross-platform toolkits came and went inside and outside the browser. Some notable toolkits were [Adobe Flash](https://get.adobe.com/flashplayer/about) and [Microsoft Silverlight](https://www.microsoft.com/silverlight/). These toolkits' main issues were 1) security and 2) lack of phone support. These toolkits didn't survive entirely, but much of the technology persists in different forms.   

Today, we have many cross-platform toolkits to choose from, most of which are phone oriented: [Flutter](https://flutter.dev/),  [React Native](https://reactnative.dev/), .NET ([Uno Platform](https://platform.uno/), [AvaloniaUI](https://avaloniaui.net/), [MAUI](https://docs.microsoft.com/en-us/dotnet/maui/what-is-maui)) and others. Some try to harness the native look, feel and behaviour of the OS, and others try to render a pixel-perfect experience across platforms.   

The Problem
-----------

App development is hard. If you have a successful app, the chances are that you will write at least two: one for the web and one for phones. The problem I witness is that businesses often expand on this and write three or more apps. Every app is a long-term maintenance liability, and each app requires specialized skills. If you create any app, there are no guarantees that you will build a beautiful and stable one unless you are willing to spend a lot of time and money on making it perfect.   

If we're generous, we can say that any app has around a 50% chance of pleasing users and being stable. If we built two apps, that percentage drops to 25%. If we build three, that drops to 12.5%. That's a seven in eight chance that at least one of the apps will be problematic, annoy users, or have recurring bugs. A business has a solid chance of making one or maybe two good apps. Every app you add to this increases the likelihood that one app will drag down the goodwill that the other apps create.   

Code is a liability. The more of it you have, the slower you will adapt to change, and the more likely things will go wrong. The aim of a software business is to put downward pressure on the complexity and size of the codebase. That doesn't mean that the business sacrifices quality. It means that if quality comes at the cost of complexity and maintenance, a decision-making process weighs these things up.  

If you build native apps, you increase the number of codebases you need to maintain. You might like Swift personally, but someone else needs to build the Kotlin version if you build a Swift app. There is no escaping the fact that you need to target at least two phone platforms and possibly desktop platforms.    

If you ask someone in your team if they are an expert in Kotlin or Swift, you will get decisive hands up somewhere. Someone will love building in that language and have an incentive to build with that toolkit. When you consider that developers [routinely underestimate](https://en.wikipedia.org/wiki/Planning_fallacy) the time it takes to create - let alone maintain an app, you can see that building multiple apps is fraught with danger.  

Cross-platform Single Source to the Rescue?
-------------------------------------------

No. There is no overcoming this issue. There are many operating systems, and each has different requirements. For example, I write cross-platform [USB and HID frameworks.](https://github.com/MelbourneDeveloper/Device.Net) USB connectivity is completely different across platforms. If you want to connect to a USB device on multiple platforms, you're in for a nightmare. I can say from experience that putting a cross-platform layer over this is very difficult.   

This is only the tip of the iceberg. Native toolkits provide a tight fit for the OS and give you the best possible tooling for that platform. The OS developer is vested in providing a development experience that encourages developers to build for their platform. Building an Android app with native Kotlin will likely result in a small and performant app, and the tooling will be great.  

Knowing this, shouldn't we build all apps with native toolkits?  

The answer is, of course: it depends.  

The brutal truth is that you have two choices: maintain more apps, or fall back on a single source toolkit with some compromises. If you use a cross-platform, single-source toolkit, chances are it won't be as perfect as the native toolkit. But, software is about trade-offs. We make decisions based on reality, not the ideal world.   

The Decision-Making Process
---------------------------

Do you have infinite resources and time? If so, the choice is easy: build native. You can hire the best developers for each platform, and up to a certain extent, you can hire more until the team or teams can reliably produce quality products. Even then, there is no guarantee that you won't get one bad apple in your suite of apps, but theoretically, given enough time and money, you should be able to pull those apps out of their poor state.  

The business proposition is clear for the other businesses (including Facebook, Instagram, Microsoft, BMW, Google, eBay, Alibaba, Tencent, and countless others): put your time and resources into building one single-source app that works well. All these companies use cross-platform toolkits, and they obviously work well. If they didn't, these giant corporations wouldn't use them.   

Check out the list of companies using [Flutter](https://flutter.dev/showcase) (self-rendering) and [React Native](https://reactnative.dev/showcase) (more native-UI).  

Your business does not have infinite time and resources. That app you started recently will become a liability for you to maintain in the future. You will have to hire at least one person per app to maintain them. If you choose a cross-platform toolkit, you can invest your time and money into making that app as perfect as possible.   

You will make some compromises. You might find that the app does not have the perfect native look and feel. It might be slightly larger than a native version, but there are always ways to reduce app size, improve performance and please your users. It's very easy to build garbage apps that annoy users even with the native toolkit. However, one or two good devs are far more likely to produce one quality app than multiple teams are to produce multiple quality apps.   

A Few Things To Think About
---------------------------

A common conception about cross-platform apps is that the UI necessarily deviates from the native look and feel. This is not true. Firstly, toolkits like MAUI and React Native use native controls, making it easy to achieve the native look and feel. Flutter does take a different approach. Flutter does take on the burden of rendering the UI, but there is plenty of [tooling](https://docs.flutter.dev/resources/platform-adaptations) to make things like [wait indicators](https://api.flutter.dev/flutter/material/CircularProgressIndicator/CircularProgressIndicator.adaptive.html) and scroll inertia look and feel like the native platform. Flutter goes a long way toward making your app feel like a native app, but if that isn't enough, you can use [native UI](https://docs.flutter.dev/development/platform-integration/android/platform-views) within your Flutter UI and drop back to [native code](https://docs.flutter.dev/development/platform-integration/platform-channels) when necessary.   

In a  nutshell, when people complain that cross-platform toolkits don't have a native look and feel, they are often attacking a straw man.   

On top of this, consistent look and feel are extremely important. People often underestimate the value of having an app look and behave similarly. For example, I've seen apps that round currency differently between Android and iOS. This is generally unacceptable, and cross-platform toolkits can solve this problem.   

Consistency is a branding issue! You want your users to recognize your app wherever they decide to use it.  

Wrap-up
-------

This isn't about disparaging native toolkits. They have their place, and if you want to build an OS-specific app, you should use the native toolkit. It's about the reality of maintaining apps. If you want to build your app twice with the native toolkit, consider this carefully and understand how much risk and effort are involved. Don't shy away from the fact that native toolkits mean at least one extra codebase.

> Nobody will ever argue that getting a cross platform app to work smoothly is easier than doing the same thing on native. But if you've ever tried to create two native apps that look the same and then maintain them both, you'll never argue that it requires less resources

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Nobody will ever argue that getting a cross platform app to work smoothly is easier than doing the same thing on native. But if you&#39;ve ever tried to create two native apps that look the same and then maintain them both, you&#39;ll never argue that it requires less resources</p>&mdash; Christian Findlay (@CFDevelop) <a href="https://twitter.com/CFDevelop/status/1550069482038562817?ref_src=twsrc%5Etfw">July 21, 2022</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

<sub><sup>[Photo](https://www.pexels.com/photo/facebook-application-icon-147413/) by Pixabay from Pexels</sup></sub>