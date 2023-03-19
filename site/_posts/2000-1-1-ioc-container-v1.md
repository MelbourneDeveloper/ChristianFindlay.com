---
layout: post
title: "Flutter Dependency Injection: ioc_container V1"
date: 2022-10-24 20:37:13 +0600
tags: ioc-container cross-platform dart
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/blog/ioc_container/header.jpeg"
image: "/assets/images/blog/ioc_container/header.jpeg"
trending: true
permalink: /blog/:title
---

`ioc_container` is an IoC Container for Dart and Flutter. It started about five months ago as a quick way to replace dependencies for testing but evolved into a comprehensive Dependency Injection library for Dart and Flutter. Version 1.0.0 rounds off the major features and weighs in at [81 lines of code](https://github.com/MelbourneDeveloper/ioc_container/blob/f92bb3bd03fb3e3139211d0a8ec2474a737d7463/lib/ioc_container.dart#L2) according to test coverage. You should try it in your project, and here's why.

[ioc_container](https://pub.dev/packages/ioc_container) on pub.dev

[ioc_container](https://github.com/MelbourneDeveloper/ioc_container) on GitHub

Dependency Injection
--------------------

[Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection) can simplify your Flutter app. When your app grows in complexity, it becomes difficult to manage the construction and disposal of objects. You will find that some of your services depend on other services, and some services should exist for the lifetime of your app, while other services should only exist for a given widget's life. `ioc_container` allows you to configure factories so that services can access other services when needed and easily switch between Singleton (one per app) or Transient (fresh instance every time).

Dependency Injection is an established approach, and you can bring your knowledge of DI from other platforms to Flutter. The library takes inspiration from [DI in .NET](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection) and other technologies like Java.

Saying all that, you can also use ioc_container as a [service locator](https://en.wikipedia.org/wiki/Service_locator_pattern). Just declare the container in a global location, and you can access it anywhere. That means you can create scoped dependencies for a widget and dispose of them when you dispose of the widget.

It's Fast
---------

Performance is important, and the benchmarks show that `ioc_container` easily holds up to the performance of libraries that do similar things. Check out the benchmarks [here](https://github.com/MelbourneDeveloper/ioc_container/tree/main/benchmarks). Measurements are in microseconds and get operations to occur in fractions of a millisecond, so you can be sure it won't slow your app down.

Manage Async Initialization
---------------------------

`ioc_container` 1.0.0 brings an API for handling async initialization. Services don't always start up correctly, but you can still define your services as singletons and use the [retry](https://pub.dev/packages/retry) package to make multiple initialization attempts. The [getAsynSafe()](https://pub.dev/documentation/ioc_container/latest/ioc_container/IocContainerExtensions/getAsyncSafe.html) method ensures the container doesn't store the failed attempt. Check out the Flutter example.

```dart
class MyApp extends StatelessWidget {
  const MyApp({
    required this.container,
    super.key,
  });

  final IocContainer container;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ioc_container Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //We use a FutureBuilder to wait for the initialization to complete
      home: FutureBuilder(
        //Add resiliency by retrying the initialization of the FlakyService until it succeeds
        future: retry(
            delayFactor: const Duration(milliseconds: 50),
            //getAsyncSafe ensures we don't stored the failed initialization in the container
            () async => container.getAsyncSafe<AppChangeNotifier>()),
        builder: (c, s) => s.data == null
            //We display a progress indicator until the Future completes
            ? const CircularProgressIndicator.adaptive()
            : AnimatedBuilder(
                animation: s.data!,
                builder: (context, bloobit) => MyHomePage(
                  title: 'ioc_container Example',
                  appChangeNotifier: s.data!,
                ),
              ),
      ),
    );
  }
}
```

`ioc_container` also simplifies adding, initializing, and testing Firebase in your app. Check out the[ documentation](https://pub.dev/packages/ioc_container#add-firebase) here.

Use Mocks or Fakes for Testing
------------------------------

`ioc_container` makes it easy to have a single [composition root](https:/.ploeh.dk/2011/07/28/CompositionRoot/). This means you configure all your dependencies in one place instead of spreading that throughout the app. Replacing a given dependency with a fake or a mock is easy when it comes to testing. You can generate mocks with [Mockito](https://pub.dev/packages/mockito) and then replace them like this.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

///This does exactly the same thing as AppChangeNotifier
///but it shows you how you can use Mock/Fake instead of the real service
class FakeAppChangeNotifier extends ChangeNotifier
    implements AppChangeNotifier {
  int counter = 0;

  void increment() {
    counter++;
    notifyListeners();
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final builder = compose(allowOverrides: true)
      ..addSingleton<AppChangeNotifier>((container) => FakeAppChangeNotifier());

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      container: builder.toContainer(),
    ));

    //Wait for the progress indicator to disappear
    await tester.pumpAndSettle();

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

Change Your App Without Changing Code
-------------------------------------

You will probably need to change parts of your app at some point. For example, you might load data from Firebase instead of a local database. If you use DI, you can write a new class and swap it in without changing the other code in your app. This is what we mean when we talk about the [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle), which is part of the [SOLID principles](https://en.wikipedia.org/wiki/SOLID).

Scoping
-------

Sometimes, you may need objects for the lifespan of a widget. In this case, call `scoped()` to get a scoped container. You can specify a dispose method for each dependency, and on widget dispose, you can call dispose on the container. This means you can clean up after creating dependencies, but this is not mandatory.

```dart
final builder = IocContainerBuilder()
  ..addSingletonService(A('a'))
  ..add((i) => B(i<A>()))
  ..add<C>(
    (i) => C(i<B>()),
    dispose: (c) => c.dispose(),
  )
  ..add<D>(
    (i) => D(i<B>(), i<C>()),
    dispose: (d) => d.dispose(),
  );
final container = builder.toContainer();
final scope = container.scoped();
final d = scope<D>();
await scope.dispose();
expect(d.disposed, true);
expect(d.c.disposed, true);
```

Wrap-Up
-------

Flutter sometimes feels like an uncharted sea, but you can follow established approaches that have been useful on other platforms. DI makes it easy to manage your dependencies, and `ioc_container` makes DI simple. Even if you don't want to follow the traditional DI pattern, `ioc_container` is perfect as a simple factory management tool or a service locator. Most importantly, it is fast and simple, so you can easily understand how it works. Try it out and reach out on [GitHub](https://github.com/MelbourneDeveloper/ioc_container) if you have issues.

<sub><sup>[Photo by Miguel Á. Padriñán from Pexels](https://www.pexels.com/photo/gold-1-freestanding-decor-2249528/)</sup></sub>