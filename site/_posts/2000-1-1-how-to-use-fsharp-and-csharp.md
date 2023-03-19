---
layout: post
title: "How to Use F# from C#"
date: "2020/10/17 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/fsharp/logo.svg"
image: "/assets/images/blog/fsharp/logo.svg"
post_image_size: width:50%
tags: fsharp csharp
categories: dotnet
permalink: /blog/:title
---

F# is a [functional programming](https://en.wikipedia.org/wiki/Functional_programming) language that compiles to .NET Intermediate Language ([IL)](https://en.wikipedia.org/wiki/Common_Intermediate_Language). C# is becoming a more functional programming language. The latest version of C# (9) has [new features](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-9) that make functional programming more accessible. The good news is that because both languages compile to IL, we can use them interchangeably. We can reference F# projects in C# projects and vice versa. Also, with the use of [dnSpy](https://github.com/dotfornet/dnSPy), we can convert IL to C#. This article explains how to compile an F# assembly (IL) and then reference it in C# or convert it to C#. It gives C# programmers the rich feature set of F# without having to port all of the code.

What is Functional Programming?
-------------------------------

The Wikipedia text explains it well.

> [In computer science, functional programming is a programming paradigm where programs are constructed by applying and composing functions. It is a declarative programming paradigm in which function definitions are trees of expressions that each return a value, rather than a sequence of imperative statements which change the state of the program.](https://en.wikipedia.org/wiki/Functional_programming)

> [In functional programming, functions are treated as first-class citizens, meaning that they can be bound to names (including local identifiers), passed as arguments, and returned from other functions, just as any other data type can. This allows programs to be written in a declarative and composable style, where small functions are combined in a modular manner.](https://en.wikipedia.org/wiki/Functional_programming)

We usually divide languages into two categories: functional and imperative. The imperative approach focuses on supplying step by step instructions in loops, while functional languages rely on expressions and the concept of [higher order functions](https://en.wikipedia.org/wiki/Higher-order_function) for a more declarative style. We usually call C# an imperative language and F# a functional language, but you should understand that neither language is purely functional or imperative, and both have imperative and functional constructs. So, it can be misleading to categorize either of them. In C#, you are free to mix and match the approaches. Purists would argue that mixing the approaches is a bad idea, but you’re probably already using some C# functional constructs, as you will see. It’s up to you and your team to decide how much of a functional approach you take with C# code.

Higher-order Functions
----------------------

As mentioned above, a higher-order function is a function that accepts one or more functions as a parameter or returns a function. If you’ve used LINQ lamdas in C#, you’ve probably used higher-order functions. For example, [Enumerable.Where](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.where) is a higher-order function. It takes a function as a parameter. You can hold a function as a variable and pass the function to the Where method. For example, this method returns only strings that have a length of one character.

The important part above is that we created a function inside a function, and we bound the function to the name predicate. We call these [first-class functions](https://docs.microsoft.com/en-us/dotnet/fsharp/introduction-to-functional-programming/first-class-functions) because we treat the functions like any other data type.

This is only one aspect of functional programming. Functional programming is an entire paradigm that encourages programmers to approach programming in a completely different manner. F# strongly encourages functional programming from the ground up. On the other hand, C# is a flexible language that allows functional, imperative, and object-oriented constructs.

Expressions Vs. Statements
--------------------------

In a nutshell, functional programming uses expressions, while imperative programming uses statements. Statements tell the compiler what to do step by step, while expressions return values without necessarily requiring sequential definition. Consider these two C# methods. Both achieve the same result, but the method that uses statements is much more explicit and verbose about what it is doing.

Expressions in F# are exquisite, and C# borrows constructs from it. The elegance of F# expressions may be a good reason to build some of your code in F#. SQL maps to F# [Query expressions](https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/query-expressions) very quickly.

Immutability
------------

Another key concept in the functional programming world is [immutability](https://docs.microsoft.com/en-us/dotnet/fsharp/introduction-to-functional-programming/#immutability). Essentially, it means that after we construct a variable, it’s data should not change. More importantly, the language or runtime should provide tools to ensure that the data does not change. We use record types in C# and F# for this purpose and immutable lists for data collections. Records accept their values during construction and do not provide a mechanism for changing the data after construction.

Here is an example of a record in F#. Very simply, this type accepts three ints as constructor parameters, and you cannot change these values after construction.

```fsharp
type Point = { X: int; Y: int; Z: int; }
```

This is the usage in F#.
```fsharp
let point = { X = 1; Y = 2; Z = 3; }
```

This is the usage in C#. Yes, you can directly use these types from C#.
```csharp
var point = new FSharpLibrary.Point(1, 2, 3);
```
    
C# 9 adds [record types](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-9#record-types). This is an example of a record in C#:

```csharp
public record CsharpPoint(int X, int Y, int Z);
```

Usage:
```csharp
var csharpPoint = new CsharpPoint(1, 2, 3);
```

While C# has had higher-order functions since the early days, adding immutability with record types is a clear sign that the language designers are deliberately adding more functional constructs to the language. C# will likely evolve in this direction, and C# programmers will probably need to learn more about [functional programming](https://medium.com/@naveenrtr/introduction-to-functional-programming-with-c-b167f15221e1).

F# Lists
--------

[F# lists](https://docs.microsoft.com/en-us/dotnet/fsharp/language-reference/lists) are immutable by default. You cannot add or remove items from the list without constructing a new list. You can use F#’s immutable lists in C# directly. You don’t even need to add an F# project. To use F# lists in C#, add the [FSharp.Core Nuget package](https://www.nuget.org/packages/FSharp.Core/) to your C# project. Here is an example C# console app.

Output

1, 2, 3

Note: the C# standard for immutable lists is ImmutableList. You can read about immutable collections in C# [here](https://docs.microsoft.com/en-us/archive/msdn-magazine/2017/march/net-framework-immutable-collections). It is part of the [System.Collections.Immutable](https://www.nuget.org/packages/System.Collections.Immutable/) NuGet package.

Discriminated Unions
--------------------

Discriminated unions are similar to inheritance in object oriented programming. Here is an example in F#.

You can directly use this in C#

How to Reference F# Code in C#
------------------------------

Compiled F# assemblies are basically the same as C# assemblies. The only difference is that F# assemblies, by default, depend on the library FSharp.Core. It’s just a NuGet package that you can reference from C#. You can grab this sample [here](https://github.com/MelbourneDeveloper/Samples/tree/master/F%23/FSharpFromCSharp).

Firstly, check that you have the [F# tools](https://docs.microsoft.com/en-us/visualstudio/ide/fsharp-visual-studio?view=vs-2019) installed. You probably do.

Create an F# .NET class library
![](/assets/images/blog/fsharp/image.png)

Change to target .NET Standard 2.1

![](/assets/images/blog/fsharp/image-1.png)

Create a C# .NET Core console app (3.1) unless you already have a project you want to leverage F# from.

![](/assets/images/blog/fsharp/image-2.png)

Reference the F# project from the C# project.

![](/assets/images/blog/fsharp/image-3.png)

You can now directly use code from the F# library in your C# console app. It’s that simple.

![](/assets/images/blog/fsharp/image-4.png)

![](/assets/images/blog/fsharp/image-5.png)

How to Convert F# to C#
-----------------------

F# compiles to .NET IL, and you can use dnSpy to convert IL to C#. This is great for two reasons. Firstly, F# is completely transparent. You don’t need to guess what it is doing. You can look at the C# version and see how it works. Secondly, you could use compiled F# code as a cookie-cutter for C# code. You might find yourself in a situation where you want to build functional code with F#, but you cannot use F# in your team. In this case, you can write the F# and drag the resulting C# into your project.

*   Download and install dnSpy. This is a great tool that you should be using to inspect code inside .NET DLLs
*   Compile your F# project
*   Open the compiled assembly in the bin folder in dnSpy
*   You will see the structure of the IL converted to C#
*   You can directly copy and paste this code into a C# project or export all the code as C#.

This is what the F# Point record type looks like when opened in dnSpy and converted to C#

![](/assets/images/blog/fsharp/image-6.png)

Click on the image to see all the code

Here is the same thing with a C# record and viewed in dnSpy.

![](/assets/images/blog/fsharp/image-7.png)

Click on the image to see all the code

Click on these images to see all the code. Take some time to compare C# records to F# records. It’s important to understand that both languages hide some complexity and you won’t necessarily know about it.

Does this mean F# is Unnecessary?
---------------------------------

No. F# is an awesome language. As you can see, it’s far less verbose to write functional-style code in F# than C#. It’s so straight forward that anyone who understands C# can start using it without knowing anything about the language. If you are already writing functional style C# code, you will probably write a lot less code by moving chunks to F#.

Mixing and Matching
-------------------

F# is a more opinionated language than C#. As you can see, it hides a lot of the complexity of the types that we see in C#. There is also a lot of duplication between C# and F#. F#’s lists are not the same as immutable lists in System.Collections.Immutable and records are not the same under the hood, either. So, is it safe to use F# types in C#?

The answer depends on your project and your team. Transparency is essential because F# types may not behave expectedly. C# developers may get caught out in their subtle differences. If you use F# types, make sure that your team agrees to this, and this is well understood. Don’t use F# types unnecessarily. For example, you will probably have less trouble with C# records than F# records in C#. But, if you build an entire library with F#, there is no reason you can’t leverage this with C#. Also, there is no reason why you cannot use libraries like System.Collections.Immutable in F# so that immutable lists are compatible with C#.  

As always, communication is key. Don’t be the person who sits in a corner doing weird stuff only to get called into an office to explain what a monad is because nobody else has heard of it before. Use them if they make your development life easier, and your team understands. Otherwise, use diplomacy and gentle persuasion.

Stop the Tribalism
------------------

No group has a monopoly on functional programming. F# is a great tool for writing functional code when you can use it, but that does not mean you should not use functional-style programming in C#. If you’re an F# programmer and find yourself on a project with only C#, explain how F# can be leveraged within existing C# infrastructure. If you’re a C# programmer, stop and think about all the functional style programming you’ve already done. [Lambda Expressions](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/lambda-expressions) would not exist if functional proponents did not push for functional programming in the C# space. C# is simply not a pure imperative or object-oriented language. It clearly has aspects of multiple paradigms, and you are not getting the benefits of the language and platform if you reject functional-style programming.

There is no space in the .NET ecosystem for antagonism between the groups of programmers. They are both tools we can use to solve problems. Stop thinking of yourself as a C# or F# developer, and think of yourself as a .NET developer. Both languages complement .NET.

Wrap-up
-------

F# and C# both compile to .NET libraries. You can build code for F# in C#, and you can build code for C# in F#. You can convert F# code to C# with dnSpy. The future of C# is functional. F# is another tool in your arsenal. Look at the languages as complementary – not mutually exclusive. Use F#. Don’t be afraid of it. There will be value in learning a little about it even if you don’t program in pure F#. If you can, try breaking some of your libraries off into F#. You may find that there is less code to maintain, and you might find unexpected benefits from a more functional approach. When discussing functional programming in your team, start with C#, and some people may warm to migrating parts of the codebase to F#.