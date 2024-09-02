---
layout: post
title: "Modularity vs. Maintainability"
date: "2024/08/30 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/mod-main/mod-main.webp"
post_image_height: 400
image: "/assets/images/blog/mod-main/mod-main.webp"
description: 
tags: testing software-quality clean-architecture SOLID
categories: [software development]
permalink: /blog/:title
---

Developers understand that modularity and maintainability are fundamental to code design. These concepts are related. However, it's important to understand that they are not synonyms, and an increase in one does not necessarily lead to an increase in the other. Actually, an increase in modularity can reduce maintainability, particularly through the introduction of unnecessary complexity and indirection. 

Understanding the difference is critical for architects and developers who aim to create systems that are both well-organized and sustainable over time. Both are necessary for long-term success, but you must balance them carefully to build a robust system that a team can reasonably maintain.

### Modularity

Modularity refers to the degree to which a system's components can be separated and recombined. This concept is grounded in the idea of encapsulation, where each module encapsulates a specific set of functionalities and exposes a well-defined interface to the rest of the system. 

The primary benefit of modularity is that it allows for change isolation: if particular functionality needs to be altered or replaced, you only need to modify the relevant module. Theoretically, this leaves the rest of the system unaffected.

> The primary benefit of modularity is that it allows for change isolation: if particular functionality needs to be altered or replaced, you only need to modify the relevant module.

We aim for modularity to increase flexibility, reusability, and scalability. The textbooks say that discrete, interchangeable modules allow developers to extend the system and adapt it to new requirements more easily. We should also be able to repurpose the components in different contexts. 

They tell us that modularity is essential in large and complex systems for managing dependencies and ensuring that development efforts can proceed in parallel. Still, we do need to ask if this is really true.

### Maintainability

Maintainability refers to the ease with which we can understand, correct, adapt, and enhance the system over time. A maintainable system is one where the cost and effort of making changes is minimal. This often involves clarity of design, simplicity of implementation, and the availability of comprehensive documentation. 

A key aspect of maintainability is understandability. If developers can easily understand a system's architecture, codebase, and logic, they can more readily diagnose issues, implement changes, and ensure the system's continued operation. 

Maintainability also involves minimizing the risk of introducing new bugs when making changes, which requires a well-organized codebase with high-quality automated testing.

### Code As a Liability...

--

### The Tension Between Modularity and Maintainability

While modularity and maintainability are both desirable, they do not always align. In practice, increasing modularity can sometimes lead to a decrease in maintainability, particularly when developers pursue modularity for its own sake rather than as a response to specific design challenges.

Moreover, the process of modularization can lead to overcomplexity. The system can become more complex than necessary to address the problem at hand. This can result in a codebase that is difficult to navigate and understand, reducing the overall maintainability of the system. In such cases, the effort to make the system more modular leads to a situation where maintaining the system is actually more difficult than it would have been. The original, less modular design may have been better for maintainability.

The overcomplexity often comes in the form of layering, abstraction, mapping, and other indirection. 

> The overcomplexity often comes in the form of layering, abstraction, mapping, and other indirection. 

#### Script Example

Let's consider an example of a simple Python script that performs a straightforward task in ten lines of code. This script might be highly maintainable in its original form because it is easy to read, understand, and modify. However, if the developer decides to refactor the script to make it more modular - perhaps by breaking it down into multiple functions or classes to allow for alternative actions or reuse - this can introduce complexity that makes the script harder to maintain. 

The once-simple script may now involve multiple files, interfaces, and dependencies. You must understand and manage each of them. As the cognitive load required to understand the system increases, the likelihood of bugs or integration issues rises.

### When Modularity Supports Maintainability

Modularity can support maintainability. In large systems, where different teams are responsible for different parts of the system, modularity can prevent changes in one part of the system from inadvertently affecting other parts. By enforcing clear boundaries between modules, modularity can make it easier to understand and manage one section of the system. 

For systems that require frequent updates or need to be highly adaptable, modularity can theoretically allow for rapid iteration without the need to overhaul the entire system. In those cases, the benefits of modularity can outweigh the potential downsides of increased complexity.

### Clean Architecture and The SOLID Principles

Robert C. Martin's Clean Architecture is an approach to building software with modular components by dividing the app or service into layers [^1]. SOLID is a set of principles that apply to the individual elements of the code themselves. Both approaches produce modular code, and if you follow these approaches in full, it becomes possible to lift almost any component out of the codebase and reuse it externally. Or replace an app component with an external component without affecting the functioning of the system.


Clean Architecture proposes a separation of concerns through layers, with dependencies pointing inward. 

> The overriding rule that makes this architecture work is The Dependency Rule. This rule says that source code dependencies can only point inwards. Nothing in an inner circle can know anything at all about something in an outer circle. In particular, the name of something declared in an outer circle must not be mentioned by the code in the an inner circle. That includes, functions, classes. variables, or any other named software entity.

https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html

The principle seems elegant, but in practice, it leads to mapping, abstractions, and, quite often, layers of calls that basically do the same thing. Let's take an example, which is very typical of what I see in C# .NET codebases.

```csharp
// Domain Layer
public record User(int Id, string Name, string Email);

// Use Case Layer
public static class GetUserUseCase
{
    public static User Execute(int userId, IUserRepository repository) =>
        repository.GetUser(userId);
}

// Interface Adapter Layer
public interface IUserRepository
{
    User GetUser(int userId);
}

public record UserDto(int Id, string Name, string Email);

public static class UserPresenter
{
    public static UserDto ToDto(User user) =>
        new(user.Id, user.Name, user.Email);
}

// Framework & Drivers Layer
public class UserController
{
    private readonly IUserRepository _repository;

    public UserController(IUserRepository repository)
    {
        _repository = repository;
    }

    public UserDto GetUser(int userId)
    {
        var user = GetUserUseCase.Execute(userId, _repository);
        return UserPresenter.ToDto(user);
    }
}

public class DatabaseUserRepository : IUserRepository
{
    public User GetUser(int userId)
    {
        // Simulating database access
        return new User(userId, $"User {userId}", $"user{userId}@example.com");
    }
}

// Client code
public static class Program
{
    public static void Main()
    {
        var repository = new DatabaseUserRepository();
        var controller = new UserController(repository);
        var userDto = controller.GetUser(1);
        Console.WriteLine($"User: {userDto.Name}, Email: {userDto.Email}");
    }
}
```

Notice that each layer has its own model and this means that the layers maintain the dependency principle. They don't know anything about the outer circle. The code does allow you to swap any implementation of `IUserRepository` into the app for mocking or otherwise, but notice how a change to the models would require changes in multiple places and how much repetition and indirection the code has. 

If we relax the Clean Architecture rules to some extent, we will get simpler, easier-to-understand code.

```csharp
using System;
using System.Threading.Tasks;

// Domain Model
public record User(int Id, string Name, string Email);

// Data Access Interface
public interface IUserRepository
{
    Task<User> GetUserAsync(int userId);
}

// Concrete Data Access Implementation
public class DatabaseUserRepository : IUserRepository
{
    public async Task<User> GetUserAsync(int userId)
    {
        // Simulating async database access
        await Task.Delay(100); // Simulate network delay
        return new User(userId, $"User {userId}", $"user{userId}@example.com");
    }
}

// Application Logic
public static class UserService
{
    public static async Task<User> GetUserAsync(int userId, IUserRepository repository) =>
        await repository.GetUserAsync(userId);

    public static string FormatUserInfo(User user) =>
        $"User: {user.Name}, Email: {user.Email}";
}

// Presentation
public static class UserPresentation
{
    public static async Task DisplayUserInfo(int userId, IUserRepository repository)
    {
        var user = await UserService.GetUserAsync(userId, repository);
        var formattedInfo = UserService.FormatUserInfo(user);
        Console.WriteLine(formattedInfo);
    }
}

// Client code
public static class Program
{
    public static async Task Main()
    {
        var repository = new DatabaseUserRepository();
        await UserPresentation.DisplayUserInfo(1, repository);
    }
}
```

If we abandon Clean Architecture entirely, we get something along these lines.

```csharp
using System;
using System.Threading.Tasks;

public record User(int Id, string Name, string Email);

public class UserService
{
    public virtual async Task<User> GetUserAsync(int userId)
    {
        await Task.Delay(100); // Simulate network delay
        return new User(userId, $"User {userId}", $"user{userId}@example.com");
    }

    public string FormatUserInfo(User user) =>
        $"User: {user.Name}, Email: {user.Email}";

    public async Task DisplayUserInfo(int userId)
    {
        var user = await GetUserAsync(userId);
        Console.WriteLine(FormatUserInfo(user));
    }
}

public static class Program
{
    public static async Task Main()
    {
        var service = new UserService();
        await service.DisplayUserInfo(1);
    }
}
```

Notice how this approach results in far less code, is much easier to read and reason about, and still maintains the ability for mocked data access with the `virtual` keyword.

```csharp
// Example of how to create a mock for testing
public class MockUserService : UserService
{
    public override Task<User> GetUserAsync(int userId)
    {
        var mockUser = new User(userId, "Mock User", "mock@example.com");
        return Task.FromResult(mockUser);
    }
}
```

The SOLID principles, also introduced by Martin, aim to make software designs more understandable, flexible, and maintainable[^2]. However, strict adherence to these principles can lead to unnecessary abstraction and complexity. For instance, the Interface Segregation Principle might result in an explosion of small interfaces. This increases the cognitive load for developers.

While both these approaches do indeed lead to modularity, they often introduce additional complexity and indirection, which makes the system harder to understand and maintain.

A study by Scanniello et al. found that while applying SOLID principles improved some aspects of software quality, it did not significantly improve maintainability[^3]. This suggests that blindly following these principles without considering the specific context of a project may not always lead to the desired outcomes.

### Automated Testing's Role in Maintainability

Automated testing is indeed crucial for maintainability. It provides a safety net for refactoring and helps catch regressions early. A study by Spadini et al. found that code with tests tends to be more maintainable[^4].

However, it's important to note that tests themselves require maintenance. Overly complex or brittle tests can become a burden. Martin Fowler warns against the "test-induced design damage," where the desire for testability leads to designs that are harder to understand and maintain[^5].

### Striking the Right Balance

Finding the right balance between modularity and maintainability requires careful consideration of the specific project context. As noted by Bass et al. in their book on software architecture, there's no one-size-fits-all solution in software design[^6].

For some systems, a more monolithic approach might be more maintainable. For example, the success of Ruby on Rails in building maintainable web applications with a relatively monolithic structure challenges the notion that high modularity is always necessary[^7].

### Does My System Need Modularity?

The need for modularity depends on various factors, including system size, expected lifespan, and rate of change. As pointed out by Parnas in his seminal paper on modular programming, modularity is most beneficial when we anticipate changes[^8].

However, premature modularization can be counterproductive. A case study by Sarkar et al. on large-scale software systems found that excessive modularity can lead to increased complexity and reduced maintainability[^9].

### Managed Change Doesn't Require Modularity

The idea that software systems need to be designed for easy part replacement, like cars, is a misconception. Unlike physical systems, software can be modified in place. Feathers, in his book on working with legacy code, emphasizes the importance of incremental change and refactoring over wholesale replacement[^10].

Version control systems and modern deployment practices allow for gradual, managed changes without requiring high levels of modularity. This approach often leads to more maintainable systems than those designed with excessive modularity from the start.

### Conclusion

While modularity and maintainability are important attributes of software systems, they are not synonymous, and increasing one doesn't necessarily improve the other. Developers must carefully assess the trade-offs involved in increasing modularity and strive for a balance that supports both the system's flexibility and maintainability.

The key is to avoid dogmatic adherence to principles and instead focus on creating systems that are sustainable and easy to manage over time. This often involves a pragmatic approach that considers the specific needs of the project and team, rather than blindly following architectural trends or patterns.
