---
layout: post
title: "RestClient.Net 5"
date: "2021/05/27 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/restclientdotnet/logo.png"
tags: restclient-net csharp
categories: [dotnet]
permalink: /blog/:title
---

[RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net) makes HTTP calls in .NET easy. Send the request body as a strongly typed object, and get back a strongly typed object. You can inject the abstraction into your service classes and quickly mock them without worrying about the HTTP plumbing or converting to JSON. RestClient.Net 5 is a much improved, battle-hardened version that builds on the approach of V4 while introducing immutable types and a fluent API. It reduces the chance of shooting yourself in the foot with [HttpClient](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-5.0), plays nicely with dependency injection, integrates with Polly, and the design should be familiar and comfortable to F# programmers.

### Why Use a Rest Client?

The HttpClient and System.Uri classes are a mess, and yet we see them used throughout codebases. You shouldn't use HttpClient directly, and you certainly shouldn't new HttpClient in your code because this makes it impossible to unit test your code. Use a solid Rest Client, which takes you one level of abstraction higher and takes the nasty edges off HttpClient.

### Unit Testability

First and foremost, HttpClient does not have a straightforward abstraction. If you want to mock HttpClient for unit testing, you need to inject a [DelegatingHandler](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.delegatinghandler?view=net-5.0) into the client. Even then, you need to mock the conversion to and from raw data. This takes focus away from the simple act of verifying that the client is sending and receiving the correct object. 

RestClient.Net solves this problem with the [IClient](https://github.com/MelbourneDeveloper/RestClient.Net/blob/e24d8a2d49fb06fa8d8a1aea69d5df3f587145bd/src/RestClient.Net.Abstractions/IClient.cs#L9) interface. You send a strongly typed object in the body, and you receive a strongly typed object in the response body. This is straightforward to mock, and you can safely mock this in one line.

```csharp
/// <summary>
/// Dependency Injection abstraction for Rest Clients. Use the CreateClient delegate to create an IClient when more than one is needed for an application.
/// </summary>
public interface IClient
{
    /// <summary>
    /// Sends a strongly typed request to the server and waits for a strongly typed response
    /// </summary>
    /// <typeparam name="TResponseBody">The expected type of the response body</typeparam>
    /// <param name="request">The request that will be translated to a HTTP request</param>
    /// <returns>The response as the strong type specified by TResponseBody /></returns>
    /// <typeparam name="TRequestBody"></typeparam>
    Task<Response<TResponseBody>> SendAsync<TResponseBody, TRequestBody>(IRequest<TRequestBody> request);

    /// <summary>
    /// Default headers to be sent with HTTP requests
    /// </summary>
    IHeadersCollection DefaultRequestHeaders { get; }

    /// <summary>
    /// Base Url for the client. Any resources specified on requests will be relative to this.
    /// </summary>
    AbsoluteUrl BaseUrl { get; }
}
```

### Dependency Injection

The solid abstraction also means that dependency injection is straightforward. You can inject the IClient interface directly or take a factory approach with CreateClient. This means that you don't have to use the default implementation of IClient. You can write your own implementation of IClient if you have the need.

The RestClient.Net.DependencyInjection package works with ASP.NET Core dependency injection and uses the default [IHttpClientFactory](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/implement-resilient-applications/use-httpclientfactory-to-implement-resilient-http-requests) implementation to create HttpClients. This means that RestClient.Net always gets HttpClients via the factory which Microsoft maintains.

```csharp
var serviceCollection = new ServiceCollection()
    //Add a service which has an IClient dependency
    .AddSingleton<IGetString, GetString1>()
    //Add RestClient.Net with a default Base Url of http://www.test.com
    .AddRestClient((o) => o.BaseUrl = "http://www.test.com".ToAbsoluteUrl());

//Use HttpClient dependency injection
_ = serviceCollection.AddHttpClient();
```

### Urls

System.Uri is a bloated class that creates lots of confusing corner cases. For example, putting a forward slash in the wrong place can result in an incorrect URL. Concatenating Uris is error-prone, and many subtle bugs arise from doing this.

RestClient.Net uses the [Urls](https://github.com/MelbourneDeveloper/Urls) library instead of System.Uri for building and passing URLs throughout the system. It makes constructing URLs easier, more readable, and less error-prone. Adding a path and query string to a base URL is always safe, and you do not have to worry about concatenating strings manually. Incidentally, switching to this library dramatically increased the mutation testing score of RestClient.Net. This is probably because there are fewer possible corner cases.

Here is an F# example
```fsharp
[<TestMethod>]
member this.TestComposition () =

    let uri =
        "host.com".ToHttpUrlFromHost(5000)
        .AddQueryParameter("fieldname1", "field<>Value1")
        .WithCredentials("username", "password")
        .AddQueryParameter("FieldName2", "field<>Value2")
        .WithFragment("frag")
        .WithPath("pathpart1", "pathpart2")

    Assert.AreEqual("http://username:password@host.com:5000/pathpart1/pathpart2?fieldname1=field%3C%3EValue1&FieldName2=field%3C%3EValue2#frag",uri.ToString());
```

### Immutable Types

HttpClient allows you to change a lot of properties. That means that if multiple parts of your system use the same instance, they may change some property and break another part of the system. For example, one class may add a default header, and another class may remove it. This is a thread safety issue.

All classes in RestClient.Net are immutable. You cannot change their values after construction. This follows the functional style programming approach, which F# programmers will be familiar with. You can quickly clone an existing client using the With methods (non-destructive mutation) or use the CreateClient factory's options to specify the client's properties. 

```csharp
var client = new Client(
  new NewtonsoftSerializationAdapter(),
  baseUrl: testServerBaseUri,
  defaultRequestHeaders: 
    HeadersExtensions
      .FromJsonContentType()
      //Non-destructive mutation to create a new headers collection
      .WithBearerTokenAuthentication(bearerToken));
```

### Why RestClient .Net?

#### Legacy Support (.NET Framework 4.5, .NET Standard 2.0)

Many teams are stuck on older versions of .NET, Xamarin, or UWP. These systems do not offer the same API as .NET Core. You can use RestClient.Net right now and bring it with you when you upgrade to .NET Core. RestClient came from a background of disparate .NET implementations. I realize that the .NET ecosystem is not as straightforward as many would believe. Your codebase should have a first-class Rest Client no matter which .NET implementation you use.

#### Thoroughly Tested

RestClient.Net follows Test-Driven Development, and there is 100% code coverage on .NET Core. I also use [Stryker Mutator](https://stryker-mutator.io/) to test the unit tests and have a score of 66% and improving. This means that if I break something in the future, the likelihood of the unit tests picking up this problem is high.

#### It's Simple and Scales Up

You can make a call with one line of code, reuse the client, and make subsequent calls by specifying new RelativeUrls. This means less fumbling around when you start a new project, but it doesn't mean that you will be abandoning good practice. I use RestClient.Net because I find it the most accessible client when getting started on a new project, but I can also trust it for more sophisticated projects.

#### No Known Bugs

I fixed several bugs between V4 and V5. There are no known bugs at the time of release, and I will treat bugs with a high priority in future. RestClient.Net focuses on the core REST operations of sending and receiving data over HTTP perfectly. Features only appear when they have no kinks.

### Wrap-up

Try out RestClient.Net for your next project. Grab the RestClient.Net.DependencyInjection package if you are using ASP.NET Core dependency injection or RestClient.Net to use the basic library. There is currently a Blazor sample in the samples solution, and I will soon upgrade the Uno Platform and Xamarin Forms samples from Version 4. Help your team to move away from misuse of HttpClient.
