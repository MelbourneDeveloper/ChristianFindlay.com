---
layout: post
title: "Flutter - Full App Widget Testing"
date: "2023/04/04 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/testing/testingheader.jpg"
post_image_width: 600
image: "/assets/images/blog/testing/testingheader.jpg"
description: Discover the benefits of full app widget testing in Flutter, and learn how to ensure your app's UI works as intended with comprehensive coverage. This in-depth guide provides code examples, tips on dependency injection, and insights into automated testing and UI behavior for building reliable and high-quality Flutter applications.
tags: testing
categories: flutter
permalink: /blog/:title
canonical_url: https://www.nimblesite.co/blog/flutter_full_app_widget_testing/
---

Testing is a critical aspect of software development. It ensures the quality and reliability of an app and allows you to make changes over time without the fear of bugs occurring. Flutter has several [types of tests](https://docs.flutter.dev/testing), including unit tests, widget tests, and integration tests. Unit testing focuses on testing the logic of individual components of an application. While this can sometimes be useful for isolating the logic, it does not test the UI, and this is the most important part of a Flutter app. 

This blog post takes a deep dive into the advantages of full app [widget testing](https://docs.flutter.dev/cookbook/testing/widget/introduction) and explains how it's more comprehensive than unit testing for controllers. Full app widget tests test the entire widget tree instead of focusing on a single widget. This allows you to verify that the whole app works as intended This post will also provide code examples, discuss dependency injection, and explore the broader concepts of automated testing and UI behavior.

This article belongs to [Nimblesite](https://www.nimblesite.co). They specialize in widget testing and training. Call them on <a href="tel:1300794205">1300 794 205</a>, send an email at <strong>sales at nimblesite.co</strong>, or fill out the [contact form](https://www.nimblesite.co/#contact)

## Why Full App Widget Testing?

Flutter apps are primarily about the UI. Widgets form the backbone of the application. Full app widget testing involves testing the entire widget tree instead of isolating parts of the app. This ensures that you test the app's UI comprehensively. You can test actual use cases that the user experiences and detect potential issues that may arise from widget interactions. In contrast, unit tests focus on testing the logic of individual components, such as functions and classes, without taking the UI into account. You can consider these to be implementation details that are not visible to the user.

Furthermore, it tests the app with all of its state. If we focus on testing a single widget, we do not combine the various moving parts of your app such as hierarchical state or controllers. The full widget tree is far more complex than a single widget, so testing a single widget is not enough to ensure that the app works as intended.

### Tests UI Behavior
Full app widget testing evaluates how the UI behaves and responds to user interactions, whereas unit tests only assess the logic and functionality of controllers. By testing the entire widget tree, you can identify issues related to rendering, layout, and user interactions that may not be apparent with unit tests. You can also test on different form factors like various iOS and Android screen resolutions, or desktop resolutions.

### Real-world Simulation
Full app widget tests simulate how users would interact with the app, enabling a more accurate assessment of the app's performance and responsiveness. Unit tests, on the other hand, focus on specific components without considering the overall user experience. Widget tests can simulate things like button taps, entering text, and scrolling. This is how your users will interact with the app, so it's important to test it this way.

### Comprehensive Coverage
By testing the entire widget tree, full app widget tests cover all UI components, ensuring that the app works as intended. You will get higher test coverage with less test code. Full app widget tests take less time to build and have less maintenance over time. Unit tests may miss certain interactions and dependencies between components, which makes it much harder to test the app comprehensively. See my articles on why [test isolation](test-isolation-expensive) is expensive, and how to achieve good [test coverage](test-coverage) for a more in-depth analysis of this.

### Speed (Fake clock)
Widget testing is fast. Flutter's animations run on a fake clock so you don't have to wait for animations to complete. Completing a full test as a user may take many seconds or minutes, but widget tests often execute in under a second or milliseconds. This is a critical aspect of widget testing, and a strong reason to embrace widget tests.

## Examples

### Basic Example

This is a basic widget testing sample. It simulates user interaction with the app. The test checks the initial counter value and verifies that it increments after tapping the '+' icon. It tests the controller logic indirectly. You don't need to test the controller directly because it's already tested in the unit test. However, you can add unit tests, or more fine-grained widget tests if you need to isolate the logic of a specific component.

```dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the initial counter value is 0.
    expect(find.text('0'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter has incremented to 1.
    expect(find.text('1'), findsOneWidget);
  });
}
```

### Dependency Injection Example

Widget tests cannot make HTTP calls, so we need to mock API calls. This example demonstrates how to use dependency injection in widget tests. It uses the [flutter_ioc_container](https://pub.dev/packages/flutter_ioc_container) package to inject a mock implementation of the `ApiService` class. This is useful for testing the app without making actual HTTP calls. The mock implementation returns a fixed value instead of making a real API call. You need to install the `flutter_ioc_container` package to run this test.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_ioc_container/flutter_ioc_container.dart';
import 'package:flutter_test/flutter_test.dart';

///Gets data from an external API. We can't call this in our widget tests
///because it makes a HTTP call
class ApiService {
  double getForecast() => 50;
}

///Mock implementation of the [ApiService]. This is safe to call in widget tests
class MockApiService implements ApiService {
  @override
  double getForecast() => 86;
}

void main() {
  testWidgets('Fetch the forecast and display it on the screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      CompositionRoot(
        compose: (builder) =>
            //Use the mock implementation of the [ApiService] instead of the real one
            builder.addSingletonService<ApiService>(MockApiService()),
        child: Builder(
          builder: (context) => MaterialApp(
            home: Scaffold(
              //Grab the dependency from the widget tree and get forecast
              body: Text('Forecast ${context<ApiService>().getForecast()} °F'),
            ),
          ),
        ),
      ),
    );

    //Verify that we see the mock textt
    expect(find.text('Forecast 86.0 °F'), findsOneWidget);

    //And that we don't see the text from the real API call
    expect(find.text('Forecast 50.0 °F'), findsNothing);
  });
}
```

Note that [Flutter integration](https://docs.flutter.dev/cookbook/testing/integration/introduction) tests can make HTTP calls. Flutter runs integration tests on a real device or emulator (iOS, Android or desktop), so you can test the app with a real API. The other important thing to note is that Flutter integration tests can also test your UI and you can use the same widget test code for this. One big difference is that integration tests don't run on a fake clock so they're slower than widget tests. My advice is to configure your tests so they run as integration tests or widget tests. [This article](/blog/flutter-integration-tests) explains how to do this.

### Full Widget Tree Example

Testing the entire widget tree can reveal issues that you might miss when isolating a single widget. Suppose we have a simple app with a "Show Details" button that displays additional information when pressed. The additional information is hidden by default.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My App')),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showDetails = false;

  void _toggleDetails() {
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Welcome to My App'),
        ToggleButton(
          onPressed: _toggleDetails,
          text: _showDetails ? 'Hide Details' : 'Show Details',
        ),
        if (_showDetails)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Additional information about the app...'),
          ),
      ],
    );
  }
}

class ToggleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const ToggleButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      );
}
```

Let's create a widget test that isolates the `ToggleButton` and verifies whether the button's text changes when pressed. This test passes because it only checks whether the button's text changes. However, it does not verify whether the additional information is displayed when the button is pressed. 

```dart
import 'package:flutter/material.dart';
import 'package:flutter_application_16/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Button text changes when pressed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return ToggleButton(
              onPressed: () {
                // This will not actually update the button's text because it is not connected to the state.
              },
              text: 'Show Details',
            );
          }),
        ),
      ),
    );

    expect(find.text('Show Details'), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Hide Details'), findsNothing);
  });
}
```

To achieve a realistic test, we need to test the entire widget tree. This test will check the button text and whether the additional information is displayed. It actually verifies what the user sees on screen. This is why tests should include the app's state instead of state that only belongs to a single widget.

```dart

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';

void main() {
  testWidgets('Button text changes and additional information is displayed when pressed', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('Show Details'), findsOneWidget);
    expect(find.text('Additional information about the app...'), findsNothing);

    await tester.tap(find.byType(ToggleButton));
    await tester.pump();

    expect(find.text('Hide Details'), findsOneWidget);
    expect(find.text('Additional information about the app...'), findsOneWidget);
  });
}
```

## Conclusion

Full app widget testing allows you to comprehensively test your Flutter app's UI behavior, simulate real-world user interactions, and achieve more comprehensive coverage. Furthermore, widget tests are fast, running on a fake clock, which enables you to identify issues quickly and efficiently.

This post demonstrated the importance of testing the entire widget tree, using dependency injection to mock API calls, and understanding the differences between widget tests and integration tests. Full app widget testing is an essential practice for creating high-quality and reliable Flutter applications. You can use it to ensure your app performs as expected, providing the best possible experience for your users.

<sub><sup>Photo by [Rodolfo Clix](https://www.pexels.com/photo/photo-of-clear-glass-measuring-cup-lot-1366942/) from Pexels</sup></sub>