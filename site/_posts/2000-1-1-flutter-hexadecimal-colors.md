---
layout: post
title: "Using Hexadecimal Color Strings in Flutter: A Comprehensive Guide"
date: "2023/04/03 00:00:00 +0000"
tags: colors dart
categories: flutter
author: "Christian Findlay"
post_image: "/assets/images/blog/colors/colors.jpg"
image: "/assets/images/blog/colors/colors.jpg"
permalink: /blog/:title
---

Color plays a critical role in the Flutter user experience. It can enhance or destroy the look and feel of your app. We can represent colors in various ways, such as [RGB, ARGB](https://en.wikipedia.org/wiki/RGBA_color_model), CMYK, HSV, and HSL. When designers give you colors, they may use any of these variants. RGB and ARGB and very common, and we often use hexadecimal strings to represent these in Flutter. This blog post will explain converting between the various formats and using hexadecimal color strings in Dart and Flutter.

## The `Color` Class
The [Color](https://api.flutter.dev/flutter/dart-ui/Color-class.html) class is a fundamental class in the Flutter API. It represents a 32-bit number. A 32-bit number is just another word for a Dart integer. The number represents four smaller values: the alpha, red, green, and blue channels. The alpha channel represents the opacity of the color, and the red, green, and blue channels represent the color itself. Computers make colors by combining red, green, and blue light. [ARGB or (RGBA)](https://en.wikipedia.org/wiki/RGBA_color_model) is a common computing system for representing colors. 

To construct a color, pass an integer into the constructor. This example represents black. There is no alpha, red, green, or blue.

```dart
final color = Color(0);
```

## Hexadecimal
A [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) color is a  representation of a color in hexadecimal format, which is a base-16 numbering system that uses 16 digits (0-9 and A-F). Each color has an alpha, red, green, and blue (ARGB) value. We use two digits in the range of 00-FF to represent each value. The format of an ARGB hexadecimal color is AARRGGBB. AA is the alpha channel. It represents the opacity of the color. RR is the red value, GG is the green, and BB is the blue. 

The Dart language allows us to write integer literals directly in hexadecimal format. We don't need to do any special string parsing or conversion. We prefix the number with `0x`. Here is white as an example. 

```dart
const Color white =  Color(0xFFFFFFFF);
```

The 0xFF prefix represents the alpha value, which is the transparency level of the color, where 0x00 is fully transparent, and 0xFF is fully opaque. Each of the ARGB values for white is 255.

Note that a hexadecimal value with six characters represents an RGB color. This does not include the alpha channel. When encountering an RGB color, you can convert it to an ARGB value by putting FF in front. For example, white as RGB is `FFFFFF`. We can convert it to ARGB with `FFFFFFFF`.

## Convert a Hexadecimal String to a `Color`
You can convert hexadecimal strings to a Flutter `Color`. This is usually not necessary but could be useful in niche scenarios. For example, you may want to allow your users to enter a color in the app configuration. You can store the string in the settings and then use the number to set the background in your app. You need to store eight characters that represent the hexadecimal number. You should also validate the number before storing it.

One straightforward way to convert a string to a color is to convert it to an integer first, then construct a `Color` with the integer. Here is a function to do that. It uses the [`parse`](https://api.flutter.dev/flutter/dart-core/int/parse.html) method of the `int` type.

```dart
int hexToInteger(String hex) => int.parse(hex, radix: 16);
```

We can use the function to read a string that represents the color red like this:

```dart
final red = Color(hexToInteger('FFFF0000'));
```
We can go even further and write an extension method that converts a string to a color.

```dart
extension StringColorExtensions on String {
  Color toColor() => Color(hexToInteger(this));
}
```
Here is a live Flutter example that uses these methods:

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=ec6b9a94f16ca5db8555543b1c94b21a&split=70&mode=dart"></iframe>

## Convert Between Other Formats
Designers don't always give you ARGB hexadecimal numbers. They may give them to you in other formats. There are a variety of online tools that will convert between formats. 

[Color Designer](https://colordesigner.io/convert/cmyktohex): Converts between Hex RGB and CMYK

[Convert a Color](https://convertacolor.com/): a great tool that converts between multiple formats

Google: has an inbuilt convert that is easy to use.
![Google](/assets/images/blog/color/googleconverter.png){:width="100%"}

## Conclusion

Hexadecimal colors in Flutter are simple and powerful. It is a portable way to express colors on all platforms. This post discussed how to convert between different color formats, including RGB, ARGB, CMYK, HSV, and HSL and provided examples of how to use hexadecimal color strings in Flutter, including how to convert a hexadecimal string to a Color object. For further reading, you could read about Flutter's [color theming system](https://docs.flutter.dev/cookbook/design/themes).

<sub><sup>Photo by Alexander Grey from [Pexels](https://www.pexels.com/photo/assorted-color-bricks-1148496/)</sup></sub>