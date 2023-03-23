---
layout: post
title: "Stateful Factory Pattern"
date: "2023/03/23 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/statefulfactory/header.jpg"
post_image_size: width:400px;
image: "assets/images/blog/statefulfactory/header.jpg"
description: "Discover the parody blog post about the Stateful Factory pattern, a made-up design pattern that highlights the importance of critical thinking in software development. Learn how this fictional pattern 'solves' object creation problems, and read the humorous account of a code review where it's 'successfully' implemented. This entertaining piece serves as a reminder to avoid blindly following trends and to evaluate the specific needs of your application before applying any design pattern."
tags: 
categories: [software development]
permalink: /blog/:title
---

This is a parody blog post about how you can manipulate language to make a made-up pattern sound like a perfectly reasonable solution to a problem, and make people feel bad for not using it. It is not intended to be taken seriously. ChatGPT wrote most of this. 

## Intro

The Stateful Factory design pattern is a combination of the [Factory Method](https://en.wikipedia.org/wiki/Factory_method_pattern) and [State pattern](https://en.wikipedia.org/wiki/State_pattern)s. It provides a way to create objects based on the current state of a factory object while allowing the factory to change its state to create different types of objects as needed. This can be useful in scenarios where the factory needs to create objects based on runtime conditions or application settings.

Dart Example:

```dart
abstract class Animal {
  void speak();
}

class Dog implements Animal {
  void speak() => print('Woof!');
}

class Cat implements Animal {
  void speak() => print('Meow!');
}

enum AnimalType { dog, cat }

class AnimalFactory {
  AnimalType _currentType = AnimalType.dog;

  void setType(AnimalType type) {
    _currentType = type;
  }

  Animal createAnimal() {
    switch (_currentType) {
      case AnimalType.dog:
        return Dog();
      case AnimalType.cat:
        return Cat();
      default:
        throw Exception('Invalid animal type');
    }
  }
}

void main() {
  var factory = AnimalFactory();

  factory.setType(AnimalType.dog);
  Animal animal1 = factory.createAnimal();
  animal1.speak(); // Woof!

  factory.setType(AnimalType.cat);
  Animal animal2 = factory.createAnimal();
  animal2.speak(); // Meow!
}
```

C# Example:

```csharp
using System;

public interface IAnimal
{
    void Speak();
}

public class Dog : IAnimal
{
    public void Speak() => Console.WriteLine("Woof!");
}

public class Cat : IAnimal
{
    public void Speak() => Console.WriteLine("Meow!");
}

public enum AnimalType { Dog, Cat }

public class AnimalFactory
{
    private AnimalType _currentType = AnimalType.Dog;

    public void SetType(AnimalType type)
    {
        _currentType = type;
    }

    public IAnimal CreateAnimal()
    {
        switch (_currentType)
        {
            case AnimalType.Dog:
                return new Dog();
            case AnimalType.Cat:
                return new Cat();
            default:
                throw new InvalidOperationException("Invalid animal type");
        }
    }
}

class Program
{
    static void Main(string[] args)
    {
        var factory = new AnimalFactory();

        factory.SetType(AnimalType.Dog);
        IAnimal animal1 = factory.CreateAnimal();
        animal1.Speak(); // Woof!

        factory.SetType(AnimalType.Cat);
        IAnimal animal2 = factory.CreateAnimal();
        animal2.Speak(); // Meow!
    }
}
```

## Why Use It?

The Stateful Factory pattern can be useful when the types of objects created by the factory depend on runtime conditions, such as user input or application configuration. By allowing the factory to change its state, the pattern provides a flexible way to create different types of objects without requiring modification to the factory or client code. This pattern can help improve the maintainability and adaptability of your application.

Not using it when the types of objects created by the factory depend on runtime conditions should be considered an anti-pattern. Here are some scenarios where not using the Stateful Factory would be considered an anti-pattern and detrimental to your codebase:

- Complex object creation logic: If object creation involves complex logic based on the application state or other runtime conditions, not using the Stateful Factory pattern can lead to code duplication and increased complexity. It can make it difficult to maintain the code and introduce subtle bugs.

*Pitfalls*: Increased complexity, reduced maintainability, and higher chances of introducing bugs.

- Violation of the Single Responsibility Principle: If a class is responsible for creating multiple types of objects based on runtime conditions, not using the Stateful Factory pattern can lead to a violation of the Single Responsibility Principle. The class may become too large and difficult to manage, making it challenging to modify or extend the code.

*Pitfalls:* Code that is difficult to manage, modify, or extend, and reduced maintainability.

- Difficulty in unit testing: Not using the Stateful Factory pattern can make it challenging to write unit tests for object creation. It can lead to tightly coupled code, making it difficult to replace dependencies with test doubles or stubs.

*Pitfalls*: Tightly coupled code, reduced testability, and the inability to ensure correct object creation behavior through unit testing.

- Inability to adapt to changing requirements: If the object creation requirements change frequently or unpredictably, not using the Stateful Factory pattern can make it difficult to adapt the code to new requirements. This can lead to extensive code modifications, making the application harder to maintain.

*Pitfalls*: Difficulty in adapting to changing requirements, increased maintenance effort, and the risk of breaking existing functionality.

## Code Review

We talked to Jim Chalmers, an expert on the Stateful Factory pattern about a recent code review he performed for a client. Here's what he had to say:

<blockquote> When I first saw the code, I was shocked. This is what I said to myself ...

<p>I cannot believe the code I am seeing here! How could anyone not use the Stateful Factory pattern in this situation? It is clear to me that the Stateful Factory pattern is the superior solution for any object creation problem that involves runtime conditions or application state.</p>

<p>Look at this mess of conditional statements and duplicated code, it's like a labyrinth! If only they had used the Stateful Factory pattern, they could have easily encapsulated all of this complexity and made their code much more maintainable and extensible. Furthermore, the Single Responsibility Principle has been thrown out of the window here. Classes are doing too much and are too tightly coupled, making it a nightmare to modify or extend.</p>

<p>And don't even get me started on testability! Writing unit tests for this code is a herculean task. With the Stateful Factory pattern, we could have easily replaced dependencies with test doubles or stubs, ensuring the correctness of our object creation logic.</p>

<p>Lastly, I can't help but think of the future maintenance and adaptation of this code. It's like they're asking for countless hours of refactoring and debugging when the requirements inevitably change. The Stateful Factory pattern would have made it so much easier to adapt to new requirements without extensive modifications.</p>

<p>I can't fathom how anyone could overlook the obvious benefits of the Stateful Factory pattern in a scenario like this. It is, without a doubt, the one and only solution to these types of problems. I must spread the gospel of the Stateful Factory pattern far and wide, so that no code shall ever suffer again!</p>

<p>Oh, what a glorious day it was when I finally had the opportunity to fix this abomination of code with the one and only Stateful Factory pattern! I rolled up my sleeves, dove in, and began by encapsulating all of the complex object creation logic into a beautiful, elegant Stateful Factory class. No more labyrinth of conditional statements and duplicated code; everything was neatly organized, with each factory state responsible for creating the appropriate object based on runtime conditions or application state.</p>

<p>I also made sure to adhere to the Single Responsibility Principle, ensuring that each class had a single, clear purpose, making the code much more maintainable and extensible. The tight coupling that once plagued this project was vanquished, and now each component could be modified or extended with ease.</p>

<p>And, oh, the joy of testability! Writing unit tests for the new code was like a walk in the park. With the Stateful Factory pattern in place, I could easily replace dependencies with test doubles or stubs, allowing me to verify the correctness of our object creation logic with confidence. </p>

<p>Now, whenever the winds of change blow and bring new requirements, we can adapt our code with minimal effort, thanks to the almighty Stateful Factory pattern. Every time I gaze upon the masterpiece I have created, I cannot help but swell with pride, knowing that I have saved this code from the depths of despair and elevated it to new heights of elegance and maintainability. All hail the Stateful Factory pattern! </p>
</blockquote>

## Conclusion

In summary, not using the Stateful Factory pattern in situations where it would be beneficial can lead to increased complexity, reduced maintainability, increased chances of introducing bugs, and difficulty in adapting to changing requirements. However, it is essential to carefully evaluate the specific needs of your application before deciding whether to apply the Stateful Factory pattern. Applying design patterns indiscriminately can also lead to over-engineering and unnecessary complexity. Especially when AI just makes all this stuff up off the top of its head.