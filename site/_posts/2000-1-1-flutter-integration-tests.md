---
layout: post
title: "Run Flutter Widget Tests as Integration Tests"
date: 2021/12/18 00:00:00 +0000
tags: testing
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/blog/testing/WidgetTestsIntegrationTests.png"
permalink: /blog/:title
---

Automated testing in flutter is easy. The flutter team built it into the framework from the ground up. They call it [integration testing](https://docs.flutter.dev/cookbook/testing/integration/introduction), but non-flutter developers would refer to it as automated testing. You can run integration tests on several platforms and in pipelines such as GitHub Actions. You might already be familiar with widget testing. Widget testing is the headless version of integration tests and gives you the same toolset, but without being able to see the actual UI. This article steps you through the process of running widget tests as integration tests. Take some time to read about [Flutter Testing](https://docs.flutter.dev/cookbook/testing) - particularly [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction), before you step through this guide.

This article uses Visual Studio code and I recommend this IDE for Flutter, but you can do it with any IDE or with the terminal

### 1. Create the App

<img src="/assets/images/blog/testing/createapp1.jpeg" alt="Create the App" width="700"/>


This template creates a minimal app with a widget test

<img src="/assets/images/blog/testing/createapp2.jpeg" alt="Create the App" width="700"/>

This is the out of the box widget test

<img src="/assets/images/blog/testing/widgetTest.jpeg" alt="Widget test" width="700"/>

You can run or debug the test here. You will notice that the test doesn't deploy to a device or show anything in a window. That's the difference between a widget test and an integration test.

<img src="/assets/images/blog/testing/widgetTestRunning.jpeg" alt="Running widget test" width="700"/>

### 2. Add Integration Testing to the Project

Change the `pubspec.yaml` to include integration testing

```yaml
dev_dependencies:  
  flutter_test:    
    sdk: flutter  
  integration_test:    
    sdk: flutter
```

### 3. Create the integration_test folder

Flutter picks up integration tests in the `integration_test` folder. So, create the folder and copy the existing widget test file into the folder.

<img src="/assets/images/blog/testing/integrationTest.jpeg" alt="integration test" width="700"/>

You can run the integration test. You should see the app pop and disappear

<img src="/assets/images/blog/testing/runIntegrationTest.jpeg" alt="run integration test" width="700"/>

<img src="(/assets/images/blog/testing/integrationTestRunning.jpeg" alt="integration test running" width="700"/>

Run flutter test `integration_test` at the terminal to choose the platform.

<img src="/assets/images/blog/testing/runInTerminal.jpeg" alt="run from terminal" width="700"/>

4. Share The Code
------------------

You've ended up with a duplicate test file. All you need to do is make the test function in the original file public and then point to that from your integration test.

Highlight the test code and refactor it into a new method. Call it sharedTest

<img src="/assets/images/blog/testing/refactorTest.jpeg" alt="refactor" width="700"/>

<img src="/assets/images/blog/testing/sharedTest.jpeg" alt="shared test" width="700"/>

Rename this file and delete the test code

<img src="/assets/images/blog/testing/renameFile.jpeg" alt="rename file" width="700"/>

Add an import to the original widget test and call the shared test method from the widget test file.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_tests/main.dart';

import '../test/widget_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await sharedTest(tester);
  });
}
```

### Wrap-up

Now you can call your tests as widget tests or full integration tests. There is no reason to create two sets of tests. Run the tests as widget tests when you want a quick result. Run them as integration tests on multiple platforms in the pipelines to protect the main branch from bugs. You will probably want to test with multiple screen sizes and multiple platforms. I hope to write another article on how to set this up with GitHub actions.