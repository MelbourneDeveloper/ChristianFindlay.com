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

### Code As a Liability

Code itself is a liability. Every line of code written requires maintenance, introduces potential for bugs, and adds complexity to the system. This perspective challenges the notion that more code or more modular code is inherently better.

Developers should strive for simplicity and clarity, aiming to solve problems with as little code as possible. This approach often leads to more maintainable systems, as there's simply less to understand and manage.

### The Tension Between Modularity and Maintainability

While modularity and maintainability are both desirable, they do not always align. In practice, increasing modularity can sometimes lead to a decrease in maintainability, particularly when developers pursue modularity for its own sake rather than as a response to specific design challenges.

Moreover, the process of modularization can lead to overcomplexity. The overcomplexity often comes in the form of layering, abstraction, mapping, and other indirection.  The system can become more complex than necessary to address the problem at hand. This can result in a codebase that is difficult to navigate and understand, reducing the overall maintainability of the system. In such cases, the effort to make the system more modular leads to a situation where maintaining the system is actually more difficult than it would have been. The original, less modular design may have been better for maintainability.

> The overcomplexity often comes in the form of layering, abstraction, mapping, and other indirection.  

#### Script Example

Let's consider an example of a simple Python script that performs a straightforward task in ten lines of code. This script might be highly maintainable in its original form because it is easy to read, understand, and modify. However, if the developer decides to refactor the script to make it more modular - perhaps by breaking it down into multiple functions or classes to allow for alternative actions or reuse - this can introduce complexity that makes the script harder to maintain. 

The once-simple script may now involve multiple files, interfaces, and dependencies. You must understand and manage each of them. As the cognitive load required to understand the system increases, the likelihood of bugs or integration issues rises.

### When Modularity Supports Maintainability

Modularity can support maintainability. In large systems, where different teams are responsible for different parts of the system, modularity can prevent changes in one part of the system from inadvertently affecting other parts. By enforcing clear boundaries between modules, modularity can make it easier to understand and manage one section of the system. 

For systems that require frequent updates or need to be highly adaptable, modularity can theoretically allow for rapid iteration without the need to overhaul the entire system. In those cases, the benefits of modularity can outweigh the potential downsides of increased complexity.

#### Vscode Extensions

The differene between a simple code editor and a full-fledged IDE is extensibility. Vscode is an example of a code editor that has a rich ecosystem of extensions. Allowing for extensibility requires modularity. The designers understood that each part of system needs to be modifiable and extensible. This is modularity is truly useful.

[EXPAND]

### Clean Architecture and The SOLID Principles

Robert C. Martin's Clean Architecture is an approach to building software with modular components by dividing the app or service into layers [^1]. SOLID is a set of principles that apply to the individual elements of the code themselves. Both approaches produce modular code and aim to make components reusable and replaceable without affecting the overall functioning of the system.

Clean Architecture proposes a separation of concerns through layers, with dependencies pointing inward. Martin states:

> The overriding rule that makes this architecture work is The Dependency Rule. This rule says that source code dependencies can only point inwards. Nothing in an inner circle can know anything at all about something in an outer circle. In particular, the name of something declared in an outer circle must not be mentioned by the code in the an inner circle. That includes, functions, classes. variables, or any other named software entity.

[Clean Coder](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

While elegant in theory, in practice, this approach often leads to excessive mapping, abstractions, and layers of similar calls. Consider this typical example in C# .NET:

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


[INSERT SOLID EXAMPLES HERE] <- demonstrate how SOLID leads to more code and indirection

While both these approaches do indeed lead to modularity, they often introduce additional complexity and indirection, which makes the system harder to understand and maintain.

A study by Scanniello et al. found that while applying SOLID principles improved some aspects of software quality, it did not significantly improve maintainability[^3].[INSERT QUOTE ] This suggests that blindly following these principles without considering the specific context of a project may not always lead to the desired outcomes.

### Automated Testing's Role in Maintainability

Automated testing is the single most important factor for maintainability [citation]. It provides a safety net for refactoring and helps catch regressions early. A study by Spadini et al. found that code with tests tends to be more maintainable[^4]. 

Coarse tests that focus on the user interface and app side effects test the app's behavior without tangling the tests with implementation details. They give you confidence that the app's behavior stays consistent without affecting your ability to refactor.

However, it's important to note that test code also requires maintenance. Overly complex or brittle tests can become a burden. Martin Fowler warns against "test-induced design damage," where the desire for testability leads to designs that are harder to understand and maintain[^5].

If you introduce too much [test isolation](https://www.christianfindlay.com/blog/test-isolation-expensive), i.e., low-level unit tests, your test suite will blow out in size and make your app less refactorable. 

Ultimately, how easy your app is to refactor is one of the most important measures of maintainability.

### Striking the Right Balance

Finding the right balance between modularity and maintainability requires careful consideration of the specific project context. As Bass et al. note in their book on software architecture, there's no one-size-fits-all solution in software design[6].

For some systems, a more monolithic approach might be more maintainable. For example, Ruby on Rails's success in building maintainable web applications with a relatively monolithic structure challenges the notion that high modularity is always necessary[7].

### Does My System Need Modularity?

The need for modularity depends on various factors, including system size, expected lifespan, and rate of change. As Parnas pointed out in his seminal paper on modular programming, modularity is most beneficial when we anticipate changes [8]. [EXPAND WITH QUOTE]

However, premature modularization can be counterproductive. A case study by Sarkar et al. on large-scale software systems found that excessive modularity can lead to increased complexity and reduced maintainability [^9].

### Managed Change Doesn't Require Modularity

We don't need to design software systems like cars. The need to replace components in the way we replace car parts, is a misconception. Unlike physical systems, we can modify software in place. In the book  Working with Legacy Code, Feathers emphasizes the importance of incremental change and refactoring over wholesale replacement[^10]. [INSERT QUOTE]

Version control systems and modern deployment practices allow for gradual, managed changes without requiring high levels of modularity. This approach often leads to more maintainable systems than those designed with excessive modularity from the start.

### The Cost of Abstraction

While abstraction is a powerful tool for managing complexity, it comes with a cost. Each layer of abstraction introduces cognitive overhead and the potential for misunderstanding. As noted by Joel Spolsky in his "Law of Leaky Abstractions," all non-trivial abstractions are leaky to some degree[^11]. [INSERT QUOTE]

This means that developers often need to understand not just the abstraction but also what's happening underneath it. In many cases, a more direct approach with fewer abstractions can lead to code that's easier to understand and maintain.

### Conclusion

Modularity and maintainability are both important aspects of software design, but they are not always aligned. While modularity can contribute to maintainability in large, complex systems, excessive modularity can actually hinder maintainability by introducing unnecessary complexity and indirection.

The key to creating maintainable software lies in striking the right balance for each specific project. You should:

1. Prioritize simplicity and clarity over unnecessary abstraction
2. Focus on the core logic rather than technical patterns
3. Use automated testing judiciously to support maintainability
4. Recognize that code itself is a liability and strive to solve problems with less code
5. Embrace incremental change and refactor instead of designing for wholesale replacement

Ultimately, the goal should be to create systems that are easy to understand, modify, and extend over time. This often means resisting the urge to over-engineer or prematurely optimize for modularity and instead focusing on writing clear, concise code that directly addresses the problem at hand.

[^1]: Martin, [missing]
https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164

[^2]: Martin, R. C. (2000). Design Principles and Design Patterns. Object Mentor. http://www.cvc.uab.es/shared/teach/a21291/temes/object_oriented_design/materials_adicionals/principles_and_patterns.pdf

[^3]: Scanniello, G., et al. (2019). "On the impact of SOLID principles on software changeability: a preliminary investigation." Empirical Software Engineering, 24(5), 3139-3176. https://link.springer.com/article/10.1007/s10664-018-9670-1

[^4]: Spadini, D., et al. (2018). "On the Relation of Test Smells to Software Code Quality." 2018 IEEE International Conference on Software Maintenance and Evolution (ICSME). https://ieeexplore.ieee.org/document/8530039

[^5]: Fowler, M. (2011). "Test Induced Design Damage." Martin Fowler's Blog. https://martinfowler.com/articles/is-tdd-dead/test-induced-design-damage.html

[^6]: Bass, L., Clements, P., & Kazman, R. (2012). Software Architecture in Practice (3rd ed.). Addison-Wesley Professional. https://www.amazon.com/Software-Architecture-Practice-3rd-Engineering/dp/0321815734

[^7]: Hansson, D. H. (2014). "The Majestic Monolith." Signal v. Noise. https://m.signalvnoise.com/the-majestic-monolith/

[^8]: Parnas, D. L. (1972). "On the criteria to be used in decomposing systems into modules." Communications of the ACM, 15(12), 1053-1058. https://dl.acm.org/doi/10.1145/361598.361623

[^9]: Sarkar, S., et al. (2009). "Modularization of a Large-Scale Business Application: A Case Study." IEEE Software, 26(2), 28-35. https://ieeexplore.ieee.org/document/4786942

[^10]: Feathers, M. (2004). Working Effectively with Legacy Code. Prentice Hall. https://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052

[^11]: Spolsky, J. (2002). "The Law of Leaky Abstractions." Joel on Software. https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/

[^12]: Evans, E. (2003). Domain-Driven Design: Tackling Complexity in the Heart of Software. Addison-Wesley Professional. https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215
