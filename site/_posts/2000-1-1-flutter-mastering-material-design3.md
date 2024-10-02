---
layout: post
title: "Mastering Material Design 3: The Complete Guide to Theming in Flutter"
date: "2023/05/04 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/materialdesign/logo.webp"
post_image_height: 300
post_image_width: 300
image: "/assets/images/blog/materialdesign/logo.webp"
description: Master Material Design 3 Theming in Flutter with this comprehensive guide. Explore custom themes with ThemeData, define color palettes with ColorScheme, and learn how to adhere to Material Design guidelines. Discover how to override colors, customize typography, and automate theme switching in Flutter. Perfect for Flutter developers looking to enhance their UI design skills and create visually stunning, user-friendly applications.
categories: flutter
tags: material-design
permalink: /blog/:title
keywords: [
  "Flutter theming",
  "Material Design 3",
  "ThemeData Flutter",
  "Flutter custom themes",
  "ColorScheme in Flutter",
  "Dark mode Flutter",
  "Flutter typography customization",
  "Material Design 3 colors",
  "Flutter UI design",
  "Flutter theme switching",
  "Material Design guidelines",
  "Flutter widget theming",
  "Flutter app development",
  "Material 3 shape theming",
  "Flutter theme best practices",
  "Material Design color system",
  "Flutter theme debugging",
  "Material 3 in Flutter",
  "Flutter theme customization",
  "Material Design 3 typography"
]
---

One of the most common questions developers ask when working with Flutter is how to efficiently manage themes to create visually appealing and consistent UIs across their apps. Themes are part of the design system we use. Flutter apps usually use Material Design or Cupertino, but this article focuses on theming with [Material Design 3](https://m3.material.io/). This article details how to create, customize, and apply themes in your Flutter applications.

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

## Shapes

[Theme Shapes](#theme-shapes)

[Conclusion](#conclusion)

## Understanding Flutter Material Design Themes

Material Design 3 is Google's latest design system for building apps and websites. Before looking into theming, you should read up about the [design system](https://m3.material.io/). A theme in Flutter is a collection of property-value pairs that dictate the appearance of the app's widgets. [`ThemeData`](https://api.flutter.dev/flutter/material/ThemeData-class.html) is the class responsible for holding these properties. Let's first understand the significance of `ThemeData` and how it helps in theming.

#### [ThemeData](https://api.flutter.dev/flutter/material/ThemeData-class.html)

The `ThemeData` class encapsulates a Material Design theme's colors, typography, and shape properties. We typically use it as an argument for the [`MaterialApp`](https://api.flutter.dev/flutter/material/MaterialApp-class.html) widget, which in turn applies the theme to all descendant widgets.

#### Creating a Custom Theme

Create a `ThemeData` instance and assign values to the properties you wish to customize. Let's create a custom theme and apply it to our Flutter app. You can try this out in [Dartpad](https://dartpad.dev/). Just modify the existing default app there. Ensure you set `useMaterial3` to true because this tells Flutter you want to use the latest version of Material Design, which is three.

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
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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

Flutter also allows you to define separate themes for dark and light modes. You can set the `darkTheme` property of the `MaterialApp` widget. Make sure you set the `ColorScheme`'s `brightness` property to `Brightness.dark` to indicate it's a dark theme.

```dart
ThemeData darkTheme = ThemeData(
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 18, color: Colors.white70),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.red,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.red,
    brightness: Brightness.dark,
  ),
);
```

#### Applying Dark ThemeData Instance

This tells Flutter that there are two themes: light and dark. Flutter automatically switches between the two themes based on the device's brightness settings. 

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

[`ColorScheme`](https://api.flutter.dev/flutter/material/ColorScheme-class.html) is a class that defines the set of colors that your app can use. It should have a cohesive set of colors and follow the Material Design [color system](https://m3.material.io/styles/color/the-color-system). It contains properties for primary, secondary, surface, background, error, and other colors that make up your application's color palette. 

In Material Design 3, `ColorScheme` plays an even more significant role. It defines the default colors for many widgets and provides a straightforward way to create adaptive themes that work well in light and dark modes. 

#### Default colors in Material Design 3

The primary purpose of a `ColorScheme` is to define a set of default colors for your app, which then applies to various widgets and UI elements. In Material Design 3, many components and themes rely on the `ColorScheme` to determine their default colors. This makes it easier to create a consistent color palette for your app while adhering to Material Design guidelines.

When creating a `ThemeData` object for your app, you can define a custom `ColorScheme` by using the [`ColorScheme.fromSeed()`](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html) (recommended for Material Design 3) or by specifying each color property individually. This example generates the colors from the seed color blue.

```dart
ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
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
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
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

‍![Green Button](/assets/images/blog/materialdesign/greenbutton.png){:width="100%"}

Unfortunately, there is no one-size-fits-all way to determine which property of the `ColorScheme` the widget uses because they use different color properties for their default color. The primary sources for learning these are a) the Flutter source code and b) the documentation. 

You won't always find the answer in the documentation, so look at the widget's source code. Flutter is open-source; you can view the source code for any widget to see exactly how it works. Simply ctrl+click (or cmd+click on macOS) on the widget name in your editor if you are using an IDE like VSCode or Android Studio, and it should take you to the definition in the source code.

Buttons have a `defaultStyleOf` method that returns a `ButtonStyle`. This example this is from the Flutter source code and returns the defaults from `_TextButtonDefaultsM3`. 

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

You should try to utilize the `ColorScheme` colors because if you get these right, your app will automatically adhere to the Material Design guidelines and have a coherent color scheme. However, you can also override the colors for the specific widget at the theme level. This can be a shortcut to finding the `ColorScheme` default color, but it means you only change the color for a given widget. Widgets that should have the same colors according to Material Design 3 may end up with different colors.

#### Override Default Colors

In Material Design 3, [`ElevatedButton`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html), [`OutlinedButton`](https://api.flutter.dev/flutter/material/OutlinedButton-class.html), and [`TextButton`](https://api.flutter.dev/flutter/material/TextButton-class.html) all use the `ColorScheme` to derive their default colors. However, you can override the default colors for these widgets by setting the `style` property of the specific button or by overriding the button's type's specific style. 

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

Remember that while you can set `buttonStyle` on the theme, it often has little or no effect. You might think this would make buttons appear in red, but it doesn't

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

‍![Not Red Button](/assets/images/blog/materialdesign/notredbutton.png){:width="100%"}

## Complete Example

This example allows you to toggle between the three theme modes to see how the dark and light themes look. You can modify the code to check out how the different colors apply to the widgets.

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

## Theme Shapes

Defining shapes at the theme level in Flutter ensures your design remains consistent, making your application more intuitive and appealing to users. Shapes in Material Design 3 can be simple or complex, adding depth and enhancing the visual hierarchy of the user interface. From subtle round edges to bold, expressive cut corners, shape variations can significantly impact a design's feel and functionality. 

To define shapes at the theme level, specify the `shape` parameter of the widget's theme like this.

```dart
ThemeData(
  useMaterial3: true,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0),
    ),
  ),
)
```

The theme sets the default shape for the widget, and you can reference the shape from `Theme`. 

```dart
Card(
  shape: Theme.of(context).cardTheme.shape,
  child: const SizedBox(
    width: 100,
    height: 100,
  ),
),
```

This is a complete example. The first card uses the default shape, and the second uses a custom shape.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=7ec38a9d1049e037c012bec865630dfc"></iframe>
</figure>

## Conclusion
Grasping Flutter's Material Design 3 themes is key for modern application design, so spend some time on the [Material Design website](https://m3.material.io/) to learn more about the system and how to use it in your apps. Refer back to this guide when you need an overview but remember to take the time to read the official documentation. Also, experiment with themes in Dartpad. This will save you a lot of time. Lastly, remember than you may need to check the actual Flutter code of the widgets to find out where they are getting their default theme values from.

<sub>This article has had some minor corrections, particularly around generating the ColorScheme. You can view the document history [here](https://github.com/MelbourneDeveloper/ChristianFindlay.com/blob/main/site/_posts/2000-1-1-flutter-mastering-material-design3.md)</sub>