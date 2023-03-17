---
layout: post
title: "Test Coverage"
date: "2023/03/09 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/testcoverage/header.jpg"
tags: testing software-quality
categories: [software development]
permalink: /blog/:title
slider_post: true
---

This article is part of a series I am writing about testing. It refers to an [article](https://www.christianfindlay.com/test-isolation-expensive) I wrote on test isolation, which is important reading for this topic.   

Test coverage measures the actual amount of code your test suite hits. It usually gives you a percentage of the overall lines of code in the system covered and the ability to see which lines of code the tests ran. This allows you to adjust your tests so that they cover more code.   

However, it is a much-maligned metric, and understandably so. It doesn't measure the quality of your tests. It only measures quantity. It can be a misleading figure because an app can have 100% code coverage and still be very buggy. Some teams get caught up in green fever (blindly chasing the green-colored coverage metric) to reach 100% test coverage. This will certainly have harmful effects on your code and team.  

However, we all understand that an app with 0% coverage has big problems. As [Vladimir Khorikov](https://twitter.com/vkhorikov) mentions in [Unit Testing Principles, Practices, and Patterns.](https://livebook.manning.com/book/unit-testing/chapter-1/59)  

> _coverage metrics, while providing valuable feedback, can't be used to effectively measure the quality of a test suite. It's the same situation as with the ability to unit test the code: coverage metrics are a good negative indicator but a bad positive one._  

In other words, hitting 100% coverage won't magically turn your software into a rock-solid feature factory. But, having no tests will guarantee that adding features to or changing your software is painful and error-prone. So, let's explore the appropriate way to think about test coverage. Should we pay attention to it? What number should we strive for? Are there better metrics?  

Why Write Tests?
----------------

To answer these questions, we must look at why we write automated tests. We test our software so we can make changes without breaking the software. We automate the process to reduce the burden on manual testers, speed up the testing process and make it more reliable. Automated tests are good when they help us ship features and fixes reliably. They are useless or even detrimental when they slow that process down.  

Good tests confirm that actual use cases are working in the app. They confirm that users can navigate through the screens, enter data, and see the correct results, or they confirm that an endpoint accepts the desired request and returns the desired response. This isn't an abstract or academic point: it's simply about ensuring the app works.  

Test Use Cases
--------------

Getting lost in the morass of recommendations about how to test software is easy. Unlimited books and reading materials recommend all kinds of practices for writing tests and designing code so you can write those tests. However, we often lose sight of the main goal: testing the app. A use case might entail navigating to the account screen, clicking the change password button, entering the password twice, and then the test assertion would verify that the code saved the change back to the database. You need to test these use cases.  

You may have used a framework like Selenium. This tool is great because it allows you to test actual use cases. However, it is a black box tool. Out of the box, it doesn't measure code coverage.   

So testing use cases seems to remove our focus from the coverage metric, right? If we do vanilla automated tests, we don't see the metric. We know our app is working correctly, but we have no idea how much of the code this covers. This is where the waters get murky, and code coverage could steer us off course and direct us to chase metrics with fine-grained unit tests. This is a bad idea.  

Fine-grain unit tests can help us to isolate bugs in units of code. This is necessary for some apps but can distract us from testing actual use cases directly. Teams often find themselves in the scenario where they scramble to churn out hundreds or thousands of unit tests to bump the coverage up by a few percent here and there. These tests don't actually confirm that the user can use the app. This often leads to a feeling of futility and resentment toward the coverage metric. This is all understandable. But it doesn't have to be like this.  

[Playwright](https://playwright.dev/) and other modern web testing tools, such as framework-specific toolkits, allow us to collect code coverage data as the tests run. Many UI toolkits have testing frameworks allowing us to test use cases and collect code coverage data directly. For example, Flutter comes with [widget tests](https://docs.flutter.dev/cookbook/testing/widget/introduction) that allow us to test actual use cases in the whole app. But, back-end frameworks also allow us to do integration and end-to-end tests that collect code coverage. For example, you can [test use cases of ASP .NET Core endpoints with integration testing](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-7.0). All these frameworks collect coverage data and run in CI/CD pipelines.   

Testing Use Cases Is Less Expensive
-----------------------------------

At this point, you may think, "but aren't higher-level tests, such as integration tests, more expensive to write and maintain?".   

No. the opposite is true. Testing actual use cases results in better coverage, making the tests less expensive to write and maintain. You can read a complete explanation of that in this [article](https://www.christianfindlay.com/test-isolation-expensive). But don't take my word for it. Try testing actual use cases at the whole app level and see how much less test code is necessary to get more test coverage.  

Test Doubles
------------

You can still mock/fake system components if they run too slowly or unreliably. The point is that you test as much as possible working together and replace with test doubles as necessary instead of the other way around.   

[Isolated unit tests](https://www.christianfindlay.com/test-isolation-expensive) that mock everything except the SUT are expensive to create and maintain because they don't test all the moving parts together. Getting close to 100% test coverage is nearly impossible if you have to write one or more unit tests for each class in the system. This is a recipe for a 3:1 or 4:1 test code to normal code ratio. This gets exponentially harder as the system grows. You will know the pain if you've worked on a large system with many fine-grained unit tests.  

Test doubles will leave you in a situation where the tests don't cover certain code. For example, you may decide to mock database calls. That means that your database code remains untested. You still need to test that code and test doubles kick that can down the road. Where possible, testing against the database directly solves this issue, but this can be hard or too slow to get feedback quickly enough.   

Modern tools like the [Firebase emulator](https://firebase.google.com/docs/emulator-suite) enable running end-to-end tests locally and in the CI/CD pipelines. If this increases the runtime of your test suite too much, you can run the database tests on a nightly basis or test database calls by isolating them and testing them once or twice instead of running them as part of the end-to-end tests. Ideally, you can reuse test code from your end-to-end tests with database mocks to run the same tests quickly.  

Test Isolation
--------------

As mentioned, [test isolation](https://www.christianfindlay.com/test-isolation-expensive) is an important characteristic of your test suite to consider. If an integration test fails, we have no idea which function is giving the incorrect result. Unit tests can tell us exactly which function gives us the incorrect result. This is the value of isolation. It narrows the problem down to a given area.  

End-to-end tests can tell us if something is wrong with the system, but isolated unit tests can tell us exactly where that problem is. This is the crux of the whole decision-making process. We need high-level coarse tests to test the main use cases, but there is also value in isolating pieces of the code. It's important to understand that more isolation comes with more test code, and this is where the coverage trade-off comes in. More isolation results in less coverage.  

Test Quality
------------

We can't talk about test metrics without talking about test quality. Code coverage measures quantity, but it doesn't measure quality. It tells you how much code the tests cover, but it doesn't tell you if the tests are enforcing the current behavior of the code or if the current enforced behavior is correct. So, how do we know if the tests have quality? Is it possible to get an indicator of the overall quality of tests?  

There is one metric that can give you an indication of overall test quality. It's called the mutation score. We get it by running [mutation tests](https://en.wikipedia.org/wiki/Mutation_testing). The mutation score measures how many changes the mutation tests can make in your code before the tests fail. In other words, it adds bugs to your code and checks to see if your existing tests catch them. This gives you a good indication of the quality of your tests. Mutation testing only exists for some technologies. [Stryker Mutator](https://stryker-mutator.io/) is a notable mutation testing framework for .NET, JavaScript, and Scala. There are several other frameworks, but I am not familiar enough with them to recommend any.  

High-quality tests make many assertions about what the code is doing, run with many input parameter permutations, and the isolation level also plays a part in quality. As mentioned, we pay a heavy price for test isolation. But, some level of isolation can help diagnose problems because we isolate the problem to a smaller area of code, which helps with debugging.  

Even though it is possible to measure quality to a certain extent, you cannot have quality where no tests exist at all. If your tests miss large use cases, you will probably get bugs in those areas. So, a good test suite has high test coverage and high-quality tests. We need both. It's not either, or. You can prioritize one over the other, but it's quite possible to spend all the team's time and energy on one at the expense of the other.  

Is Code Coverage A Useful Metric?
---------------------------------

Yes, and your team should pay attention to it. Testing use-cases leads to high code coverage, so if your code coverage is low, you missed testing some use cases or have dead code. That's why code coverage is useful: it tells you if you have tested the main use cases.   

While 100% code coverage doesn't mean that your tests will stop all the bugs. 50% or lower does mean that there are use cases that your test suite does not cover, so it's important to strive for more than 50% test coverage.  

Mutation score is also a very useful testing metric, but it is unavailable for all languages and doesn't replace code coverage. You can prioritize quality or quantity, but it doesn't make sense to stop improving your test coverage until you're confident that the tests cover the main use cases the user will experience.  

Conclusion
----------

You can focus on testing use cases and collect useful code coverage data without indulging in "green fever". Metrics, in general, are useful if you don't treat them as your primary aim. They are indicators of the achievement of aims, not aims in and of themselves.  

You should use code coverage to indicate whether you have covered the main use cases. However, quality doesn't end with code coverage. You still need to ensure that your tests are high quality. Mutation testing can certainly help with that if it's available to you.  

My advice:

*   Focus on testing use cases over increasing code coverage
*   Balance your time on test quantity and test quality
*   Reduce test redundancy by aiming for less isolation and test duplication to make your suite more maintainable
*   Use code coverage to give you an indication of whether or not you covered the main uses cases or have dead code
*   Use mutation testing to get a test quality metric if you can
*   Add enough unit tests to isolate problematic or critical parts of your code  
    

Lastly, don't be fooled into thinking that full test coverage is the same as bug-free code, but also be aware that 50% code coverage means that half of your codebase has no tests at all.

<sub><sup>[Photo](https://www.pexels.com/photo/abstract-bright-colorful-cover-268941/) by Pixabay from Pexels</sub></sup>