---
layout: post
title: "Flutter - Themes in Material Design Three"
date: "2023/04/29 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/testing/testingheader.jpg"
image: "/assets/images/blog/testing/testingheader.jpg"
description: Discover the benefits of full app widget testing in Flutter, and learn how to ensure your app's UI works as intended with comprehensive coverage. This in-depth guide provides code examples, tips on dependency injection, and insights into automated testing and UI behavior for building reliable and high-quality Flutter applications.
tags: theming [material design] colors
categories: flutter
permalink: /blog/:title
---

One of the most common questions developers ask when working with Flutter is how to efficiently manage themes to create visually appealing and consistent UIs across their apps. Themes are coupled with the design system we use. Flutter apps usually use Material Design, or Cupertino, but this article focuses on theming with [Material Design 3](https://m3.material.io/). We'll dive into the details of how to create, customize, and apply themes in your Flutter applications.

## Understanding Flutter Material Design Themes

Material Design 3 is Google's latest design system for building apps and websites. You should read up about the [design system](https://m3.material.io/) before looking into theming. A theme in Flutter is a collection of property-value pairs that dictate the appearance of the app's widgets. ThemeData is the class responsible for holding these properties. Let's first understand the significance of ThemeData and how it helps in theming.

#### [ThemeData](https://api.flutter.dev/flutter/material/ThemeData-class.html)

The `ThemeData` class encapsulates colors, typography, and shape properties for a material design-based theme. We typically use it as an argument for the [`MaterialApp`](https://api.flutter.dev/flutter/material/MaterialApp-class.html) widget, which in turn applies the theme to all descendant widgets.

#### Creating a Custom Theme

Create a `ThemeData` instance and assign values to the properties you wish to customize. Let's create a custom theme and apply it to our Flutter app. You can try this out in [Dartpad](https://dartpad.dev/). Just modify the existing default app there. Make sure you set `useMaterial3` because this tells flutter you want to use the latest version of Material Design, which is three.

```dart
ThemeData customTheme = ThemeData(
  useMaterial3: true,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(secondary: Colors.orange),
);
```

#### Applying the ThemeData Instance

Pass the custom theme to the `theme` property of the `MaterialApp` widget.

```dart
MaterialApp(
  title: 'Custom Theme Demo',
  theme: customTheme,
  home: MyHomePage(),
);
```

#### Using the Theme Properties

Access the ThemeData properties with the `Theme.of(context)` method. Here's an example of how to use the primary color and text theme in a Text widget:

```dart
Text(
  'Hello, Flutter!',
  style: Theme.of(context).textTheme.headlineMedium,
);
```

Section 4: Dark and Light Themes

Flutter also allows you to define separate themes for dark and light mode. This can be done by setting the darkTheme property of the MaterialApp widget.

4.1 Defining Dark ThemeData Instance

dart

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.red,
  accentColor: Colors.amber,
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyText1: TextStyle(fontSize: 18, color: Colors.white70),
  ),
  appBarTheme: AppBarTheme(
    color: Colors.red,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

4.2 Applying Dark ThemeData Instance

dart

MaterialApp(
  title: 'Custom Theme Demo',
  theme: customTheme,
  darkTheme: darkTheme,
  home: MyHomePage(),
);

Conclusion

Congratulations! You've now learned how to create and customize themes in Flutter, as well as how to apply different themes for dark
<sub><sup>Photo by [Rodolfo Clix](https://www.pexels.com/photo/photo-of-clear-glass-measuring-cup-lot-1366942/) from Pexels</sup></sub>