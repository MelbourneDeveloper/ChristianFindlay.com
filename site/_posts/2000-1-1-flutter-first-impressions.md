---
layout: post
title: "Flutter: First Impressions"
date: "2021/09/04 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/flutter/header.svg"
post_image_height: 300
image: "/assets/images/blog/flutter/header.svg"
tags: dart
categories: flutter
permalink: /blog/:title
---

[Flutter](https://flutter.dev/) is Google's cross-platform UI Toolkit. It uses the language [Dart](https://dart.dev/). I have a long history of building cross-platform apps with .NET and XAML. I created the first [Uno Platform Udemy course](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661). This post is about my first impressions, but the blog aims at giving .NET devs a window into the Flutter ecosystem to help evaluate if Flutter is a good choice for a given project.

### What is Dart?

Dart is a versatile programming language with C-like syntax and elements of both functional programming and object-oriented programming. It will be familiar for all C# and Java programmers and incorporates many aspects of the JavaScript and Typescript ecosystems. If you use C#, you won't have much trouble understanding Dart. I intend on blogging about some differences and oddities, but there is nothing about Dart that requires radically different thinking if you are used to .NET.

However, there are some features of Dart that make it distinct from C# and .NET. For example, you can compile Ahead Of Time (AOT) compile dart to machine language directly. This opens Dart up for performance that Just in Time (JIT) compiled languages may not be able to achieve. Dart also transpiles to JavaScript so you can use it directly in a browser.

You can directly edit Dart code in the browser like this. This code should give you a good idea of how similar Dart is to C#. Check out [Dartpad](https://dartpad.dev) for in browser Dart and Flutter editing.

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-inline.html?id=df8e2d154e5562f38441cd5aa0b39222&split=70&mode=dart"></iframe>

### What is Flutter?

‍  
[Google](https://dart.dev/) sums it up perfectly:

> Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, desktop, and embedded devices from a single codebase.

Flutter started out as an alternative to Xamarin and React Native for iOS and Android. It was very successful and became popular quickly. However, the Flutter team extended the model to browsers and desktops. Flutter now runs on all the major operating systems and works with all form factors with nearly pixel-perfect identical rendering. This makes it a true cross-platform technology comparable to [Uno Platform](https://platform.uno/).

At the time of writing, the .NET world is transitioning to use .NET MAUI, from Xamarin.Forms lineage. This is still in preview mode, and .NET MAUI does not target browsers or some desktop platforms, so Flutter and MAUI are not comparable. If you want to build native apps that run on desktops, phones and browsers, your two current options are Uno Platform and Flutter. Both have their strengths and weaknesses, and I intend on writing more about those in future.

### Why Cross-Platform UI?

Nobody wants to write a different app for each platform. It's expensive, time-consuming and quite often, apps look and feel completely different between platforms. If you work at a FAANG company, you probably have the resources to write native apps with the language peculiar to the platform and maintain multiple codebases. FAANG companies do this because they are willing to pay top dollar to squeeze out a tiny bit more performance and follow the platform's idioms. For everyone else, maintaining multiple native codebases is probably just a liability. An app might start out simple, but inevitably, as you add features, the codebases get exponentially harder to maintain and keep the degree of familiarity across platforms. Check out my video on .[NET Cross-Platform App UI Technologies](https://youtu.be/hzbS0lcQXRk).

Cross-platform apps have a checkered history. I was interested in cross-platform UI in the Java days before .NET became popular. Java was an up-and-coming technology, and it was easy to build cross-platform apps with it. When Microsoft released .NET, there was a promise of achieving the same thing with .NET, but in a nutshell, .NET splintered off into Mono, and for much of its life, the focus of .NET was on Windows development. Xamarin and Xamarin.Forms breathed new life into .NET as a cross-platform app technology, but it wasn't until Uno Platform became popular that you could run the same app on phones, desktops and browsers.

Flutter is a fresh start. Google rethought the paradigm, and now there is an alternative to .NET technologies.

‍![Dartpad](/assets/images/firstimpressions/dartpad.png){:width="100%"}

### My Experience

I am currently building an Asset Management System (AMS) with a Flutter UI. I developed the back-end with ASP .NET Core and gRPC. I have a background in asset management, and I decided to try out Flutter as a UI toolkit for building the app. I started with a Figma design and prototyped it with Flutter. The app is closed source, and I won't be releasing much information about it for the time being. But, I can describe the experience of using Flutter.

I mostly used XAML to build apps in the past. XAML gives .NET developers the ability to separate UI logic from the actual rendering and style of the controls. I can see benefits in this but the XAML ecosystem is currently quite fragmented, and I don't see Microsoft strongly pushing XAML. I still believe that Microsoft should push Uno Platform as a truly cross-platform technology but Microsoft is divided between MAUI and Uno Platform. It is not clear which technology the Microsoft community will use in future. Perhaps both.

Flutter does not have any of this baggage. Flutter's state management pattern is inspired by React. You don't declare UI controls with markup, you do it with code. In Flutter we call controls widgets. There is no binding. This seemed counter-intuitive after using XAML for a long time. But, Flutter embraces immutability. Instead of controls responding to model changes, Flutter widgets completely rebuild when their state changes. This is a familiar concept for people who like functional-style programming. It reduces the complexity of widgets and functional-programming concepts become a lot more useful.

After spending some time building a Windows desktop app, I can clearly see that Flutter is a well-designed powerful technology. I use Visual Studio Code but you can also use Android Studio. Even though Windows is in the beta channel, the tooling is amazing. The [widget inspector](https://flutter.dev/docs/development/tools/devtools/inspector) is top-notch and integrated into Code.

‍![Devtools](/assets/images/firstimpressions/devtools.png){:width="100%"}

Debugging with VS Code is next to perfect and there are amazing tools like the performance profiler:

‍![Profiler](/assets/images/firstimpressions/profiler.png){:width="100%"}


The list of established tooling goes on and on. Unit testing, widget testing, and automated testing are all there and are generally far easier to implement than .NET or C# code. This requires further explanation in further posts. My app is looking amazing, I have extensive test coverage, and I've not had a better front-end development experience in years.

### Wrap-up

‍  
I am deeply impressed by Flutter. I see Uno Platform and Flutter as the two major cross-platform technologies to keep your eye on. .NET and Flutter are complimentary technologies. Flutter works well with a .NET back-end and it's not too hard for developers to switch backward and forward between Dart and C#.

If you live in the .NET world, Uno Platform may be your best choice, but I also see that Flutter is definitely emerging quickly. If your team has .NET resources, Xamarin is still probably the safest bet. But, C# programmers can learn Flutter quickly and there may come a time when the cost of maintaining a Xamarin codebase actually outweighs the cost of maintaining a Flutter one. Regardless, I will be documenting how my opinion on this evolves over time.