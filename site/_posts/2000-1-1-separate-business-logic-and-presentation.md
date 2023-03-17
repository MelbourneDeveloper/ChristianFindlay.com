---
layout: post
title: "Separate Business Logic and Presentation"
date: 2022-10-09 20:37:13 +0600
tags: state-management bloc
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/blog/seperatebusinesslogic/header.jpeg"
permalink: /blog/:title
---

The Flutter community is always looking for ways to create a clear separation between business logic and presentation. There are several solutions, but they can be overcomplicated. This article will introduce you to three approaches and explain why using `StatefulWidgets` directly can make it difficult to separate business logic and presentation (widgets).

Why Separate Business Logic and Presentation?
---------------------------------------------

Widgets display information and allow the user to interact with the app. Logic, and the infrastructure layers underneath process, validate and transfer data. Separating these at the code level creates a clear [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns). If we isolate logic in a class that does not reference the UI (widget code), it is easy to understand how the logic works by reading the code. The logic exists outside the context of the widget. We can reason about it without considering how it affects the widgets on-screen or how the user might interact with them.

Lastly, logic clutters up widget classes. When we look at widget code, we want to see mostly UI declarations. If we look at a complex widget tree with a lengthy callback code, it distracts us from being able to imagine how that tree will render at runtime. The separation is also about readability.

StatefulWidgets
---------------

Using simple `StatefulWidgets` is not wrong and may be appropriate for your team. It is harder to create a separation of business logic and presentation with vanilla `StatefulWidgets` because the `State` class forces you to do widget build logic. But you should note that all state management solutions build on top of `StatefulWidget` in some way. The most important thing is that you can test your UI and logic.

We don't always have to go to great lengths to separate the concerns. Some apps are very simple, and mixing presentation and logic does not pose a problem. Google's own Flutter examples don't always have a clear separation between business logic and presentation. Take this example. [The code ](https://github.com/flutter/samples/blob/b9db6c879b2374ed544e5368dfd8e23624b5dc9e/form_app/lib/src/sign_in_http.dart#L33)passes an HTTP Client into a widget. This is an example of mixing logic or infrastructure into the widget (presentation).

Take a look at the typical flutter [Counter Example](https://dartpad.dev/?id=e75b493dae1287757c5e1d77a0dc73f1). It has a StatefulWidget, and business logic and presentation are in the same class. `_incrementCounter` has business logic and modifies the state while the `build()` method creates physical UI elements (widgets).

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

*Note that this post does not go into `Provider` or `InheritedWidgets` or show examples of how to use them. That's so the examples remain simple and clear.*

Testing
-------

One of the most important decisions you can make about state management is how to test your app. [Widget tests](https://docs.flutter.dev/cookbook/testing/widget/introduction) allow you to test the UI and the logic of your UI simultaneously. They decouple your tests from the state management approach, so your tests should stay intact if you decide to change approaches. [This video](https://www.youtube.com/watch?v=3N1fng1GWOQ) can give you more context. The takeaway is that you can build widget tests before settling on a state management approach. Your tests can remain constant even if you change the state management approach multiple times.

Directly testing the business logic is usually unnecessary because we can indirectly test the logic with widget tests. But, isolating the logic allows us to create unit tests for the logic if needed. This can sometimes be useful if the app has very complex logic or users consistently encounter logic bugs.

A Note on the Observer Pattern
------------------------------

This is a bit technical, and you don't need to understand this to understand separating business logic and presentation so you can skip this part. Still, it's important to know that the BloC pattern and `ChangeNotifier` use the [Observer Pattern](https://en.wikipedia.org/wiki/Observer_pattern) (or Publisher/Subscriber pattern). Dart streams are an example implementation of the pattern, and the observer pattern is the basis for [Reactive Programming](https://en.wikipedia.org/wiki/Reactive_programming). The BloC pattern uses [Dart Streams](https://dart.dev/tutorials/language/streams).

The wikipedia definition says:

> an object, named the **subject**, maintains a list of its dependents, called **observers**, and notifies them automatically of any state changes, usually by calling one of their methods.

According to Wikipedia, the Observer pattern addresses the following problems. If you don't have these problems, perhaps you don't need the observer pattern.

> A one-to-many dependency between objects should be defined without making the objects tightly coupled. It should be ensured that when one object changes state, an open-ended number of dependent objects are updated automatically. It should be possible that one object can notify an open-ended number of other objects.

If we translate this to Flutter language, we might need the observer pattern's decoupling when multiple widgets need to listen to state changes emanating from a central subject (Bloc or ChangeNotifier). We probably don't need this for simple scenarios where we have one business logic component for each widget and vice versa. 

Approach One: bloobit
=====================

[bloobit](https://pub.dev/packages/bloobit) is a simple library. You extend the Bloobit class and define your state and business logic in that class. You call `setState()` when the state changes. However, bloobit does not implement the Observer Pattern. Instead, bloobit directly calls `setState()`. The [code](https://github.com/MelbourneDeveloper/bloobit/blob/main/lib/bloobit.dart) under the hood is extremely simple, and you can follow it or fix it yourself. bloobit doesn't attach or detach listeners like a Dart Stream. If you need to stream state changes (observer pattern) from bloobit, you can wire up the `onSetState` callback.

Use this approach when your business logic is simple and there is a one-to-one relationship between your business logic and your widgets.

Check out the Flutter counter increment sample with Bloobit here

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=852bb434276d46775f61d74ece554209"></iframe>
</figure>

Approach Two: ChangeNotifier and AnimatedBuilder
================================================

These classes are part of the Flutter framework. Like bloobit, you define your state and business logic in a class that extends `ChangeNotifier` and call `notifyListeners` when the state changes. `AnimatedBuilder` listens to these changes and calls `setState` for you. You don't need to dispose of the change notifier if you only attach an `AnimatedBuilder` because the `AnimatedBuilder` will automatically remove its handler when it disposes.

Use this approach when your business logic is moderately complex and multiple widgets may need to listen to state changes from one central subject.

Check out the Flutter counter increment sample with `ChangeNotifier` here

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=2ead2e9055b85515b24032a46c6488b8"></iframe>
</figure>

Approach Three: BloC Pattern
================================================

You can roll your own version of BloC or use the [BloC Library](https://bloclibrary.dev/). I find that the [Cubit class](https://pub.dev/documentation/bloc/latest/bloc/Cubit-class.html) in the BloC Library is the simplest way to implement the BloC pattern. As you can see in the example below, you can use it similarly to bloobit.

Use this approach when your business logic is moderately complex and multiple widgets may need to listen to `state` changes from one central subject.

Check out the Flutter counter increment sample with `Cubit` here

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=693af7d9899e7c9e3079fd86695e1f41"></iframe>
</figure>

Consistency
-----------

Consistency is critical for any app. That doesn't mean that one app should never use more than one approach to state management, but it does mean that there should be clear, logical reasons for using more than one approach. For example, you may use one of the three approaches mentioned here for complex screens and `StatefulWidgets` for simple ones.

However, using more than one approach could increase the cognitive load for a new team member. They may find it hard to navigate the file structure, so it's preferable to stick to one approach where possible. The key is to balance this with adding complexity for complexity's sake. If sticking to one approach makes your code too complex, consider more than one approach.

Wrap-Up
-------

There are many ways to implement a separation of business logic and presentation. There are many other libraries that this article does not mention. Separating business logic and presentation can make your app more readable and easy to understand, but it is not always necessary for testing. The important thing is that your team understands and can navigate the code and that you have good-quality testing in place. If you find that `StatefulWidgets` get confusing and muddy the waters, try one of the solutions listed here. Lastly, always consider consistency.

<sub><sup>[Photo by Jonathan Borba from Pexels](https://www.pexels.com/photo/colorful-lane-marker-in-rippled-swimming-pool-6110600/)</sup></sub>