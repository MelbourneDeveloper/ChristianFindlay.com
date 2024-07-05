---
layout: post
title: "Dart: Algebraic Data Types"
date: "2024/05/05 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/adts/ADTs.png"
image: "/assets/images/blog/adts/ADTs.png"
description: Explore Algebraic Data Types (ADTs) in Dart 3.0+. Learn about sum and product types, see examples in F# and Kotlin, and discover powerful pattern matching in Dart with switch expressions. Learn functional programming skills with ADTs.
tags: dart adts functional-programming records fsharp
categories: flutter
permalink: /blog/:title
---
Algebraic Data Types (ADTs) are a powerful functional programming concept that allows developers to model complex data structures more elegantly than traditional object-oriented classes. They are composite types, meaning that they combine other types. Dart 3.0 introduced sealed classes and [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching), which made ADTs possible in Dart 3. This article explains the concept of ADTs, how to use them in Dart, and why using them with pattern matching solves so many traditional code-design problems that OOP languages tend to struggle with.

## What are Algebraic Data Types?

The official Dart documentation doesn't explain ADTs, or Dart's relationship to ADTs very well. It glosses over the concept and only introduces one aspect of ADTs in Dart. This article gives a broader perspective on ADTs outside of Dart and gives some examples in other languages.  If you want some background reading, the [Wikipedia article on ADTs](https://en.wikipedia.org/wiki/Algebraic_data_type) is a good place to start.

There are two main categories of ADTs, and it's important to understand these definitions.

[Sum types](https://en.wikipedia.org/wiki/Tagged_union) (also known as tagged unions or variants)

[Product types](https://en.wikipedia.org/wiki/Product_type) (such as tuples or [records](https://dart.dev/language/records))

You can combine these types to create more complex structures, which enables developers to represent data and states in a highly expressive manner.

## ADTs in Other Languages

Before we look at Dart's implementation, we should see how other languages known for their strong functional programming support handle ADTs. 

### F#

[F#](https://fsharp.org/) is a modern, FP-first, statically-typed language and provides excellent support for ADTs through discriminated unions:

```fsharp
type Shape =
    | Circle of radius: float
    | Rectangle of width: float * height: float
    | Triangle of base: float * height: float

let area = function
    | Circle r -> Math.PI * r * r
    | Rectangle (w, h) -> w * h
    | Triangle (b, h) -> 0.5 * b * h
```

The `Shape` type is a discriminated union, which is F#'s implementation of a sum type. It encapsulates three distinct shapes (Circle, Rectangle, and Triangle) within a single type. Each has its own set of parameters. This structure allows for type-safe representation of different shapes without the need for inheritance or interfaces. 

The `area` function demonstrates pattern matching. Importantly, there are only three possible shapes, which allows the compiler to know ahead of time what branches the code can travel down. It is a key feature of ADTs. This is called [exhaustiveness checking](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/pattern-matching). It uses a single function to calculate the area for any shape, and the compiler ensures all cases are covered. 

### Kotlin

Kotlin is a modern, hybrid paradigm language like Dart. Like Dart, Kotlin represents ADTs using sealed classes:

```kotlin
sealed class Shape {
 data class Circle(val radius: Double) : Shape()
 data class Rectangle(val width: Double, val height: Double) : Shape()
 data class Triangle(val base: Double, val height: Double) : Shape()
}

val area: (Shape) -> Double = { shape ->
 when (shape) {
 is Shape.Circle -> Math.PI * shape.radius * shape.radius
 is Shape.Rectangle -> shape.width * shape.height
 is Shape.Triangle -> 0.5 * shape.base * shape.height
 }
}
```

## The Benefit of ADTs and Pattern Matching

ADTs give you tools to improve your code design.

Type safety: they provide compile-time guarantees about the structure of data and reduce the need for casting

Exhaustiveness checking: compilers can determine whether or not your code handled all cases with pattern matching.

Expressiveness: you can represent complex domain models clearly and concisely. 

Immutability: ADTs encourage immutable data structures, which reduces side effects.

Consider this Dart code. At first glance, it has the right data, but there is a problem. None of the values are mutually exclusive, even though the states that the class represents have mutually exclusive pieces of data.

```dart
class AuthState {
  final String? userId;
  final String? errorMessage;
  final bool isLoading;

  AuthState({this.userId, this.errorMessage, this.isLoading = false});

  bool get isAuthenticated => userId != null;
  bool get hasError => errorMessage != null;

  // This allows creation of invalid states
  // e.g., AuthState(userId: "123", errorMessage: "Error")
}

// Usage
void handleAuth(AuthState state) {
  if (state.isLoading) {
    print("Loading...");
  } else if (state.isAuthenticated) {
    print("Welcome, user ${state.userId}");
  } else if (state.hasError) {
    print("Error: ${state.errorMessage}");
  } else {
    print("Please log in");
  }
}
```

ADTs solve this code-design issue and make accessing this data far safer because you can't access two pieces of mutually exclusive data at the same time.

## ADTs in Dart

Dart 3.0 introduces several new [class access modifiers](https://dart.dev/language/class-modifiers), such as the [sealed modifier](https://dart.dev/language/class-modifiers#sealed). This addition brings the ADT approach to Dart and allows for a form of sum type.

Let's look at how we can improve upon the previous example with ADTs in Dart. Notice that the user id and error message are now mutually exclusive pieces of data. We cannot create a scenario where there is both a `userId` and an `errorMessage`. This is the magic of ADTs. We prevent states that shouldn't exist from occurring in the first place. 

```dart
sealed class AuthState {}

final class Unauthenticated extends AuthState {}

final class Authenticating extends AuthState {}

final class Authenticated extends AuthState {
  final String userId;
  Authenticated(this.userId);
}

final class AuthError extends AuthState {
  final String errorMessage;
  AuthError(this.errorMessage);
}

// Usage
String handleAuth(AuthState state) => switch(state) {
  Unauthenticated() => "Please log in",
  Authenticating() => "Loading...",
  Authenticated(:final userId) => "Welcome, user $userId",
  AuthError(:final errorMessage) => "Error: $errorMessage"
};

// Example usage
void main() {
  final states = [
    Unauthenticated(),
    Authenticating(),
    Authenticated("user123"),
    AuthError("Invalid credentials"),
  ];

  for (final state in states) {
    print(handleAuth(state));
  }
}
```

The example above uses a sealed type, `AuthState,` to declare a fixed set of types that can derive from it. The compiler knows that these are the only possible types, which means it can do [exhaustiveness checking](https://dart.dev/language/branches#exhaustiveness-checking).

Exhaustiveness checking forces you to handle all possible states. If you don't, you will get a compilation error. This removes a whole category of potential exceptions from your code. Without exhaustive cases, your code could end up on an unknown branch, and the code would throw an exception. Then, you'd have to handle the exception at a higher level. ADTs allow you to avoid this need. 

Notice that the subtypes use the [final](https://dart.dev/language/class-modifiers#final) class modifier, which is important because otherwise, you could inherit from the class and break the exhaustiveness checking.

Here is the shape example we saw earlier, but in Dart:

```dart
sealed class Shape {}

final class Circle extends Shape {
  final double radius;
  Circle(this.radius);
}

final class Rectangle extends Shape {
  final double width;
  final double height;
  Rectangle(this.width, this.height);
}

final class Triangle extends Shape {
  final double base;
  final double height;
  Triangle(this.base, this.height);
}

double area(Shape shape) => switch (shape) {
      Circle(radius: var r) => 3.14 * r * r,
      Rectangle(width: var w, height: var h) => w * h,
      Triangle(base: var b, height: var h) => 0.5 * b * h
 };
```

## Pattern Matching in Dart

Let's explore some sophisticated [pattern-matching](https://dart.dev/language/patterns) examples in Dart to showcase the power of ADTs. See my library [nadz](https://pub.dev/packages/nadz) for more complete examples of Result objects as ADTs.

```dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);
}

T match<T, R>(
  Result<R> result,
  T Function(R) onSuccess,
  T Function(String) onFailure,
) =>
    switch (result) {
      Success(value: var v) => onSuccess(v),
      Failure(error: var e) => onFailure(e)
 };

// Usage
void main() {
  final result = Success(42);
  final output =
      match(result, (value) => "Success: $value", (error) => "Failure: $error");
  print(output); // Output: Success: 42
}
```

The above is an example of a Result object that can either have a state of `Success` or `Failure` and allows you to specify what mutually exclusive data these two states have.

Here's a more complex example using nested patterns:

```dart
import 'dart:math';

sealed class Tree<T> {
  const Tree();
}

class Leaf<T> extends Tree<T> {
  final T value;
  const Leaf(this.value);
}

class Node<T> extends Tree<T> {
  final Tree<T> left;
  final Tree<T> right;
  const Node(this.left, this.right);
}

int sum(Tree<int> tree) => switch (tree) {
      Leaf(value: var v) => v,
      Node(left: var l, right: var r) => sum(l) + sum(r)
 };

num depth<T>(Tree<T> tree) => switch (tree) {
      Leaf() => 0,
      Node(left: var l, right: var r) => 1 + max(depth(l), depth(r))
 };

// Usage
final tree =
    Node(Node(Leaf(1), Leaf(2)), Node(Leaf(3), Node(Leaf(4), Leaf(5))));

main() {
  print(sum(tree)); // Output: 15
  print(depth(tree)); // Output: 3
}
```

ADTs are a great choice for tree structures in Dart because any element could be a `Node` or a `Leaf`.

## Records

Records are another recent addition to the Dart language and add further expressiveness to ADTs. Here is a simple example of a record type, which is a product type in Dart.

typedef Point = (double x, double y);

double distanceFromOrigin((double, double) point) {
  var (x, y) = point;
  return sqrt(x * x + y * y);
}

## A Complete Example

This example combines several different types of data into a record and gives you an example of how you might use it in switch expression with pattern matching

```dart
// Sealed class representing different account statuses
sealed class AccountStatus {}

// Represents an active user account
class Active extends AccountStatus {
  final DateTime lastActive;
  Active(this.lastActive);
}

// Represents a suspended user account
class Suspended extends AccountStatus {
  final String reason;
  Suspended(this.reason);
}

// Represents a deactivated user account
class Deactivated extends AccountStatus {
  final DateTime deactivationDate;
  Deactivated(this.deactivationDate);
}

// Record type representing a user profile with bio, interests, and account status
typedef UserProfile = (
  String? bio,
  List<String> interests,
  AccountStatus status
);

// Function to analyze a user profile using pattern matching
String analyzeProfile(UserProfile profile) => switch (profile) {
      // New user with empty profile
 (null, [], Active(lastActive: var date)) =>
        "New user, last active on ${date.toLocal()}. Needs to complete profile.",

      // User with minimal profile information
 (String b, [var single], Active()) =>
        "Minimal profile: '$b'. Only interested in $single. Very active.",

      // Suspended user with multiple interests
 (_, [_, _, ...], Suspended(reason: var r)) =>
        "Suspended account ($r) with multiple interests.",

      // Deactivated user profile
 (String b, var ints, Deactivated(deactivationDate: var date)) =>
        "Deactivated on $date. Bio: '$b'. Had ${ints.length} interests.",

      // Active coder with multiple interests
 (_, ["coding", var second, var third, ...], Active()) =>
        "Active coder also interested in $second and $third.",

      // Default case for any other profile type
 _ => "Other profile type"
 };

void main() {
  // List of example user profiles
  final profiles = [
 (null, <String>[], Active(DateTime.now())),
 ("Dart lover", ["programming"], Active(DateTime.now())),
 ("Flutter enthusiast", ["mobile", "web", "AI"], Suspended("Spam")),
 (
      "I code, therefore I am",
 ["coding", "philosophy", "coffee"],
      Active(DateTime.now())
 ),
 ("Ex-user", ["reading", "writing"], Deactivated(DateTime(2023, 12, 31))),
 ("Mysterious", ["enigma"], Active(DateTime.now())),
 ];

  // Analyze and print results for each profile
  for (final profile in profiles) {
    print(analyzeProfile(profile));
 }
}
```

Notice that the switch cases allow you to bind variables. For example `lastActive` becomes `date`. Also notice that we don't need to do a null check on `Bio: '$b'` because the match already determined that the value is not null.

## Conclusion
Dart has taken a significant step towards supporting the functional programming paradigm. These features enable developers to write more expressive, type-safe, and maintainable code and it bridges the gap between Dart and languages traditionally associated with functional programming.

The access modifiers enable powerful ADT features, and if you start thinking in FP style, your code design becomes more natural and fluent. There are fewer opportunities for exceptions to occur. It probably won't be obvious until you try it a few times for yourself, but this is a game changer for your code design game.