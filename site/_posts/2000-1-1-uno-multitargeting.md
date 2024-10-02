---
layout: post
title: "How to Move Uno Platform Pages to a Multi-Targeting Library"
date: "2020/08/25 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/uno/uno.gif"
image: "/assets/images/blog/uno/uno.gif"
tags: uno-platform cross-platform visual-studio
categories: dotnet
permalink: /blog/:title
---

You can move Uno Platform pages and other code into a multi-targeted library that you can reference from the Uno Platform head projects. This is much more convenient than using Visual Studio Shared libraries. Shared libraries don't seem to have full support in Visual Studio, and some features like quick refactors often don't work. This article briefly explains what I did to get this working. I completely removed the shared library in my sample. You can clone my [working sample](https://github.com/MelbourneDeveloper/Samples/tree/master/UnoCrossPlatformTemplate) here.

Check out my Udemy course [Introduction To Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661).

This video gives you a quick overview of creating a multi-targeting library and moving a page into it. 

https://youtu.be/MYEwMvQd9SM

[This article](https://nicksnettravels.builttoroam.com/uno-crossplatform-template/) gives you a much more comprehensive step by step guide to converting an existing solution to used a multi-targeting library. Also, this process seems support hot-reload.

The trick is that this template project uses SDK type MSBuild.Sdk.Extras . These types of projects build for all the different platforms mentioned. Here is some of the config in the csproj file. The noteworthy part is the TargetFrameworks. We can't merely build for .NET Standard. We need libraries for all the platforms we want to target.

```xml
<PropertyGroup>   
	<TargetFrameworks>uap10.0.16299;netstandard2.0;xamarinios10;xamarinmac20;MonoAndroid90;monoandroid10.0</TargetFrameworks>
    <!-- Ensures the .xr.xml files are generated in a proper layout folder -->
    <GenerateLibraryLayout>true</GenerateLibraryLayout>
    <LangVersion>8.0</LangVersion>
    <Nullable>enable</Nullable>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
</PropertyGroup>
```    

I took the time to add some basic features to the project so that you can get started with Uno Platform development quickly. Also, it gives you Cat Facts! The only extra dependency I have added is to [RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net), which the app uses to make Web API calls. These are the features of the project at the time of publishing this article. I will try to update and fix this sample moving into the future.

*   Current version of Uno Platform (3.0.12)
*   C# version 8
*   FxCop with my flavor of code rules. This prevents common coding mistakes. Check out the documentation at the [Roslyn Github repo](https://github.com/dotnet/roslyn-analyzers).
*   RestClient .Net for APIs
*   ViewModel with binding
*   ICommands
*   Converters
*   **_No shared project_**
*   Nullable turned on. This a feature of C# 8 to reduce the need for null checking

In Progress

*   Hot reload doesn't seem to work. Shout out if you know why!
*   There is a build problem on Mac because it cannot build for UWP. Let me know if you know how to ignore this on Mac for Visual Studio

Watch a video of the app:
<iframe width="560" height="315" src="https://www.youtube.com/embed/oOMvHV1U82w" title="Uno Platform Cross-Platform Template" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Wrap-up
-------

Grab the sample and get started building an app. If you found this information useful, check out my Udemy course [Introduction To Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661).