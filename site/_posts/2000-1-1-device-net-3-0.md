---
layout: post
title: "Device.Net 3.0"
date: "2019/08/26 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/devicenet/logo.png"
tags: device-net usb hid cross-platform
categories: dotnet
permalink: /blog/:title
---

[Device.Net 3.0](https://github.com/MelbourneDeveloper/Device.Net) has been released. Device.Net is a framework for communicating with connected devices. Along with Device.Net Usb.Net, and Hid.Net 3.0 were also released. These libraries share infrastructure with Device.Net so that code can be shared for Usb, and Hid devices on Android, UWP, Windows, Linux, and OSX. Device.Net puts a layer across these platforms to handle things like connection events and so on. See the [Quick Start guide](https://github.com/MelbourneDeveloper/Device.Net/wiki/Quick-Start).

Join the conversation on the [Device.Net Discord Server](https://discord.gg/ZcvXARm)

Device.Net - Not Just Another USB/Hid Library
---------------------------------------------

There are dozens of C# USB and Hid libraries floating around. Most of them will do the job, but few of them handle both USB, and Hid, and fewer still work across platforms. If you're trying to build an application that crosses devices types, or platforms, you're going to have to build infrastructure and dependency injection so that the behavior between the platforms isn't different. With each release Device.Net has gotten progressively closer to achieving this goal for you, so you can be concerned with communicating with the device, not building framework.

Fixes / Enhancements
--------------------

If you've used earlier versions of the framework and found issues, you might find that they have been fixed in the latest version. Here are some of the [fixes and features](https://github.com/MelbourneDeveloper/Device.Net/projects/8). The framework is under active development and you can expect more fixes and features in future.

### More Hid Devices Show Up in Enumeration ([#97](https://github.com/MelbourneDeveloper/Device.Net/issues/97))

Some Hid devices were not showing up because there was a failure to get things like the serial number. This issue was fixed. The devices show up whether the properties can be obtained or not.

### Reads Return Read Byte Count ([#85](https://github.com/MelbourneDeveloper/Device.Net/issues/85))

Reads now return a struct that contains the number of actual bytes read. This means that it is now possible to tell where the data ends in a large array of data

### USB Interfaces and Endpoint Selection ([#19](https://github.com/MelbourneDeveloper/Device.Net/issues/19), [#77](https://github.com/MelbourneDeveloper/Device.Net/issues/77))

This was one of the biggest issues with previous versions. USB devices expected to use Interrupt endpoints (pipes) but this was not the normal use case. The UsbDevice class now allows switching between different Interfaces on the USB device, and different endpoints on the interfaces. There is a distinction made between bulk transfer and interrupt transfer. Bulk transfer will be the default, and the library will fall back on interrupt transfer by default for oddball devices that use interrupt transfer instead of bulk.

### Logging and Tracing ([#7](https://github.com/MelbourneDeveloper/Device.Net/issues/7))

Tracing supports dependency injection so that devices can write out that the data that is read from or written to the device. This will help with diagnosing issues with data transfer.

### USB Buffer Size Can Be Specified ([#63](https://github.com/MelbourneDeveloper/Device.Net/issues/63))

Another issue with previous versions was that read/write buffer sizes could not be specified. They can now be specified in the constructor of the device.

NuGet
-----

**Hid.Net** for Android, UWP, Windows apps, and

**Usb.Net** for Android, UWP, Windows apps

The Device.Net dependency will be automatically added. Contributions and feedback are always welcome on the GitHub page.