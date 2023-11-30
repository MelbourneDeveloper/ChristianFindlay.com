---
layout: post
title: "Reactive Programming in Flutter: Understanding the Power of Observables and Computed Values with Signals, Riverpod and RxDart"
date: "2023/11/30 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/reactive/flutterrx.png"
image: "/assets/images/blog/reactive/flutterrx.png"
description: "Explore the dynamic world of Reactive Programming in Flutter with this comprehensive blog post. Delve into the intricacies of Observables and Computed Values, and discover how libraries like Signals, Riverpod, and RxDart simplify state management in Flutter. The expert analysis navigates through the frameworks, emphasizing the unique approaches to reactive computations, dependency tracking, and minimizing unnecessary recomputes. Ideal for both beginners and seasoned Flutter developers, this post illuminates the advantages of integrating reactive patterns in your Flutter applications, ensuring your UI and data stay perfectly in sync. Master the art of reactive Flutter development!"
tags: reactive dart
categories: flutter
permalink: /blog/:title
---

This article introduces you to the concept of [Reactive programming](https://en.wikipedia.org/wiki/Reactive_programming) (Rx) in Flutter and talks about how a few popular libraries implement it. It talks about the role of "caching" or storing computed values and introduces a new library called [Signals](https://pub.dev/packages/signals) that deals with a fundamental Rx problem that other libraries don't fully cover. This library is a port from the [Preact.js](https://preactjs.com/) framework.

## Reactive Programming
Reactive programming is a paradigm centered around reacting to changes in data over time. It facilitates propagating updates automatically. This ensures UI and data remain in sync. In Flutter terms, this means triggering rebuilds automatically whenever the state changes.

### Observables: The Core of Reactivity
Observables are at the core of Reactive Programming. These are data sources that emit updates to subscribers whenever data changes. Dart's core observable type is Stream. Flutter has two types: `ValueNotifier`, and `ChangeNotifier`, which are observable-like types but don't offer any real computational combinability. The RxDart library also has a popular type called `BehaviorSubject`.

Observables notify listeners when the state changes. Anything from a user interaction to a data fetch operation can trigger this. This facilitates how Flutter apps respond in real-time to user inputs and other changes.

### The Misconception of "Cache" in Reactive Programming
People often misuse the term "cache" in the reactive programming context. In this context, a better term for "cache" would be "computed values" or ["memoization"](https://en.wikipedia.org/wiki/Memoization). Reactive computation is the process of deriving new values automatically when the underlying data changes. This is unlike traditional caching, which stores data for quick retrieval and usually has a time-based expiry. Reactive computations dynamically generate new states based on changes in underlying data.

However, storing computed values is important because you don't want to recalculate values unnecessarily. 

## The Core Problem

The core problem that Reactive Programming attempts to deal with is automating the triggering of computations when any value (dependency) in the dependency graph changes. If there are multiple observable values, and you need to combine them into a computation, the Rx library should do this for us automatically. Also, the library should minimize recomputes automatically to enhance performance.

The `ValueNotifier` class in Flutter is reactive in a sense because it notifies observers when there is a value change, but you need to manually listen to changes on all values to compute the full value. Look at this example and note how it requires the `_updateFullName` method to work.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=b59fdfa637188576d073dbfa53fd7689"></iframe>
</figure>

If you make a mistake in the code above, changing either of the names won't result in a UI update. This could be problematic.

## Do I Need Rx?

Let's take a step back here. You saw an example where there were two observable values that we wanted to combine into another observable: `fullName`. But do you need an Rx framework to deal with this?  

In most cases, you don't. 

In most cases, you don't need to listen to value changes on each value. It's just not necessary. You can use a simple `ChangeNotifier`, or even a `StatefulWidget`. This example bundles the state into the `ChangeNotifier`, and changing the first name or surname updates the UI.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=850a8261c535cb64f80620ed372eff33"></iframe>
</figure>

You only need specialized Rx functionality when there is some special need to listen to multiple values that comprise other values. So, don't try to build Rx into every app level. It may add unnecessary complexity.

## Surveying the Rx Options

Perhaps you've discovered a case in your app that does actually need to listen to multiple values and computations of those. This section explains your options. Let's take a look.

### ValueNotifier

**Overview**: `ValueNotifier` allows for simple reactive patterns.

**Reactive Computation**: It doesn't solve the core problem of automatically computing values. You must explicitly write functions to compute and update values when the underlying state changes, leading to increased boilerplate and potential for errors.

This does the job, but you need to do manual work. It doesn't automate much for you, as you saw above.

### Riverpod

**Overview**: [Riverpod](https://riverpod.dev/docs/introduction/why_riverpod) is a library that aims at being a "reactive caching framework"

**Reactive Computation**:  It does perform reactive computations automatically. However, combining and reacting to multiple state changes still requires some manual effort. Inside the computed value Provider, you need to manually call watch on each dependency, as seen in the example below.

 **Storing Computed Values**: Riverpod stores computed values. It doesn't automatically minimize recomputes, but it does offer the [select](https://riverpod.dev/docs/advanced/select#filtering-widgetprovider-rebuild-using-select) method to help you minimize recomputes.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=3e65ba721a77717ed951e4f9ac269f2a"></iframe>
</figure>

My personal opinion is that the Riverpod example highlights a non-standard approach to managing variables (state). It's not that top-level declarations are inherently bad. The issue is that the approach usurps the language's normal variable scoping mechanism and moves the variable into a scope that Riverpod manages, while the underlying code that manages this is quite hard to follow.

The `Consumer` widget here is necessary to interact with the state. None of the other approaches require a custom `Widget`. `Consumer` has a non-standard `build` method, which means if you ever need to change state management solutions, you will also have to change the physical widgets instead of just the state.

This is unlike Signals below, where you can benefit from the library without needing custom widgets. This does, however, offer the advantage of automatic disposal.

### RxDart

**Overview**: Brings the power of [ReactiveX](https://reactivex.io/) to Flutter. 

**Reactive Computation** As shown in the example below, It has advanced handling of reactive computations compared to `ValueNotifier`. Still, it requires explicit logic to combine and react to different data streams.

**Storing Computed Values**: it doesn't directly store computed values in a stateful way, but it does provide useful operators like [distinctUnique](https://pub.dev/documentation/rxdart/latest/rx/DistinctUniqueExtension/distinctUnique.html) to help you minimize recomputes.

This library adds functionality to Dart's existing streams. It doesn't reinvent the wheel and uses patterns familiar to developers on other platforms. This is a safe bet for adding Rx in small doses.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=faca2cbc7c0c4eca96df1254e080c4fb"></iframe>
</figure>

### Signals

**Overview**: [Signals](https://pub.dev/packages/signals) introduces an innovative, elegant solution with its `computed` function. It automatically creates reactive computations that update when any of the dependent values change. This thoroughly sets it apart from the earlier options.

**Reactive Computation**: it automatically achieves reactive computation with minimal code. As you can see in the example below, the `computed` callback code only requires the same amount of code that you would need to display the value as text. It automatically detects the dependencies you've used. 

**Storing Computed Values**: This framework automatically minimizes recomputes by versioning values. When a new value arrives, it only recomputes delta changes. This saves on performance.

Signals is a port of Preact.js Signals to Dart and Flutter by [Rody Davis](https://twitter.com/rodydavis), who works on Flutter at Google. Signals deals with Flutter state management by triggering computations when any value (dependency) in the dependency graph changes. Signals efficiently manages a network of interconnected values, where a change in one value automatically propagates updates to other related values. The [`watch`](https://pub.dev/documentation/signals/latest/signals_flutter/Watch-class.html) extension is the only thing necessary to trigger Flutter rebuilds. 

This feature eliminates the need for manual tracking and updating of dependent values. It significantly simplifies the development of reactive applications. You can declaratively define complex relationships between data points and ensure that changes reflect seamlessly and automatically across the entire dependency graph. 

```dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final name = signal('Jane');
  final surname = signal('Doe');
  late final ReadonlySignal<String> fullName;
  late final void Function() _dispose;

  @override
  void initState() {
    super.initState();
    fullName = computed(() => '${name.value} ${surname.value}');
    _dispose = effect(() => fullName.value);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Signals Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                fullName.watch(context),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                onPressed: () =>
                    name.value = name.value == 'Jane' ? 'John' : 'Jane',
                child: const Text('Change Name'),
              ),
              ElevatedButton(
                onPressed: () =>
                    surname.value = surname.value == 'Doe' ? 'Dop' : 'Doe',
                child: const Text('Change Surname'),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
```

It excels at automating reactive computations with simplicity.

## Conclusion

You don't need to use complex Rx libraries to build a Flutter app, and you don't need to use the same approach for every widget. Rx is complicated, and you should reserve it for parts of your app with a complex mesh of observable dependencies. Stick to the Flutter basics wherever you can. Don't be afraid to choose different nuanced approaches for different parts of your app.

`ValueNotifier`, Riverpod and RxDart offer varying degrees of control over reactive computations. However, they often require explicit logic to handle complex relationships between data. Signals, with its computed function, presents a more automated and less error-prone approach. It effectively addresses the core problem of handling manual, reactive computations and automatically minimizing recomputes in Flutter development.