---
layout: post
title: "How to Stop NullReferenceExceptions in .NET"
date: "2021/07/30 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/nrt/header.jpeg"
image: "/assets/images/blog/nrt/header.jpeg"
tags: csharp
categories: dotnet
permalink: /blog/:title
redirect_from: /2021/03/18/stop-nullreferenceexceptions/
---

This article gives you a toolset for stopping NullReferenceExceptions in .NET code. The article centers around [Nullable Reference Types](https://docs.microsoft.com/en-us/dotnet/csharp/nullable-references) (NRT), a feature that Microsoft added in C# 8. This article mentions five additional tools to ensure that users will never encounter the exception and explains how to implement them in your code.

The Toolset

*   Use [non-nullable variables (Reference and value types)](https://docs.microsoft.com/en-us/dotnet/csharp/tutorials/nullable-reference-types): flag variables that should never be null
*   [Null object pattern](https://en.wikipedia.org/wiki/Null_object_pattern): inject default implementations with null behavior instead of null references
*   [Treat NRT warnings as errors](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/errors-warnings): enforce the NRT rules to ensure that variables cannot enter a null/not-null state at the wrong time. Treat NRT warnings as errors so code will not compile if it breaks the NRT rules.
*   [Immutability](https:/.ndepend.com/c-sharp-immutable-types-understanding-attraction/): reduce the risk of NullReferenceException by only setting the reference once
*   [ArgumentNullException](https://docs.microsoft.com/en-us/dotnet/api/system.argumentnullexception?view=net-5.0): An oldy but a goody. Stop code execution early in cases where the consuming code does not treat NRT warnings as errors.
*   [Unit testing](https://docs.microsoft.com/en-us/visualstudio/test/unit-test-basics?view=vs-2019): pass nulls into your code to make sure the appropriate result occurs. [Mutation testing](https://stryker-mutator.io/docs/stryker-net/Introduction/) can help you achieve a higher level of certainty in your tests.

**Note**: This article talks about libraries and consumers of those libraries. This might sound like it’s about open-source libraries, and it is, but it’s also about maintaining libraries in your team. If you publish libraries, someone will be consuming them, and that might even be you.

### Nullable Reference Types

I recommend reading the official NRT [documentation](https://docs.microsoft.com/en-us/dotnet/csharp/nullable-references) before or after reading this post. This article will refer to some terminology in that documentation which is important to understand.

Reference types (classes, delegates, interfaces) are nullable by their nature. So, why is there suddenly a feature in the language that makes it sound as though they are suddenly nullable? The answer is partly historical. Value types (primary data types and structs) are not inherently nullable. C# added the [nullable values types](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/nullable-value-types) feature and added a nullable ? shortcut in C# 7. The NRT feature follows on from this. It extends the concept so that types suffixed with ? are meant to allow null. The corollary of this is that when we turn NRT on (nullable aware context), types without the? flip from being inherently nullable to not nullable. The syntax also brings C# in line with several other modern languages like [Dart](https://dart.dev/null-safety).

When turned on, variables are in _nullable aware context_. You can turn nullable aware context on project by project or file by file. You need to turn it on file by file in the older csproj formats (pre SDK style). For example, you cannot turn it on at the project level for UWP or Android. Variables declared where nullable aware context is off are considered _nullable oblivious._

If you leave this feature half-implemented, it could be confusing for people consuming the library. The IDE quick info bubbles may not identify between nullable aware and nullable oblivious variables. The consumer may not know if they allow null or not, and it’s not easy for them to tell the difference between these and variables that are nullable oblivious. You might choose to convert entire projects for this reason or not to implement NRT on older projects.

**Note:** NRT support in IDEs is getting better, and IDEs will likely distinguish between nullable aware and nullable oblivious variables in the quick info in the future.

### Turn on NRT (Nullable Aware Context)

There are a few different [strategies for turning on NRT](https://docs.microsoft.com/en-us/dotnet/csharp/nullable-migration-strategies). I recommend doing it all at once and at the project level if you can. As mentioned, doing it for half a library could confuse the consumer_._ This is the Microsoft documentation on [upgrading to NRT](https://docs.microsoft.com/en-us/dotnet/csharp/tutorials/upgrade-to-nullable-references). Open up the csproj file and add these lines:

```xml
<LangVersion>Latest</LangVersion> 
<Nullable>enable</Nullable>
```
    
You will see lots of warnings. The existing variables where the reference type does not have a ? suffix will become not nullable. This flips the meaning of the existing code. Any reference type variables that were nullable change to not nullable. If you want to turn on nullable aware context at the file level, add this to the top of the file.

```csharp
#nullable enable
```
    
**Note**: you can also leave the language version at 8.

### Turn on Treat Warnings as Errors

Warnings are not enough. You need to [treat warnings as errors](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/errors-warnings). Warnings are too easy to ignore, so you need to tell the compiler to stop compilation when you violate an NRT constraint. If you don’t, you won’t get the most significant benefit of NRT. When you turn this setting on, you will not be able to compile unless you fix all the potential issues that could cause NullReferenceException. You can configure the warning severity levels in several different ways, and this is the [official documentation](https://docs.microsoft.com/en-us/visualstudio/code-quality/use-roslyn-analyzers?view=vs-2019) on that. If you don’t want to address other issues, turn off error severity for issues that do not relate to NRT for now. The simplest way to treat warnings as errors is to add this to your project. I recommend this for new projects.

```xml
<TreatWarningsAsErrors>true</TreatWarningsAsErrors>
```

You will see many compilation issues. The most common error will probably be “Converting null literal or possible null value to non-nullable type”. This means that you are attempting to set a not nullable variable to a possibly null value. You need to set the variable to something that is definitely not null. You will also encounter “Dereference of a possibly null reference”. This means that you are trying to access a member of an object that may be null. This forces you to mark the variable as not nullable or deal with the case where it is null.

You will notice that many variables show errors because you didn’t initialize them: “Non-nullable field ‘test’ must contain a non-null value when exiting constructor. Consider declaring the field as nullable.”. The default value of reference types is null, so you need to initialize each variable’s value before the constructor’s end. It may be tempting to set strings to string.Empty, but this somewhat defeats the purpose of NRT. You need to make design decisions at this point. If your class is holding on to a string member variable, you should ask why. Perhaps you should pass the string in the constructor like a record type. Notice that record types with strings properties don’t have this problem.

### Design to Avoid NullReferenceExceptions

Ideally, your class should set all the variables in the constructor (immutability), avoid nullable variables where possible, use the null object pattern, and use null guards (ArgumentNullException) to stop execution as early as possible. These three things mainly guarantee that consumers will not encounter NullReferenceException, and code analysis ensures that you get compilation errors in places where the code is ignoring this. You should also [design for NRT](https://docs.microsoft.com/en-us/dotnet/csharp/tutorials/nullable-reference-types#incorporate-nullable-reference-types-into-your-designs). Use nullable variables sparingly but remember that calling code may not treat warnings as errors and may pass null into variables that aren’t supposed to be null.

### Make Your Code as Immutable as Possible

C# 9 brings [record types to C#](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record). A feature of these types is that they have some immutability out of the box. You must specify the value reference in the constructor, and the property is read-only – the reference does not change for the object’s lifespan. That means that the reference will never become null if you pass a reference into the constructor. If you use the NRT feature with code rules turned on, you can’t pass null in. Here is a basic example, but this has a big flaw, as I will explain later.

```csharp
#nullable enable

using Sample;
using System;

var testRecord = new TestRecord("Hi", null);
Console.WriteLine(testRecord.NotNullableProperty);

namespace Sample
{
    public record TestRecord(string NotNullableProperty, string? NullableProperty);
}
```

You can make regular classes more immutable by passing variables via the constructor and making those properties read-only. You can then apply a null guard.

If variables in your class need to change, you need to be more careful throughout your code because something could set the reference to null. However, code analysis will catch some of these issues

### Use Null Guards – ArgumentNullException

If you are writing a library, you will probably want to implement null guards because you can’t guarantee that the consumer will treat NRT warnings as errors. Remember, consumers can ignore those warnings. If you are writing an app, you are working with nullable aware context, and you are treating NRT warnings as errors, you can choose not to implement null guards because the compiler should catch the errors.

Otherwise, don’t let the consumers bully your code. Don’t start down a code path that could waste time, perform an unwanted action or result in a more obscure error message. Tell the consumer what is wrong [straight away](https://en.wikipedia.org/wiki/Fail-fast). Here is an example that guards against null as early as possible in the code execution with ArgumentNullException. You need to be vigilant about this because code rules won’t tell you that you need to do this in many cases. Always validate parameters on static methods as well.

```csharp
#nullable enable

using System;

namespace Sample
{
    public class NullGuardExample
    {
        public string NotNullableProperty { get; }
        public string? NullableProperty { get; }

        public NullGuardExample(
            string notNullableProperty,
            string? nullableProperty)
        {
            NotNullableProperty = notNullableProperty ?? throw new ArgumentNullException(nameof(notNullableProperty));
            NullableProperty = nullableProperty;
        }
    }
}
```

You should use this sparingly. A better option is to create default implementations for the Null Object Pattern. Remember, if the consumer passes in null, the operation failed. The null guard only gives the consumer some helpful information that they did something wrong rather than continuing with the code.

### Dependency Injection with Default Implementations

You can safely allow consumers to pass null into your classes if you use the [Null Object Pattern](https://en.wikipedia.org/wiki/Null_object_pattern). The consumer does not need to implement the interface to create the instance of the class.

This example follows the null object pattern for the default implementation of the dependency. This code respects NRT because you set the member variable to a fall-back instance. Add the ? suffix to the type on the optional parameter.

```csharp
#nullable enable

namespace NullObjectExample
{
    class Program
    {
        static void Main()
        {
            var someService = new SomeService();
        }
    }

    public class SomeService
    {
        private readonly IPerformsAction performsAction;

        public SomeService(IPerformsAction? performsAction = null)
        {
            this.performsAction = performsAction ?? NullActionPerformer.Instance;
        }
    }

    public interface IPerformsAction
    {
        void PerformAction();
    }

    public class NullActionPerformer : IPerformsAction
    {
        public static NullActionPerformer Instance { get; } = new NullActionPerformer();

        public void PerformAction()
        {
        }
    }
}
```

There is no need for null checking. Null checking is error-prone and makes code more complicated. There may be performance reasons to do null checking in some cases, but the null object pattern is less error-prone.

You can also use the same pattern for delegate types like Funcs and Actions. Check out [this example](https://github.com/MelbourneDeveloper/Device.Net/blob/4ebf7d7df15b12d4d652c2e39b069f0faa15c3f3/src/Device.Net/Observer.cs#L22) in Device.Net. Lastly, this same principle applies to static methods and extension methods.

**Note**: Null object refers to null behavior – not a null object reference. See my article [ILogger and Null Object Pattern](ilogger-nullobject). You will encounter ILogger and ILoggerFactory often.

### Unit Testing

Lastly, Unit Testing is your friend. Unit testing is a whole topic by itself, but people sometimes overlook it. The important thing is to pass nulls into your methods and constructors as input permutations. This ensures that your code does the right thing when it receives a null. If you are using non-nullable variables, you can [supress](https://docs.microsoft.com/en-us/dotnet/fundamentals/code-analysis/suppress-warnings) code rules off in certain parts of your code to force the compiler to allow exceptions. This can be useful for testing scenarios where users do not treat NRT warnings as errors.

Lastly, I strongly recommend learning about Mutation Testing. Unit tests test your code, but mutation testing tests your tests. It ensures that you have high-quality tests with a lot of assertions. Check out [Stryker.NET](https://stryker-mutator.io/docs/stryker-net/Introduction/).

### Something To Think About

This is from the inventor of null Tony Hoare:

> I call it my billion-dollar mistake. It was the invention of the null reference in 1965. At that time, I was designing the first comprehensive type system for references in an object oriented language ([ALGOL W](https://en.wikipedia.org/wiki/ALGOL_W)). My goal was to ensure that all use of references should be absolutely safe, with checking performed automatically by the compiler. But I couldn’t resist the temptation to put in a null reference, simply because it was so easy to implement. This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused a billion dollars of pain and damage in the last forty years.[\[26\]](https://en.wikipedia.org/wiki/Tony_Hoare#cite_note-26)

Seeing that .NET supports nulls, and there is no way to stop that, **_NRT is the closest existing feature to make it impossible to set non-nullable variables to null_**. Library consumers can still ignore the compiler warnings, but if you opt-in and treat warnings as errors, you will significantly reduce the chance of hitting NullReferenceException.

### Wrap-up

Dealing with nulls is difficult. It requires a multi-pronged approach. The NRT feature and treating NRT warnings as errors go a long way toward preventing NullReferenceExceptions at compile time. However, not all library consumers will opt for this feature and, it’s your choice if you want to deal with those scenarios. As always, use the tools at your disposal and test thoroughly.
