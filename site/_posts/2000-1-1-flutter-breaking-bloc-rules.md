---
layout: post
title: "Flutter: Breaking the BloC Rules"
date: 2022-12-28 20:37:13 +0600
tags: bloc state-management cross-platform
categories: [flutter]
author: "Christian Findlay"
post_image: "/assets/images/art/rubiks.jpg"
post_image_height: 300
image: "/assets/images/art/rubiks.jpg"
trending: true
permalink: /blog/:title
---

BloC is a common UI pattern in the Flutter world. Google originally created the idea early on in Flutter's life. Since its inception, the pattern has taken several forms, and now the most popular approach is to use the [library](https://pub.dev/packages/flutter_bloc) named after the pattern. There is no real official BloC pattern other than what Google articulated in the [original talk](https://www.youtube.com/watch?v=RS36gBEp8OI). The closest documentation may be [this article](https://medium.com/codechai/architecting-your-flutter-project-bd04e144a8f1) that the Flutter documentation links to. However, the pattern has evolved over time and picked up several characteristics, core concepts, and unofficial rules. 

This article discusses BloC rules and when it may be appropriate to bend or break them. The purpose is to show you that following BloC conventions only sometimes results in the best possible code and that the strict rules may not apply to your situation.

### Overview

The first thing to understand here is that I will refer to the [bloobit](https://pub.dev/packages/bloobit/score) library in some cases. I wrote this library as an alternative to BloC. BloC inspires Bloobit and closely resembles [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), [Cubit](https://pub.dev/documentation/bloc/latest/bloc/Cubit-class.html), and other similar classes. The core concept it shares with BloC is that it separates [UI and business logic](/flutter-business-logic-presentation). 

Any concepts I write about here should be compatible with BloC implementations. However, if you use the [BloC library](https://pub.dev/packages/flutter_bloc), the documentation will come with some rules, and I'm not recommending you break those. bloobit doesn't come with any rules, and I permit you to do whatever you want.

It's also important to understand where the BloC pattern comes from. Much like the [MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel) pattern, BloC comes from a time when people were working with more than one UI toolkit at a time. If you watch this [early video](https://www.youtube.com/watch?v=PLHln7wHgPE), you can see that the aim is to share code between Flutter and Angular Dart. That required an overt separation of logic and UI. We don't need to do that these days because Flutter runs everywhere. 

"Business Logic" is usually code for "UI Logic" with a sprinkling of validation and so on. Business logic usually ends up being heavier on the back end, so you shouldn't be surprised that most of the logic in your Flutter app is around the UI. Attempting to remove any UI logic from your controller can be futile and may make you jump through unnecessary hoops.

### Antipatterns

"I see so many antipatterns here!"

An [antipattern](https://en.wikipedia.org/wiki/Anti-pattern) is

> *a common response to a recurring problem that is usually ineffective and risks being highly counterproductive*

I disagree with the assertion that these approaches are ineffective or risk counterproductivity. Some of these tips will save you time and improve maintainability. You should not appeal to authority on what is or isn't counterproductive. You should look at the approach on its merits, understand the tradeoffs and make decisions based on those.

I don't recommend that you blindly follow my examples. I recommend you weigh up all the thinking and make up your mind.

### Rules Don't Replace Thinking

Software development is hard, and you cannot escape thinking about the structure of your app. There is no silver bullet you can use to force people in your team to do the right thing. Even with the wealth of documentation on the existing patterns, we regularly see glaring mistakes. Some of those mistakes are due to misunderstanding the pattern, but most of the time, it's plain old human fallibility. 

The only way to deal with this is through communication, mentoring, review, and training. If you throw junior devs into the deep end and say, "Just follow the BloC documentation", you may get code that follows the rules, but you still won't get code that the team is happy with. Work with other programmers, discuss the tradeoffs, and gain consensus. A set of rules is no replacement for this.

### A Note on Testing

As I write elsewhere, this article assumes that you write mostly widget tests. I won't go deep into why you don't need to write copious unit tests for your controllers (BloC), but you can cover the logic in your controllers with widget tests. Anything you can't cover with widget tests probably can't happen in your app. 

*Brace yourself because here we go...*

### Use Mutable State

Immutability is a good thing, but it takes work. I've written extensively about it in [Dart](/dart-immutable-collections) and other languages. However, implementing it in a lax way is a recipe for disaster. Records and other immutability features for Dart are on their way. Still, getting [Immutability with structural equality right is challenging](/immutability-dart-vs-fsharp). Immutability has benefits, but be prepared to work for them. 

The BloC pattern works fine with mutable types. However, the BloC library [expects structural equality](https://pub.dev/packages/flutter_bloc#blocselector). You can work around this, but bloobit works with mutable or immutable state. You can also use mutable state without StatelessWidgets.

### Inject GlobalKeys into your Business Logic Controller

Given a navigator or scaffold messenger key, you can do things like navigate or show snack bars from business logic. You often find that you must perform business logic before these things happen. Sometimes, you may only want to navigate if the state meets certain criteria, and your code may have branching logic. 

Note that it might be hard to mock the keys for testing, but you don't have to worry about that if you're writing widget tests. You don't need to test your controllers directly if you write widget tests.

### Use Dialog Callbacks In Your Controller

There is no good reason you shouldn't write an abstraction for a UI action like popping up a dialog. This code injects a DialogService into the bloobit and is an abstraction that actually displays the dialog and returns the result that the user selected. Again, there is nothing wrong with putting UI logic in the controller because UI logic is what apps are mostly concerned with. This does not pose a problem for testing because you can mock the dialog if you need to.

{% highlight dart linenos %}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User {
  const User(this.id, this.name);
  final String id;
  final String name;
}

class UserScreenState {
  const UserScreenState(this.user, this.isProcessing, this.isDeleted);
  final User user;
  final bool isProcessing;
  final bool isDeleted;

  UserScreenState copyWith({
    User? user,
    bool? isProcessing,
    bool? isDeleted,
  }) =>
      UserScreenState(
        user ?? this.user,
        isProcessing ?? this.isProcessing,
        isDeleted ?? this.isDeleted,
      );
}

class UserService {
  Future<void> deleteUser(String id) =>
      Future<void>.delayed(const Duration(seconds: 1));
}

class DialogService {
  DialogService(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  Future<bool?> showYesNoDialog(String title, String message) =>
      showDialog<bool>(
        context: navigatorKey.currentState!.context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        ),
      );
}

class UserScreenBloobit extends Bloobit<UserScreenState> {
  UserScreenBloobit(
    this.logger,
    this.userService,
    super.initialState,
    this.dialogService,
  );

  final Logger logger;
  final UserService userService;
  final DialogService dialogService;

  Future<void> delete() async {
    try {
      logger.info('Delete Clicked');

      setState(state.copyWith(isProcessing: true));

      final result = await dialogService.showYesNoDialog(
            'Delete User',
            'Are you sure you want to delete ${state.user.name}?',
          ) ??
          false;

      logger.info('User confirmed dialog: ${result ? 'Yes' : 'No'}');

      if (result) {
        await userService.deleteUser(state.user.id);
        logger.info('User Deleted');
        setState(state.copyWith(isDeleted: true));
      }
    }
    catch (e)
    {}

    setState(state.copyWith(isProcessing: false));
  }
}

{% endhighlight %}

Live sample:

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=e9d097b701667bdd2b137536509dd287"></iframe>
</figure>

Note: you can also directly show dialogs with a navigator key.

### Stream Between Business Logic Components

You can and should stream state and other data between your business logic components. The whole point of [streams and listenables (observer pattern)](https://en.wikipedia.org/wiki/Observer_pattern) is to allow a decoupled one-to-many relationship between the subject and the observers. If you don't, what's the point of using streams in the first place? 

The BloC library [documentation](https://bloclibrary.dev/#/architecture?id=bloc-to-bloc-communication) says this. 

> *Because blocs expose streams, it may be tempting to make a bloc which listens to another bloc. You should not do this. [...] it creates a dependency between two blocs. [...] Generally, sibling dependencies between two entities in the same architectural layer should be avoided at all costs, as it creates tight-coupling which is hard to maintain.*

This is quite reasonable, and the example injects one BloC into another BloC that unnecessarily couples two components. However, there is no such issue with injecting the stream of one BloC into the constructor of another BloC. If one BloC emits a stream, another BloC can safely listen to that stream without creating coupling. Just inject the stream in the constructor and listen. Call close on the subscription when you dispose of the BloC.

{% highlight dart linenos %}
import 'dart:async';

class MyBloc {
  final Stream<int> _stream;
  final _streamController = StreamController<int>();
  late final StreamSubscription? _streamSubscription;

  Stream<int> get stream => _streamController.stream;

  MyBloc(Stream<int> stream) : _stream = stream {
    // Inject the source stream into the bloc's constructor and listen to it
    // to emit state
    _streamSubscription = _stream.listen((data) {
      // Emit the data as state
      _streamController.add(data);
    });
  }

  void dispose() {
    // Clean up when the bloc is disposed
    _streamSubscription?.cancel();
    _streamController.close();
    print('Disposed');
  }
}

void main() {
  // Create a stream that emits values of type int
  final sourceStream = Stream.fromIterable([1, 2, 3]);

  // Inject the stream into the bloc's constructor
  final bloc = MyBloc(sourceStream);

  // Listen to the stream to receive the emitted state
  bloc.stream.listen((state) {
    print(state); // Prints 1, 2, 3
    if (state == 3) {
      // Clean up the bloc when it's no longer needed
      bloc.dispose();
    }
  });
}
{% endhighlight %}

It's quite common for one part of an app to listen to state changes in another part of the app. Streams give you the mechanism to do this in a decoupled way, and that's the main purpose of streams and the observer pattern in general.

View the interactive sample here:

### Avoid Streams When Unnecessary

The flip side of the above is that you should only use streams when necessary. Unnecessary streams can use up valuable resources, such as memory and processing power, which can degrade your app's performance. In addition, using too many streams can make your code harder to understand and maintain. It's generally best to use streams only when necessary.

Consider avoiding streams if the business logic is a one-to-one relationship with the UI component (Widget). The BloC pattern always uses streams, but Bloobit achieves a similar result without streams. That's why I created it. It just calls setState instead of opening and closing streams. 

### Stop Using The Repository Pattern

The repository pattern is a common design pattern in software development. It separates concerns between an application's data access and business logic layers. This can make it easier to test the business logic of an application since we can test it in isolation from the data access layer.

However, widget testing already provides a way to test the business logic of a widget without the need for a repository pattern. You can directly fake the [Firestore client](https://pub.dev/packages/fake_cloud_firestore/example) or [HTTP client](https://pub.dev/documentation/http/latest/http.testing/MockClient-class.html), which provides data to the widget to perform its business logic. This eliminates the need for a repository pattern, which can [add unnecessary complexity](https://www.infoworld.com/article/3117713/design-patterns-that-i-often-avoid-repository-pattern.html) to the application.

If you are not using the repository pattern for a specific reason, it is generally best to avoid using it to keep your application simple and easy to test.

### Conclusion

The core message here is that there are no rules set in stone. As a developer, you need to make decisions about the code. You can't rely on an authority to tell you what is right or wrong. You should listen to people when they warn you against something, but try to hear the "why". If there isn't solid justification behind the recommendations, then you may not need to place importance on what they are saying. 

Also, make sure that the recommendation actually applies to you. Many recommendations lose their narrow scope over time and become too broad. Sometimes, people stop you from writing normal code because they misinterpreted the original problem.

Ultimately, it's all about understanding the pros and cons and weighing them up for yourself and in your team.

[Photo by Miguel Á. Padriñán from Pexels](https://www.pexels.com/photo/yellow-orange-and-green-3x3-rubik-s-cube-19677/)