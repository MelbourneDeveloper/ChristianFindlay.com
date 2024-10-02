---
layout: post
title: "Upgrade from .NET Framework to .NET 6"
date: "2021/12/12 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/upgradedotnet/header.jpg"
image: "/assets/images/blog/upgradedotnet/header.jpg"
tags: visual-studio dotnet-standard
categories: [dotnet]
permalink: /blog/:title
---

You're probably here because your business has a legacy codebase, and you need to upgrade it. You're not alone, and almost every business goes through a similar thing at some stage. This post is part guide and part food for thought. Here, the focus is on upgrading a back-end from ASP.NET to ASP .NET Core, but you will find this helpful if you need to upgrade any code from Framework to .NET 6. You may want to break your architecture up into Microservices, or you may want to consolidate microservices back into a single service. You may want to upgrade your WPF app to WPF on .NET 6. Whatever your goal is, the process for upgrading to .NET 6 is going to be more or less the same.

Your Codebase
-------------

You have a legacy system running on .NET Framework 4.x. It's probably a bit of a mess with some .NET Framework libraries, some .NET Standard or .NET Core libraries scattered around. Perhaps you share some code with Xamarin or UWP apps. Some of your code may be ready to come along for the ride, and some may not. You will go through a process involving sorting through the projects and determining what to upgrade, abandon, or rewrite.

Refactor, Rewrite or Bifurcate?
-------------------------------

You will need to look at each of your projects one by one and decide what to do with them. You may find that you can simply delete some old projects. But, you will need to decide what to do with important code.

Refactoring involves upgrading the existing code to work in the new environment under .NET 6. It will probably also target .NET Framework with [multi-targeting](https://docs.microsoft.com/en-us/nuget/create-packages/multiple-target-frameworks-project-file). This is the best-case scenario, and I'll explain why shortly.

Rewriting involves rewriting the code from scratch. The new code probably won't run on .NET Framework. It will only target .NET 6. This requires the most work.

Bifurcation means taking the old .NET Framework code, copying and pasting it into a new .NET 6 project, and getting it to run there. You should prefer refactoring to bifurcation, but you may not be able to do this in all scenarios. More on this soon.

The Roadmap
-----------

Are you going to upgrade all the code in the background and then cut across to .NET 6 when you finish the process? Or, can you upgrade each project in the legacy codebase in a way that allows you to keep maintaining the legacy codebase while also targeting .NET 6?

The latter involves some risk because the upgrade process could disrupt the legacy system, but the risk may well be worth it, and here is why...

Any code rewrites involve maintaining two sets of code: the legacy code and the new code. You will need to maintain both until you can delete the legacy code. If the legacy system is still running, you need to do bug fixes and potentially feature enhancements until you turn off the legacy system. If the code exists in two places, you need to apply the fixes and features to two codebases. Do not underestimate how much work this requires. Think about the maintenance of your current system. Is that onerous? Yes. Of course, it is. Now imagine doing that maintenance twice. You are doubling your workload. Not only do you have to fix the issue in the existing live system, but you also need to merge those changes into the new .NET 6 codebase. Nothing could be more frustrating and time-consuming for developers.

The good news is that .NET Framework code is mostly compatible with modern .NET Code. You can refactor at least part of the existing legacy system and take the benefits of those refactors into your new .NET 6 codebase. As mentioned, this adds a little risk to the legacy system, but it also means that improvements to your legacy system add value to your .NET 6 codebase. The key is multi-targeting. You can convert your existing .NET Framework projects to target newer formats such as .NET Standard or .NET 6. That code will run on .NET Framework in your legacy system and on .NET 6. It can also target platforms such as UWP or Xamarin.

So, your roadmap needs to include some multi-targeting. How much is up to you and your team, but the more you can multi-target, the less double maintenance you will require.

Changing the Data Store(s)
--------------------------

You may be breaking up your data store for Microservices. Or, you may be consolidating multiple data stores. Either way, you should probably do this before or after the technology upgrade. Changing data stores in the middle of an upgrade will be far more difficult. These are ultimately different processes and you shouldn't confuse one with the other. Upgrading your code to .NET 6 will put you in a very good position to move to Microservices as the next step.

Step 1 - Understand Your Dependencies
-------------------------------------

You should take some time to survey your projects and how they depend on one another. If you have a tool to generate a dependency diagram, this will be very helpful. It will also be helpful to survey external NuGet packages and so on that, your projects depend on. Do you use [NuGet packages](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#check-for-api-compatibility) that don't exist in .NET 6?


![NDepend](/assets/images/blog/upgradedotnet/ndepend.png){:width="100%"}

Step 2 - Upgrade the Visual Studio Project (csproj) Format
----------------------------------------------------------

Legacy codebases tend to use the old csproj format. This format is overly verbose and requires a lot of explicit definitions. The newer format ([SDK Style](https://docs.microsoft.com/en-us/dotnet/core/project-sdk/overview)) requires minimal explicit configuration and enables you to compile the code ([target](https://docs.microsoft.com/en-gb/dotnet/standard/frameworks)) for .NET Framework and .NET 6 or .NET Standard. You should upgrade as many of your .NET Framework projects as you can. At the very least, you will find maintaining the newer project format more manageable, and you will see less Git history for your projects. Focus on projects you think you will need in the new .NET 6 system, but it's even better if you can upgrade all projects.

You can use the [.NET Upgrade Assistant](https://dotnet.microsoft.com/en-us/platform/upgrade-assistant) to help you. See [this section](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#migrating-with-a-tool) on using the upgrade tool or [migrating by hand](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#migrating-by-hand), along with some [preparation](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#preparation).

Start the upgrade process on the lowest level libraries first - i.e., the libraries that other libraries depend on and work your way up the dependency graph. Leave the highest level projects like Web API or UI code until last. They are likely to change the most and require the most thought.

![csproj](/assets/images/blog/upgradedotnet/csproj.png){:width="100%"}

A typical old style csproj

Step 3 - Multi-target .NET Framework and .NET Standard or .NET 6
----------------------------------------------------------------

Firstly, you should read through this [documentation](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#migrating-with-a-tool) from Microsoft.

When your projects use the SDK Style project format, you can attempt to compile to .NET 6 or .NET Standard. See this [documentation](https://docs.microsoft.com/en-us/nuget/create-packages/multiple-target-frameworks-project-file#create-a-project-that-supports-multiple-net-framework-versions) on multi-targeting. You should see this [chart](https://docs.microsoft.com/en-us/dotnet/standard/net-standard#net-implementation-support) if you need to target Xamarin or UWP. There is some further reading [here](1/net-standard/). That might require you to target .NET Framework and .NET Standard 2.0 or 2.1 instead of .NET 6. If that's the case, the library will still run fine on .NET 6. But, if you don't need Xamarin or UWP, you can target .NET Framework and .NET 6.

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFrameworks>net6.0, net45, netstandard2_0</TargetFrameworks>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>

</Project>
```

This is a modern multi-targeting csproj file. It covers .NET 4.5, UWP, Xamarin up to .NET 6

Step 4 - Fix Code Issues
------------------------

Targeting the newer .NET version such as .NET 6 will cause some compilation and dependency issues. Some .NET Framework libraries may not have versions [compatible](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#verify-every-dependency-compatibility-in-net) with .NET 6. You need to [fix all the code issues](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#fix-the-code-and-build) that appear. 

If .NET 6 is missing a library that you use in .NET Framework, you will need to find an alternative or write the code yourself. The best thing is to find a more recent supported library and replace the existing code with code that uses the new library. Otherwise, you will need to use [#if](https://docs.microsoft.com/en-us/dotnet/architecture/modernize-desktop/example-migration#use-if-directives) with different code paths for both targets.

You don't have to fix all compilation issues straight away. You can leave some targets in a non-compilational state while gradually fixing up each project. The main thing you need to do is ensure that the .NET Framework version still compiles. This ensures you can still release versions of your legacy system. You will need to create a process for creating builds without the .NET 6 targets until that code compiles. One approach might be to remove all the .NET 6 targets until it compiles.

You can take this opportunity to refactor your existing code and add unit tests, and so on. Or, you can choose to avoid risky refactors. The latter is sensible because refactors can break the legacy system. You should be able to upgrade all your projects without changing too much of the original code. Where .NET 6 is incompatible with legacy code, you can use #if so that the old code stays exactly the same.

There are some tools that you have at your disposal to help you. You can use [partial classes](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/partial-classes-and-methods) so that the majority of the class exists in one file and then two other versions for the .NET 6 and .NET Framework specific code. You [conditionally](https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-conditional-constructs?view=vs-2022) include/exclude files based on the target. You can do the same for NuGet packages. You don't have to keep the same dependency set for .NET Framework as you would with .NET 6.

Work through all the code (except for the highest level projects) until you don't see any compilation issues.

Step 5 - High-Level Projects
----------------------------

By now, your low-level dependency projects should be compiling for .NET 6 or .NET Standard, but you still need to convert the highest level code. For Web API back-ends, you will need to convert those from ASP .NET to ASP .NET Core. 

If those projects have code that you can move to lower-level projects, you should do that. For example, you may have some DTO classes in your highest-level project. Most of those to a shared library so that the high-level .NET Framework and .NET 6 projects can access the shared code. These high-level projects should only include the specifics of the Web API. They should not contain logic. Web API projects should only include endpoint controllers, HTTP pipeline code, IoC composition, routing configuration, etc. 

You will probably need to maintain two of the highest-level projects. For example, you may keep an ASP.NET MVC app and an ASP .NET Core Web API app. That means you can compile and run the original Web API and the new one from the same solution. You will probably need to rewrite large chunks of the highest-level projects. But, these projects will share most of the same project dependencies, and you can share code files by adding [files as links](https://andrewlock.net/including-linked-files-from-outside-the-project-directory-in-asp-net-core/). Try to minimize the amount of duplicate code. 

My experience tells me that you can share a lot of code between ASP .NET MVC Web Apis and ASP.NET Core Web Apis. You should probably keep the endpoints exactly the same between the two versions because this allows you to run the same code side by side.

Step 6 - Testing
----------------

You should already have unit tests and integration tests in your system. If you do, you should run them regularly to ensure that the new API works the same as the old API. If not, should add them where possible during the upgrade process. The good news is that ASP .NET Core has a good [integration testing](https://docs.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-6.0) system, so you should implement this as early as possible in the upgrade process.

If you've been careful to keep the original .NET Framework code intact, you can now run both versions of the back-end side by side and theoretically run your front-end against the new back-end. Testing your front-end should be the final part of the process. You will find weird issues and this point and you will need to fix the code in an iterative process until the app behaves the same as the old version. You should also add more and more tests to make the codebase doesn't go backwards during this process. The performance of .NET 6 is leagues ahead of .NET Framework so the whole process will be worth it.

Database Code
-------------

The code that you will probably find most difficult to upgrade will be database code. If you use Dapper, you probably won't find much difference between .NET Framework and .NET 6. However, Entity Framework is very different to Entity Framework Core. Some EF code will compile for EF Core but have different results and execute different SQL. This is why testing is important, and you should create a set of database tests that ensure that new database access code running on .NET 6 does the same thing as the .NET Framework code.

Should We Do All This in a Separate Branch?
-------------------------------------------

Inevitably you're going to need to decide whether you upgrade and retarget the .NET Framework projects one by one, and amongst normal development, or if you're going to branch for several months and then merge back. There are a variety of circumstances which will influence you here, but here is my two cents.

Upgrade and retarget as many projects as you can before you start working on a separate branch. This introduces some risk but you want to minimize the time you are working on code that is not running in production. If you are squirreling code away in a branch for a long period of time, it becomes less and less like the production code and you will have to deal with more and more merge conflicts. 

Tips
----

Keep filenames the same during the whole process. If you move files in to new folders etc. you will have a lot of difficulty with merging

Don't repeat yourself. Look for ways to avoid copying and pasting code. There are many and .NET Framework is not that different from .NET 6 so you can usually find a way to share code between the two

Building up tests is your key to ensuring that both the old and new codebases continue to work. If you are worried about breaking something, it's because you need more tests.

Don't get sidetracked with refactoring. You will feel the urge to refactor but you probably shouldn't unless you are confident that the old system has enough code coverage to stop you from breaking the system.

Wrap-Up
-------

Upgrading a codebase involves the same software development principles that you'd apply to anything else. If you're doing it well, you wil maximise the benefit of your changes to the legacy and new system. If you're doing it poorly, you will duplicate every line of code in the system. Everything about the decision making process will involve tradeoffs around risk and the amount of work you need to do. That becomes a business decision, but you have to adjust and communicate as a team to pull this off. There is no recipe for success but any team that does not communicate, understand the decisions being made and make the best guesses about the path will surely face a lot of pain.

You will probably have a crossover period where you need to run the legacy code and the new code side by side, but ultimately, your reward will be deleting the .NET Framework specific code, and turning off the old back-end and seeing those performance benefits.