---
layout: post
title: "Using Pattern Matching with Algebraic Data Types in C#"
date: "2024/01/16 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/adts/algebraic.png"
image: "/assets/images/blog/adts/algebraic.png"
tags: csharp adt
categories: dotnet
permalink: /blog/:title
---

## Introduction

[Algebraic Data Types (ADTs)](https://en.wikipedia.org/wiki/Algebraic_data_type) is a topic that's been gaining traction in the .NET community. C# is [becoming a more functional language](https://dotnetcore.show/episode-52-functional-csharp-with-simon-painter/) and ADTs are a core Functional Programming concept. If you're familiar with functional programming or have dabbled in languages like F#, you might have encountered ADTs already. But does C# support ADTs?

The answer is yes, and ADTs can help you make your C# code more robust and useful for [pattern matching](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/functional/pattern-matching). While ADTs are core to FP, they also work well in a typical OOP C# codebase. It's only a slight twist on traditional C# constructs that you probably already know, so let's take a look at how they work.

## What are Algebraic Data Types?

Algebraic Data Types are data types composed of other types. They provide a way to create complex data structures by combining simpler ones. ADTs represent data in a way that's both flexible and type-safe. Technically, ADTs include several different categories of data types such as [product](https://en.wikipedia.org/wiki/Product_type) and [sum types](https://en.wikipedia.org/wiki/Tagged_union). These are technical words and are useful for learning FP, but not necessary for illustrating ADTs in C#.

ADTs are very similar to normal inheritance in C#. You have a base class and several subclasses. On a basic level, we can define an ADT as a type that has a fixed number of subtypes so we know at compile time which possible subtypes there are. We call this exhaustiveness. When the app runs, we already know that there are a finite number of possible types that we are dealing with.

## Why use ADTs?

Use ADTs when you have a fixed set of types that share a common structure but have different data or behaviors. They shine in scenarios where you need exhaustive representation of data variations and want to leverage type safety.

However, avoid ADTs if your data model is simple or doesn't have a well-defined set of variations. Simpler data structures might be more appropriate for these cases. If you want to allow consumers of your library to create their own subclasses, ADTs are not the right choice.

## Implementing ADTs in C#

C# doesn't have any special support for ADTs out of the box. Instead, we need to declare an abstract class with all of the subclasses defined inside the base abstract class. We cannot mark the base class as `sealed`, because this would prevent us from inheriting from the base class in the first place. However, we do need to mark each of the subtypes as `sealed`.

**Base Abstract Class**: This represents the ADT itself. It's abstract because it only defines a contract for the types that will extend it. You can add methods to the base type if you want to, but functional programming encourages separating state from behavior. I.e. we should avoid types where there are both data and methods.

**Subclasses**: These are specific instances of the ADT. Each class represents a different variation of the data you want to model. You need to mark each class with `sealed` so it is impossible for any consumer to pass in a type that the code does not expect.