---
layout: post
title: "C# Code Rules Part 2 - How To Configure"
date: 2019-02-23 00:00:00 +0000
author: "Christian Findlay"
post_image: "/assets/images/blog/coderules/rules.jpg"
image: "/assets/images/blog/coderules/rules.jpg"
categories: [dotnet]
tags: code-quality visual-studio
permalink: /blog/:title
---

*Edit: There is a [new article](/code-rules) that replaces these two articles and uses the more modern editor config format. These two articles are still useful for .NET framework and teams using the older configuration. It's also worth reading about my thoughts on code rules in general. You can read the first part [here](c-code-rules-part-1)*

If you haven't read the [first part](c-code-rules-part-1) of this series, you might want to have a read. It is an intro to why code rules are a good thing. This part is a How to Guide for people who want to jump straight in, and follow the steps to turn on code rules and configure them. This article is mostly aimed at Visual Studio 2017. Some features will be slightly changed in Visual Studio 2019, and I will write another article with changes fairly soon.

## Step One - Install Fx NuGet Package
I already covered this in the first part but here it is again for completeness sake. This step assumes you are not working on a .NET Framework project. This may work for .NET Framework, but code analysis works a little differently to .NET Core, .NET Standard, UWP and so on.

Install the Microsoft.CodeAnalysis.FxCopAnalyzers NuGet package. This will give Visual Studio the analyzers it needs to apply code rules. At first, this will just create a bunch of Warnings, but we will turn those in to Errors.

![NuGet](/assets/images/coderules2/fxcop.png){:width="100%"}

These are nice to have by themselves, but won't stop you from compiling the app.

![warning](/assets/images/coderules2/warning.png){:width="100%"}

## Step Two - Treat Warnings As Errors
This is the secret to stopping the app from compiling when there are warnings in your code. This is an optional step to some extent. You could leave this off and only treat some rules as errors. This is up to you and your team. You should discuss this and work out what is best. Perhaps the errors should only kick in on a CI build?

![Warnings As Errors](/assets/images/coderules2/warningsaserrors.png){:width="100%"}

-   Right click on the project and click Properties
-   Go the Build properties page
-   Select 'All' on Treat warnings as errors
-   Switch the warning level to 4 (highest)
-   Notice that you now cannot compile if you have code violations

Notice what this does to your csproj file (viewed in Visual Studio Code)

![csproj XML](/assets/images/coderules2/csprojxml.png){:width="100%"}

It's up to you, but I prefer to move this inside the global PropertyGroup instead of only being applied to Debug|AnyCPU. I changed mine to be like this:

![csproj XML 2](/assets/images/coderules2/csprojxml2.png){:width="100%"}

## Step Three - Configuring Code Rules
There are two, perhaps more ways of configuring the rules. The first way is to ignore them in the Suppress Warnings field, but here I will outline how to add a code rules file which gives you more control and allows you to share the config file across projects.

Add the rule set:

![Add rules](/assets/images/coderules2/addrules.png){:width="100%"}

Once you have added the file, you will be able to edit the rules by double clicking on the file. It allows you to switch the rules between none, error, and warning. You will want to switch as many as possible to Error.

![Added rules](/assets/images/coderules2/addedrules.png){:width="100%"}

![Added rules 2](/assets/images/coderules2/addedrules2.png){:width="100%"}

This is not enough however. Visual Studio does not have a property page for turning on these rules by default.  It used to be here and might come back in Visual Studio 2019?.

![Missing](/assets/images/coderules2/missing.png){:width="100%"}

You need to manually edit the project file again, and include the CodeAnalysisRuleSet tag like this. ***This is crucially important***.

![Ruleset](/assets/images/coderules2/ruleset.png){:width="100%"}

There are many options to consider when choosing which code rules to turn on. You may want to turn some errors off because you do not agree with them. Some rules simply do not match the coding style of some teams. If you're starting a new project, I recommend turning on all rules, and then gradually switching off the ones you don't want. However, if you are modifying and existing project, you could simply turn on a few rules to start with, and gradually add more and more.

## Step Four - Getting it to Build
At some point, you will need to be able to actually build your app or library. There's no sense in applying so many code rules that you cannot actually deploy your code. This is where the decision making process comes in, and you will probably need to gain consensus in your team.

Dealing with stubborn team members can be quite tricky. If you have team members that are skeptical of code rules, you could sneak in the rules one by one. They don't hurt. If you only sneak in a couple, the other team members might not even notice, and then you can say "Hey, you've already been using code rules and you didn't even notice!". But, it's probably best to discuss this with your team lead first.

The decision making process involves deciding which rules to fix, which rules to ignore, and which code to suppress errors on. If there are parts of your code that are already very stable but badly coded, then you may want to suppress code rules in these areas because the code is not likely to change. However, my experience is that code always changes, and it's always worthwhile revisiting code that hasn't changed for a long time because it will almost always need a cleanup at some point. If you decided to suppress errors in some parts of the code, you can always go back and remove the suppression later. Generally speaking, it's better to suppress a rule in a couple of spots than to ignore the rule altogether. Although, sometimes a code rule can be broken so often, it is not worth trying to fix it first time around. It can always be fixed later.

## Supression
If you Ctrl-Dot the problem, you will usually get two options in a context menu. One will try to automatically fix the problem. This is great in many cases, and is getting better in Visual Studio. But for now, we will just suppress.

![Ctrl-dot](/assets/images/coderules2/ctrldot.png){:width="100%"}

If you suppress it with the context menu, it will ugly up your code with a pragma:

![Pragma](/assets/images/coderules2/pragma.png){:width="100%"}

Sometimes you can right click on the error in the errors list, and suppress the error in a file which is generally preferable because you can keep the suppression all in one place.

![Supression file](/assets/images/coderules2/supfile.png){:width="100%"}

The suppression while go in to a file like this and the compiler will ignore the problem:

![Supression file 2](/assets/images/coderules2/supfile2.png){:width="100%"}

### Ignore Errors

To turn errors off, double click on the ruleset as mentioned earlier.

You can search for errors as below, and switch their action to 'None'. If you turn off enough, you will be able to build your app or library.

![Turn Off](/assets/images/coderules2/turnoff.png){:width="100%"}

## Conclusion
What I've given you here is enough to get started on any existing or new project. There's no real excuses for not applying code rules. They can be applied anywhere, and if you do not agree with the rules, you can turn them off. My experience has shown that they are invaluable to a team. Ideally, getting consensus in the team in the best way, and it is best to discuss which code rules should be added one by one so that the team feels included. But, the real problem is a psychological one. People fear things that they do not understand, so it's a matter of slowly convincing people as to why code rules will actually help, not hinder their work.