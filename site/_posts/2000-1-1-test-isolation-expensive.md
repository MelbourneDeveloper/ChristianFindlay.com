---
layout: post
title: "Test Isolation is Expensive"
date: "2023/02/20 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/expensivetests/header.jpg"
image: "/assets/images/blog/expensivetests/header.jpg"
tags: testing software-quality
categories: [software development]
permalink: /blog/:title
slider_post: true
---

This article is part of a series on testing that I am writing, and this series is part of an e-book on testing that I am compiling. This article doesn't dwell on the value of different testing approaches or try to weigh the pros and cons of different approaches. Let's say it is a given that any system will require a mixture of fine-grained tests, such as unit tests, and coarser tests, like integration tests. The ratio is a question for the broader topic.  

This article demonstrates how more test isolation results in more test code and less test coverage. More isolation also makes it harder to refactor your code because more tests need to change when you refactor. In short, test isolation is expensive in terms of maintainability. Generally speaking, the higher the level of test isolation, the more test code you will need to cover your app, and the less maintainable your test suite becomes. Furthermore, fine-grained unit tests simply cannot test things like UI or the HTTP pipeline.  

Please understand that this is not a value judgment. You do need some level of test isolation. I am only pointing out that your team pays a price for it. Please don't take my word for anything here. Try this out in your codebase. Do your own experiments.  

Test Pyramid
------------
The test pyramid says that unit tests appear at the bottom. Doesn't that mean they are cheaper?  

![Test Pyramid](/assets/images/blog/expensivetests/pyramid.png)

Mike Cohn's original test pyramid above only concerns itself with isolation and performance. Unit tests are faster because they only run tiny amounts of code simultaneously. However, the pyramid completely leaves out the most important dimension: the amount of test code.   

Considering the amount of test code we would need to cover a whole app with fine-grained unit tests would flip the pyramid upside down. Fine-grained unit tests result in more test code. So, let's look at why that's the case.   

A Dart Example with Functions
-----------------------------

Take a look at the code in this example. There are four functions. One function is a composition of the other three.

<script src="https://gist.github.com/MelbourneDeveloper/469d64c84869bb8efbdc5aa6389da5a5.js"></script>

We can take two approaches to testing here. We could test all the moving parts together (integration) or isolate each function (unit testing). Both approaches have their pros and cons. Both approaches should catch a bug, but if we isolate each function, a failed test will highlight exactly where the code failed.   

On the other hand, integrating the functions together makes the test far less verbose. That's easy to see when you look at the first test. The difference is massive, and this is only a simple example. We are looking at about three-four times more test code. Also, notice how much more straightforward the first example is. You can understand it without context. The test doubles, in particular, make the last test difficult to understand without context.   

What about more complex examples? The problem only multiplies as the system becomes more complex. Try adding more functions or turning the functions and interface dependencies. You can see how quickly the isolated tests balloon in test code size - particularly with the need for test doubles. Each dependency requires a test double to achieve test isolation. All this leads to less maintainable tests because there is more to change if you need to refactor.  

ASP.NET Core API Endpoint Example
---------------------------------

There are many things that we cannot test with a unit test because we need to spin up an entire framework to do that. For example, we cannot test how the HTTP pipeline will interact with our code because we need to spin up a whole web server to test that. However, if we spin up a server, we can test everything together, along with the business logic.   

Take this ASP.NET Core endpoint example.

<script src="https://gist.github.com/MelbourneDeveloper/bb6215c83707258b52d7ed0a410ecb49.js?file=Program.cs"></script>

What code can we actually test with a unit test here? Here are some tests, and one of them is a unit test. It turns out that we can't test much of this Web API with unit tests. Most of the code is dedicated to the record and spinning up the web server. The main business logic is the Fahrenheit calculation.

<script src="https://gist.github.com/MelbourneDeveloper/bb6215c83707258b52d7ed0a410ecb49.js?file=Tests.cs"></script>

If we calculate test coverage for the unit test (`TestFahrenheitCalculation`), we only cover a small portion of the app.

![Unit test coverage](/assets/images/blog/expensivetests/aspunitcoverage.png){:width="100%"}

We could break the logic of the auth middleware out into a function, but this would require a refactor, and attempting to test this as a unit test would be very difficult. It would become a matter of making the code more complicated just for the sake of test isolation. If we did break out this functionality for testing, the test becomes less meaningful.  

<script src="https://gist.github.com/MelbourneDeveloper/bb6215c83707258b52d7ed0a410ecb49.js?file=zCheckHeader.cs"></script>

Now, take a look at what happens when we run the integration tests (EndpointTestOK and EndpointTestUnauthorized) and measure the test coverage. We get full test coverage with very little test code. We can test the logic along with the entire HTTP pipeline.  

![Integration test coverage](/assets/images/blog/expensivetests/aspintegrationcoverage.png){:width="100%"}

Flutter UI Example  
---------------------

The issue is most acute at the UI level. The majority of Flutter code is often widgets. You cannot test widgets without putting the entire Flutter engine into action.   

Take a look at the standard Counter sample. It comes with a widget test. It gives you 92.3% test coverage right out of the box with seven lines of test code. More importantly, the main use case is covered. But it's not about the numbers. It's about what it tests. It tests the UI and the logic of the UI. It doesn't only test the logic. It tells you that the user can click on a button, the state changes and that state change reflects back to the user.  

<script src="https://gist.github.com/MelbourneDeveloper/755684a6028add425907a7c17a8b9955.js"></script>

![Widget Test Coverage](/assets/images/blog/expensivetests/flutterintegrationcoverage.png){:width="100%"}

But what about unit tests? If you look at the standard Counter sample, it's not even possible to unit test the logic. We have to refactor to achieve that. That raises another point. If testing requires refactoring that makes the code more complicated, we lose additional maintainability. We shouldn't increase code complexity for test isolation unless we are sure we need it.  

We can break the logic out into a controller as a ValueNotifier for the sake of this exercise. If we remove the widget test, the coverage drops to 11.5% because the tests don't test the UI. The majority of the code is widgets, so the test misses more than 80% of the code.

![Unit Test Coverage](/assets/images/blog/expensivetests/flutterunitcoverage.png){:width="100%"}

Conclusion
----------

Test isolation is expensive in terms of writing and maintaining tests. It may even influence you to make your code more complicated just so you can isolate test logic. Isolated unit tests cannot cover many aspects of your app, like composition, HTTP pipelines, or UI interactions. Isolation is a trade-off. It may help you to pinpoint issues when they arise, but it will make your codebase harder to refactor and your tests harder to maintain over time. Understand the trade-offs and make decisions about how to test based on that.  

<sub><sup>[Photo by Taryn Elliott from Pexels](https://www.pexels.com/photo/person-standing-on-brown-sand-under-blue-sky-4405252/)</sup></sub>