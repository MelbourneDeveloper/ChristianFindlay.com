---
layout: post
title:  "xUnit - Strongly Typed Test Data"
date:   2019/06/30 00:00:00 +0000
categories: [dotnet]
tags: testing
author: "Christian Findlay"
post_image: "/assets/images/blog/xunit/header.png"

permalink: /blog/:title
---

[xUnit](https://xunit.net/) has a quirky system for consuming test data. Strongly typed test data can be specified with the MemberData attribute and the Theory attribute but it's not intuitive.

The MemberData attribute allows you to specify a getter that returns an enumeration of object arrays. It expects the type to be `IEnumerable<object[]>`. The trick is to return a List with multiple object arrays in it. Here is some example code for the getting the strongly typed test data. This makes for much cleaner unit testing.

This repo can be cloned [here](https://github.com/MelbourneDeveloper/Samples). This is the [source code](https://github.com/MelbourneDeveloper/Samples/blob/6b69b4933143fe9b2e43385f3b5acb1b85724075/xUnit/Sample.Tests/Sample.Tests/UnitTest1.cs#L6) for the unit test.

The getter for the test data:

![Test Data Method](/assets/images/blog/xunit/testdatamethod.png)

This is the SampleData class:

![Sample Data Class](/assets/images/blog/xunit/sampledataclass.png)

This is how your unit test can consume the strongly typed data:

![Usage](/assets/images/blog/xunit/test.png)
