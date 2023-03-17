---
layout: post
title: "Blazor WebAssembly Rest Client"
date: "2020/02/14 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/blazor/header.png"

tags: blazor
categories: dotnet
permalink: /blog/:title
---

Blazor is Microsoft's latest Single Page Application (SPA) framework, which is C# based and renders to the browser HTML DOM. Blazor comes in two flavors: server-side and client-side rendering. This article focuses on client-side rendering and explains how to use [RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net) to make calls to a RESTful API. Blazor WebAssembly uses C# compiled for [WebAssembly](https://webassembly.org/) (Wasm).

[ > _Blazor lets you build interactive web UIs using C# instead of JavaScript._ Blazor apps are composed of reusable web UI components implemented using C#, HTML, and CSS. Both client and server code is written in C#, allowing you to share code and libraries.](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor)

If you haven't heard of Blazor yet, now would be a good time to start doing some research. Front-end development has been primarily dominated by JavaScript and related technologies like TypeScript for a long time. C# developers often need to switch between JavaScript and C#, even though working in a single language can provide significant benefits for software development. Blazor offers an opportunity to write browser-based applications that are written purely in C#. 

I previously wrote about [using RestClient.Net on Uno Platform.](/restclient-net-on-webassembly-c/) Uno is another Wasm based technology that allows developers to build C# apps for browsers. Uno provides developers with a XAML based platform that is familiar to Windows desktop developers. Blazor allows a mixture of HTML and C# in a single page, so it is more similar to ASP.NET Core Razor scripting. It offers a pathway to migrate away from MVC apps.

The RestClient.Net NuGet package can be added to any server-side or client-side Blazor app. The Client class can be used directly on Blazor razor pages like so:

<script src="https://gist.github.com/MelbourneDeveloper/a90ca939bf65c9a38dde22a4939a7a89.js"></script>

The easiest way to get started is to

*   Clone the [repo](https://github.com/MelbourneDeveloper/RestClient.Net.git)
*   Use the latest version of Visual Studio 2019 (I'm using 16.4.4)
*   Open the solution RestClient.Net.Samples.sln
*   Set the project RestClient.Net.Samples.Blazor as the startup project
*   Hit debug
*   The app should open in your default browser

This is what the Country Data page will look like:

![Rest Countries](/assets/images/blog/blazor/restcountries.png){:width="100%"}

Notice that you can see RestClient.Net network calls inside the network tab of the browser because WebAssembly uses the browser's default Http client for network traffic:

![Rest Countries 2](/assets/images/blog/blazor/restcountries2.png){:width="100%"}

The project is configured for client-side rendering on WebAssembly. It targets .NET Standard 2.1. Debugging is not available in this mode. To switch to server-side rendering, change the target framework to .NET Core 3.1 (NETCOREAPP3.1) . You can do this by editing the .csproj file directly.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Project Sdk="Microsoft.NET.Sdk.Web">
   <PropertyGroup>
      <TargetFramework>netstandard2.1</TargetFramework>
      <RootNamespace>BlazorApp1</RootNamespace>
   </PropertyGroup>
   <PropertyGroup Condition="'$(TargetFramework)'!='netcoreapp3.1 ">
      <RazorLangVersion>3.0</RazorLangVersion>
   </PropertyGroup>
   <ItemGroup Condition="'$(TargetFramework)'!='netcoreapp3.1'">
      <Compile Remove="Startup.cs" />
      <Content Remove="Pages\_Host.cshtml" />
      <PackageReference Include="Microsoft.AspNetCore.Blazor" Version="3.2.0-preview1.20073.1" />
      <PackageReference Include="Microsoft.AspNetCore.Blazor.Build" Version="3.2.0-preview1.20073.1" PrivateAssets="all" />
      <PackageReference Include="Microsoft.AspNetCore.Blazor.DevServer" Version="3.2.0-preview1.20073.1" PrivateAssets="all" />
      <PackageReference Include="Microsoft.AspNetCore.Blazor.HttpClient" Version="3.2.0-preview1.20073.1" />
   </ItemGroup>
   <ItemGroup>
      <Compile Include="..\RestClient.Net.Samples.Uno\RestClient.Net.Samples.Uno.Shared\NewtonsoftSerializationAdapter.cs" Link="NewtonsoftSerializationAdapter.cs" />
      <PackageReference Include="Newtonsoft.Json" Version="12.0.3" />
      <ProjectReference Include="..\RestClient.Net\RestClient.Net.csproj" />
   </ItemGroup>
</Project>
```
    

Here you can see the main difference between server and client-side rendering in the Program startup code:

```csharp
public class Program
{
    //This is for server side rendering
#if (NETCOREAPP3 1)
    public static void Main(string[] args)
    {
        CreateHostBuilder(args).Build().Run();

        public static IHostBuilder CreateHostBuilder (string[] args) =>
        Host.CreateDefaultBuilder(args)
        ConfigureWebHostDefaults(webBuilder=>
        { 
            webBuilder.UseStartup<Startup>();
        });

#else
        //Client side Blazor rendering
        public static async Task Main(string[] args)
        {
            var builder = WebAssemblyHostBuilder.CreateDefault(args);
            builder RootComponents.Add<App>("app");
            await builder.Build().RunAsync());
        }
#endif
    }
}
```

The RestClient.Net page has [documentation](https://github.com/MelbourneDeveloper/RestClient.Net/wiki) for different use cases. It can be used with JSON, and also Protobuffer. If you face any issues with RestClient.Net on Blazor, feel free to reach out on the issues section.

Wrap Up
-------

Check out Blazor and Uno Platform. These platforms both offer new approaches to building web apps and provide familiar territory for .NET developers. Consuming RESTful Apis on Blazor is straight forward with RestClient.Net, so try it out with your next SPA project!