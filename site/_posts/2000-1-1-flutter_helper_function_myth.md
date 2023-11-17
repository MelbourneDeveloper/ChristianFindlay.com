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

Functions and methods are the basic building blocks for reusable code. They are particularly useful for breaking large pieces of widget code into smaller, more manageable and reusable pieces. However, there is some anxiety in the Flutter community about whether it is safe to use them. This blog post explains that while there are some general pitfalls around constructing widgets, functions are not only safe to use - they are often preferable to creating a full Widget class. Avoiding unnecessary widget nodes in the tree simplifies it, and may even improve performance in some cases. This blog post also goes into the history around why there is confusion on this topic and how to avoid some pitfalls when constructing the widget tree.

## Background

In 2019, there was already some anxiety around whether or not Flutter developers should break widgets up into smaller functions or methods. Some had already labeled it an "antipattern". A hapless Redditor pointed out that ["Extracting widgets to a function is not an anti-pattern"](https://www.reddit.com/r/FlutterDev/comments/avhvco/extracting_widgets_to_a_function_is_not_an/) and they were right, but the post eventually led to a Stack Overflow post where a Flutter community member argued that we should ["Prefer using classes over functions to make reusable widget-tree"](https://stackoverflow.com/a/53234826/1878141). At the end of 2021, the official Flutter YouTube channel published a [video](https://www.youtube.com/watch?v=IOyq-eTRhvo) that seems to echo the same sentiment.

Ever since the post and the video, the debate over using classes versus functions for creating reusable widgets has been a hot topic and has led to confusion in the Flutter community. Today, I'm writing to debunk the myth that has arisen from this debate – the idea that helper functions are not suitable for breaking up reusable components in the widget tree.

The Stack Overflow post and the YouTube video both point to Dartpad samples that illustrate some issues about constructing the widget tree, but none of the issues illustrated in those samples necessarily lead to the conclusion that always creating a Widget class is better than using a function to construct the widget tree. They present a [false dichotomy](https://www.dictionary.com/browse/false-dichotomy) where the spectrum of possible options is misrepresented as an either-or choice between two mutually exclusive things. 

Widget classes and functions that construct them are two different things, and the material above conflates them in confusing ways. 

## The Case for Helper Functions

### Simplicity and Readability

Helper functions shine in their simplicity. They allow developers to encapsulate widget logic in a more readable and maintainable way, especially for straightforward, less complex widgets. This approach can lead to cleaner code, as it prevents the overuse of classes for relatively simple tasks.
Performance Considerations

One common misconception is that helper functions inherently lead to performance issues. However, this is not the case. Properly used helper functions can be just as efficient as classes. The key is in knowing when to use them - they are best for widgets that do not require their own state or lifecycle.
Flexibility and Reusability

Helper functions offer flexibility. They can be easily reused across different parts of an application, helping to keep the code DRY (Don't Repeat Yourself). This reusability is particularly beneficial for creating consistent UI elements across an app.
Addressing the Confusion

The Stack Overflow post argues that classes should be preferred over functions for widget creation, citing issues like performance optimization and framework integration. While these points hold validity in certain scenarios, they do not render helper functions obsolete or always inferior.
Context Matters

The choice between classes and helper functions should be based on the specific use case. For complex widgets that require managing state or lifecycle, classes are indeed the better choice. However, for simpler, stateless widgets, helper functions are often more than adequate.
Not an Either/Or Situation

It's essential to understand that using helper functions or classes is not an exclusive choice. In many cases, a combination of both can be the most effective approach, depending on the complexity and requirements of the widget in question.
Best Practices for Using Helper Functions

    Use for Stateless Widgets: Helper functions are best suited for stateless widgets that do not need to interact with the lifecycle methods of a widget.

    Keep Them Simple: Avoid adding complex logic or state management inside helper functions. If a widget starts to grow complex, consider converting it into a class.

    Focus on Readability: One of the main advantages of helper functions is improving code readability. Keep them clean and easy to understand.

    Performance Awareness: Be aware of the performance implications. For instance, avoid unnecessary re-rendering of widgets.

Conclusion

The myth that helper functions are not suitable for creating reusable widgets in Flutter needs to be dispelled. Both classes and functions have their place in Flutter development, and the decision to use one over the other should be guided by the specific needs of the widget being created. Let's embrace the flexibility that Flutter offers and use the full range of tools at our disposal to create efficient, maintainable, and high-performing applications.

Remember, in software development, understanding the tools and making informed decisions based on the project's needs is always key to successful implementation.
<sub><sup>Photo by [Rodolfo Clix](https://www.pexels.com/photo/photo-of-clear-glass-measuring-cup-lot-1366942/) from Pexels</sup></sub>