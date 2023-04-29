---
layout: post
title: "Flutter - Themes in Material Design Three"
date: "2023/04/29 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/materialdesign/logo.png"
image: "/assets/images/blog/materialdesign/logo.png"
description: Discover the benefits of full app widget testing in Flutter, and learn how to ensure your app's UI works as intended with comprehensive coverage. This in-depth guide provides code examples, tips on dependency injection, and insights into automated testing and UI behavior for building reliable and high-quality Flutter applications.
tags: theming material-design colors
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
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
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
  theme: lightTheme,
  home: MyHomePage(),
);
```

#### Using the Theme Properties

Access the ThemeData properties with the [`Theme.of(context)`](https://api.flutter.dev/flutter/material/Theme/of.html) method. Here's an example of how to use the primary color and text theme in a Text widget:

```dart
Text(
  'Hello, Flutter!',
  style: Theme.of(context).textTheme.headlineMedium,
);
```

#### Dark and Light Themes

Flutter also allows you to define separate themes for dark and light mode. You can set the `darkTheme` property of the `MaterialApp` widget. Make sure you set the theme's `brightness` property to `Brightness.dark` to indicate that it's a dark theme.

```dart
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.red,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
    secondary: Colors.amber,
    brightness: Brightness.dark,
  ),
);
```

#### Applying Dark ThemeData Instance

This tells Flutter that there are two themes: light and dark. Flutter will automatically switch between the two themes based on the device's brightness settings. 

```dart
MaterialApp(
  title: 'Custom Theme Demo',
  theme: lightTheme,
  darkTheme: darkTheme,
  home: MyHomePage(),
);
```

You can also manually set the theme mode to light or dark using the `themeMode` property of the `MaterialApp` widget. If you do this, the Flutter app will ignore your device's brightness setting and use the theme you specify.

```dart
MaterialApp(
  title: 'Custom Theme Demo',
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.light,
  home: MyHomePage(),
); 
```



## Modifying Typography with TextStyles

[Typography](https://m3.material.io/styles/typography) is an important aspect of Material Design, and Flutter's `ThemeData` allows you to customize the typography of your app. This includes adjusting font sizes, weights, and colors for different text styles. The `textTheme` property of `ThemeData` contains a [`TextTheme`](https://api.flutter.dev/flutter/material/TextTheme-class.html) object, which in turn has a set of predefined [`TextStyle`](https://api.flutter.dev/flutter/painting/TextStyle-class.html) properties. These properties represent different text styles like headlines, body text, captions, etc. You can modify the TextStyle properties to customize the typography for each style. This is an example of setting the font sizes and weights.

```dart
ThemeData lightTheme = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 96, fontWeight: FontWeight.w300, color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 60, fontWeight: FontWeight.w400, color: Colors.black),
    displaySmall: TextStyle(
        fontSize: 48, fontWeight: FontWeight.w400, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 34, fontWeight: FontWeight.w400, color: Colors.black),
    headlineSmall: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
    titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
    bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
    bodyMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87),
    bodySmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
    labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
  ),
);
```

You can use these styles in your app with the [`Theme.of(context).textTheme`](https://api.flutter.dev/flutter/material/ThemeData/textTheme.html) property.

#### Typography and Material Design

Material Design provides a set of typographic guidelines that define how to style text across different platforms and devices. These ensure that your app adheres to the Material Design principles, which helps you create a better user experience. The predefined text styles in Flutter's `TextTheme` follow these guidelines, so Flutter apps automatically adhere to the Material Design typography guidelines.

## Identifying the Theme Property for Widget Colors

You need to identify the theme property that sets the color for that specific widget. These properties should come from the [`ColorScheme`](https://api.flutter.dev/flutter/material/ColorScheme-class.html). Generally, the color property for a widget is stored within a specific property of an object in the `ThemeData`. Your first point of call should be the Flutter API documentation for that widget. It should tell you which properties you need to set.

```dart
ThemeData(
  appBarTheme: const AppBarTheme(
    color: Colors.pink,
  ),
);
```


## Complete Example

Try the live sample in your browser [here](https://dartpad.dev/?id=940b8910603af83786d34e416bc89901). This example allows you to toggle between the three different theme modes so you can see how the dark and light themes look.

```dart
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
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

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.red,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
    secondary: Colors.amber,
    brightness: Brightness.dark,
  ),
);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  IconData get _themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.brightness_low;
      case ThemeMode.dark:
        return Icons.brightness_3;
      case ThemeMode.system:
      default:
        return Icons.brightness_auto;
    }
  }

  void _toggleThemeMode() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : _themeMode == ThemeMode.dark
              ? ThemeMode.system
              : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Toggler'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: _toggleThemeMode,
            ),
          ],
        ),
        body: Center(
          child: MyWidget(
            themeMode: _themeMode,
            themeModeIcon: _themeModeIcon,
          ),
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  final ThemeMode themeMode;
  final IconData themeModeIcon;

  const MyWidget(
      {required this.themeMode, required this.themeModeIcon, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hello, World!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          'Current Theme Mode: ${themeMode.toString().split('.').last}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 10),
        Icon(themeModeIcon, size: 48),
      ],
    );
  }
}
```

## Conclusion
This article explained how to use Material Design themes with Flutter. Understanding the Material Design system is critical for Flutter developers, so spend some time on the [Material Design website](https://m3.material.io/) to learn more about the system and how to use it in your apps. It is full of great examples and points to the Fluttter documentation.
