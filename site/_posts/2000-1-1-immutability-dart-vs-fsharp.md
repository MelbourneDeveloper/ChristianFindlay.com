---
layout: post
title: "Immutability: Dart vs. F#"
date: "2022/11/05 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/immutibility/header.png"
image: "/assets/images/blog/immutibility/header.png"
tags: Immutability dart fsharp functional-programming
categories: flutter
permalink: /blog/:title
---

[Immutability](https://en.wikipedia.org/wiki/Immutable_object) is a very important part of [Functional Programming](https://en.wikipedia.org/wiki/Functional_programming). Dart and F# are two excellent modern languages that support immutability and functional programming constructs. However, [Don Syme](https://twitter.com/dsymetweets) and the team designed [F#](https://en.wikipedia.org/wiki/F_Sharp_(programming_language)) explicitly for functional programming constructs. It is a "functional-first" language. Immutability is also an important part of Flutter, and there are now [F# bindings](https://github.com/fable-compiler/Fable.Flutter) for Flutter via the [Fable compiler](https://fable.io/). So, this article compares immutability in the two languages and explores the two different approaches.   

Why Immutability?
=================

Immutability facilitates [pure functions](https://en.wikipedia.org/wiki/Pure_function) by disallowing mutable parameters to functions. Pure functions are simpler to test and maintain because they provide certain guarantees. We know that a pure function cannot modify anything about the inputs, there are no side effects, and the result will always be identical given that the inputs are identical.   

[Structural equality](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/structural-equality/) allows a language to compare two immutable objects based on their contents instead of their object references. For example, these two objects are structurally equal but not referentially equal.  

‍![Structurally Equal](/assets/images/blog/immutibility/strucurallyequal.png)

The Flutter community has embraced immutability. Some patterns and libraries make immutability and structural equality a requirement. According to the [flutter\_bloc](https://pub.dev/packages/flutter_bloc#blocselector) documentation:  

> The selected value must be immutable in order for BlocSelector to accurately determine whether builder should be called again.  

So, we need to ask how well the Dart language supports immutability and whether or not there are any caveats or pitfalls we should consider when using immutability.   

Requirements of Immutability
============================

Firstly, we must discuss what a language needs to support immutability properly. This list is not exhaustive but gives you an idea of how the language should behave. The important thing to understand is that immutable types come with a contract. They should not allow you to change anything about the object unless you go out of your way to use a backdoor like reflection.  

### Compile Time and Runtime Safety

The language should stop changing anything about the object at runtime, but it should also stop you at compile time. The compiler should give you an error if you attempt to modify anything about the object. Immutable types should not have members that mutate the object.   

### Immutable Collections

This includes modifying collections. See this article on [Dart Immutable Collections](https://www.christianfindlay.com/blog/dart-immutable-collections). The language needs specialized types for immutable lists. Interfaces are not enough because they do not specify behavior. The type must prevent mutation. Again, runtime safety is not enough. Collections must have compile time safety. An immutable collection with no compile-time safety may be more dangerous than a mutable collection because the compiler won't stop errors before they appear in your app.  

### Structural Equality

Immutability and [structural equality](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/structural-equality/) go hand in hand. If a type is truly immutable, it is possible to accurately compare structural equality between two objects. While this is not a strict requirement for immutability, it comes with immutability.   

However, structural equality requires automation. If the onus is on the programmer to compare all fields on the object, they will make mistakes. The language must automate the comparison somehow.  

### Recursive Contract

Objects are graphs. They are not flat. For a type to be truly immutable, the field types need to be immutable, and their fields need to be immutable. If a type has a mutable field collection, this breaks the contract.   

How Do F# and Dart Deal With These?
===================================

There are many ways for a language to provide these characteristics. The language doesn't have to bake these things in. We can create tools and frameworks on top, but F# has a concept called [record](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/records). Records are immutable by default. At this time, Dart has a [specification for record types](https://github.com/dart-lang/language/blob/master/accepted/future-releases/records/records-feature-specification.md), but we currently handle immutability differently in Dart.  

This is an example of a record in F#

<script src="https://gist.github.com/MelbourneDeveloper/8d9f1213c34a5ab0ec3bfb5e2b61fe79.js"></script>

This is a similar class in Dart that has some immutability features out of the box.

<script src="https://gist.github.com/MelbourneDeveloper/e7b45c29cdf5f5522d65fb3b6dc18ee3.js"></script>

But the results are very different. The first thing you should notice about the F# version is that the Numbers list is immutable at compile time. We don't even have add or remove methods to modify the list. F# satisfies the safety requirements for records and collections already.

‍![No add method](/assets/images/blog/immutibility/noaddmethod.png){:width="100%"}

The list on the Dart version is completely mutable. We can modify it at compile time and runtime. This code runs correctly  
  
‍![Can add to list](/assets/images/blog/immutibility/addmethod.png){:width="100%"}

How about structural equality? Well, F# does this out of the box. This comparison returns true because all the values in the record match.  

‍![F# Structural Equality](/assets/images/blog/immutibility/fsharpstructuralequality.png){:width="100%"}

The Dart version does not have structural equality by default. If we use the tool dnSpy, we can see what the F# code looks like as C# code. 

‍![F# Structural Equality](/assets/images/blog/immutibility/fsharpstructuralequality2.png){:width="100%"}

And by default, all records are immutable in F#, so no matter how many fields we add to the type graph, we have recursive immutability by default in F#. Flutter uses the [immutable annotation](https://api.flutter.dev/flutter/meta/Immutable-class.html) to specify the immutable type contract. Incidentally, Dart doesn't have this annotation out of the box. But, this only forces us to use the final keyword on classes. The analyzer does not recursively check that all fields are immutable and all fields of fields are immutable. It doesn't check that collections are immutable. 

There is one gotcha with F#, though. F# does allow mutable fields, so it is possible to break the immutability contract. This code runs, and it's still considered a record. But, these object instances are unequal because the F# type system knows that classes are mutable.

‍![F# Mutable](/assets/images/blog/immutibility/mutablefsharp.png){:width="100%"}

So, we see that Dart does not have the same automatic immutability qualities that F# does, but not even F# is perfect. We can still use tools to fill the gaps in Dart.  

Dart: Filling The Gaps
======================

As mentioned, Dart doesn't have compile-time immutable lists by default. The [fixed\_collections](https://pub.dev/packages/fixed_collections) package offers a good solution by deprecating members that mutate the list. You can use the [unmodifiable](https://api.flutter.dev/flutter/dart-core/List/List.unmodifiable.html) constructor of List<> to create an immutable list, but this does not provide compile-time safety.  

We can add structural equality with the [equatable package](https://pub.dev/packages/equatable). But, this package requires us to specify the properties for structural comparison. There is no automation, so we can easily make mistakes and introduce very subtle bugs. If we add a field to a type and forget to add it to the props, the comparison will not work correctly. This can be a horrendously difficult problem to problem to pinpoint.  

The [freezed package](https://pub.dev/packages/freezed) may offer a better solution. If we define our type like this, it generates code useful for structural equality.
  
<script src="https://gist.github.com/MelbourneDeveloper/71f9a8ffa6e5605078706df8b61a12f6.js"></script>

Unfortunately, there is still an issue. It's possible to change the collection from outside the freezed type. We can run this and the list gets modified. Thanks to [Alessio Salvadorini](https://twitter.com/ASalvadorini) for pointing this one out.

‍![Modify List](/assets/images/blog/immutibility/modifylist.png){:width="100%"}

The other issue is that by default freezed does not give us compile-time collection safety. This example causes a runtime error, but the compiler doesn't catch the error.  

‍![Runtime Exception](/assets/images/blog/immutibility/runtimeerror.png){:width="100%"}

You can add compile-time safety to your Lists, Sets and Maps with the [fixed\_collections](https://pub.dev/packages/fixed_collections) package.

*   [Install](https://pub.dev/packages/fixed_collections/install) the dependency
*   Import fixed collections
*   Declare your list as FixedList<> (or other type)
*   Run the freezed code generation

‍![Fixed Collections](/assets/images/blog/immutibility/fixedcollections.png){:width="100%"}

In order to see compilation errors, you must add the [deprecated\_member\_use](https://dart.dev/tools/diagnostic-messages#deprecated_member_use) code analysis option.

‍![Deprecated Member Use](/assets/images/blog/immutibility/deprecatedmemberuse.png)

‍![Deprecated Add](/assets/images/blog/immutibility/deprecatedadd.png){:width="100%"}

_One caveat here, is that at the time of writing, I was not able to get this working with json\_serializable. I got errors that I could not fix on code generation. If you know how to do this, please reach out to me on Twitter._

There are also other custom immutable collection libraries that you can use such as [kt\_dart](https://pub.dev/packages/kt_dart), [built\_collection](https://pub.dev/packages/built_collection) and [fast\_immutable\_collections](https://pub.dev/packages/fast_immutable_collections). Just be aware that these collections don't implement the List<>, Set<> and Map<> interfaces, so you may need to do conversion in some parts of your code.

Lastly, if you use any tool that generates source code, you need to configure the pipelines to regenerate the code on every build. Otherwise, you may forget to generate the code.  

### Wrap Up

It's not surprising that F# has first-class support for immutability, while Dart lacks some features. Dart is a pragmatic language that aims at broad uptake and doesn't take a purist approach to functional programming. Still, we can use tooling to fill the gaps in Dart, and Dart records are a promising addition to the language. [Static metaprogramming](https://github.com/dart-lang/language/issues/1482) will probably make the automation of things like structural equality easier.  

The takeaway from this article is that immutability is not simple, and we shouldn't treat it as such. We shouldn't use Dart/Flutter constructs that require structural equality and immutability unless we are willing and have time to implement immutability properly in our projects. Even then, there are some easy ways to break immutability.  

For this reason, I suggest a rethink of the need for immutable state in all scenarios. The Flutter documentation explicitly uses mutable state with [StatefulWidgets](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) and in the Simple app state management [example](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple#changenotifier). While immutability is preferable, you don't have to implement it in every part of every app. You need to weigh up the pros and cons of your scenario.   

F# is the clear winner for immutability, which may make it a great option for building flutter apps in the future. Still, Dart records are on the way, and I totally expect that immutability will become a first-class citizen in Dart before long.