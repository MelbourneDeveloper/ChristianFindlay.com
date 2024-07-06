---
layout: post
title: "Reactive Programming: Hot Vs. Cold Observables"
date: "2020/10/25 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/reactive/header.jpeg"
image: "/assets/images/blog/reactive/header.jpeg"
tags: reactive csharp
categories: dotnet
permalink: /blog/:title
redirect_from: /2020/10/25/rx-hot-vs-cold/
---

The [Observer Pattern](https://en.wikipedia.org/wiki/Observer_pattern) is at the core of [reactive programming](https://en.wikipedia.org/wiki/Reactive_programming), and observables come in two flavors: hot and cold. This is not explicit when you are coding, so this article explains how to tell the difference and switch to a hot observable. The focus is on hot observables. The concepts here are relevant to all languages that support reactive programming, but the examples are in C#. It's critical to understand the distinction before you start doing reactive programming because it will bring you unstuck if you don't.

Reactive Programming
--------------------

It's hard to clearly define what Reactive Programming is because it spans so many languages and platforms, and it has overlap with programming constructs like events in C#. I recommend reading through the [Wikipedia article](https://en.wikipedia.org/wiki/Reactive_programming) because it attempts to give a history of reactive programming and provide objective information.

In a nutshell, reactive programming is about responding to events in the form of sequences (also known as streams) of data. Technically, any programming pattern that deals with this is a form of reactive programming. However, a pattern called the [Observer pattern](https://en.wikipedia.org/wiki/Observer_pattern) has emerged as the _de facto_ standard for reactive programming. Most programming languages have frameworks for implementing the observer pattern, and the observer pattern has become almost synonymous with reactive programming. 

Here are some popular frameworks:

[RxJS](https://rxjs-dev.firebaseapp.com/guide/overview) (JavaScript) 

[System.Reactive](https://github.com/dotnet/reactive)(.Net)

[ReactiveX](http://reactivex.io/) (Java oriented - with implementations for many platforms)

[RxDart](https://github.com/ReactiveX/rxdart) (Dart)

The concept is simple. Observables hold information about observers who subscribe to sequences of notifications. The observable is responsible for sending notifications to all of the subscribed observers.

_Note: The_ [_publish-subscribe_](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) _(pub/sub pattern) is a closely related pattern, and although technically different, is sometimes used interchangeably with the observer pattern._

Hot Observables
---------------

For most intents and purposes, hot observables start producing notifications independently of subscriptions. Cold observables only produce notifications when there are one or more subscriptions.

Technically, all Observables only produce notifications when there is a subscriber, but with cold observables, each subscriber receives independent notifications. In the case of hot observables, connecting with the Connect() method creates only one subscriber, and all users receive notifications on that shared subscription.

Take some time to read up about the observer pattern if you are not familiar. If you start Googling, be prepared for many different interpretations of the meaning. [This article](http://introtorx.com/Content/v1.0.10621.0/14_HotAndColdObservables.html) explains it well and gives examples in C#. This [article](https://leecampbell.com/2010/08/19/rx-part-7-hot-and-cold-observables/) is another good article on the topic of hot and cold observables.

A hot observable is simpler because only one process runs to generate the notifications, and this process notifies all the observers. A hot observable can start without any subscribed observers and can continue after the last observer unsubscribes.

On the other hand, a cold observable process generally only starts when a subscription occurs and shuts down when the subscription ends. It can run a process for each subscribed observer. This is for more complex use cases.

Hot Observable Use Case
-----------------------

Let's imagine the simplest use case. The notification publisher is a singleton. It gets instantiated when the app starts and will continue to poll for information throughout the app's lifespan. It will never shut down, and it will send notifications to all instances of the subscriber that subscribe to it.

In C#, observers implement the IObserver<> interface, and observables implement the IObservable<> interface. This is an implementation of the use case in C#. We create the publisher with CreateObservable(), and then two subscribers subscribe. They both receive the notification "Hi" repeatedly until they unsubscribe, or we can cancel the task. This is a hot observable because the long-running task runs independently of the subscribers.

_Note: this is not the recommended approach. This is just an example for clarity._

```csharp
/*
Output
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
*/

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reactive.Disposables;
using System.Reactive.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace UnitTestProject1
{
    class Subscriber
    {
        public string Name;

        //Listen for OnNext and write to the debug window when it happens
        public Subscriber(IObservable<string> observable, string name)
        {
            Name = name;
            var disposable = observable.Subscribe((s) => Debug.WriteLine($"Name: {Name} Message: {s}"));
        }
    }

    internal class BasicObservable<T> : IObservable<T>
    {
        List<IObserver<T>> _observers = new List<IObserver<T>>();

        public BasicObservable(
            Func<T> getData,
            TimeSpan? interval = null,
            CancellationToken cancellationToken = default
            ) =>

            Task.Run(async () =>
            {
                while (!cancellationToken.IsCancellationRequested)
                {
                    try
                    {
                        await Task.Delay(interval ?? new TimeSpan(0, 0, 1));
                        _observers.ForEach(o => o.OnNext(getData()));
                    }
                    catch (Exception ex)
                    {
                        _observers.ForEach(o => o.OnError(ex));
                    }
                }

                _observers.ForEach(o => o.OnCompleted());

            }, cancellationToken);

        public IDisposable Subscribe(IObserver<T> observer)
        {
            _observers.Add(observer);
            return Disposable.Create(observer, (o) => _observers.Remove(o));
        }
    }

    public static class ObservableExtensions
    {
        public static IObservable<T> CreateObservable<T>(
            this Func<T> getData,
            CancellationToken cancellationToken = default)
        => new BasicObservable<T>(getData, default, cancellationToken);

        public static IObservable<T> CreateObservable<T>(
            this Func<T> getData,
            TimeSpan? interval = null,
            CancellationToken cancellationToken = default)
        => new BasicObservable<T>(getData, interval, cancellationToken);
    }

    [TestClass]
    public class UnitTest1
    {
        string GetData() => "Hi";

        [TestMethod]
        public async Task Messaging()
        {
            var cancellationSource = new CancellationTokenSource();
            var cancellationToken = cancellationSource.Token;

            Func<string> getData = GetData;

            var publisher = getData.CreateObservable(cancellationToken);

            new Subscriber(publisher, "One");
            new Subscriber(publisher, "Two");

            for (var i = 0; true; i++)
            {
                if (i >= 5)
                {
                    cancellationSource.Cancel();
                }

                await Task.Delay(1000);
            }
        }
    }

}
```

Reactive Extensions
-------------------

The reactive extensions are a set of C# helpers for building observables and observers. They exist in the namespace System.Reactive. Their home is in this [is](https://github.com/reactiveui/ReactiveUI) [repo](https://github.com/dotnet/reactive)[.](https://github.com/reactiveui/ReactiveUI) You can use it by installing the [System.Reactive NuGet package](https://www.nuget.org/packages/System.Reactive/). It would help if you used these extensions instead of directly implementing IObservable<> or IObserver<>. Reactive frameworks for other platforms have similar libraries. 

Cold Observables
----------------

[Observable.Create](https://docs.microsoft.com/en-us/previous-versions/dotnet/reactive-extensions/hh229114(v=vs.103)) from the reactive extensions creates observables. What the documentation doesn't tell you is that the observable is cold by default. The code that you supply doesn't run until something subscribes, and when multiple subscribers subscribe, multiple copies of the code will be running in parallel. This may be the desired result, but most people wouldn't expect this unless they already have a strong background with reactive programming.

Have a look at [my version](https://gist.github.com/MelbourneDeveloper/56075e78894f576fe72a3457615f0269) of the example from the documentation [here](https://gist.github.com/MelbourneDeveloper/56075e78894f576fe72a3457615f0269). Notice that if you put a breakpoint where the while loop starts, it will get hit twice. Two loops run in parallel. This is probably not the behavior you would expect. 

Convert a Cold Observable to a Hot Observable
---------------------------------------------

In C#, you can use [Observable.Publish](https://www.reactiveui.net/reactive-extensions/publish/observable.publish) from the reactive extensions to return a connectable, observable sequence that shares a single subscription. This is a hot observable. It runs one process and sends notifications to all subscribers from that one process. You can still control the observable workflow, but it means that it doesn't depend on subscriptions. Here is an example. This version creates almost the same result as my earlier code, but I don't need to implement IObservable<>. It runs the GetData()method every second. The CompositeDisposable neatly wraps up all the disposables, but this is not necessary.

```csharp
/*
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
Name: One Message: Hi
Name: Two Message: Hi
This sample is a modification of Enigmativity's code
Stack Overflow: https://stackoverflow.com/a/64520014/1878141
*/

using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics;
using System.Reactive.Disposables;
using System.Reactive.Linq;
using System.Threading.Tasks;

namespace Observables
{
    class Subscriber : IDisposable
    {
        public string Name;
        private IDisposable _disposable;

        //Listen for OnNext and write to the debug window when it happens
        public Subscriber(IObservable<string> observable, string name)
        {
            Name = name;
            _disposable = observable.Subscribe((s) => Debug.WriteLine($"Name: {Name} Message: {s}"));
        }

        public void Dispose() => _disposable.Dispose();

    }

    [TestClass]
    public class UnitTest1
    {
        private static string GetData() => "Hi";

        [TestMethod]
        public async Task Messaging()
        {
            var coldObservable =
                Observable
                    .Timer(TimeSpan.Zero, TimeSpan.FromSeconds(1.0))
                    .Select(_ => GetData());

            var publisher = coldObservable.Publish();

            //Note that we might miss some notifications here. This is because we subscribe after calling the publish method.
            //If want to avoid this we would have to rewrite the code in a similar way to Enigmativity's code.
            var subscriptions =
            new CompositeDisposable(
                new Subscriber(publisher, "One"),
                new Subscriber(publisher, "Two"));

            var connection = publisher.Connect();

            await Task.Delay(TimeSpan.FromSeconds(5.0));

            //Disconnect the subscriptions
            subscriptions.Dispose();

            //Stop the observable
            connection.Dispose();
        }
    }
}
```

This code by Enigmativity

Here is the [previous version](https://gist.github.com/MelbourneDeveloper/dc5f04782e54e20d5ef268b47d6adc08) of the code that also works, but is not as safe or elegant as Enimativity's code above. It's essential to understand the Connect() method and how the disposal works. This [post](http://introtorx.com/Content/v1.0.10621.0/14_HotAndColdObservables.html) explains further detail. 

Wrap-up
-------

Your learning about reactive programming doesn't stop here. This article is just a primer to get started with hot and cold observables. Reactive programming is a vast topic, and you should look at taking some courses on the topic. The difference between cold and hot observables deserves a course of its own. A full discussion on the use cases for the two different flavors is outside the scope of this article but, hopefully, you will have enough information to understand how to create either one using the reactive extensions. Use the reactive extensions where possible to reduce the amount of code your write. If you find yourself implementing either of the two main interfaces, ask yourself whether you can use the reactive extensions instead.

Lastly, thanks to [Theodor Zoulias](https://stackoverflow.com/users/11178549/theodor-zoulias), who clarified this topic for me [here](https://stackoverflow.com/a/64511557/1878141), and [Enigmativity](https://stackoverflow.com/users/259769/enigmativity) who simplified the code even further [here](https://stackoverflow.com/a/64520014/1878141).

_Note: the definition of cold vs. hot was written for technical correctness._