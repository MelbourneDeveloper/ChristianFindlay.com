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

## Implementing ADTs in C#

You can implement ADTs with abstract classes and subclasses.

**Base Abstract Class**: This represents the ADT itself. It's abstract because it only defines a contract for the types that will extend it.

**Subclasses**: These are specific instances of the ADT, each representing a different variation of the data you want to model.