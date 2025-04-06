---
layout: post
title: "Dart Immutable Collections"
date: "2022-09-29 00:00:00 +0000"
tags: dart functional-programming
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/blog/Immutability/header.png"
post_image_width: 300
image: "/assets/images/blog/Immutability/header.png"
permalink: /blog/:title
---

Dart makes it pretty easy to create [immutable classes](https://en.wikipedia.org/wiki/Immutable_object), and several patterns encourage you to use them. However, we often don't use immutable collections correctly. If a class has a collection property that is not immutable, the class is not actually immutable. It's possible to add, remove or change one of the collection elements, which means we can mutate the overall class. For a class to be immutable, all members must be immutable, so collections must also be immutable.

What is an Immutable Collection?
--------------------------------

An immutable collection is a collection that you can't change. You cannot add, remove, modify the elements, or reorder the elements. The normal constructor of `List<T>` type does not qualify as immutable because it allows you to do all these things. For example, this class is not actually immutable because we can change elements in the strings list.


<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-inline.html?id=efe0676acbcf2abd74d37c74ebb25d23"></iframe>
</figure>

It is impossible to modify an immutable collection. Still, the collection in this example is mutable, which makes class A mutable even though we marked it with the `@immutable` annotation.

How Can We Use Immutable Collections?
-------------------------------------

An immutable collection should have runtime safety and compile time safety. That means a running app cannot modify the collection, and the app should not compile if we try to modify the list. There are a few packages on [Pub.dev](https://pub.dev/) that do this, but I'm going to point you to the [fixed_collections](https://pub.dev/packages/fixed_collections) package because it has an important feature.

The collections in this package are normal `Lists`, `Sets` and `Maps`. `FixedList` implements the `List` interface, `FixedSet` implements the `Set` interface, and `FixedMap` implements the `Map` interface. You can pass them into any function or constructor that accepts those basic collections. You don't have to convert between collection types.

```dart
void main(List<String> arguments) {
  final fixedList = FixedList([1, 2, 3,]);
  printLength(fixedList);
}
void printLength(List<int>list) => print(list.length);
```

Under the hood, these collections just use the [unmodifiable constructors](https://api.flutter.dev/flutter/dart-core/List/List.unmodifiable.html) on their class. They don't have any extra logic, but if you use the mutable members with code analysis errors turned on, you will see errors at compile time. You could use these constructors, but the unmodifiable constructor doesn't give you any compilation time errors. In fact, these constructors, without the benefit of compile-time errors, may make your code more error-prone because you may accidentally modify the collection at runtime and cause an error. Here is an example with compile time errors.

![](/assets/images/blog/immutability/error.png){:width="100%"}

In contrast, other immutable collections take a different approach. The `built_collection` package uses the builder pattern to create built collections. It's a good package, but the types don't implement the common interfaces like `List<>`. This code doesn't compile because you can't pass a `BuiltList` to a function that accepts `List`.

![](/assets/images/blog/immutability/error2.png){:width="100%"}

Note: you can convert a `BuiltList` to a `List`, but you have to call `toList()`

To use the `fixed_collections` package, [install ](https://pub.dev/packages/fixed_collections/install)it, and [turn on errors](https://pub.dev/packages/fixed_collections#errors) in your analysis options file. This is a simple example. You can use these collections like any other `List`, `Set` or `Map`.

```dart
import 'package:fixed_collections/fixed_collections.dart';

void main(List<String> arguments) {
  final fixedList = FixedList([1, 2, 3]);
  test(fixedList);
}

void test(List<int> list) => print(list.length);
```

Equality (Comparing Lists)
--------------------------

You may need to override the `==` operator or hashCode on your class. But, as this [linter rule](https://dart.dev/guides/language/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes) says:

> When you define `==`, you also have to define `hashCode`. Both of those should take into account the object's fields. If those fields *change* then that implies the object's hash code can change. Most hash-based collections don't anticipate that---they assume an object's hash code will be the same forever and may behave unpredictably if that isn't true.

So, if your class has a mutable collection and the class's hash code depends on the collection's hash code, it may behave unpredictably. This is one strong reason that we should use immutable collections on immutable classes.

fixed_collections doesn't override the equality behaviour of your collection. Other packages do this, and this is not the library's focus. Take a look at [listEquals ](https://api.flutter.dev/flutter/foundation/listEquals.html)for basic list comparisons, and consider using the [equatable ](https://pub.dev/packages/equatable)package if you need to override equality in your class. The library documentation says this:

> Equatable is designed to only work with immutable objects, so all member variables must be final (This is not just a feature of Equatable - [overriding a hashCode with a mutable value can break hash-based collections](https://dart.dev/guides/language/effective-dart/design#avoid-defining-custom-equality-for-mutable-classes))

Again, it's important to use immutable collections on your immutable classes. Here is an example of using FixedList with equatable. This prints `true`.

```dart
import 'package:equatable/equatable.dart';
import 'package:fixed_collections/fixed_collections.dart';
import 'package:meta/meta.dart';

@immutable
class ImmutableExample extends Equatable {
  const ImmutableExample(this.name, this.numbers);

  final String name;
  final FixedList<int> numbers;

  @override
  List<Object?> get props => [name, numbers];
}

void main(List<String> arguments) {
  final example1 = ImmutableExample(
    'example',
    FixedList(
      [1, 2, 3],
    ),
  );
  final example2 = ImmutableExample(
    'example',
    FixedList(
      [1, 2, 3],
    ),
  );
  print(example1 == example2);
}
```

Maximizing Immutability
-----------------------

We allow opportunities to accept mutable lists if we accept the `List<>` type in Dart or Flutter. Use `FixedList`, `FixedSet`, and `FixedMap` directly in your code, so it's harder to receive mutable lists. Change your classes and functions to accept the fixed version of the type. Here is a Flutter example.

```dart
import 'package:fixed_collections/fixed_collections.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
      widgets: FixedList([
    const Text(' One '),
    const Text(' Two '),
    const Text(' Three '),
  ])));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.widgets, super.key});

  final FixedList<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
```

Wrap-up
-------

Use immutable lists where you can. They make your code less error-prone. There are several packages on pub dev that you can experiment with, but you want to make sure that whichever solution you run with, you see errors at compile time.

<sub><sup>[Photo by Pixabay from Pexels](https://www.pexels.com/photo/gray-and-blue-land-form-158729)</sup></sub>