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

One of the most common questions developers ask when working with Flutter is how to efficiently manage themes to create visually appealing and consistent UIs across their apps. Themes are coupled with the design system we use. Flutter apps usually use Material Design, or Cupertino, but this article focuses on theming with [Material Design 3](https://m3.material.io/). This article dives into the details of how to create, customize, and apply themes in your Flutter applications.

## Theming

[Understanding Flutter Material Design Themes](#understanding-flutter-material-design-themes)

[ThemeData](#themedata)

[Creating a Custom Theme](#creating-a-custom-theme)

[Applying the ThemeData Instance](#applying-the-themedata-instance)

[Using the Theme Properties](#using-the-theme-properties)

[Dark and Light Themes](#dark-and-light-themes)

[Applying Dark ThemeData Instance](#applying-dark-themedata-instance)

## Colors

[The Importance of ColorScheme in Material Design 3](#the-importance-of-colorscheme-in-material-design-3)

[Identifying How Widgets Get Their Default Color](#identifying-how-widgets-get-their-default-color)

[Override Default Colors](#override-default-colors)

[Complete Example](#complete-example)

## Typography

[Modifying Typography with TextStyles](#modifying-typography-with-textstyles)

[Conclusion](#conclusion)

## Understanding Flutter Material Design Themes

Material Design 3 is Google's latest design system for building apps and websites. You should read up about the [design system](https://m3.material.io/) before looking into theming. A theme in Flutter is a collection of property-value pairs that dictate the appearance of the app's widgets. [`ThemeData`](https://api.flutter.dev/flutter/material/ThemeData-class.html) is the class responsible for holding these properties. Let's first understand the significance of `ThemeData` and how it helps in theming.

#### [ThemeData](https://api.flutter.dev/flutter/material/ThemeData-class.html)

The `ThemeData` class encapsulates colors, typography, and shape properties for a Material Design theme. We typically use it as an argument for the [`MaterialApp`](https://api.flutter.dev/flutter/material/MaterialApp-class.html) widget, which in turn applies the theme to all descendant widgets.

#### Creating a Custom Theme

Create a `ThemeData` instance and assign values to the properties you wish to customize. Let's create a custom theme and apply it to our Flutter app. You can try this out in [Dartpad](https://dartpad.dev/). Just modify the existing default app there. Make sure you set `useMaterial3` to true because this tells flutter you want to use the latest version of Material Design, which is three.

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

## The Importance of ColorScheme in Material Design 3

Flutter widgets pay particular attention to the `ColorScheme` in your theme data. They use the colors here for default color values.

#### What is ColorScheme?

[`ColorScheme`](https://api.flutter.dev/flutter/material/ColorScheme-class.html) is a class that defines the set of colors that your app can use. It should have a cohesive set of colors, and follow the Material Design [color system](https://m3.material.io/styles/color/the-color-system). It contains properties for primary, secondary, surface, background, error, and other colors that make up your application's color palette. 

In Material Design 3, `ColorScheme` plays an even more significant role, as it defines the default colors for many widgets and provides a straightforward way to create adaptive themes that work well in both light and dark modes. 

#### Default colors in Material Design 3

The primary purpose of a `ColorScheme` is to define a set of default colors for your app, which are then applied to various widgets and UI elements. In Material Design 3, many components and themes rely on the `ColorScheme` to determine their default colors. This makes it easier to create a consistent color palette for your app while still adhering to Material Design guidelines.

When creating a `ThemeData` object for your app, you can define a custom `ColorScheme` by using the [`ColorScheme.fromSeed()`](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html) (recommended for Material Design 3), [`ColorScheme.fromSwatch()`](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSwatch.html) methods or by specifying each color property individually:

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
)
```

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  ),
)
```

## Identifying How Widgets Get Their Default Color

Widgets get their default color from the `ColorScheme`. Each widget has a set of specific properties that define the various colors it uses. For example, `TextButton` gets the foreground text color from `ColorScheme.primary`. In this example, the button's text displays as green.

```dart
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            primary: Colors.green,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: TextButton(
            onPressed: () {},
            child: const Text('test'),
          ),
        ),
      ),
    );
```

‍![Green Button](/assets/images/blog/materialdesign/greenbutton.png)

Unfortunately, there is no one-size-fits-all way to find out which property of the `ColorScheme` the widget uses because they use different color properties for their default color. The primary sources for learning these are a) the flutter source code, and b) the documentation. 

You won't always find the answer in the documentation so look at the widget's source code. Flutter is open-source, and you can view the source code for any widget to see exactly how it's built. Simply ctrl+click (or cmd+click on macOS) on the widget name in your editor if you are using an IDE like VSCode or Android Studio, and it should take you to the definition in the source code.

Buttons have a `defaultStyleOf` method that returns a `ButtonStyle`. This example if from the Flutter source code and returns the defaults from `_TextButtonDefaultsM3`. 

```dart
@override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Theme.of(context).useMaterial3
      ? _TextButtonDefaultsM3(context)
      : styleFrom(
        // [This code is irrelevant for Material Design 3]
        );
  }
```

This is the definition of the `_TextButtonDefaultsM3` class. Most widgets have a class suffixed with `DefaultsM3` that you can find in the widget's source code file. This code shows you how the widget picks up the foreground color from the `ColorScheme.primary` property when the button is enabled.

```dart
class _TextButtonDefaultsM3 extends ButtonStyle {
  _TextButtonDefaultsM3(this.context)
   : super(
       animationDuration: kThemeChangeDuration,
       enableFeedback: true,
       alignment: Alignment.center,
     );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  // ...

  @override
  MaterialStateProperty<Color?>? get foregroundColor =>
    MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return _colors.onSurface.withOpacity(0.38);
      }
      return _colors.primary;
    });

  // ...
}
```

You should try to utilize the `ColorScheme` colors because if you get these right, your app will automatically adhere to the Material Design guidelines and have a coherent color scheme. However you can also override the colors for the specific widget at the theme level. This can be a shortcut to finding the `ColorScheme` default color but it means you are only changing the color for a given widget. Widgets that should have the same colors according to Material Design 3 may end up with different colors.

#### Override Default Colors

In Material Design 3, [`ElevatedButton`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html), [`OutlinedButton`](https://api.flutter.dev/flutter/material/OutlinedButton-class.html), and [`TextButton`](https://api.flutter.dev/flutter/material/TextButton-class.html) all use the `ColorScheme` to derive their default colors. However, you can override the default colors for these widgets by setting the `style` property of the specific button, or by overriding the button's type's specific style. 

For example, you can override the background color for `ElevatedButton` only like this. Note that we need to convert the color to a [`MaterialStateProperty<Color?>`](https://api.flutter.dev/flutter/material/MaterialStateProperty-class.html). This is because the background color can change depending on the state of the button. This example makes the button red in any state.

```dart
ThemeData theme = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) => Colors.red,
    ),
  )),
  useMaterial3: true,
);
```

Bear in mind that while the you can set `buttonStyle` on the theme, it often has little or no effect. You might think this would make buttons appear in red, but it doesn't

```dart
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          buttonTheme: const ButtonThemeData(buttonColor: Colors.red),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {},
            child: const Text('test'),
          ),
        ),
      ),
    );
```

‍![Not Red Button](/assets/images/blog/materialdesign/notredbutton.png)

## Complete Example

This example allows you to toggle between the three different theme modes so you can see how the dark and light themes look. You can modify the code to check out how the different colors are applied to the widgets.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=940b8910603af83786d34e416bc89901"></iframe>
</figure>

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

You can use these styles in your app with the [`Theme.of(context).textTheme`](https://api.flutter.dev/flutter/material/ThemeData/textTheme.html) property, and the [`Text`](https://api.flutter.dev/flutter/widgets/Text-class.html) widget's default `TextStyle` is `bodyMedium`. This example shows how to set the text style, how the `Text` widget picks up the default style, and how to use a named `TextStyle` from the theme.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=57b9f78da95614eef4b1d922ea2f6593"></iframe>
</figure>


## Conclusion
Grasping Flutter's Material Design 3 themes is key for modern application design, so spend some time on the [Material Design website](https://m3.material.io/) to learn more about the system and how to use it in your apps. This guide discussed creating custom themes with `ThemeData`, defining color palettes with `ColorScheme`, and adhering to Material Design guidelines for a user-friendly experience.

It also examined overriding colors, understanding widget color inheritance, customizing typography, and automated theme switching in Flutter. For a polished UI, implementing Material Design themes in Flutter is essential.
