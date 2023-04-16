---
layout: post
title: "Dart: Formatting and Trailing Commas"
date: "2022-07-30 00:00:00 +0000"
tags: dart code-quality
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/blog/dartformatting/dartformatting.png"
image: "/assets/images/blog/dartformatting/dartformatting.png"
permalink: /blog/:title
---

Trailing commas may sound like a minor aspect of the Dart language, but they have a major impact on the formatting of your code. This article explains deterministic formatting, how trailing commas affect it, why you should use them, and how to add the [dart_code_metrics](https://pub.dev/packages/dart_code_metrics) package to enforce them for better formatting.

Deterministic Formatting
------------------------

A code formatter or code beautifier is a tool that formats your code. Dart has a tool called [dart format](https://dart.dev/tools/dart-format). Formatters take raw code (and sometimes configuration) as input and output formatted code.

Given some raw semantically identical code, a *deterministic* formatter always outputs identical text. In other words, if you copy, paste a chunk of code, and put extra whitespaces in the second copy, applying the deterministic formatter will always result in the exact same text. No matter how you format the original code with whitespaces, the formatter will always produce a predictable code result.

Why is Deterministic Formatting Important?
------------------------------------------

It may seem like a pedantic point, but disparate formatting is one of the most common causes of merge conflicts. It also creates many unnecessary git changes. If two people format their code differently, it inevitably leads to extra whitespace diffs in commits. This often leads to merge conflicts, but this is absolutely avoidable. If a team decides to format all code according to a set of rules, they remove the chance that disparate formatting will cause merge conflicts. Deterministic formatting reduces git diffs and consequently reduces the risk of merge conflicts.

Deterministic formatting is also critical for readability. Most languages recommend a formatting style. The language usually dictates whether curly braces start on the current line or the next line. These inducements often give the language its aesthetic flavor. That means that people get used to the style of the formatter and unformatted code is often less readable. While a good formatter allows some configuration at the team level for autonomy, the formatter needs to enforce the language's aesthetic flavor and stop people from stepping outside the team's decisions.

Lastly, teams can end up with code-style arguments at review time. Your team may want to tweak some of the language's formatting options, but at the very least, the team should make consistent decisions about formatting. When the code review happens, you don't want to have an *ad hoc* debate about the best way to format code. That debate should happen ahead of time, and build process should enforce these rules. In the words of the Flutter team,

> While your code might follow any preferred style---in our experience---teams of developers might find it more productive to:

> - Have a single, shared style, and

> - Enforce this style through automatic formatting.

> [The alternative is often tiring formatting debates during code reviews, where time might be better spent on code behavior rather than code style](https://docs.flutter.dev/development/tools/formatting)

Dart Formatting
---------------

The Dart formatter is mostly deterministic. It allows you to do a few things that mean it is not 100% deterministic. For example, it allows you to add one line break or no line breaks in a chunk of code. This is probably a good thing so that you can break two distinct pieces of code apart. However, for the most part, it will make your code look consistent with other people's code and maintain the dart aesthetic.

You can run the Dart formatter on all the code in your codebase. Read about the Dart formatter [here](https://dart.dev/tools/dart-format).

Turning on Auto Formatting
--------------------------

[Visual Studio Code](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjuy6Wpyp_5AhX_SmwGHcLXCmoQFnoECA4QAQ&url=https%3A%2F%2Fcode.visualstudio.com%2F&usg=AOvVaw15O90sm1ios8AUpw56hCml) and [Android Studio](https://developer.android.com/studio) both have features to format the current document upon saving automatically. You need to turn it on so that formatting is not an afterthought or extra task. The [Flutter Code Formatting documentation](https://docs.flutter.dev/development/tools/formatting) explains how to turn this on for both IDEs. Turn on auto-formatting early in your project.

If you start a project without enforcing formatting, you will have many different formatting styles. This will lead to merge conflicts and confusion. If you find yourself in a situation where code is not formatted, my advice is to bite the bullet, apply dart format to the whole codebase and start clean. You will find this better in the long run.

The dart formatter does have one quirk, and this is where the discussion about the trailing comma comes in...

Trailing Comma
--------------

Trailing commas act as directives to the code formatter. The formatter will format your code differently if you add trailing commas. Read the Flutter documentation about this [here](https://docs.flutter.dev/development/tools/formatting#using-trailing-commas).

This is an example with no trailing commas

![No Trailing Comma](/assets/images/blog/dartformatting/nocomma.png){:width="100%"}

This example has trailing commas

![No Trailing Comma](/assets/images/blog/dartformatting/comma.png){:width="100%"}

The Flutter team recommends that you always use trailing commas, and the difference is obvious. I find the trailing comma version far easier to read. But, more importantly, it formats parameters and so on vertically instead of wrapping them to a specified horizontal width.

Take a look at this very simple example. There are only two extra commas in the second chunk of code. You can copy and paste these chunks of code in to your IDE and see how drastically different the formatting is. Trailing commas trade horizontal space for vertical space.

```dart
class NumbersNoTrailing {
  final numbers = [1, 2];

  int add(int number1, int number2) {
    return number1 + number2;
  }
}

class NumberswithTrailing {
  final numbers = [
    1,
    2,
  ];

  int add(
    int number1,
    int number2,
  ) {
    return number1 + number2;
  }
}
```

Enforce Trailing Comma with a Code Rule
---------------------------------------

The [Dart Code Metrics](https://pub.dev/packages/dart_code_metrics) package is an excellent tool for adding extra code analysis to your project. You add it to your `dev_dependencies` and configure it in `analysis_options.yaml`. There is a rule called prefer-trailing-comma. You need to turn this on. Read further installation documentation [here](https://pub.dev/packages/dart_code_metrics/install). This is an example config section I often use, but you don't have to turn all the errors on as I have done here.

```yaml
dart_code_metrics:
  anti-patterns:
    - long-method:
        severity: error
    - long-parameter-list:
        severity: error
  metrics:
    cyclomatic-complexity: 20
    maximum-nesting-level: 5
    number-of-parameters: 4
    source-lines-of-code: 50
    weight-of-class: 0.33
    halstead-volume: 150
  metrics-exclude:
  rules:
    - newline-before-return:
        severity: error
    - no-boolean-literal-compare:
        severity: error
    - no-empty-block:
        severity: error
    - prefer-trailing-comma:
        severity: error
    - prefer-conditional-expressions:
        severity: error
    - no-equal-then-else:
        severity: error
    - avoid-restricted-imports:
        severity: error
    - avoid-global-state:
        severity: error
    - avoid-ignoring-return-values:
        severity: error
    - avoid-late-keyword:
        severity: error
```

This causes an error if you do not add the trailing comma, but it also gives you a quick fix to automatically add it. This is very handy when there is a lot of nesting, and it is not clear where the issue in the code is.

![Add trailing comma quick fix in VS Code](/assets/images/blog/dart_formatting/add_trailing_commas.png "Add trailing comma quick fix in VS Code"){:width="100%"}

Break The Build On Bad Formatting
---------------------------------

If someone in your team submits code in a pull request, and that code contains badly formatted code, the build should fail. If it doesn't, unformatted code can easily split through. I find it strange that the dart analyzer does not fail upon encountering bad formatting. This is also true for the build command. However, running this command can make the build fail when it encounters bad code. You can add this to your build pipeline YAML.

`flutter format [LIB FOLDER] --set-exit-if-changed`

Essentially, this runs the formatter and exits with a failure code if it finds anything to format.

Wrap-Up
-------

Teams can avoid a lot of heartache with deterministic formatting, and dart has an excellent formatter. You also can auto-format all dart documents and break the pipeline build if the code is not formatted. When all these things work together, your team will have far fewer arguments about formatting, experience fewer git diffs, and merge conflicts. Adding the trailing comma in your code will also improve overall formatting. Try to set this up early in the project, but it's never too late to make these changes in a project.