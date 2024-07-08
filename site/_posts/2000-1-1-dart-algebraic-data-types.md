---
layout: post
title: "Dart: Algebraic Data Types"
date: "2024/07/05 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/adts/ADTs.webp"
post_image_width: 1200
image: "/assets/images/blog/adts/ADTs.webp"
description: Explore Algebraic Data Types (ADTs) in Dart 3.0+. Learn about sum and product types, see examples in F# and Kotlin, and discover powerful pattern matching in Dart with switch expressions. Learn functional programming skills with ADTs.
tags: dart adts functional-programming records fsharp
categories: flutter
permalink: /blog/:title
---
Algebraic Data Types (ADTs) are a powerful functional programming concept that allows developers to model complex data structures more elegantly than traditional object-oriented classes. They are composite types, meaning that they combine other types. Dart 3.0 introduced sealed classes and [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching), which made ADTs possible in Dart 3. [Dart Switch Expressions](https://www.christianfindlay.com/blog/dart-switch-expressions) leverage pattern matching well. This article explains the concept of ADTs, how to use them in Dart, and why using them with pattern matching solves so many traditional code-design problems that OOP languages tend to struggle with.

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

If you're interested, you can read the [official Dart specification on this feature](https://github.com/dart-lang/language/blob/main/accepted/3.0/patterns/exhaustiveness.md).

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

Notice that the subtypes use the [final](https://dart.dev/language/class-modifiers#final) class modifier. This is important if you want to preserve the behavior of the class and prevent other classes from inheriting from this type. Still, not using it doesn't break exhaustiveness checking.

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
      Circle(radius: final r) => 3.14 * r * r,
      Rectangle(width: final w, height: final h) => w * h,
      Triangle(base: final b, height: final h) => 0.5 * b * h
 };
```

## Pattern Matching in Dart

Let's explore some sophisticated [pattern-matching](https://dart.dev/language/patterns) examples in Dart to showcase the power of ADTs. See my library [nadz](https://pub.dev/packages/nadz) for more complete examples of Result objects as ADTs. This library is also loaded with extension methods to make working with ADTs easier.

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
      Success(value: final v) => onSuccess(v),
      Failure(error: final e) => onFailure(e)
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
      Leaf(value: final v) => v,
      Node(left: final l, right: final r) => sum(l) + sum(r)
 };

num depth<T>(Tree<T> tree) => switch (tree) {
      Leaf() => 0,
      Node(left: final l, right: final r) => 1 + max(depth(l), depth(r))
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

## Avoid Casting and Unnecessary Assignments

FP encourages the use of expressions. Expressions are generally more concise than imperative statements. Instead of writing code in a step-by-step way, expressions return the value of one or more operations. Pattern matching with constructs like Dart switch expressions allow you to write fluid expressions that don't require unnecessary variable assignments or casting. 

While this point is not strictly about ADTs, it illustrates how a shift towards expressions over statements can generally improve your code. ADTs help you move your code in this direction.

Consider these three functions. 

```dart
import 'dart:convert';

void main() {
  final jsonMap = jsonDecode('{ "test": 123 }');

  final one = numberWithCasting(jsonMap as Map<String, dynamic>);
  final two = numberWithTypePromotion(jsonMap);
  final three = numberWithSwitch(jsonMap);

  print(one);
  print(two);
  print(three);
}

int numberWithCasting(
  Map<String, dynamic> jsonMap,
) {
  if (jsonMap['test'] is int) {
    return jsonMap['test'] as int;
 }
  return -1;
}

int numberWithTypePromotion(
  Map<String, dynamic> jsonMap,
) {
  final test = jsonMap['test'];
  if (test is int) return test;
  return -1;
}

int numberWithSwitch(
  Map<String, dynamic> jsonMap,
) =>
    switch (jsonMap['test']) {
      final int value => value,
 _ => -1,
 };
```

Notice that the first two functions require you to either cast the type to `int` with `as` or make a variable assignment. There is nothing inherently wrong with the extra assignment in `numberWithTypePromotion`, but the naming of the variable can detract from the readability of the function and make the code more verbose. 

On the other hand, casting is generally bad because it can cause exceptions. Avoiding the `as` keyword is generally advisable, even in cases where it obviously does not cause an issue. If someone refactors this code, they may separate the type check from the cast, and then the cast becomes dangerous. 

The third function, `numberWithSwitch,` addresses both issues by eliminating the need for a variable assignment and combining the type check with the switch. The switch only returns the value if the expected type occurs and allows us to safely deal with other cases.

## Records

Records are another recent addition to the Dart language and add further expressiveness to ADTs. Here is a simple example of a record type, which is a product type in Dart.

```dart
typedef Point = (double x, double y);

double distanceFromOrigin((double, double) point) {
  final (x, y) = point;
  return sqrt(x * x + y * y);
}
```

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

String analyzeProfile(UserProfile profile) => switch (profile) {
      // New or minimal active profiles
      (null, [], Active(lastActive: final date)) =>
        "New user, last active on ${date.toLocal()}. Needs to complete profile.",
      (String b, [final single], Active()) =>
        "Minimal profile: '$b'. Only interested in $single. Very active.",

      // Active coder profiles
      (_, ["coding", final second, final third, ...], Active()) =>
        "Active coder also interested in $second and $third.",

      // Other active profiles
      (String(), [], Active()) ||
      (String(), [_, _], Active()) ||
      (String(), [_, _, _, ...], Active()) =>
        "Active user with varying interests.",
      (null, [_], Active()) ||
      (null, [_, _], Active()) ||
      (null, [_, _, _, ...], Active()) =>
        "Active user without bio, with varying interests.",

      // Suspended profiles
      (_, [_, _, ...], Suspended(reason: final r)) =>
        "Suspended account ($r) with multiple interests.",
      (String() || null, [], Suspended()) =>
        "Suspended account with no interests.",
      (String() || null, [_], Suspended()) =>
        "Suspended account with one interest.",

      // Deactivated profiles
      (String b, final ints, Deactivated(deactivationDate: final date)) =>
        "Deactivated on $date. Bio: '$b'. Had ${ints.length} interests.",
      (null, [], Deactivated()) =>
        "Deactivated account without bio or interests.",
      (null, [_], Deactivated()) =>
        "Deactivated account without bio, with one interest.",
      (null, [_, _], Deactivated()) =>
        "Deactivated account without bio, with two interests.",
      (null, [_, _, _, ...], Deactivated()) =>
        "Deactivated account without bio, with multiple interests.",
    };

void main() {
  final now = DateTime.now();
  final profiles = <(String?, List<String>, AccountStatus)>[
    // New active user
    (null, <String>[], Active(now)),

    // Minimal active profile
    ("Dart lover", ["programming"], Active(now)),

    // Active coder profile
    ("I code, therefore I am", ["coding", "philosophy", "coffee"], Active(now)),

    // Active user with varying interests
    ("Eclectic", ["music", "sports", "cooking", "travel"], Active(now)),

    // Active user without bio, with varying interests
    (null, ["reading", "writing", "arithmetic"], Active(now)),

    // Suspended profile with multiple interests
    ("Flutter enthusiast", ["mobile", "web", "AI"], Suspended("Spam")),

    // Suspended profile with no interests
    ("Oops", [], Suspended("Violation of terms")),

    // Suspended profile with one interest
    (null, ["trouble"], Suspended("Inappropriate behavior")),

    // Deactivated profile with bio and interests
    ("Ex-user", ["reading", "writing"], Deactivated(DateTime(2023, 12, 31))),

    // Deactivated profile without bio or interests
    (null, [], Deactivated(DateTime(2023, 11, 15))),

    // Deactivated profile without bio, with one interest
    (null, ["gaming"], Deactivated(DateTime(2023, 10, 1))),

    // Deactivated profile without bio, with two interests
    (null, ["music", "dance"], Deactivated(DateTime(2023, 9, 15))),

    // Deactivated profile without bio, with multiple interests
    (
      null,
      ["art", "science", "history", "literature"],
      Deactivated(DateTime(2023, 8, 1))
    ),
  ];

  // Analyze and print results for each profile
  for (final profile in profiles) {
    print(analyzeProfile(profile));
    print('---'); // Separator for readability
  }
}
```
#### Output

```dart
Minimal profile: 'Dart lover'. Only interested in programming. Very active.

Active coder also interested in philosophy and coffee.

Active user with varying interests.

Active user without bio, with varying interests.

Suspended account (Spam) with multiple interests.

Suspended account with no interests.

Suspended account with one interest.

Deactivated on 2023-12-31 00:00:00.000. Bio: 'Ex-user'. Had 2 interests.

Deactivated account without bio or interests.

Deactivated account without bio, with one interest.

Deactivated account without bio, with two interests.

Deactivated account without bio, with multiple interests.
```

Notice that the switch cases allow you to bind variables. For example `lastActive` becomes `date`. Also notice that we don't need to do a null check on `Bio: '$b'` because the match already determined that the value is not null.

## Conclusion
Dart has taken a significant step towards supporting the functional programming paradigm. These features enable developers to write more expressive, type-safe, and maintainable code and it bridges the gap between Dart and languages traditionally associated with functional programming.

The access modifiers enable powerful ADT features, and if you start thinking in FP style, your code design becomes more natural and fluent. There are fewer opportunities for exceptions to occur. It probably won't be obvious until you try it a few times for yourself, but this is a game changer for your code design game.