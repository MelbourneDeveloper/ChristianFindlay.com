---
image: "/assets/images/blog/coderules/rules.jpg"
layout: post
title: "C# Code Rules"
date: "Apr 24, 2022"
author: "Christian Findlay"
post_image: "/assets/images/blog/coderules/rules.jpg"
tags: csharp
categories: dotnet
permalink: /blog/:title
---

The C# Compiler's name is Roslyn. Roslyn has a very large set of analyzers to check the quality of your code, but you must turn these analyzers on before they start doing anything. This post gives you some quick information on why it's important to turn these analyzers on in your C# projects, how to do that, and how to configure them.

What Are Code Rules?
--------------------

Code rules are rules that the compiler or code analysis tool enforces at the build level. They enforce [Coding Conventions](https://en.wikipedia.org/wiki/Coding_conventions), detect mistakes, and provide the tooling to do bulk fixes. Roslyn and other .NET/C# tools use [Static Code Analysis](https://en.wikipedia.org/wiki/Static_program_analysis) on your codebase to check where there are violations in your code. [Rider](https://www.jetbrains.com/rider/) and [Resharper](https://www.jetbrains.com/resharper/) provide static code analysis tools on top of the existing Roslyn code analysis. I recommend supplementing your code analysis with Rider or Resharper, but this article focuses on the core Roslyn analyzers. Check out the overview [here](https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview).

Why Do We Need Code Rules?
--------------------------

This is a controversial topic, and I'm not going to fill this article with arguments for using code rules. My years of experience tell me that code rules are a very good thing and that teams that use them have fewer issues. Here are some of the benefits I have found over the years:

*   Fewer bugs
*   Less nitpicking on pull requests
*   Forces newer code constructs instead of old ones
*   Changes bad habits
*   Code style determinism reduces pointless Git diffs
*   Removes unnecessary code
*   Less unnecessary code paths

Example
-------

This code sample has a bug. Without code rules, this code compiles fine. 

```csharp
using System.Globalization;

namespace CodeRulesExample;

public static class Program
{
    public static void Main() => 
        Console.WriteLine(string.Format(new CultureInfo("en-US"), "Hello {0}{1}!", "World"));
}
```

However, when we turn code rules on, the code analyzer tells us that there is a bug. If we configure code rules correctly, we cannot build the app. That's one bug prevented before we even ran the tests.

![](/assets/images/blog/csharprules/1024x266.png){:width="100%"}

This is only the beginning. Countless rules can help you improve code quality, performance, readability and find easier ways of writing code.

Turning On Code Rules: Fresh Solution
-------------------------------------

You turn on code rules at the csproj level, and then you can modify the editor config file for the individual rules. Various settings have different effects, but here is a baseline configuration. Check out the [reference documentation](https://docs.microsoft.com/en-us/dotnet/core/project-sdk/msbuild-props) for Code analysis properties.

Notice that we add the Microsoft.CodeAnalysis.NetAnalyzers (Roslyn Analysers) Nuget package. This is the most common set of analyzers. They work on all IDEs and platforms and work inside CI/CD pipelines. Check out the Github Repository [here](https://github.com/dotnet/roslyn-analyzers). You can also add other Nuget packages for additional analyzers.

```xml
<Project Sdk="Microsoft.NET.Sdk">

	<PropertyGroup>
		<OutputType>Exe</OutputType>
		<TargetFramework>net6.0</TargetFramework>
		<ImplicitUsings>enable</ImplicitUsings>
		<Nullable>enable</Nullable>
		<AnalysisMode>AllEnabledByDefault</AnalysisMode>
		<AnalysisLevel>latest</AnalysisLevel>
		<TreatWarningsAsErrors>true</TreatWarningsAsErrors>
		<EnforceCodeStyleInBuild>True</EnforceCodeStyleInBuild>
		<EnableNETAnalyzers>True</EnableNETAnalyzers>
		<WarningsNotAsErrors>CA1014</WarningsNotAsErrors>
	</PropertyGroup>

	<ItemGroup>
		<None Include="..\.editorconfig" Link=".editorconfig" />
	</ItemGroup>

	<ItemGroup>
	  <PackageReference Include="Microsoft.CodeAnalysis.NetAnalyzers" Version="6.0.0">
	    <PrivateAssets>all</PrivateAssets>
	    <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
	  </PackageReference>
	</ItemGroup>

</Project>
```

You will notice that you will see red error messages even on the most basic projects. You need to fix the error messages here.

![](/assets/images/blog/csharprules/1024x232.png){:width="100%"}

If you have more than one project in your solution, you should move the configuration to a [Directory.Build.props](https://docs.microsoft.com/en-us/visualstudio/msbuild/customize-your-build?view=vs-2022#directorybuildprops-and-directorybuildtargets) file. This file allows you to share project options across multiple projects in your solution.

Configuring Rules
-----------------

It's much easier to start with all rules turned on and build your solution with full code analysis. However, if you want to turn off some code rules or have an existing solution, you can configure each rule. Add an [editor config](https://docs.microsoft.com/en-us/visualstudio/ide/create-portable-custom-editor-options?view=vs-2022) to your solution. This file acts as a settings file for the various analyzers. Try to keep the file at the root of your solution instead of creating one for each project. 

You can add the default editor settings for .NET by adding a new file like this:

![](/assets/images/blog/csharprules/1024x710.png)

You will see the configuration screen here, and there is a tab for analyzers.

![](/assets/images/blog/csharprules/965x1024.png)

You can edit the text of the file with Visual Studio Code. You can read the configuration reference [here](https://docs.microsoft.com/en-us/visualstudio/code-quality/use-roslyn-analyzers?view=vs-2022).

![](/assets/images/blog/csharprules/1024x830.png)

I recommend turning on all the code rules and gradually fixing errors that you encounter in your solution. There are bulk fix tools to help you with many issues. If you click "Solution" here, it will remove all unused variables in the solution. You should use as many of the bulk fixes as possible.

![](/assets/images/blog/csharprules/image-1.png)

This CLI (when it works) applies many of the fixes, but I often find that I need to run the bulk fixes one by one manually.

dotnet format

Fixing all the issues can take a while. Small projects generally take 1 or 2 days, but a large codebase might take a full month. You don't have to fix all the code rule violations in one hit. I recommend fixing the ones you can fix and turning the other rules into a warning. We turned on TreatWarningsAsErrors so that this line won't have any effect.

![](/assets/images/blog/csharprules/1024x91.png)

At the project config level, we also need to add this error to the WarningsNotAsErrors collection. So, don't be surprised if using the GUI rule editor has no effect.

![](/assets/images/blog/csharprules/1024x464.png)

Here is an [example editor config](https://github.com/MelbourneDeveloper/RestClient.Net/blob/main/src/.editorconfig) from my library [RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net), with nearly all rules, turned on. You can use it as a reference, but please note that it does not have all rules turned on. This file will turn on more rules than the default.

Wrap-Up
-------

Add code rules to every new project you work on, and try to bring existing code up to scratch by applying code rules. Some people will find the process jarring, and I will admit that the configuration system is pretty messy, but it will be worth it in the long term. Code analysis does improve your code quality, and you will improve your coding habits. You will also improve the coding habits of your team and have fewer fights over small details on pull requests. If there are people in your team who resist, make some concessions by turning off rules that they find particularly offensive.  

Please also see [this article](/stop-nullreferenceexceptions/) that talks about using code rules to stop NullReferenceExceptions.