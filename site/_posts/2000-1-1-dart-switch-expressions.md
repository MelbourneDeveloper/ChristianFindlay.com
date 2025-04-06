---
layout: post
title: "Dart Switch Expressions"
date: "2023/05/11 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/dart/dart.png"
post_image_width: 300
image: "/assets/images/blog/dart/dart.png"
tags: ADTs dart functional-programming
categories: flutter
permalink: /blog/:title
description: Dive into Dart 3's new switch expression feature and other features like pattern matching that support it. Understand how these enhance functional programming and improve Flutter development. Learn through examples for a comprehensive understanding of Dart 3.
keywords: [
  "Dart 3 features",
  "Switch expressions Dart",
  "Dart pattern matching",
  "Functional programming Dart",
  "Dart 3 switch expression",
  "Exhaustiveness checking Dart",
  "Dart sealed types",
  "Flutter state management",
  "Dart records",
  "Dart guard clauses",
  "Dart multi-paradigm programming",
  "Flutter development",
  "Dart 3 syntax improvements",
  "Dart expressions vs statements",
  "Dart algebraic data types",
  "Async snapshot handling Flutter",
  "Dart imperative programming",
  "Dart declarative programming",
  "Dart code conciseness",
  "Flutter widget composition"
]
---

Dart 3 adds a new feature called [Switch Expressions](https://dart.dev/language/branches#switch-expressions). Dart is a multi-paradigm language that supports both [object-oriented](https://en.wikipedia.org/wiki/Object-oriented_programming), [imperative](https://en.wikipedia.org/wiki/Imperative_programming), [functional-style](https://en.wikipedia.org/wiki/Functional_programming) and [declarative](https://en.wikipedia.org/wiki/Declarative_programming) programming. Programmers have adopted it worldwide, primarily because of its simplicity, flexibility, and because it the main language for the Flutter framework. The release of Dart 3 brought several new features and improvements around functional style programming, with the new switch expression being one. 

If you find Dart's Switch Expression useful, you should also look into [Dart's Algebraic Data Types](https://www.christianfindlay.com/blog/dart-algebraic-data-types). This will bring your Dart code design to a new level and supercharge your use of the switch expression.

## Expressions Over Statements
Expressions and statements are two foundational concepts in coding. Expressions evaluate to a value. For example, they include arithmetic like `2 + 2` or more complex functions. Statements, in contrast, perform actions, such as assigning a value to a variable or controlling program flow. Expressions can be part of larger expressions, while statements can only execute an action and can't form part of larger expressions. This is why we consider statements part of imperative programming.

The preference for expressions over statements is characteristic of functional programming. They are more declarative. They emphasize data flow over action sequences, often leading to more concise and testable code. Imperative languages focus on statements and action sequences, which can be more straightforward but potentially lead to more complex code for intricate tasks. As languages evolve, the line between the two styles is getting blurry. Many languages, including Dart, incorporate more expressive features for more powerful and flexible programming.

## What is a Switch Expression?
The traditional Dart switch statement is imperative and procedural. It lacks the capability to return a value directly. The new switch expression is functional in nature. It is an expression rather than a statement, which means it evaluates to a value. This transformation is an important shift as it introduces a new functional programming aspect to Dart, a feature that modernizes the language and offers developers more flexibility and power.

The switch statement is followed by a series of statements. But, the switch expression in Dart 3 uses a syntax similar to arrow functions to map case clauses directly to values. This makes the code more concise, readable, and less prone to errors. Here's an example of how it works:

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-inline.html?id=45452f771b2df8a4a4809fbca7a28568&split=70&mode=dart"></iframe>

## Pattern Matching
Pattern matching is a powerful feature that checks if a given variable or object matches a specific pattern or structure. It's a prevalent feature in functional programming languages like F#, Haskell, Rust, and Scala. You can use it to destructure complex data types, perform conditional execution, and write more readable and intuitive code. It enhances control flow and allows programmers to write cleaner, more efficient code with less error handling.

Dart 3 introduces [pattern matching](https://dart.dev/language/patterns). The new switch expression in Dart 3 supports pattern matching. With pattern matching, each case clause in the switch expression can be an arbitrary pattern, and the expression to the right of the arrow `=>` evaluates only if the pattern matches. You can use pattern matching with various types of patterns, including constant patterns, variable patterns, and structured patterns. This is more powerful than the switch statement, which only allows constant patterns.

This is a very simple example that matches on type:

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-inline.html?id=68bfd14dd9f66473f382c5b732fae405&split=70&mode=dart"></iframe>

## Exhaustiveness Checking
Exhaustiveness checking is a feature that gives compile-time errors if the switch expression does not cover all cases. For example, if you switch on a nullable Boolean (bool? b) without a case for null, you will get an error. However, a default case (_ or default) can cover all possible values, which makes any switch statement exhaustive.

[Sealed types](https://dart.dev/language/class-modifiers#sealed) (another new Dart 3 feature) and enums are especially useful for switches because the compiler knows their possible values ahead of time, even without a default case. Applying the `sealed` modifier to a class enables exhaustiveness checking when switching over its subclasses. If we add a new subclass to a sealed class, the switch expression will be incomplete. Exhaustiveness checking helps flag this. 

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-inline.html?id=f734a8e08f0ff21657a54dc488d97053&split=70&mode=dart"></iframe>

If you add this new class to the example, the code will fail to compile with an exhaustiveness error.

```dart
class Rectangle extends Shape {
  Rectangle(this.length, this.width);
  final double length;
  final double width;
}
```

## Matching On Records and Using Guard Clauses
Dart 3 also introduces [records](https://dart.dev/language/records). Put simply, functions and expressions can return more than one value at a time. We can pattern match on records. This powerful feature allows us to destructure complex data types and perform conditional execution. We can use the `when` keyword to specify a guard clause. This Boolean expression must be true for the case to match. 

Here is an example:

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-inline.html?id=1528d67474e7e37f1a90bc08de8ce12d&split=70&mode=dart"></iframe>

## What Does This Mean For Flutter?
The new syntax makes widget composition even more concise and readable. It also makes it easier to handle complex state management. One example is when handling async snapshots. In this scenario, Dart 2 allowed us to use nested ternaries as expressions. But, the switch expression gives us a new option. 

This is a flutter example. Notice that we can compose the entire app with a single expression, and the switch expression makes the async snapshot handling far less verbose.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=14f042ee757148c1baabcd79dfffad48"></iframe>
</figure>

## Conclusion
Dart 3's new Switch Expression further adds functional programming to the language. It emphasizes expressions over statements and promotes concise, testable code. As Dart evolves, it merges the best of functional and imperative styles. This offers a versatile toolset for developers to craft efficient, robust applications. Dart signifies innovation and adaptability. This will further cement its place as a leading language for cross-platform application development.