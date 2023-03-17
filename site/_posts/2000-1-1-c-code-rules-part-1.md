---
layout: post
title: "C# Code Rules Part 1"
date: 2019-02-11 00:00:00 +0000
author: "Christian Findlay"
post_image: "/assets/images/blog/coderules/rules.jpg"
categories: [dotnet]
tags: code-quality csharp
permalink: /blog/:title
---

*Edit: There is a [new article](/code-rules) that replaces these two articles and uses the more modern editor config format. These two articles are still useful for .NET framework and teams using the older configuration. It's also worth reading about my thoughts on code rules in general. You can read the second part [here](/c-code-rules-part-2-how-to-configure/). This is more of a How To Guide if you want to skip the writing.*

As a human, you can't be trusted to write good quality code. In fact, you've probably made a tonne of coding mistakes just in the last half an hour or so. I'm making spelling and grammar mistakes right now as I type. The thing is, Word Processors and plain old Text Boxes have learnt to alert you when you are making a mistake. Unfortunately for C# programmers, coding checkers are not as common as spelling and grammar checkers. That's not because they don't exist. It's mostly because code checkers like [FxCop](https://docs.microsoft.com/en-us/previous-versions/dotnet/netframework-3.0/bb429476(v=vs.80)) have been through many iterations and the way you are supposed to use them is only just settling down now. If you are using C#, this article will show you how to implement them.

Firstly, a quick intro to code rules, why they are necessary, and how you've been doing code wrong if you're not using them...

Coders gain [bad habits](https://www.quora.com/What-are-the-common-bad-practices-by-c-developers). We don't do it deliberately. But, often we are not corrected because [telling someone that their code is bad is a tricky subject](https://stackoverflow.com/questions/206286/how-do-you-tell-someone-theyre-writing-bad-code). You may think that you are approachable, but for any number of reasons, a member of your team, or another person using your open source project may not have the courage to make a suggestion about your coding practices. Other times, you simply may not know that there is a simpler way of doing something because a new feature in C# has come out to make something easier, or because you missed some obscure part of the [C# Reference](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/). To be honest, before I started using code rules, and [Resharper](https://www.jetbrains.com/resharper/) (<- Check this out), I didn't know about a whole raft of coding techniques that have made my code simpler and easier to read. But, it can't be denied that laziness is also often a factor.

When you add into the mix one more programmer, or more than one programmer, bad habits start adding up to a colossal mess.  Coding teams often write documents on coding style, and these style documents often sit somewhere tucked away in source control, that some person opens up for a chuckle once in a while. Here is [the story of a truly romantic coder](http://www.richardrodger.com/2012/11/03/why-i-have-given-up-on-coding-standards/#.XGEsmrhxWUk) who thinks:

> The truly evil thing about coding standards is what they do to your heart, your team's heart. They are a little message that you are not good enough. You cannot quite be trusted. Without adult supervision, you'll mess up.

Code rules can help you overcome the problem of different coding styles conflicting and causing code quality issues. Believe me, nothing stops a lazy coder dead in their tracks like a compilation error. If they can't get the damn thing to compile, that unused variable just ain't making it into version control. I'm not really concerned with my team's 'heart'. I'm concerned with writing good code, and humans are notoriously bad at it.
## Code Rules in old .NET Framework Projects - Visual Studio 2015, 2017
In the older csproj format, it was quite simple to turn on code rules which is really a front end for FxCop. This has been removed from the newer csproj format for .NET Standard, and .NET Core. But, the code rules can be used in another way as I will mention. If you create a simple WPF app in Visual Studio and go to the properties of the project, you will see this. This is how you turn code rules on. The "Enable Code Analysis on Build" will run FxCop after a build to analyze code rules.

![Properties](/assets/images/blog/coderules/properties.png){:width="100%"}

You can edit the rules by clicking the Open button above. If you turn all the rules to Error like this, you will get lots of errors when you try to compile.

![Rules](/assets/images/blog/coderules/rules.png){:width="100%"}

There's always some person in the team who insists on leaving variables in the code that shouldn't be there. I don't care what anyone says, that person just should not be allowed to get away with it!

![Rules 2](/assets/images/blog/coderules/rules2.png){:width="100%"}

The downside of using the code rules like this is that it's a bit buggy. It sometimes doesn't kick in when it should, and sometimes kicks in when you least expect it. I do not know why but causing FxCop to actually do the analysis can lead you to spend hours working out what went wrong. There have been occasions where I checked in code that I thought passed the rules, but actually FxCop only kicked in when someone else tried to compile the code.

## FxCop NuGet Package - Newer csproj Format
I believe that this is now the [recommended approach](https://docs.microsoft.com/en-us/visualstudio/code-quality/fxcop-analyzers-faq?view=vs-2017) to code rules in Visual Studio, or any other C# based IDE. This will work in Visual Studio on MacOS, and will also work with the command line compiler. That's probably why FxCop has gone down this path.

![macOS](/assets/images/blog/coderules/macos.png){:width="100%"}

This is for projects where the first line looks like this:

```xml
<Project Sdk="Microsoft.NET.Sdk">
```

Here's how to use it:

Install the Microsoft.CodeAnalysis.FxCopAnalyzers NuGet package:

![NuGet](/assets/images/blog/coderules/nuget.png){:width="100%"}

This works a bit like the old FxCop tool. It will create Warnings from your existing code. These warnings are mostly the same warning that would be considered errors with the old Visual Studio inbuilt code rules system. However, they're not errors by default. You have to tell Visual Studio in your project that you want to treat warnings as errors:

![Warnings](/assets/images/blog/coderules/warnings.png){:width="100%"}

This might get pretty fiddly because of instead of opting in to warnings/errors, you need to opt out. As mentioned above, you could turn on the code rules that you want through the GUI. But, with the NuGet package, you need to exclude warnings that you don't want by typing them in the "Suppress warnings" field above. You also have the options of dropping the "Warning level" down which will make less severe warnings not show up as errors. You will get compilation errors like this that can be turned off:

![Errors](/assets/images/blog/coderules/errors.png){:width="100%"}

If you don't want a particular error based on a specific line of code to stop you from compiling, you suppress the error in a suppression file. Just right click on the error in the window above. Sometimes you get a "Suppress" context menu, and sometimes you don't... Not sure why.

Conclusion
----------

***Coding without code rules is like driving a formula one car with no seat-belt while drunk.***

I think I've given you what you need to get started with code rules here. I could probably go to greater lengths to explain why they are necessary, but seeing you found this page you're probably already looking for ways to get that wayward programmers to accept responsibility for their actions. I can only say that ***code rules work***! They have helped me a lot over the years in my own work, they have corrected some of my bad habits, and showed me better ways of designing code. They have also led to better outcomes in the team because there are objective rules that stop people from just ignoring a coding standards document. If your code is in bad shape, all the more reason to jump on this! Just enable a few rules to start with, and then keep on ratcheting them up until the code is squeaky clean! I hope to follow this up with more details about the power of certain code rules in the next article.