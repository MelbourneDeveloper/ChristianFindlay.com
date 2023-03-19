---
layout: post
title: "C# String Interpolation"
date: Oct 5, 2019
tags: csharp
categories: [dotnet]
author: "Christian Findlay"
post_image: "/assets/images/blog/stringinterpolation/header.jpg"
image: "/assets/images/blog/stringinterpolation/header.jpg"
permalink: /blog/:title
---

Introduction
------------

String interpolation allows the creation of string literals with interpolation expressions. The syntax is convenient for formatting strings and is generally more readable than composite formatting (e.g. `string.Format()`). C# added the feature in version 6. Developers should take localization (translation) into account when adding strings to any system. If a translation is not necessary, string interpolation is generally better than using composite formatting for string literals.

String Formatting Options
-------------------------

Here is an example of an _interpolated string_. It includes the integer 10 as part of the formatted string.

```csharp
var errorCode = 10;   var message = $"An error occurred. Error code: {errorCode}";
```

Output

_An error occurred. Error code: 10_

Notice that the string literal is easy to read. Here is the equivalent with traditional string concatenation.

```csharp
var errorCode = 10;   var message = $"An error occurred. Error code: " + errorCode;
```

Notice that the string the plus operator makes the literal harder to read and usually makes the declaration longer. It is equivalent to composite formatting.

```csharp
var errorCode = 10;   var message = string.Format("An error occurred. Error code: {0}", errorCode);
```

Notice that this method is error-prone because the number of arguments passed to the **Format** function must match the numbers specified in the string literal. If they don’t, the application throws an exception.

Interpolation Symbols $ { } ()
------------------------------

Developers can convert any string literal to an interpolated string. To do so, prepend the literal with the dollar sign symbol. It tells the compiler or syntax parser that the string contains interpolation expressions within the literal. At compile time, the compiler generally converts the expression to a string.Format or similar call.

To specify an _interpolation expression_, open the expression with a brace { and close it afterward}. The expression contained within the braces renders into the string literal at runtime. This example shows the use of expressions inside the literal

```csharp
var item = new { Name = "Banana", Price = (decimal)1 };   var message = $"This item is a {item.Name} and costs ${item.Price}";
```

Output:

_This item is a Banana and costs $1_

Notice that the dollar sign at the start of the literal specifies that the string contains interpolation. However, the second dollar sign is treated as a normal part of the literal and can be included anywhere within the literal.

To specify conditional expressions with the _conditional operator_, you must wrap the expression in parentheses. Here is an example.

```csharp
var item = new { Name = "Banana", Price = (decimal)1, IsYellow = true };   var message = $"This item is {(item.IsYellow ? "yellow" : "not yellow")}";
```

Output

_This item is yellow_

Notice that the string includes “yellow” when \`IsYellow\` is true, and “not yellow” when it is false. The following example _does not compile_ because the conditional code does not wrap the expression in parentheses.

```csharp
var item = new { Name = "Banana", Price = (decimal)1, IsYellow = true };   var message = $"This item is (item.IsYellow ? "yellow" : "not yellow"}";
```

Refactoring Tools
-----------------

Tools can be used to find and convert string literals to interpolated strings automatically. Below is an example of Visual Studio C# project with FxCop rules turned on. It can help to find cases where interpolated strings can be used, and convert them to interpolation. Many other refactoring tools have similar functionality.

![Quick Tips](/assets/images/blog/stringinterpolation/ctrldot.png){:width="100%"}

Internationalization
--------------------

Developers should generally store string literals in locations where the app can retrieve them in the user’s local language. Developers should consider this at the beginning of a project. However, internationalization is not always a requirement for a given project, and it is sometimes acceptable for system-level error messages and so on to remain in English.

When translating text into multiple languages, it is often necessary to store string literals in a way that allows for string swapping at runtime. Languages other than English often do not have the same word ordering as English, so it may still be necessary to use string.Format for internationalization like so.

```csharp
var errorCode = 10;var cultureInfo = new CultureInfo("en-US");var rawResource = ResourceFile.GetString("ErrorMessage", cultureInfo);   var message = string.Format( rawResource, errorCode);
```

In these cases, string interpolation would not be appropriate.

The most common way to allow translation is to store strings in resource files. However, this bakes the strings into the DLLs and makes it impossible to change them without recompiling and redeploying. It would be better to use a cloud-based string translation API.

Conclusion
----------

String interpolation increases the readability, and conciseness of string literals. It is not always appropriate to leave string literals in code, but when it is appropriate, developers should use string interpolation. The easiest way to harness the functionality is by finding a tool to help convert string literals to interpolated strings. Lastly, if you find a good cloud-based string translation API, please let me know!