---
layout: post
title: "Rounded Buttons in Flutter with Material Design 3"
date: "2023/04/03 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/buttons/header.png"
post_image_width: 300
image: "/assets/images/blog/buttons/header.png"
description: Learn how to create Material Design 3 rounded buttons in Flutter with this simple guide.
tags: 
categories: flutter
permalink: /blog/:title
keywords: [Flutter buttons, Material Design 3, rounded buttons Flutter, ElevatedButton customization, Flutter UI design, Material 3 theming, Flutter button styling, useMaterial3 flag, Flutter BorderRadius, Flutter button colors, Flutter padding, Material Design buttons, Flutter app development, Material 3 Flutter implementation, custom button design Flutter]
description: "Learn to create and customize rounded buttons in Flutter using Material Design 3. This guide covers enabling Material 3, basic and advanced button styling, and live examples for immediate practice."
---

Rounded buttons in Material Design 3 is even simpler than before. Google's latest design language offers the ability to enable rounded buttons by default with a single flag in the theme configuration. This blog post will walk you through the process of creating rounded buttons in Flutter using Material Design 3. It will demonstrate how to enable the [`useMaterial3`](https://api.flutter.dev/flutter/material/ThemeData/useMaterial3.html) flag in [`ThemeData`](https://api.flutter.dev/flutter/material/ThemeData-class.html) and showcase four different button configurations.

## Enabling Material Design 3 Rounded Buttons

Set the `useMaterial3` flag in the `ThemeData`. The following code demonstrates this:

```dart
MaterialApp(
  theme: ThemeData(useMaterial3: true),
  //...
),
```

If the `useMaterial3` flag is true, Material Design 3's default button style has rounded corners. Let's explore a few examples using this flag.

## Basic `ElevatedButton`

This is a simple [`ElevatedButton`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html) using Material Design 3's default style. The button will have rounded edges by default. No additional style configuration is required.

```dart
ElevatedButton(
  onPressed: () {},
  child: const Text("Press me!"),
),
```

## Customizing BorderRadius

For cases where you want to further customize the button's BorderRadius, you can do so with the shape parameter. `12` makes the border less round in this example.

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),
  child: const Text('Press me!'),
),
```
## Custom Colors and BorderRadius

To apply custom colors to the button while maintaining the rounded appearance, use the `foregroundColor` and `backgroundColor` parameters. In this example, we set the button's foreground color to white and the background color to purple, while keeping the BorderRadius full rounded corners.

```dart
ElevatedButton(
onPressed: () {},
style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.purple,
),
child: const Text('Press me!'),
),
```

## Custom Colors and Padding

To customize the button's padding along with its colors and BorderRadius, wrap the Text widget in a Padding widget. We added `EdgeInsets.symmetric` to the [`Padding`](https://api.flutter.dev/flutter/widgets/Padding-class.html) widget which provides consistent horizontal and vertical padding to the button text.

```dart
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.green,
  ),
  child: const Padding(
    padding:
        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    child: Text('Press me!'),
  ),
),
```

Check out the live sample of all these button customizations here. You can experiment with them to see how changes affect the button's appearance.

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=6ba74bd132932f48e61db8022a0f60f4&split=70&mode=dart"></iframe>

## Conclusion

You can easily achieve rounded buttons with Material Design 3 in Flutter. It's a more streamlined approach with less code. The four examples showcased in this blog post demonstrate various customization options while maintaining the rounded appearance of the buttons.