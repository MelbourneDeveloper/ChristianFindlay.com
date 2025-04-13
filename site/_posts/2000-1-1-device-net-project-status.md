---
layout: post
title: "Device.Net Project Status"
date: "2022/08/06 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/devicenet/logo.png"
image: "/assets/images/blog/devicenet/logo.png"
tags: device-net usb hid
categories: dotnet
permalink: /blog/:title
---

[Device.Net](https://github.com/MelbourneDeveloper/Device.Net) is a cross-platform framework that attempts to put a layer over the top of USB and Hid. It runs on Android, UWP, .NET Framework and .NET. I wrote this for a crypto project (hardwarewallets) a long time ago, and this has ballooned. I'm pausing indefinitely and looking for other people to contribute. This post also touches on funding open source projects. For a discussion around open source and funding, please check out this [podcast episode](https://open.spotify.com/episode/3hf8BYDCRARuQt9vXN0O9m?si=efff2c09b8f043ac). I talk about open source with [Mr Bill](https://live.mrbillstunes.com/) and [Rockford Lhotka](https://lhotka.net/).  

Background
----------

In 2022 custom USB and Hid are still a reality. We all have USB devices and apps that communicate with them. I originally created the libraries Trezor.Net, KeepKey.Net and Ledger.Net to communicate with cryptocurrency hardwarewallets. You can use the same library to communicate with these devices on a PC or Android phone. Many device manufacturers contacted me and asked for help with .NET apps. This will continue because there is simply no alternative to USB yet. Bluetooth is not an alternative for low latency requirements like gaming peripherals.  

My original intention was to create something that the .NET community could get behind and contribute to. Sadly, the main contributions have only been to fix their projects' issues. In most cases, these were not open source projects and did not benefit the .NET community. In multiple cases, people took my open source code, close sourced it, and profited from my code. One person even had the nerve to ask for help with their closed source project after essentially profiting from my work.  

Over time, I have attempted to work on a few projects with USB connectivity and Device.Net, but people seem to underestimate device connectivity's complexity. Getting software working with USB devices is a long, difficult task. Testing is so much harder because unit testing simply does not cut it.  I have not been able to establish any revenue stream to support the development of Device.Net.   

The other avenue I had hoped to pursue was the [.NET Foundation](https://dotnetfoundation.org/) route. I went through most of the work to submit it to the foundation, but just look at the kind of [criteria](https://github.com/dotnet-foundation/projects#eligibility-criteria) that the foundation expects before submission. A large aspect of submission is the "Health Criteria" which basically feels like a popularity contest. Then came this [controversy](https://github.com/dotnet-foundation/Home/discussions/59). This all felt like too much, and from what I understand, the foundation does not directly fund OSS development work anyway.  

I put a lot of work in to this framework, and the only options for getting funding involve doing a lot more work that I don't have time for. I'm grateful for the enthusiasm from the community, and I also appreciate your frustration.  

Pull Requests
-------------

I appreciate that some people did contribute pull requests. However, testing Device.Net is extremely difficult. Even if your code is perfect, I need to pull my box of dongles out, and run the integration tests one by one on each platfrom with each device. I don't have the time to sit down and go through all of that for a once off fix. What Device.Net really needs people who are serious about implementing the missing functionality and adding heaps of unit tests. Ideally, you would need to have a box of dongles like I do.  

What Next?
----------

I still want to work on Device.Net but only if other people are willing to help. .NET developers deserve a library that works across platforms, and device manufacturers should be able to create config apps in .NET for this purpose. I do not understand why Microsoft has not yet developed a library for this. I would love it if they would contact me and negotiate something so that this library has a guaranteed future. But, I will not be contributing to this library for a while. I may respond to issues from time to time, but if I don't respond it's for the reasons that I enumerated here.   

I Want To Contribute
--------------------

I would be happy to hand some work over to someone else. If you want to put your name on a popular repo, this could be an opportunity for you. However, as I mentioned above, I have no interest in merging some small PRs to fix once-off issues. If you want to contribute, you need to:  

1) Understand the design philosophy and code style

2) Add tests to everything. If there are no tests to prove the code is working, I won't look at it.

3) Show me that you're interested in the framework itself. Contribute unit tests and code cleanup instead of fixes that only solve a problem in your situation.

4) Commit to furthering the framework and investigating issues etc.  

If you are interested in doing this, please reach out on [Twitter](https://twitter.com/CFDevelop).  

Wrap Up
-------

I apologise to those people who came here looking for a live project with a plan for the future. .NET developers deserve a framework that delivers that. Unfortunately, my countless hours of plugging and unplugging dongles while pulling my hair out for no money is on indefinite hiatus. The future of this library is now in the hands of the community.