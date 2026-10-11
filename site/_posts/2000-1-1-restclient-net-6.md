---
layout: post
title: "Introducing RestClient.NET 6"
date: "2023/04/12 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/restclientdotnet/logo.png"
image: "/assets/images/blog/restclientdotnet/logo.png"
tags: restclient-net csharp
categories: [dotnet]
permalink: /blog/:title
---

If you are looking for a simple, powerful and performant library for consuming RESTful APIs in .NET, you should check out [RestClient.NET](https://github.com/MelbourneDeveloper/RestClient.Net). It's is a cross-platform library that supports .NET Framework, .NET Core, .NET Standard, Xamarin, UWP, Blazor and Unity. That makes it very handy for legacy systems. It offers a fluent and easy-to-use API that lets you make HTTP requests with minimal code and handle responses with strong types and dependency injection. RestClient.NET is based on the native [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-8.0) class, but it adds many features and improvements, such as:

* Automatic serialization and deserialization of JSON and XML payloads using Newtonsoft.Json or System.Text.Json
* Support for custom serializers and deserializers
* Support for cancellation tokens, progress reporting and timeouts
* Support for headers, cookies, query parameters and form data
* Support for multipart requests and file uploads
* Support for custom message handlers and interceptors
* Support for logging and tracing
* Support for functional-style programming with F#

RestClient.NET also has a rich documentation and a comprehensive set of unit tests and samples. You can find the source code on GitHub and the NuGet package on [NuGet.org](https://www.nuget.org/packages/RestClient.Net).

## Creating a RestClient
In this example, we will use RestClient.Net to fetch a list of countries from the RestCountries API and print their names, capitals, and regions. The code demonstrates how to create an instance of the RestClient class, make a GET request to the API, and deserialize the response to a list of strongly-typed objects.
Creating a RestClient

The first step is to create an instance of the Client class. You can pass the base URL of the API as a parameter to the constructor. In this case, the base URL is "https://restcountries.com/v3.1/all". We use the `ToAbsoluteUrl()` method from the `Urls` package to convert the string to an AbsoluteUrl object.

```csharp
using RestClient.Net;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Urls;

public class Name
{
    public string Common { get; set; }
    public string Official { get; set; }
}

public class Country
{
    public Name Name { get; set; }
    public List<string> Capital { get; } = new List<string>();
    public string Region { get; set; }
}

public class RestClientExample
{
    public static async Task Main(string[] args)
    {
        using var client = new Client("https://restcountries.com/v3.1/all".ToAbsoluteUrl());

        var countries = await client.GetAsync<List<Country>>();

        foreach (var country in countries.Body)
        {
            Console.WriteLine($"Name: {country.Name}, Capital: {country.Capital.FirstOrDefault()}, Region: {country.Region}");
        }
    }
}
```

## Making GET Requests
To make a GET request, you can use the GetAsync<T> method. You need to pass an instance of the RestRequest class that specifies the relative URL of the resource. You can also pass a cancellation token if you want to cancel the request. The method returns a Task<T> that you can await to get the response. The response will be deserialized to the type T that you specify.

For example, to get a single task by its ID, you can do this:

```csharp
using System.Threading;
using System.Threading.Tasks;

//Create a cancellation token source
var cts = new CancellationTokenSource();

//Create a RestRequest with the relative URL of the resource
var request = new RestRequest("tasks/1");

//Make a GET request and await the response
var response = await client.GetAsync<Task>(request, cts.Token);

//Get the task from the response
var task = response.Data;

//Print some properties of the task
Console.WriteLine($"ID: {task.Id}");
Console.WriteLine($"Title: {task.Title}");
Console.WriteLine($"Completed: {task.Completed}");
The Task class is a simple POCO that represents a task entity. It has properties for Id, Title and Completed.

public class Task
{
    public int Id { get; set; }
    public string Title { get; set; }
    public bool Completed { get; set; }
}
```

To get a list of all tasks, you can do this:

```csharp
//Create a RestRequest with the relative URL of the resource
var request = new RestRequest("tasks");

//Make a GET request and await the response
var response = await client.GetAsync<List<Task>>(request);

//Get the list of tasks from the response
var tasks = response.Data;

//Print some properties of each task
foreach (var task in tasks)
{
    Console.WriteLine($"ID: {task.Id}");
    Console.WriteLine($"Title: {task.Title}");
    Console.WriteLine($"Completed: {task.Completed}");
    Console.WriteLine();
}
```
