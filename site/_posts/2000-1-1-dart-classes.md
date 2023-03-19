---
layout: post
title: "Dart Classes for C# Programmers"
date: "2021/09/06 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/dartformatting/dartformatting.png"
image: "/assets/images/blog/dartformatting/dartformatting.png"
tags: dart
categories: flutter
permalink: /blog/:title
---

Building classes in Dart is similar to C#, but there are some quirks that you need to be aware of. This article shows you how to write Dart classes and the major differences between Dart and C#

### The Basics

Here is a typical C# class with three properties and a method. This class uses [Nullable Reference Types](https://docs.microsoft.com/en-us/dotnet/csharp/nullable-references), and the properties here are not nullable. We have to initialize each property to a non-null value. Dart has a very similar feature called [Sound Null Safety](https://dart.dev/null-safety), and it's always on.

```csharp
#nullable enable

using Device.Net;
using System.Threading;
using System.Threading.Tasks;

namespace Hid.Net
{
	public class Person
	{    
		public string FirstName { get; set; } = "";    
		public string LastName { get; set; } = "";    
		public DateTime DateOfBirth { get; set; } = new(2000, 1, 1);    
		public double GetAgeInDays() => DateTime.Now.Subtract(DateOfBirth).TotalDays;
	}
}
```

Here is the equivalent in Dart.

```dart
class Person
{  
    String firstName = "";  
    String lastName = "";  
    DateTime dateOfBirth = DateTime(2000,1,1);  
    int getAgeInDays() => DateTime.now().difference(dateOfBirth).inDays;
 }
 ```

Note: [Dartpad](https://dartpad.dev) is a great online compiler and editor to test Dart code.

### Access Modifiers

The first thing you might notice is that there is no public access modifier. That's because classes and their members are public by default. C# is big on access modifiers. In fact, code analysers encourage you to specify access modifiers even when you want to use the default. Dart assumes that most of the elements of your code are public unless you add an \_ prefix to the variable name. This makes them private. For example, this class is private and has two private members. (Note that the code analyser does not like this).

```dart
class _Person2
{
    String _firstName = "";
    String _lastName = "";
}
```

### Properties

You will also notice that I did not use setters or getters in the Dart class. That's because the language encourages you not to use them unless there is a good reason. You can directly expose public variables. This can be a personal choice, but you don't need to create properties that access member fields as a starting point. Dart has elements of object-oriented and functional-style programming. Dart does is not as strict about old school [encapsulation](https://en.wikipedia.org/wiki/Encapsulation_(computer_programming)).

### Interfaces

Dart uses [implicit interfaces](https://dart.dev/guides/language/language-tour#implicit-interfaces), so there is no reason to define interfaces as we do in C# explicitly. This is probably the nicest feature of Dart. This is amazing for unit testing because we can substitute any class with an instance of a different type as long as that different type has the same public interface and uses the implements keyword. Imagine not having to go back and refactor your code to allow mocks when writing tests!

For example, this is the Dart equivalent ...

```dart
class NamedThing
{
  String firstName = "";
  String lastName = "";
}

class Person implements NamedThing
{
  String firstName = "";
  String lastName = "";
  DateTime dateOfBirth = DateTime(2000,1,1);
  int getAgeInDays() => DateTime.now().difference(dateOfBirth).inDays;
}
```

of

```csharp
#nullable enable

public interface INamedThing
{
    string FirstName { get; set; }
    string LastName { get; set; }
}

public class Person : INamedThing
{
    public string FirstName { get; set; } = "";
    public string LastName { get; set; } = "";
    public DateTime DateOfBirth { get; set; } = new(2000, 1, 1);
    public double GetAgeInDays() => DateTime.Now.Subtract(DateOfBirth).TotalDays;
}
```

### Constructors

Dart function [parameters](https://dart.dev/guides/language/language-tour#parameters) are a little different to C#. There are two kinds of parameters: named and positional. We must declare the parameters as named or positional at the function level. Positional parameters are required, and named parameters are either required or not required. This is quite strange for C# programmers because C# allows us to use function parameters as named or positional. Dart [constructors](https://dart.dev/guides/language/language-tour#using-constructors) are special types of functions for constructing classes.

Here we make two constructor parameters required in C#

```csharp
public class Person : INamedThing
{
    public Person(string firstName, string lastName)
    {
        FirstName = firstName;
        LastName = lastName;
    }

    public string FirstName { get; set; }
    public string LastName { get; set; }
    public DateTime DateOfBirth { get; set; } = new(2000, 1, 1);
    public double GetAgeInDays() => DateTime.Now.Subtract(DateOfBirth).TotalDays;
}
```    

Here is the equivalent in Dart, which is much more concise.

```dart
class Person implements NamedThing
{
  Person(this.firstName, this.lastName);

  String firstName;
  String lastName;
  DateTime dateOfBirth = DateTime(2000,1,1);
  int getAgeInDays() => DateTime.now().difference(dateOfBirth).inDays;
}
```

Here is the same thing but with named parameters instead of positional parameters. This means that the calling code needs to name the parameters instead of passing them by ordinal. Generally speaking, this makes code more readable.

```dart
class Person implements NamedThing
{
  Person({required this.firstName, required this.lastName});

  String firstName;
  String lastName;
  DateTime dateOfBirth = DateTime(2000,1,1);
  int getAgeInDays() => DateTime.now().difference(dateOfBirth).inDays;
}
```

### Usage

Here is a C# console app that uses the class.

```csharp
using System;

#nullable enable

public class Program
{
    public static void Main()
    {
        var person = new Person("jim", "bob") { DateOfBirth = new DateTime(2000, 1, 1) };
        Console.WriteLine(person.GetAgeInDays());
    }
}
```

This is the Dart equivalent with less ceremony.

<iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-inline.html?id=8d3e158112b2a52c61005cff13cd1e0f&split=70&mode=dart"></iframe>

### Wrap-up

You can express most of the same constructs in Dart that you are used to from C#. However, Dart tends to push you in different directions. My recommendation is to follow the Dart guidelines and get used to the new paradigm without trying to bring the baggage of C# into the Dart world. I will write more about this on this blog. Meantime, this documentation on [Effective Dart](https://dart.dev/guides/language/effective-dart) is a great place to start.