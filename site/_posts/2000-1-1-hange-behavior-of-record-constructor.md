---
layout: post
title: "How To Change the Behavior of a C# Record Constructor"
date: "2021/04/29 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/dotnet/record.jpg"
tags: records csharp
categories: [dotnet]
permalink: /blog/:title
---

[Records](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/records) are a new feature in C# 9. Records are special classes that borrow from [Structs](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/struct) in that they have _value-based equality_. You could look at them as a hybrid between the two categories of types. They are more or less immutable by default and have syntax sugar to make declaration easier and more concise. However, the syntax sugar can obscure more standard tasks like changing the behavior of the default constructor. You will probably need to do this for validation in some cases. This article shows you how to achieve this.

Take this simple example class:
```csharp
public class StringValidator
{
    public string InputString { get; }

    public StringValidator(string inputString)
    {
        if (string.IsNullOrEmpty(inputString)) throw new ArgumentNullException(nameof(inputString));

        InputString = inputString;
    }
}
```

It's clear that if the consumer attempts to create an instance of this class without a valid string, they will get an exception. The standard syntax for creating a record looks like this:

```csharp
public record StringValidator(string InputString);
```

It's friendly and concise, but it's not immediately clear how you would validate the string. This definition tells the compiler that there will be a property named InputString, and the constructor will pass the value to that property from a parameter.  We need to remove the syntax sugar to validate the string. Fortunately, this is easy. We do not need to use the new syntax to define our records. We can define the record similar to a class but change the keyword class to record.

```csharp
public record StringValidator
{
    public string InputString { get;  }

    public StringValidator(string inputString)
    {
        if (string.IsNullOrEmpty(inputString)) throw new ArgumentNullException(nameof(inputString));

        InputString = inputString;
    }
}
```

Unfortunately, this means we cannot use the [non-destructive mutation](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/records#non-destructive-mutation). The with keyword gives us the ability to create a new version of the record with some properties changed. This means that we do not modify the original instance of the record, but we get a copy of it. This is a common approach with Fluent APIs and Functional Style programming. This allows us to maintain immutability.

In order to allow non-destructive mutation, we need to add the init property accessor. This works similarly to the constructor but is only called during _object initialization_. Here is a more complete solution that implements the init accessor. This allows you to have shared constructor logic and init logic.

```csharp
using System;

namespace ConsoleApp25
{
    class Program
    {
        static void Main(string[] args)
        {
            //This throws an exception from the constructor
            //var stringValidator = new StringValidator(null);

            var stringValidator1 = new StringValidator("First");
            var stringValidator2 = stringValidator1 with { InputString = "Second" };
            Console.WriteLine(stringValidator2.InputString);

            //This throws an exception from the init accessor
            //var stringValidator3 = stringValidator1 with { InputString = null };

            //Output: Second
        }
    }

    public record StringValidator
    {
        private string inputString;

        public string InputString
        {
            get => inputString;
            init
            {
                //This init accessor works like the set accessor
                ValidateInputString(value);
                inputString = value;
            }
        }

        public StringValidator(string inputString)
        {
            ValidateInputString(inputString);
            InputString = inputString;
        }

        public static void ValidateInputString(string inputString)
        {
            if (string.IsNullOrEmpty(inputString)) throw new ArgumentNullException(nameof(inputString));
        }
    }
}
```

Should Record Constructors Have Logic?
--------------------------------------

This is a controversial debate and outside the scope of this article. Many people would argue that you should not put logic inside constructors. The design of records encourages you not to put logic in the constructor or init accessor. Generally speaking, records should represent the state of your data at a snapshot in time. You shouldn't need to apply logic because the assumption is that you know the state of your data at this point. However, much like every other programming construct, there is no way of knowing what use cases may arise from records. Here is an [example](https://github.com/MelbourneDeveloper/Urls/blob/5f55a9437cfac1223711d616bfdbeb72b230d263/src/Uris/QueryParameter.cs#L5) from the library [Urls,](https://github.com/MelbourneDeveloper/Urls) which treats URLs as immutable records:

```csharp
using System.Net;

namespace Urls
{
    public record QueryParameter
    {
        private string? fieldValue;

        public string FieldName { get; init; }
        public string? Value
        {
            get => fieldValue; init
            {
                fieldValue = WebUtility.UrlDecode(value);
            }
        }

        public QueryParameter(string fieldName, string? value)
        {
            FieldName = fieldName;
            fieldValue = WebUtility.UrlDecode(value);
        }

        public override string ToString()
            => $"{FieldName}{(Value != null ? "=" : "")}{WebUtility.UrlEncode(Value)}";
    }
}
```

We ensure that we decode the query value when storing it, and then we encode it when we use it as part of a Url.

You could ask the question: why not make everything a record? It seems that there would be pitfalls associated with this, but we are venturing into new territory, and we are yet to map out best-practice for records in the C# context. 

Wrap-Up
-------

It will take a few years for developers to come to terms with records and lay the ground rules for using them. You currently have a blank slate, and you and are free to experiment until the "experts" start telling you otherwise. My advice is only to use records to represent fixed data and minimal logic. Use the syntax sugar where you can. However, there are apparent scenarios where minimal validation in the constructor may be practical. Use your judgment, discuss with your team, and weigh up the pros and cons. 

_Edit: this tweet was edited and corrected thanks to this tweet_
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">This will bypass the validation. I think we&#39;ve been discussing this. If you intend to use &#39;With&#39; then probably u should implement full props and place validations there. <a href="https://t.co/kwXhoY75nO">pic.twitter.com/kwXhoY75nO</a></p>&mdash; Fati Iseni (@fiseni) <a href="https://twitter.com/fiseni/status/1387543409213181954?ref_src=twsrc%5Etfw">April 28, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script> 