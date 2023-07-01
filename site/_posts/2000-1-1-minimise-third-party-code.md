---
layout: post
title: "Minimize Your Team's Dependence on Third Party code"
date: "2023/06/28 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/statefulfactory/header.jpg"
image: "assets/images/blog/statefulfactory/header.jpg"
description: ""
tags: 
categories: [software development]
permalink: /blog/:title
---

Every software ecosystem comes with core functionality, and external libraries to expand upon the core functionality. Sometimes the core team provides the libraries, and sometimes 3rd parties like open source maintainers, or for-pay library developers provide these libraries. 3rd party libraries are critical for any ecosystem, and the open source developers that create and maintain them for free are a massive asset to the ecosystem. However, 3rd party libraries are not free from encumberance and this article explains why you should strongly consider reducing the number of libraries, and total amount of 3rd party code your team uses.

## Core Vs. Extensions

Every ecosystem has some core code. There are some special characteristics about this code:

- The core team manages and maintains this code. They upgrade it as the language evolves, or deprecate it if it becomes too problematic. 
- Every app has access to it. You don't need to install an external package to use it. 
- In most cases the core code is well-tested, particularly for issues like performance and memory usage. 
- Every developer sees the documentation for this code. Over enought time, most developers become familiar with this core code

Extension libraries, plugins or packages don't have necessarily have these characterists even when the core team maintains the library.

## Third Party Libraries

Most ecosystems have their own package managers such as [npm]() (JavaScript/Typescript), [pub dot dev]() (Dart), [NuGet]() (.NET), [Python's Thing] and so on.  Anybody can create a library and throw it up for other people to use. Most libraries in most ecosystems are open source, so you can check out the code yourself, or fork it and use it as you need as long as you follow the license. However, most of the package managers don't have any quality control. If you want to check the quality of a library, you need to inspect the code yourself.

So, how do you know which libraries are of high quality, and which ones are poor? 

It's a popularity contest, and not necessarily a fair one...

On its face, the competition between libraries may seem like a level playing field, but it's not. Package managers, and the GitHub repos that accompany them generally publish statistics about the libraries, such as popularity, downloads, stars etc. So, first in best dressed. If your library is the first library to do a certain thing, it's likely it will score well, and competing packages will forever be playing catch up simply because the first package has been doing it longer. A package with thousands of stars looks like it has higher quality than a package a a few stars, but the truth is that these statistics tell you nothing about the quality of the library. They are only popularity markers.

On top of this, social media influencers decide which packages get the most attention, and they flood channels like Twitter, Medium, and YouTube with blog posts and videos about these packages. While I cannot offer any definitive proof that money changing hands affects the popularity of libraries, I can tell you that I have included sponsored posts for technology on my website, and several people claim that open source maintainers have contacted them about paid advertising. [tweet] The extent to which this occurs is a complete mystery but there are incentives for businesses to pay for the promotion of their own libraries [citation].

## How Can I Pick Good Libraries?

All is not lost. Some 3rd party libraries are great, necessary even.