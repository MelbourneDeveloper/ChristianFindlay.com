---
layout: post
title: "ILogger and Null Object Pattern"
date: "2020/09/30 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/ilogger/nothing.jpg"
image: "/assets/images/blog/ilogger/nothing.jpg"
tags: ilogger
categories: dotnet
permalink: /blog/:title
redirect_from: /2020/09/29/ilogger-nullobject/
---

The [Null Object Pattern](https://en.wikipedia.org/wiki/Null_object_pattern) is a pattern that uses objects with null behavior instead of performing null checks throughout the codebase. [ILogger](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.ilogger?view=dotnet-plat-ext-3.1) and [ILoggerFactory](https://docs.microsoft.com/en-us/dotnet/api/microsoft.extensions.logging.iloggerfactory?view=dotnet-plat-ext-3.1) are dependencies that often require a lot of null checking, so they are perfect candidates for the null object pattern. Suppose your classes take `ILogger` or `ILoggerFactory` as a dependency, and you are not using the null object pattern. In that case, you will probably find that your code is either subject to NullReferenceExceptions, or forcing implementors to supply loggers as arguments. Use the null object pattern to avoid both these problems. This article teaches you how in C#.

Support this blog by signing up for my course [Introduction to Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661)

“Null object” might be confusing for some people because it seems to imply that the object reference might be null. However, the opposite is true. The object will never be a null reference. Null refers to the behavior of the object – not the reference itself. I think that a better name for the pattern would be “Dummy Object Pattern” since the objects you will use are shells with no behavior.

### Why Use the Null Object Pattern?

If you inject dependencies into your classes, you need to validate against null or perform null checking throughout your code. The null conditional operator ?. helps, but it is still very easy to miss one. Every single missed question mark is a bug in the code. The null object pattern gives you a third option of using a dummy object instead. This reduces the number of code paths and therefore decreases the chance of NullReferenceExceptions while still allowing the implementor to instantiate the class without creating an instance of the dependency.

In the case of `ILogger`, it is quite onerous to create an implementation. Simply put, you shouldn’t do it. If you want to implement logging, you should use an existing logging library. It becomes even more onerous if the dependency is `ILoggerFactory`. The implementor needs to pull in external dependencies or create a cascading set of classes that they may have no idea how to implement. It gets much worse when you try to mock `ILogger` or `ILoggerFactory` dependencies. Although it is still important to verify that logging gets called. You can read about that [here](/ilogger/).

### The Basics

The good news is that the Microsoft.Extensions.Logging.Abstractions namespace comes with null objects right out of the box. All you need to do is use NullLogger.Instance and NullLoggerFactory.Instance as default instances in your constructor. That’s it. Your class can now depend on these instances, as though there is a real instance.

This example guarantees that the logger will never be null without forcing the code to supply a logger. The readonly modifier ensures that the instance cannot be set to null after construction. The code does not throw a NullReferenceException:

```csharp
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using System;

namespace ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            new Example().Print("Hello World!");
        }
    }

    public class Example
    {
        readonly ILogger _logger;

        public Example(ILogger logger = null)
        {
            _logger = logger ?? NullLogger.Instance;
        }

        public void Print(string message)
        {
            _logger.LogTrace("Logged message: {message}", message);
            Console.WriteLine(message);
        }
    }
}
```

In some cases, your class should take an `ILoggerFactory` instance because it may need to pass loggers to child dependencies in the future. You can use the same approach.

```csharp
namespace ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            new Example().Print("Hello World!");
        }
    }

    public class Example
    {
        readonly ILogger _logger;
        readonly ILoggerFactory _loggerFactory;

        public Example(ILoggerFactory loggerFactory = null)
        {
            _loggerFactory = loggerFactory ?? NullLoggerFactory.Instance;
            _logger = _loggerFactory.CreateLogger<Example>();
        }

        public void Print(string message)
        {
            _logger.LogTrace("Logged message: {message}", message);
            Console.WriteLine(message);
        }
    }
}
```

Notice that we use the static property instance of both classes. We could create new instances of these objects in each case, but this would consume extra memory CPU to construct. The static instances only instantiate once in the app, and therefore, you do not waste any unnecessary resources. This is an important point. If these instances did not exist, it would be an argument for not using the null object pattern. The pattern should not consume resources unnecessarily.

### Nullable and Non-nullable Reference Types in C# 8

You may be wondering about this. If you haven’t heard of this language feature, read up about it [here](https://docs.microsoft.com/en-us/dotnet/csharp/nullable-references). It is an opt-in feature at the level of the project. Projects don’t turn it on by default. You need to modify the csproj file to turn it on with this:

_<Nullable>enable</Nullable>_

If your project uses this feature, you need to specify that the `ILogger` or `ILoggerFactory` parameter is nullable, but the field should remain non-nullable. This is supposed to be an iron-clad guarantee that the object can never be null. The only thing you need to do is add a ? after the type in the parameter.

```csharp
public Example(ILoggerFactory? loggerFactory = null)
{
    _loggerFactory = loggerFactory ?? NullLoggerFactory.Instance;
    _logger = _loggerFactory.CreateLogger<Example>();
}
```

Note that if you try to set `_loggerFactory` to `loggerFactory` without specifying a fallback instance, you will see a compiler error.

Possible null reference assignment.

### Tricky Cases

Sometimes, you may end up in a scenario like this. The class below has a base class that accepts a parameter of `ILogger` while the inheriting class accepts an `ILoggerFactory`.

```csharp
public abstract class BaseClass
{
    protected ILogger Logger { get; }

    protected BaseClass(ILogger logger)
    {
        Logger = logger;
    }
}

public class ConcreteClass : BaseClass
{
    readonly ILoggerFactory _loggerFactory;

    public ConcreteClass(ILoggerFactory loggerFactory)
            : base((loggerFactory ?? NullLoggerFactory.Instance).CreateLogger<ConcreteClass>())
    {
        _loggerFactory = loggerFactory ?? NullLoggerFactory.Instance;
    }
}
```

Notice that you need to use the null coalescing operator ?? twice because otherwise, the call to CreateLogger could throw a NullReferenceException.

Note that NullLogger also creates dummy disposable objects with BeginScope. This is important for cases where you want to use scoped logging. Both these versions of the code are safe from NullReferenceExceptions with a NullLogger.

```csharp
public void Print(string message)
{
    using (var logScope = _logger.BeginScope("Begin scope"))
    {
        _logger.LogTrace("Logged message: {message}", message);
        Console.WriteLine(message);
    }
}

public void Print2(string message)
{
    var logScope = _logger.BeginScope("Begin scope");
    _logger.LogTrace("Logged message: {message}", message);
    Console.WriteLine(message);
    logScope.Dispose();
}
```

### Wrap-Up

This came up because I asked a question as a Twitter poll. The author of the suggestion eventually deleted the original tweet.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">When creating a class where logging is important, do you</p>&mdash; Christian Findlay (@CFDevelop) <a href="https://twitter.com/CFDevelop/status/1302772179495342080?ref_src=twsrc%5Etfw">September 7, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 

The null object pattern is an excellent pattern for propagating logging dependencies around your codebase. NullLogger and NullLoggerFactory are perfect for this. You can safely add logging code anywhere in your classes without worrying whether the dependency is null. You should still unit test with and without passing logging arguments to the class, but you will at least reduce the risk of NullReferenceExceptions occurring in corners of the code.