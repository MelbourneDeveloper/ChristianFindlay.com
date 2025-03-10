---
layout: post
title: Protobuf Web API in C#
date: "2020/01/11 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/protobuf/header.png"
image: "/assets/images/blog/protobuf/header.png"
tags: grpc csharp
categories: dotnet
permalink: /blog/:title
description: "Learn how to implement Google Protocol Buffers (protobuf) in C# Web API for efficient serialization. Discover the advantages of protobuf over JSON, and how to create and consume protobuf services using ASP.NET Core and RestClient.Net"
keywords: [Protocol Buffers, protobuf, C# Web API, ASP.NET Core, RestClient.Net, binary serialization, gRPC, .proto files, JSON alternative, efficient data transfer, cross-platform serialization, Google Protocol Buffers, C# serialization, Web API performance, REST API optimization, protobuf serialization, .NET protobuf implementation, binary data transfer, protobuf advantages, C# service development]
---

Using [Google Protocol Buffers](https://developers.google.com/protocol-buffers) (protobuf) for serialization over a Web API (or REST API) is simple. Most developers use JSON as the go-to transfer protocol for services even though it is needlessly verbose, slow to serialize, and lacks the kind of functionality that Google added to protobuf. This article briefly talks about the advantages of services with protobuf, when to use them, and how to create and consume them with ASP.NET Core and [RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net).

Advantages
----------

_Protocol buffers are Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data_.

If you're reading this, I hope I don't have to convince you about the performance and bandwidth saving benefits of binary serialization over JSON. There is a myriad of articles that compare the performance of JSON and protobuf. Here is [one](https://auth0.com/beating-json-performance-with-protobuf/) for good measure. I think I would be flogging a dead horse if I talked about the performance advantages, but what other advantages are there?

Protobuf allows developers to define message type in a programming language agnostic markup language called .proto [files](https://developers.google.com/protocol-buffers/docs/proto3#simple). It means payload model objects generate automatically on both server and client-side, which saves time. It also makes up for the lack of human readability by guaranteeing that messages are compatible between client and server as long as the .proto is the same on both sides. Protobuf is the backbone of [gRPC](https://grpc.io/), so it's safe to assume that Google's investment in protobuf is for the long-run. Protobuf has other features like [Reflection](https://developers.google.com/protocol-buffers/docs/reference/csharp/namespace/google/protobuf/reflection), which make it easy to inspect the structure of messages within code and [Any](https://developers.google.com/protocol-buffers/docs/reference/csharp/class/google/protobuf/well-known-types/any) message types that allow any known message type exchange.

When should I use Protobuf?
---------------------------

Developers should use protobuf as often as possible. There are other kinds of serialization out there, but there are few with the full weight of Google behind them. Protobuf is bound to shake up the world of services, and it is quickly becoming the most recommended serialization method after JSON. Even Microsoft is getting [behind it](https://docs.microsoft.com/en-us/dotnet/architecture/cloud-native/rest-grpc).

Protobuf may not be appropriate when the audience reach is the most critical factor. Web developers are used to consuming JSON services and may not know how to generate code for protobuf serialization. However, things are changing. When low latency and efficiency are the focus, Protobuf is the obvious choice, so consider implementing services with protobuf wherever possible. Who wouldn't want to use less bandwidth and make apps snappier?

Creating the Service
--------------------

It is possible to create a gRPC service on ASP.Net Core. Here is an earlier [article](c-and-grpc-part-one/) I wrote on this. But, developers may want to implement a standard ASP.NET Core Web API with protobuf serialization. Firstly, create a Web API project and add the gRPC NuGet packages. The samples can be cloned from this [repo](https://github.com/MelbourneDeveloper/RestClient.Net).

![NUGETS](/assets/images/blog/protobuf/nugets.png){:width="100%"}

These NuGets allow defining message types with proto files. Just add a .proto file and change the properties of the file as below. It is possible to put the .proto file in a project that is shared between client and server. This is not always possible, but it's recommended. Otherwise, the outputted C# code can be copied and pasted into the client-side project. [This article](https://www.christianfindlay.com/blog/back-end-front-end-versioning) may be useful for managing versions between the back-end and front-end.

![Proto](/assets/images/blog/protobuf/proto.png){:width="100%"}

[Here is a controller](https://github.com/MelbourneDeveloper/RestClient.Net/blob/28b636e4b5323fe7d3f72f720c1fabdb715b1c0b/ApiExamples/Controllers/PersonController.cs#L11) that receives protobuf data via PUT and returns protobuf data via GET. Person is a message type. It can be downloaded with the RestClient.Net samples. The unit tests directly consume the service. ToByteArray converts the message into a byte array to be transferred across the wire.

```csharp
    [HttpGet]
    public IActionResult Get()
    {
      var person = new Person
      {
        FirstName = "Sam",
        BillingAddress = new Address
        {
          StreeNumber = "100",
          Street = "Somewhere",
          Suburb = "Sometown"
        },
        Surname = "Smith"
      };
      var data = person.ToByteArray();
      return File(data, "application/octet-stream");
    }
    
    [HttpPut]
    public async Task<IActionResult> Put()
    {
      var stream = Request.BodyReader.AsStream();
      var person = Person.Parser.ParseFrom(stream);
      if (!Request.Headers.ContainsKey("PersonKey")) throw new Exception("No key");
      person.PersonKey = Request.Headers["PersonKey"];
      var data = person.ToByteArray();
      return File(data, "application/octet-stream");
    } 
```

Consuming the Service
---------------------

The service can be consumed from any .NET application with RestClient.Net. Firstly, add the RestClient.Net NuGet package and the same gRPC / protobuf packages. This will work on .NET Framework, .NET Core, UWP, and Xamarin projects. Documentation can be found [here](https://github.com/MelbourneDeveloper/RestClient.Net/wiki). Here is an [example](https://github.com/MelbourneDeveloper/RestClient.Net/blob/28b636e4b5323fe7d3f72f720c1fabdb715b1c0b/RestClient.Net.Samples/RestClient.Net.CoreSample/Program.cs#L19) from the RestClient.Net .NET Core sample. It posts a person to the server in protobuf binary and then retrieves that person back. More examples can be found in the [Unit Tests](https://github.com/MelbourneDeveloper/RestClient.Net/blob/28b636e4b5323fe7d3f72f720c1fabdb715b1c0b/RestClient.Net.UnitTests/UnitTests.cs#L275).

```csharp
var person = new Person { FirstName = "Bob", Surname = "Smith" };
var client = new Client(new ProtobufSerializationAdapter(), new Uri("http://localhost:42908/person"));
Console.WriteLine($"Sending a POST with body of person {person.FirstName} {person.Surname} serialized to binary with Google Protobuffers");
person = await client.PostAsync<Person, Person>(person);
```    

Wrap Up
-------

Feel free to take this sample and modify it to build your service. You can modify the .proto file to add, modify, or remove message types using this [reference](https://developers.google.com/protocol-buffers/docs/reference/overview). ASP.NET Core is a great base for serving up services with protobuf and C#. If you've got difficulties, feel free to reach out on the Github issues section.