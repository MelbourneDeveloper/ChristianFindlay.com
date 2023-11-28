---
layout: post
title: "Flutter - Debunking the Helper Function Myth"
date: "2023/11/08 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/flutterhelpers/flutterconfusion.png"
image: "/assets/images/blog/flutterhelpers/flutterconfusion.png"
description: Reusing widget code with helper functions is a great idea 👍🏼
tags: dart
categories: flutter
permalink: /blog/:title
---

Functions and methods are the basic building blocks for reusable code. They are particularly useful for breaking large pieces of widget code into smaller, more manageable and reusable pieces. However, there is some anxiety in the Flutter community about whether it is safe to use them. This blog post explains that while there are some general pitfalls around constructing widgets, functions are not only safe to use - they are often preferable to creating a full Widget class. Avoiding unnecessary widget nodes in the tree simplifies it, and may even improve performance in some cases. This blog post also goes into the history around why there is confusion on this topic, how to avoid some pitfalls when constructing the widget tree and most importantly, adds nuance to the discussion.

## Background

In 2019, there was already some anxiety around whether or not Flutter developers should break widgets up into smaller functions or methods. Some had already labeled it an "antipattern". A hapless Redditor pointed out that ["Extracting widgets to a function is not an anti-pattern"](https://www.reddit.com/r/FlutterDev/comments/avhvco/extracting_widgets_to_a_function_is_not_an/) and they were right, but the post eventually led to a Stack Overflow post where a Flutter community member argued that we should ["Prefer using classes over functions to make reusable widget-tree"](https://stackoverflow.com/a/53234826/1878141). At the end of 2021, [the official Flutter YouTube channel](https://www.youtube.com/@flutterdev) published a [video](https://www.youtube.com/watch?v=IOyq-eTRhvo) that seems to echo the same sentiment. There have been several other [blog posts](https://steveos.medium.com/use-separate-widget-over-helper-method-in-flutter-heres-why-better-performace-433672eb7461) that echo the sentiment.

Ever since the post and the video, the debate over using classes versus functions for creating reusable widgets has been a hot topic and has led to confusion in the Flutter community. Today, I'm writing to debunk the myth that has arisen from this debate – the idea that helper functions are not suitable for breaking up reusable components in the widget tree.

The Stack Overflow post and the YouTube video both point to Dartpad samples that illustrate some issues about constructing the widget tree, but none of the issues illustrated in those samples necessarily lead to the conclusion that always creating a Widget class is better than using a function to construct the widget tree. They present a [false dichotomy](https://www.dictionary.com/browse/false-dichotomy) where the spectrum of possible options is misrepresented as an either-or choice between two mutually exclusive things. 

Widget classes and functions that construct them are two different things, and the material above conflates them in confusing ways. The post and the video both lack nuance and present an absolutist conclusion that results in many developers feeling like their only choice is to work with bloated widget tree code, or create a full Widget class.

## What is a Widget Tree?

It's important to understand that your code is not the Widget Tree. Your code constructs the Widget Tree. The Widget Tree is an object model that is a blueprint for rendering your UI. Your app's state informs the tree, and portions of the tree rebuild when the app state changes. The Widget Tree rebuilds eventually trigger the repainting of the UI. Animations are a quick succession of state changes that trigger changes in the Widget Tree and result in visual movement on-screen. 

You can only see the Widget Tree at runtime. This is a Widget Tree represented in the [Flutter Inspector](https://docs.flutter.dev/tools/devtools/inspector). You can use it to inspect the Widget Tree at any point after running your app.

[INSERT IMAGE]

You compose the widget tree by filling in the `build` method of `Widget` classes. When your Flutter app runs, it calls your `build` methods to construct the tree. `Widget`s can have zero, one, or many child widgets. This is a typical example of code that constructs a Widget Tree.

[INSERT IMAGE]

### Widget Classes, Helper Functions, and Other Ways To Construct Widgets

Let's say you have a heading that appears often in your app. It's basically just some fixed text with a `TextStyle` that you want to center horizontally. There are several ways you can construct this for the Widget Tree. You can create a Widget class, return it from a function, or just define a Widget instance as a `const`. Here are the different ways to represent this:    

#### As a Class

```dart
class CustomHeading extends StatelessWidget {
  const CustomHeading({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Text(
          'My Heading',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
}

// Usage
const customHeading = CustomHeading();
```

#### As a Helper Function
```dart
Widget customHeading() => const Center(
      child: Text(
        'My Heading',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

// Usage
const headingWidget = customHeading();
```

#### As a Constant
```dart
const customHeading = Center(
  child: Text(
    'My Heading',
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
);

// Usage
customHeading
```

As you can see, the constant option is the simplest, both in terms of code written, and usage. In cases where the widget has fixed content and no parameters, we don't even need a function. We can simply store the `Widget` as a constant, and this will have the best performance. But, in most cases, we will need to at least pass a value in to construct the widget, and this is where functions (or helper functions) are useful.

It's important to understand the resulting difference in the widget tree using these three cases. The second and third options result in two widgets, while the first option results in three widgets. 

[INSERT CLASS WIDGET TREE HERE]

[INSERT OTHER VERSION HERE]

Notice that the class version constructs a more complex Widget Tree. This is where performance may become a factor. All things being equal, the less complex your widget tree, the less work is necessary for rendering. Without benchmarking this, it is possible to guess that the first version may create more work for the rendering process than the second two options, but the reality is that Flutter is fast and none of these options should pose a performance issue.

## The Case for Helper Functions

Taming the complexity of the Widget Tree, and the code that constructs the Widget Tree is the key to a maintainable Flutter app. There are several ways to do this, and you shouldn't limit yourself to any single approach. Breaking up the widget tree code vertically and horizontally is critical for readability, and allows you to reuse components. 

Questionable...
Furthermore, it's generally good performance practice to replace smaller chunks in the widget tree instead of larger ones. If your `build` methods are too large, 

### Simplicity and Readability

Helper functions shine in their simplicity. They allow developers to encapsulate widget logic in a more readable and maintainable way, especially for straightforward, less complex widgets. It leads to cleaner code and IDEs have refactoring tools that allow you to easily break large `build` methods into smaller functions or methods. 

### Performance Considerations

One misconception that the article and video construe is that helper functions inherently lead to performance issues. This is not the case. Properly used helper functions are just as efficient as classes. Remember, performance derives from the runtime Widget Tree structure and how it changes over time - not how you construct the Widget Tree in your code. Using functions won't adversely affect your app's performance in most cases, but even when they would, that doesn't mean you need to create a full widget class to get the performance benefit. 

#### `const` Constructor

Both the Stack Overflow post, and the video point out that you should use `const` constructors wherever possible. This is true. And, they both make a fair point that functions stop you from using const constructors in some scenarios. Consider this code:

![Function Const Error](/assets/images/blog/myth/consterror.png){:width="100%"}

As you can see, it won't compile because the `MaterialApp` is declared as `const`. Functions only evaluate at runtime, so calling the `customHeading()` function disallows the `const` keyword. 

The SO post says classes "allow performance optimization", but this is not correct. It's the `const` keyword that allows for the optimization, and creating a widget class is not necessary to achieve this optimization. `const` widgets get compiled into your code. You can reference them anywhere in the widget tree. 

This example demonstrates why it is not necessary to create a widget class in order to leverage the const keyword to get the best possible performance, while at the same time, creating a reusable, named widget.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=e411288a95c34ddfd636a751dc20fb45"></iframe>
</figure>

### Flexibility and Reusability

Helper functions offer flexibility. You can easily reuse them across different parts of an application to keep the code DRY (Don't Repeat Yourself). This reusability is particularly beneficial for creating consistent UI elements across an app.

### Unnecessary Widget Classes Bloat Your Codebase

You shouldn't create unnecessary classes or types in any language or platform because they bloat your codebase. 

## Addressing the Confusion

The Stack Overflow post argues that classes should be preferred over functions for widget creation, citing issues like performance optimization and framework integration. While these points hold validity in certain scenarios, they do not render helper functions obsolete or always inferior.

## Context Matters

The choice between classes and helper functions should be based on the specific use case. For complex widgets that require managing state or lifecycle, classes are indeed the better choice. However, for simpler, stateless widgets, helper functions are often more than adequate.
Not an Either/Or Situation

It's essential to understand that using helper functions or classes is not an exclusive choice. In many cases, a combination of both can be the most effective approach, depending on the complexity and requirements of the widget in question.
Best Practices for Using Helper Functions

    Use for Stateless Widgets: Helper functions are best suited for stateless widgets that do not need to interact with the lifecycle methods of a widget.

    Keep Them Simple: Avoid adding complex logic or state management inside helper functions. If a widget starts to grow complex, consider converting it into a class.

    Focus on Readability: One of the main advantages of helper functions is improving code readability. Keep them clean and easy to understand.

    Performance Awareness: Be aware of the performance implications. For instance, avoid unnecessary re-rendering of widgets.

## Addressing the Samples

The YouTube video and the Stack Overflow post both point to Dartpad samples, but nothing about these samples leads to the conclusion that you should prefer Widget classes over functions. These samples demonstrate things that you need to be aware of in general, but you can run into these same issues from the misuse of Dart or the Flutter SDK in any number of ways. Let's pick them apart.



## Official Flutter Team Stance

The Stack Overflow post makes the bold assertion that

> The Flutter team has now taken an official stance on the matter and stated that classes are preferable

But, I don't think that's true at all. The Flutter team is made up of many individuals and I'm sure they all have differing opinions. Several people in the team make video content and I sincerely doubt that the whole team reviews every video before they publish. I don't know what the vetting process for YouTube videos is, but, surely, if there is an official stance on this matter, it should be on the Flutter documentation website. 

The website does [make mention](https://docs.flutter.dev/perf/best-practices#control-build-cost) of the YouTube video by saying this:

> Widgets vs helper methods, a video from the official Flutter YouTube channel that explains why widgets (especially widgets with const constructors) are more performant than functions.

Firstly, this is a clumsy, imprecise sentence. It's not clear what it means. Everything in the widget tree is a widget, and you need to use constructors, methods or functions to build it. Widget constructors are a form of method. 

As I already mentioned, leveraging `const` widgets is not limited to widgets with a predefined type. You can just declare widget constants anywhere in your code and leverage them in the widget tree. Again, the documentation here presents a false dichotomy.

I would personally like the Flutter team to issue clarification on the documentation website, and a clarification video. I'd be happy to write a PR for this if the Flutter team would like that.

## Conclusion

The myth that helper functions are not suitable for creating reusable widgets in Flutter needs to be dispelled. Both classes and functions have their place in Flutter development, and the decision to use one over the other should be guided by the specific needs of the widget being created. Let's embrace the flexibility that Flutter offers and use the full range of tools at our disposal to create efficient, maintainable, and high-performing applications.

Remember, in software development, understanding the tools and making informed decisions based on the project's needs is always key to successful implementation.
<sub><sup>Photo by [Rodolfo Clix](https://www.pexels.com/photo/photo-of-clear-glass-measuring-cup-lot-1366942/) from Pexels</sup></sub>