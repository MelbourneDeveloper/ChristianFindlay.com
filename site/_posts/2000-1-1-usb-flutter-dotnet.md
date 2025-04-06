---
layout: post
title: "Android HID/USB with Flutter and .NET"
date: "2020/10/09 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/flutnet/header.png"
image: "/assets/images/blog/flutnet/header.png"
tags: usb hid xaml
categories: flutter
permalink: /blog/:title
---

[Flutter](https://flutter.dev/) is an emerging UI technology by Google. [Flutnet](https://www.flutnet.com/) brings Flutter and .NET together. It allows you to create a Flutter UI with .NET logic. [Device.Net](https://github.com/MelbourneDeveloper/Device.Net) is a cross-platform framework for connected devices that runs on Android, UWP, .NET, and macOS and Linux via a bridge. This sample reads the temperature from a USB thermometer using .NET and the Flutter UI updates.

Grab the sample on the develop branch [here](https://github.com/MelbourneDeveloper/Device.Net/tree/develop/src/Samples/Flutnet). The [readme](https://github.com/MelbourneDeveloper/Device.Net/blob/develop/src/Samples/Flutnet/README.md) explains how to get the sample running.

<iframe width="560" height="315" src="https://www.youtube.com/embed/CUUV3lkxQ9M" title="Hid Usb Thermometer with Flutter (Flutnet) and Device.Net (.NET)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

### What is Flutter?

Flutter is a cross-platform, [open-source](https://github.com/flutter/flutter) UI technology that uses the programming language [Dart](https://dart.dev/). It is growing in popularity. It mainly targets iOS and Android, but support for web and desktop is in the works. Importantly, Flutter renders its own widgets so that functionality and animations are the same across platforms. It does not use native controls, so the app looks exactly the same on all platforms. The Flutter homepage has a browser sample that you can run directly.

### Flutter Vs. XAML

I’m a massive fan of XAML. XAML is a markup language for defining UI and UI behavior. If you don’t know about XAML, you should check out [Uno Platform](https://platform.uno/) and [AvaloniaUI](https://avaloniaui.net/). In a nutshell, XAML allows you to define UI without writing code. This also makes it easier for UI designers like those in Visual Studio and Blend for Visual Studio to allow you to edit the UI visually.

Check out my course [Introduction to Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661).

Flutter [doesn’t embrace](https://flutter.dev/docs/resources/faq#where-is-flutters-markup-language-why-doesnt-flutter-have-a-markup-syntax) markup definition. Flutter requires you to write Dart code to define UI. You could argue that this is a good or bad thing, but the bottom line is that you will need to learn Dart, and you will not have a visual editor for your UI at this point.

Despite this, Microsoft developers must pay attention. The Flutter community is already massive, with over one hundred thousand stars on Github.

### What is Device.Net?

Device.Net is a cross-platform framework for communicating with USB, HID, and Serial Port devices. Write code once and run the code on any of the supported platforms. Device.Net unifies connectivity by putting a layer over the disparate platform-specific APIs for talking to devices. The current version of Device.Net is 3.x, and 4.x is well underway. The sample uses Device.Net 4.x, which is currently in alpha mode. The sample exists in the develop branch.

### Why Flutter and Device.Net?

If you’re planning to build a Flutter UI, you may find a lack of unified USB connectivity APIs lacking. You might use the native Android USB API, but this will be different on other platforms. Device.Net exposes a [single API](https://github.com/MelbourneDeveloper/Device.Net/wiki/Quick-Start#example-code) across all platforms. On top of this, Flutnet brings the richness of the .NET development environment to the world of Flutter. It’s too early to say, but Flutter and .NET may compliment each other.

### Wrap-up

Check out the sample and send your feedback on Github. I am working hard to improve the USB connectivity experience across platforms, and Flutnet is working hard to bridge the two technologies: Flutter and .NET. [Follow me on Twitter](https://twitter.com/CFDevelop) for updates about the sample and the release of Device.Net 4.x.
