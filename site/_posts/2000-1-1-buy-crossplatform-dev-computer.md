---
layout: post
title: "How To Buy a Computer for Cross-Platform Development"
date: "2020/08/28 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/computer/header.jpg"
tags: cross-platform
categories: [software development]
permalink: /blog/:title
---

Computers are expensive, and you may need to buy a Mac and a PC as a mobile developer. As a mobile developer, you will spend a large amount of time building and deploying to phones or using emulators. All this can eat time on a slow computer. This article aims at guiding you on the decision-making process of buying a computer, and hopefully, how to save money. I’m a [Xamarin](https://dotnet.microsoft.com/apps/xamarin) developer, but most of this article will help people who develop for [Flutter](https://flutter.dev/), [React Native](https://reactnative.dev/), Blazor, Vue.js, React, Angular, or do cross-platform development in general.

Support this blog by signing up to my course [Introduction to Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661)

_Disclaimer: I’m not a hardware expert, and this is not business advice. This is information based on my experience only._

CPU Mark
--------

I will refer to a measurement called CPU mark. This is a good, reasonably objective way to measure the speed of your CPU. I won’t spend hours explaining the intricacies of different CPU features for different purposes. You should know that CPU Mark will give you a rough indicator of speed, and it is very useful for comparing computers.

Mac, PC, or Both?
-----------------

The first question you need to ask is whether or not you need both. Mac looks like a good option because you can deploy to iOS and Android, and you can simulate iOS on a Mac. You can also run [Parallels](https://www.parallels.com) to run Windows as a virtual machine. This means that you can do Windows development. However, there are drawbacks to Macs. The main drawback is that generally speaking, they are more expensive than PCs. If you have a large budget, you should probably go for the top of the range Mac that suits your needs. If you need portability, you should go for a MacBook Pro, but the faster Mac Pros will be faster than the MacBooks. If you have plenty of money and only want one computer, and the Mac is fast enough, go for the Mac. Personally, I have both because Macs are really nice for certain things, while a high-end PC is far less expensive than a high-end Mac.

Mac
---

For many people, high-end Macs are prohibitively expensive, but if you don’t have a high-end one, you will be wasting time. It will be slow, and your ability to code will suffer. I have the best custom spec mac-mini available at the time of writing. This is a good computer, and I would recommend it if you want to spend the money. However, it’s not as fast as a PC at around the same price. Generally speaking, Mac-minis have decent value, are very quiet, and reliable.

**Mac mini (2018)**

*   3.2 GHz 6-Core Intel Core [i7-8700B](https://www.cpubenchmark.net/compare/Intel-i7-8700B-vs-Intel-i7-8700/3388vs3099)
*   16 GB 2667 MHz DDR4
*   Intel UHD Graphics 630 1536 MB

I believe [this article](https://www.cpubenchmark.net/cpu.php?cpu=Intel+Core+i7-8700+%40+3.20GHz&id=3099) to describe the CPU. It rates the CPU Mark at about 12,200, which is very good for the price.

Opt for Mac if you want to write macOS apps, prefer the operating system, and want more iOS support.

PC
--

If you go for a PC only, you won’t get an iOS simulator out of the box. It is possible to deploy apps to a physical iOS device from Windows, and many people prefer doing this. However, this is a relatively recent turn of events and is not well-supported yet. [Apparently](https://docs.vmware.com/en/VMware-Fusion/11/com.vmware.fusion.using.doc/GUID-474FC78E-4E77-42B7-A1C6-12C2F378C5B9.html), it is possible to run a macOS Virtual Machine from Windows, but I have never tried this, and I can’t vouch for how well this works. Apple has a habit of making it difficult for people to use their OS without the official hardware. Please hit me up if you try this. [This article](https://nicksnettravelsblog.azurewebsites.net/ios-dev-no-mac/) walks you through deploying a Xamarin app to iOS from Windows.

As you will see, PC gives you a lot of options for the $1000-$2000 mark that Macs simply don’t. You can buy a very fast PC for under $2000 USD if the parts are cheap in your local area.

AMD has recently entered the market with CPUs that have outstanding value. I bought this computer which was actually cheaper than the mac-mini. If you go by CPU Mark, this computer is about 2.5x faster than the Mac mini. It has double the RAM and double the disk space. The case is massive, but this computer is almost as quiet as a Mac-mini, and I can also run nearly any modern game at very high detail.

**DYI PC**

*   [CPU-AMD-3900X](https://www.cpubenchmark.net/cpu.php?cpu=AMD+Ryzen+9+3900X&id=3493) <- CPU 32,000+ CPU Mark
*   MB-ASU-X570PC RAM-DD4-32GVK8D
*   RAM-DD4-32GVK8D <- 32 GB RAM
*   VGA-MSI-1650VXS <- Decent gaming graphics
*   NET-TPL-T5E
*   CAS-CLM-S600TG
*   POW-CLM-MPY750C SER-SYS-ASS-70 <- Very quiet power supply
*   CT1000MX500SSD1 MX500 1TB 2.5″ SATA SSD <- 1TB SSD

Opt for PC if iOS is not your focus, and you don’t need to build for macOS. If you have a lower budget and choose this option, you will save time on builds, etc. This is a money-saving option, but you won’t have as good an experience on the Mac front.

Value For Money
---------------

When you buy a Mac, you pay for the hardware, the 5-year guarantee, and the finished product. If you buy a PC, you might have hardware compatibility issues, and you may have to add and remove hardware. You may need to take some parts back to the store or install Windows yourself. But, you get to choose the CPU. The CPU is the heart of your computer, and a fast CPU will decrease build and deploy times. CPU power is particularly relevant today because there has been a sudden jump in value for money. AMD are back, and they are challenging Intel. As you can see, most of the CPUs with the best value for money are AMD CPUs. Apple may also embrace AMD CPUs, but you are only free to buy the best value CPUs on PC for now.

![Passmark](/assets/images/blog/computer/passmark.png){:width="100%"}

Snapshot as at 23rd October 2020

If you choose a PC, keep an eye on [this page](https://www.cpubenchmark.net/cpu_value_available.html) because it gives you a good idea of the best value CPUs. Use it as a guideline, so you don’t waste money on CPUs with poor value.

Wrap-Up
-------

PCs can give you better value for money, but it comes at the cost of piecing the computer together or buying from a manufacturer. You could look at Macs as having excellent value because of the integration of the hardware, software, and the guarantee that all this will last for five years.

Of course, the development experience is a large factor. If you have the luxury of choosing, then go for the OS that suits you the best. Using the other OS as a Virtual Machine may be an option.