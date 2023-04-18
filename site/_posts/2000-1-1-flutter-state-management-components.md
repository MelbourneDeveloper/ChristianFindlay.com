---
layout: post
title: "Components of Flutter State Management"
date: "2023/04/18 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/portfolio/flutter.svg"
image: "/assets/images/portfolio/flutter.svg"
post_image_size: width:50%
description: 
tags: state-management apps cross-platform
categories: [flutter]
permalink: /blog/:title
---

State management is a critical aspect of building responsive Flutter apps. We often talk about "State Management Solutions" in Flutter, but we rarely break down the components of state management into their constituent parts. Understanding the different components of state management in Flutter can help you understand why you might choose one state management solution over another and identify the simplest ways to do state management. Breaking these components down shows how all state management solutions are built on the same foundation. They are all variants of one underlying principle. This article discusses the components and gives examples of how they work together.

## The Components
There are four primary components of state management in Flutter: Builder, Controller, State, and Dependency Manager. Each of these components plays a unique role in managing the state of your application.

### Controller

The controller manages the application's state and business logic. It notifies the Builder when the state changes. There are two fundamental types of controllers in the core Flutter API: [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) and [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html). They both implement the [`Listenable`](https://api.flutter.dev/flutter/foundation/Listenable-class.html) interface, which allows them to notify the Builder when the state changes.

- `ChangeNotifier` is a class that extends the `Listenable` class and provides the [`notifyListeners()`](https://api.flutter.dev/flutter/foundation/ChangeNotifier/notifyListeners.html) method to notify the builders when the state changes. You may maintain the state in the controller by adding properties to the class. The `ChangeNotifier` class is a good choice when you need to maintain the mutable state in the controller.

- `ValueNotifier` also extends the `Listenable` class and provides the [`value`](https://api.flutter.dev/flutter/foundation/ValueListenable/value.html) property that holds the current state value. When the value changes, the `ValueNotifier` notifies the listeners. The `ValueNotifier` class is a good choice when you need to maintain the immutable state in the controller.

[`Cubit`](https://pub.dev/documentation/bloc/latest/bloc/Cubit-class.html) and [`Bloc`](https://pub.dev/documentation/bloc/latest/bloc/Bloc-class.html) are both controllers that exist in the [flutter_bloc library](https://pub.dev/packages/flutter_bloc). They both require you to work with immutable state. Finally, [StateNotifier](https://pub.dev/packages/state_notifier) is another controller that requires immutable state.

When we say "state management solution" we are often referring to the controller, but the overall solution may include the other components.

### Builder

A Builder is a widget that listens to state changes and calls [setState](https://api.flutter.dev/flutter/widgets/State/setState.html) when a change occurs. This tells Flutter to rebuild the widget tree. Flutter has three popular builders in the toolkit: [StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html), [ValueListenableBuilder](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html), and [AnimatedBuilder](https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html).

- We use `StreamBuilder` with streams, a sequence of asynchronous events. It listens to the stream and rebuilds the widget when new data is available.

- We use `AnimatedBuilder` with any [`Listenable`](https://api.flutter.dev/flutter/foundation/Listenable-class.html) controller. AnimatedBuilder listens to changes and rebuilds the widget when the Listenable notifies the builder of a change. The original design was for animations only, but this widget is perfect for other kinds of state management. 

- `ValueListenableBuilder` is very similar to `AnimatedBuilder`, but it takes a [ValueListenable](https://api.flutter.dev/flutter/foundation/ValueListenable-class.html) as a controller. A good example is [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html).

Another notable builder outside the core framework is [BlocBuilder](https://pub.dev/documentation/flutter_bloc/latest/flutter_bloc/BlocBuilder-class.html) in the [flutter_bloc library](https://pub.dev/packages/flutter_bloc). This builder is similar to the earlier builders but only works with a controller that implements the [StateStreamable](https://pub.dev/documentation/bloc/latest/bloc/StateStreamable-class.html) class.


### State

State is the data the app holds in memory that the UI reflects. The controller typically manages this. The State can be anything, from a simple boolean value to a complex data structure. The State can exist in the controller class, or a separate class can hold the state. The State can be mutable or immutable. Immutability is not simple in Dart, and you should carefully consider the choice between mutable and immutable. For a more in-depth discussion of immutable state in Dart, see [this article](https://www.christianfindlay.com/blog/immutability-dart-vs-fsharp).

### Dependency Manager

A dependency manager is a component that mints or holds onto the controller and its dependencies. It can hold onto the controller as a singleton, an object that is only instantiated once and shared across the entire application. It can also propagate the controller and its dependencies throughout the widget tree or expose them globally. In Flutter, there are several dependency managers, including [ioc_container](https://pub.dev/packages/ioc_container), [provider](https://pub.dev/packages/provider), and [get_it](https://pub.dev/packages/get_it), but none of these belong to the core Flutter API.

Importantly, dependency managers allow you to substitute dependencies with test doubles like [Mockito](https://pub.dev/packages/mockito). This is a critical feature for testing your application.

- `ioc_container` is a dependency manager that uses Inversion of Control principles to manage dependencies. It provides a container that manages the dependencies and allows for dependency injection. You can expose `ioc_container` throughout the widget tree as an [`InheritedWidget`](https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html) with [flutter_ioc_container](https://pub.dev/packages/flutter_ioc_container).

- `provider` is a dependency manager that primarily uses  `InheritedWidget` to provide objects to its children. It allows for a hierarchical relationship between the parent and child widgets.

- `get_it` is a dependency manager that uses the service locator pattern to manage dependencies. It provides a global singleton instance that can be used across the entire application.

## Core Flutter Building Blocks

Flutter gives us a comprehensive set of tools to build our applications. The core building blocks are the widgets, controllers, and builders. Where possible, it is always best to use the building blocks that come with the toolkit. This is because the core building blocks are well-tested, performance-optimized and designed to work together. For example, the `ValueListenableBuilder` is designed to work with the `ValueNotifier` controller. If we depend on core classes like `Listenable` or `Stream<>` we maximize the chance that components will work together.

Lastly, but most importantly, adding large 3rd party packages, especially those that depend on further packages, makes your app more opaque and harder to maintain. A rule of thumb that I follow is that I should be able to look at the code in the external package and understand what it is doing. The code should be small enough that I would have a hope of fixing it if I found a bug. You can't depend on 3rd party libraries to work the way you expect them to work. The author may make future decisions that are not in line with your expectations. That's why packages that only perform one simple function, and limit themselves to being one of the components I mentioned here are safer to use.

So, use 3rd party packages where necessary to extend the basic building blocks, but check that they do the bare minimum and don't add too much complexity. When a core Flutter building block does the job, use it.

## Bringing It Together

To summarise, we have the following components:
- State
- Builder
- Dependency Manager
- Controller

In this example, I use `ChangeNotifier` as the controller for state management. It holds the mutable state. 

I use `ioc_container` as the dependency manager because neither Dart nor Flutter have a built-in [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) framework.

Finally, I use `ListenableFutureBuilder` as the builder. It has three key features: 

- It holds onto the counter controller in the widget tree for you,  
- It allows you to do async work before the controller initializes and 
- It comes with an `InheritedWidget` to propagate the `Listenable` to descendant widgets. 

You can use a core Flutter builder, but this means you also need to manage the controller as state yourself.

Add these packages with these commands

```batch
flutter pub add ioc_container

flutter pub add listenable_future_builder
```

This is a simple counter example that demonstrates how all the components interact with each other. This example has no `StatefulWidget`s and all of the business logic exists in the controller. The builder takes care of the widget rebuilds and the dependency manager takes care of creating the controller. You can read about `ListenableFutureBuilder` [here](https://pub.dev/packages/listenable_future_builder).

```dart
import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:listenable_future_builder/listenable_future_builder.dart';
import 'package:listenable_future_builder/listenable_propagator.dart';

///🎮 Controller
///This class handles business logic and notifies listeners when the state changes.
///In this example, the controller holds the state, which is the counter.
///The state is mutable
class CounterController extends ChangeNotifier {
  CounterController(this.apiService);

  final ApiService apiService;

  ///📀 State - this is the mutable data that changes over time
  ///and displays as part of the UI
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}

///An example dependency
class ApiService {}

///🏗️ Dependency Manager
///This is the glue that holds everything together.
///It is responsible for creating the controller and allows us to replace the
///dependencies with mocks for testing.
IocContainerBuilder compose() => IocContainerBuilder()
  ..addSingleton((container) => ApiService())
  ..addAsync((container) async => Future<CounterController>.delayed(
      const Duration(seconds: 2),
      () => CounterController(container<ApiService>())));

void main() => runApp(MyApp(container: compose().toContainer()));

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.container});

  final IocContainer container;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          useMaterial3: true,
        ),
        //👷🏽 Builder
        //The ListenableFutureBuilder https://pub.dev/packages/listenable_future_builder
        //This builder has two key features:
        //1) It holds onto the counter controller in the widget tree for you
        //2) It allows you to do async work before the controller initializes
        home: ListenableFutureBuilder(
          listenable: () async => container.getAsync<CounterController>(),
          builder: (context, child, snapshot) {
            if (snapshot.hasData) {
              //This propagates the controller to the widget tree and is
              //is part of the listenable_future_builder package
              return ListenablePropagator(
                listenable: snapshot.data!,
                child: const MyHomePage(),
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            }
            return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ));
          },
        ),
      );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //Here we access the controller 🎮
    var controller = ListenablePropagator.of<CounterController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bringing It Together'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              controller.counter.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

Live demo:

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=54ab5a472d17b8b09154586a49427959"></iframe>
</figure>

## Conclusion

The builder, controller, state, and dependency manager work together to manage the state of your application and provide a responsive user interface. If you use these components effectively, you can build reliable and efficient applications. Take the time to learn and understand these components, and you'll be on your way to building successful Flutter applications.