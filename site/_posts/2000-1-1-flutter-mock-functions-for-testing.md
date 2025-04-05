---
layout: post
title: "Flutter: How To Mock Functions For Testing"
date: 2022-12-17 20:37:13 +0600
tags: testing cross-platform dart
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/blog/testing/header.jpeg"
post_image_height: 220
image: "/assets/images/blog/testing/header.jpeg"
trending: true
permalink: /blog/:title
---

The Dart language allows us to implement and mock any class. That's because Dart has [implicit interfaces](https://dart.dev/guides/language/language-tour#implicit-interfaces), which is great for testing. However, some libraries give us functions that don't belong to a class. That means we must do some work to mock or fake these functions for tests. This article explains how to do that.

## What is the Issue With Functions?
If we call a standard top-level function in Dart, we cannot mock that function for a test. A classic case is the [launchUrl](https://pub.dev/documentation/url_launcher/latest/url_launcher/launchUrl.html) function in the [url_launcher](https://pub.dev/packages/url_launcher) library. When we run a widget test, we don't want the launcher to open the Url physically, but we may want to put a fake in place, so we know that the app did call the function. We need an abstraction for the function.

A typical solution is to create a new class and add a method with the same signature as the `launchUrl` function. This does work, but it's overkill. Functions are simpler than classes and require less maintenance. We shouldn't add classes to our system only to call functions. This is especially true if we aim toward a more functional programming style. This Dart [lint rule](https://dart-lang.github.io/linter/lints/one_member_abstracts.html) says it all. I recommend turning this rule on if you can.

> Unlike Java, Dart has first-class functions, closures, and a nice light syntax for using them. If all you need is something like a callback, just use a function. If you're defining a class and it only has a single abstract member with a meaningless name like call or invoke, there is a good chance you just want a function.

## How Do We Add An Abstraction?
Functions are [first-class objects](https://dart.dev/guides/language/language-tour#functions-as-first-class-objects) in Dart. We can pass references to them around just as though we pass other objects around. 

Every function in Dart has a signature based on the parameters and their types. We can use this signature for type safety and declare [type aliases](https://dart.dev/guides/language/language-tour#typedefs) or inline function types. The type alias or function type is the abstraction. 

This code declares a type alias SomeFunction, a function with that signature assigns the function to a variable of type SomeFunction and calls the variable to return a value to result.

```dart
typedef SomeFunction = String Function();
String someFunction() => 'Some function';
SomeFunction somefunction = someFunction;
```

Abstraction

## Pass the Function Into a Widget
Let's start by creating a type alias for the `launchUrl` function. The first thing we notice about the `launchUr`l function is that it has default values and the parameters are not nullable. Function types cannot have default values, so we can only approximate the launchUrl type alias. This is a good approximation. You could remove the optional parameters if you want to simplify this.

```dart
//A type alias for the launchUrl's function signature
typedef LaunchUrl = Future<bool> Function(
Uri url, {
//We accept nulls here because we cannot use default
//values in type aliases
LaunchMode? mode,
WebViewConfiguration? webViewConfiguration,
String? webOnlyWindowName,
}
);
```

Type Alias

We can now pass the function into our `Widget`, `BloC`, `ChangeNotifier`, or other classes.

```dart
class MyApp extends StatelessWidget {
const MyApp ( {
required this.launchUrl, super.key,
);
final LaunchUrl launchUri:
Widget
@override
Widget build(BuildContext context){
...
```

Widget

## Wiring It Up
We want to be able to replace the function with a mock or fake at testing time, so we need to use some dependency injection or service location that will allow us to substitute the function later. In this example, we will use the [ioc_container](https://pub.dev/packages/ioc_container) package, but you can use [Provider](https://pub.dev/packages/provider) or a service locator. We add the package with

`flutter pub add ioc_container`

This code adds the `launchUrl` function as a dependency to our container in the compose function and injects the `launchUrl` function into the `MyApp` widget and we only need one line to run the app. You will also need the [url_launcher](https://pub.dev/packages/url_launcher) package for this example.


```dart
import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:url_launcher/url_launcher.dart';

final flutterDevUri = Uri.parse('https://www.flutter.dev');

///A type alias for the launchUrl's function signature
typedef LaunchUrl = Future<bool> Function(
  Uri url, {
  //We accept nulls here because we cannot use default
  //values in type aliases
  LaunchMode? mode,
  WebViewConfiguration? webViewConfiguration,
  String? webOnlyWindowName,
});

///Composition root. This is where we wire up dependencies
IocContainerBuilder compose() => IocContainerBuilder(
      allowOverrides: true,
    )
      ..addSingletonService<LaunchUrl>(
        //This is how we map the LaunchUrl type on to the actual function
        //Yes, this is a bit clunky, but using it in the app is very simple
        (url, {mode, webOnlyWindowName, webViewConfiguration}) async =>
           launchUrl(
              url,
              mode: mode ?? LaunchMode.platformDefault,
              webViewConfiguration:
                  webViewConfiguration ?? const WebViewConfiguration(),
              webOnlyWindowName: webOnlyWindowName,
            ),
          )
           ..add((container) => MyApp(launchUrl: container<LaunchUrl>()));

void main() => runApp(compose().toContainer()<MyApp>());

class MyApp extends StatelessWidget {
  const MyApp({
    required this.launchUrl,
    super.key,
  });

  final LaunchUrl launchUrl;

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Function Mocking Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Align(
            child: MaterialButton(
              onPressed: () async {
                await launchUrl(flutterDevUri);
              },
              color: Colors.blue,
              textColor: Colors.white,
              padding: const EdgeInsets.all(40),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.favorite,
                size: 50,
              ),
            ),
          ),
        ),
      );
}
```

## Substitute with Fake Function for Testing
The compose function returns an `IocContainerBuilder`. We can replace dependencies in the builder before we call `toContainer()`. In this widget test, we replace `launchUrl` with a fake function specifically to track the number of times the app calls `launchUrl`. The mock will add to the launches list every time the app launches a Url. After the app runs, we can verify the launch count.


```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:launch/main.dart';

class UrlLaunch {
  UrlLaunch(this.uri);

  final Uri uri;
}

void main() {
  testWidgets('Test Url Launch', (tester) async {
    final launches = <UrlLaunch>[];

    final builder = compose()
      //Replace the launch function with a mock/fake
      ..addSingletonService<LaunchUrl>((
        uri, {
        mode,
        webOnlyWindowName,
        webViewConfiguration,
      }) async {
        //This happens when try to launch a Uri
        //We track how many times the launch function is called
        launches.add(UrlLaunch(uri));
        return Future.value(true);
      });

    await tester.pumpWidget(
      builder.toContainer()<MyApp>(),
    );

    //Tap the icon
    await tester.tap(
      find.byIcon(Icons.favorite),
    );

    await tester.pumpAndSettle();

    expect(launches.length, 1);
    expect(
      launches[0].uri,
      flutterDevUri,
    );
  });
}
```

## Substitute with Mock Function for Testing
We can also create a mock with a library like [Mockito](https://pub.dev/packages/mockito) or [Mocktail](https://pub.dev/packages/mocktail), as I have done in this example. We need to create a class that extends Mock (part of Mocktail) and has one method called call. We can then use when to set up the return value. Lastly, we call `verify` to ensure that the app called `launchUrl` the correct number of times.


```dart
import 'package:fafsdfsdf/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class LaunchMock extends Mock {
  Future<bool> call(
    Uri url, {
    LaunchMode? mode,
    WebViewConfiguration? webViewConfiguration,
    String? webOnlyWindowName,
  });
}

void main() {
  testWidgets('Test Url Launch', (tester) async {
    //These allow default values
    registerFallbackValue(LaunchMode.platformDefault);
    registerFallbackValue(const WebViewConfiguration());

    //Create the mock
    final mock = LaunchMock();
    when(() => mock(
          flutterDevUri,
          mode: any(named: 'mode'),
          webViewConfiguration: any(named: 'webViewConfiguration'),
          webOnlyWindowName: any(named: 'webOnlyWindowName'),
        )).thenAnswer((_) async => true);

    final builder = compose()
      //Replace the launch function with a mock
      ..addSingletonService<LaunchUrl>(mock);

    await tester.pumpWidget(
      builder.toContainer()<MyApp>(),
    );

    //Tap the icon
    await tester.tap(
      find.byIcon(Icons.favorite),
    );

    await tester.pumpAndSettle();

    verify(() => mock(flutterDevUri)).called(1);
  });
}
```

## Wrap-up
Functions are dependencies, just like other objects. You don't need to declare a class to make an abstraction. You can make abstractions for functions, and this is usually simpler. It keeps you close to the functions in the libraries you consume without obscuring them. After all, functional programming is about functions, so embrace them where you can. The [ioc_container](https://pub.dev/packages/ioc_container) library can help you manage all types of dependencies, including top-level functions.

[Photo by Joshua Miranda from Pexels](https://www.pexels.com/photo/white-and-black-letter-blocks-3989901/)