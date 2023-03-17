---
layout: post
title: "Dart: Manual Mutation Testing"
date: 2021-12-04 00:00:00 +0000
tags: testing dart
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/blog/testing/mutant.jpg"
permalink: /blog/:title
---

Mutation testing is a technique for measuring the quality of your tests.

Mutation testing (or mutation analysis or program mutation) is used to design new software tests and evaluate the quality of existing software tests

[Wikipedia](https://en.wikipedia.org/wiki/Mutation_testing)

There are many tools for automating this process, such as [Stryker Mutator](https://stryker-mutator.io/), but Dart doesn't seem to have a tool to automate this right now. So, this post gives you a quick explanation of how you can implement a similar technique manually. This is a good way to help you prevent bugs and improve the quality of your tests. Read about [Flutter Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction) here.

### What is Mutation Testing (Automated)

Mutation testing involves modifying a program in small ways.[1] Each mutated version is called a mutant, and tests detect and reject mutants by causing the behavior of the original version to differ from the mutant. This is called killing the mutant. Test suites are measured by the percentage of mutants that they kill. New tests can be designed to kill additional mutants.

[Wikipedia](https://en.wikipedia.org/wiki/Mutation_testing)

The idea is much simpler than it sounds. A tool like Stryker Mutator will change your code and then run your tests. If the tests don't fail, then there is a mutant. The tool will measure how many mutants there are in your system, and report a score. It highlights places in your code where you need to add extra test permutations, or verify and expect calls.

### Why?

We do mutation testing to check the quality of our tests. When we fix a bug, we stop it once. However, bugs often come back, and someone who doesn't know the codebase may come along and put the bug back. Good quality tests ensure that the bug cannot come back. Mutation testing helps to ensure this.

### Manual Mutation Testing

To test for mutants, you need to use your imagination. Ask yourself: can I add a bug to my existing code without the tests failing? If you can, then you probably have a mutant. Here is an example of what I mean. Take this simple piece of code.

```dart
import 'package:flutter_test/flutter_test.dart';

int add(int a, int b) {
  return a + b;
}

void main() {
  test('Test add', () {
    expect(add(1, 1), 2);
  });
}
```

This code version is completely wrong, but our tests don't cover the input permutations and therefore don't stop the bug from happening. So, we need to add more test permutations. We have a mutant.

```dart
int add(int a, int b) {
  if (a == 2) {
    a = 3;
  }

  return a + b;
}
```

The second test now fails, which prompts us to fix the bug.

```dart
import 'package:flutter_test/flutter_test.dart';

int add(int a, int b) => a + b;

void main() {
  test('Test add 1+1', () {
    expect(add(1, 1), 2);
  });

  test('Test add 2+2', () {
    expect(add(2, 2), 4);
  });
}
```

### Wrap-up

We squashed one mutant. Of course, we should include many more input permutations, but you get the idea. This is a straightforward example, but you can stretch your imagination for Flutter scenarios. For example, would it be OK if a button had a color of pink instead of black? If not, you may have a mutant. Squash it with a verify in a [widget test](https://docs.flutter.dev/cookbook/testing/widget/introduction) to ensure the button is black. Try to get yourself in the habit of thinking this way when writing tests. It helps you to improve your tests by thinking of what potential bugs may come up and stopping them before they do.

Here is a quick reminder Tweet. A retweet would be much appreciated! Follow me on Twitter for more Flutter and Dart content.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Manual Mutation Test<br><br>✅ Create 🪲<br>✅ Run tests<br>✅ If tests pass, mutant found<br>✅ Make test fail bcos of 🪲<br>✅ Commit/push new test<br>✅ Revert 🪲<br>✅ Mutant killed</p>&mdash; Christian Findlay (@CFDevelop) <a href="https://twitter.com/CFDevelop/status/1466852921371512833?ref_src=twsrc%5Etfw">December 3, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>