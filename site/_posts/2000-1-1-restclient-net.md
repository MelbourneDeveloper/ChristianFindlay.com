---
layout: post
title: "RestClient.Net"
date: 2016-08-14 00:00:00 +0000
author: "Christian Findlay"
post_image: "/assets/images/blog/restclientdotnet/logo.png"
categories: [dotnet]
tags: restclient-net csharp
permalink: /blog/:title
---

*Edit: this library has undergone multiple iterations since this early blog post. It is no longer in beta, and has been moved to GitHub. Check the repository for the latest samples*

Today I released an Open Source project under the MIT license called RestClient.Net.

[RestClient .NET](https://github.com/MelbourneDeveloper/RestClient.Net)

[License](https://github.com/MelbourneDeveloper/RestClient.Net/blob/master/LICENSE)

## Git Clone:

https://github.com/MelbourneDeveloper/RestClient.Net.git

This is a library which makes REST calls easy on any .NET related platform. It is designed to be simple, and easy to get going on any platform without trying to do any of the heavy lifting like parsing JSON etc. Here's a look at the design principles.

## Open Source

Microsoft has released many platforms so it's impossible for me as a developer to test all the different permutations of use for RESTClient .NET, so I've open sourced this project in the hope that others will test, and contribute fixes and features. Please feel free to contribute.

## Markup Language Agnostic

REST is a markup language agnostic technology. That means that any markup language can be used to transfer data. Most people however choose to use JSON. RESTClient .NET works well with JSON. The sample applications give many examples of how to leverage the Newtonsoft Json.NET library. Although RESTClient .Net does not tie you to JSON or require you to use the Json.NET library. You can also use XML or any other markup language. For example, the samples contain examples where .NET DataContract serialization is used. This is very useful to achieve WCF style serialization/deserialization functionality over REST.

##  Strong Types

RESTClient .NET deals with strong types wherever possible. Passing markup language backward and forward from REST services shouldn't require directly dealing with markup strings, so RESTClient .NET aims to allow you to deal with your data model directly. Examples of this can be found in the sample apps that can be downloaded through the Git repo.

## NuGet

To install RestClient .NET, run the following command in the [Package Manager Console](https://docs.nuget.org/docs/start-here/using-the-package-manager-console)

Install-Package RestClient.NET

![NuGet](https://uploads-ssl.webflow.com/62b7c41e60a360d43510906f/62ba6f9f3bf03223f61c3f86_nuget.png){:width="100%"}

## All Platforms

The library will work on .NET Framework 4.6+ (Windows), .NET Core (all platforms), Windows UWP (Windows 10 / Windows 10 Phone), Xamarin Forms Portable (iOS, Android, Windows 8.1, Windows 8.1 Phone). If you find that any platforms are missing from the NuGet package, please clone the Git repo for the full set of library projects. Note: you will need to compile without the strong name keys.

*Edit: Silverlight as a platform has been removed.*

##  `async` / `await` Keywords

All processing is done on a background thread and this includes serialization and deserialization. This means that your UI is never locked up by any process going on underneath the hood. Your UI will be responsive with RestClient.NET

##  Simplicity

The code is designed to be very simple, and terse. Here is an example of how to GET a complex data structure in two lines of code:

```csharp
var countryCodeClient = new RESTClient(new NewtonsoftSerializationAdapter (), new Uri("http:/services.groupkt.com/country/get/all"));
var countryData = await countryCodeClient.GetAsync<groupktResult<CountriesResult>>();
```