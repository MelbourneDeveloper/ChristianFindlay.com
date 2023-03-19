---
layout: post
title: "C# Delegates with IoC Containers and Dependency Injection"
date: "2020/05/16 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/csharp/logo.svg"
image: "/assets/images/blog/csharp/logo.svg"
tags: csharp
categories: dotnet
post_image_size: width:50%
permalink: /blog/:title
---

Developers are usually encouraged to do dependency injection with interfaces. Some developers don't know that they can do dependency injection with delegates, and there are good reasons to do this. Moreover, developers can use delegates with modern IoC containers like ASP.NET Core's IoC container, mock delegates, and verify calls. It is good practice and should be encouraged. Let's have a look at why. All source code for this article can be found in [this repo](https://github.com/MelbourneDeveloper/Samples/tree/master/MockDelegates/MockDelegates).

Why use Delegates instead of Interfaces?
========================================

Firstly, let's focus on the [interface segregation principle](https://en.wikipedia.org/wiki/Interface_segregation_principle). It's one of the SOLID principles. It essentially means that you should minimize the number of members on an interface. It sometimes leads to an interesting situation where interfaces end up with only one method. The classic case is factory interfaces. Here is [an example](https://github.com/aspnet/HttpClientFactory/blob/7c4f9479b4753a37c8b0669a883002e5e448cc94/src/Microsoft.Extensions.Http/IHttpClientFactory.cs#L40). 

```csharp
HttpClient CreateClient(stringname);
```

You could argue that this is a code smell because the interface doesn't group methods that would commonly go together. So why create an interface? The answer is usually "because that's how IoC containers work" or "so you can mock the interface for unit testing". Both these answers are wrong because delegates offer an alternative way of performing dependency injection without having to create an interface. You can mock delegates, use them in IoC containers, and verify that they get called. It's actually more straightforward when you use a delegate instead of an interface with one method.

Lastly, you could argue that a delegate has a fixed number of inputs and outputs, while a class can have an unlimited number of dependencies injected into the constructor. This is true, but the latter part of this article demonstrates how to register a service by a delegate that takes an unlimited number of dependencies.

The Basics
==========

Take a look at this interface. In the real world, we need to name the interface, the method, mock the method, and implement the class.

```csharp
public interface IAdder
{
    int Add(int a, int b);
}

public class Adder : IAdder
{
    public int Add(int a, int b) => a + b;
}

adderMock.Setup(a => a.Add(It.IsAny<int>(), It.IsAny<int>())).Returns(2);
```

But, there is a more straightforward way with a delegate. 

```csharp
public delegate int Add(int a, int b);
adderMock.Setup(a => a(It.IsAny<int>(), It.IsAny<int>())).Returns(2);
```

And sometimes, we may not even need to write a class at all if the implementation of the delegate is simple enough.

```csharp
(a, b) => a + b
```

At this point, you're probably thinking, "What about IoC containers?". Don't they need dependencies as interfaces? The answer is no. Delegates work just as well.

Dependency Injection with Delegates
===================================

Delegates are reference types in the same way that interfaces are reference types. You can pass any reference type object into a class as a dependency via the constructor. Passing a delegate implementation into a class via the constructor is the same as interface implementations. Notice in [this code](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/SimpleDelegateCalculator.cs#L3) that when we call the delegate, we only need to supply the variable name. We do not need an unnecessary method name. It's convenient syntax sugar.

```csharp
public class SimpleDelegateCalculator
{
    private readonly Add _add;
    public SimpleDelegateCalculator(Add add)
    {
        _add = add;
    }
    public int Add(int a, int b)
    {
        return _add(a, b);
    }
}
```

Here is a [similar example](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/SimpleFactoryInterfaceCalculator.cs#L3), but this time around, we pass a factory into the constructor instead of the instance. This is a solution to the class problem of factory interfaces that only have one method. In the constructor, we grab an instance of `IAdder` by name.

```csharp
public class SimpleFactoryInterfaceCalculator
{
    private readonly IAdder _adder;
    public SimpleFactoryInterfaceCalculator(CreateInstance<IAdder> createAdder)
    {
        _adder = createAdder("simple");
    }
    public int Add(int a, int b)
    {
        return _adder.Add(a, b);
    }
}
```

Mocking Delegates with Moq
==========================

This is a version of the Add delegate with generic type arguments..

```csharp
public delegate T Add(T a, T b);
```

Here is [an example](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/Tests.cs#L97) of mocking the Add method with a string type argument.

```csharp
var adderMock = new Mock<Add<string>>();
adderMock.Setup(a => a(It.IsAny<string>(), It.IsAny<string>())).Returns("  ");
```

It says that whenever the code calls the delegate, return a string with two spaces. Notice that if we used an interface, the setup for the mock would require a method name.

We can also fill in the mock code if necessary.

```csharp
adderMock.Setup(a => a(It.IsAny<string>(), It.IsAny<string>())).Returns(new Add<string>((a, b) => a + b));
```

Delegates with IoC Containers
=============================

At their heart, IoC containers are collections keyed by type. We normally key the collection by interface types, but delegates are also types, and we can key the collection with delegates instead of interfaces. 

Here's [an example](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/Tests.cs#L120) with Add delegate from earlier with Microsoft ASP.NET Core DI.

```csharp
serviceCollection.AddSingleton<Add>((a, b) => a + b);
```

It's that simple. When a class requires the Add dependency, it gets a+b. For example, if the SimpleDelegateCalculator is constructed by the IoC container, it gets the delegate implementation above. See a StructureMap example [here](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/Tests.cs#L182).

What if the delegate code needs extra dependencies?
---------------------------------------------------

Sometimes the fixed number of parameters on the delegate is not enough. The delegate may require extra dependencies. This can also be handled with IoC containers in the same way you would handle adding dependencies to normal classes. In this case, you need a class that takes the dependencies in the constructor, and then use one of the public methods as the implementation of the delegate. This means that the delegate implementation has as many dependencies at its disposal as necessary, but there is no need to define an interface. Here is an [example](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/StringConcatenatorWithDependencies.cs#L5).

```csharp
public class StringConcatenatorWithDependencies 
{
    private readonly IFileIo _fileIo;
    public StringConcatenatorWithDependencies(IFileIo fileIo)
    {
        _fileIo = fileIo;
    }
    public string ConcatenateString(string a, string b)
    {
        var returnValue = a + b;
        var data = Encoding.UTF8.GetBytes(returnValue);
        _fileIo.WriteData(data);
        return returnValue;
    }
}
```

Notice that the above does not implement an interface. Here is how we wire this up:

```csharp
var serviceCollection = new ServiceCollection();
var mockFileIo = new Mock<IFileIo>();
//Wire up mock dependency
serviceCollection.AddSingleton(mockFileIo.Object);
//Register the class
serviceCollection.AddSingleton<StringConcatenatorWithDependencies>();
//Wire up the delegate implementation 
serviceCollection.AddSingleton<Add<string>>(s => s.GetRequiredService<StringConcatenatorWithDependencies>().ConcatenateString);
When we request the dependency by the delegate type we can directly call it:
var add = serviceProvider.GetService<Add<string>>();
var stringResult = add(" ", " ");
```

The net result is that the IoC container creates a singleton of StringConcatenatorWithDependencies with a mocked `IFileIo` instance. When we call add, it calls ConcatenateString on the said instance. This gives us all the power of dependency injection without needing to create an extra interface. 

Drawbacks Of Delegates
======================

Code that requires generic type arguments can pose problems with IoC registration. If a delegate takes a generic type argument, there is no way to register that delegate in the IoC container without specifying the generic type argument at registration time. Moreover, every class that depends on the delegate must specify the generic type. An interface may be a better choice when the interface does not take a generic type argument, but the method signature does. A classic use case for this is mapping. Here is an [example](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/AutoMapperTests.cs#L14) of mapping using AutoMapper:

```csharp
//Create an implementation of auto mapper IMapper
var config = new MapperConfiguration(
    cfg =>
    {
        cfg.CreateMap<Order, OrderDto>();
        cfg.CreateMap<Person, PersonDto>();
    }
    );
var mapper = config.CreateMapper();
//Register serviceas
var serviceCollection = new ServiceCollection();
serviceCollection.AddSingleton(mapper);
serviceCollection.AddSingleton<AutoMapperWrapper>();            
var serviceProvider = serviceCollection.BuildServiceProvider();
//Use the IoC container to construct our class and inject dependencies for us
var mapperWrapper = serviceProvider.GetService<AutoMapperWrapper>();
//Perfom mapping
var order = new Order();
var person = new Person();
var orderDto = mapperWrapper.Map<OrderDto>(order);
var personDto = mapperWrapper.Map<PersonDto>(person);
```

In the code above, we only have to register one instance of IMapper and one AutoMapperWrapper class. If we attempt the same with a delegate with generic type arguments, we would need to do more registrations, and create more AutoMapperWrapper like classes. In reality, this may be fine because it's likely that we want to create a new class for each generic type argument, but there are cases when this is not optimal. Here is [the equivalent code](https://github.com/MelbourneDeveloper/Samples/blob/fa20d8f46ab04d8d052b22ec48ec702b541bd23c/MockDelegates/MockDelegates/AutoMapperTests.cs#L46) with delegates instead of interfaces. Notice that we end up with more boilerplate code.

```csharp
//Create an implementation of auto mapper IMapper
var config = new MapperConfiguration(
    cfg =>
    {
        cfg.CreateMap<Order, OrderDto>();
        cfg.CreateMap<Person, PersonDto>();
    }
    );
var mapper = config.CreateMapper();
//Register serviceas
var serviceCollection = new ServiceCollection();
serviceCollection.AddSingleton(mapper);
serviceCollection.AddSingleton<Map<Person>>(sp => sp.GetRequiredService<AutoMapperWrapper>().Map<Person>);
serviceCollection.AddSingleton<Map<Order>>(sp => sp.GetRequiredService<AutoMapperWrapper>().Map<Order>);
serviceCollection.AddSingleton<AutoMapperWrapper>();
//Get the injected service
var serviceProvider = serviceCollection.BuildServiceProvider();
var mapPerson = serviceProvider.GetService<Map<Person>>();
var mapOrder = serviceProvider.GetService<Map<Order>>();
//Perfom mapping
var order = new Order();
var person = new Person();
var orderDto = mapOrder(order);
var personDto = mapPerson(person);
```

Here it is time the consider whether generic type arguments are correct in the first place. No matter which choice you go with, casting occurs at some point - probably in the bowels of AutoMapper. Generic types are convenient for the usage but may not be a sound structural choice.

Conclusion
==========

Take a look at the source code I've provided in the [repo](https://github.com/MelbourneDeveloper/Samples/tree/master/MockDelegates/MockDelegates). It has some useful samples, and you'll be able to see where delegates can be used instead of interfaces with one method. This approach can reduce boilerplate code. But, be careful of scenarios with generic types. You shouldn't alter the fundamental design of your code to fit delegates. Rather delegates should be a compliment to your existing code design. This article is part of the larger topic of functional programming with C#. Despite not being designed as a functional language from the ground up, it provides much of the tooling necessary for functional programming.