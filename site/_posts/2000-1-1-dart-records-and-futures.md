---
layout: post
title: "Dart 3: A Comprehensive Guide to Records and Futures"
date: "2023/05/15 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/dart/dart.png"
image: "/assets/images/blog/dart/dart.png"
tags: dart
categories: flutter
permalink: /blog/:title
description: Explore the power of Dart 3 with this comprehensive guide on Records and Futures. Understand how these features enhance the robustness of Dart applications and provide a more efficient way to manage asynchronous programming. Ideal for developers looking to leverage Dart 3 in their applications.
---


Dart 3 adds [Records](https://dart.dev/language/records). Records are an anonymous, immutable, aggregate type that allows bundling multiple objects into one object. They are fixed-sized, heterogeneous, and typed. Records can be stored in variables, passed to and from functions, and stored in lists. We can also use them with [`Future`](https://dart.dev/codelabs/async-await)s, the Dart language's asynchronous programming model. This post explains how to use records with futures.

## Records
The syntax for normal records involves comma-delimited lists of named or positional fields enclosed in parentheses. Records are structurally typed based on the types of their fields. Two records are equal if they have the same shape (set of fields), and their corresponding fields have the same values. Records also allow functions to return multiple values bundled together.

This is an example of a record with named fields:

```dart
const record = (a: 1, b: true);
print('${record.a} ${record.b}');
```

It prints: `1 true`

## Return Records From Functions/Methods

When returning a record from a function, you must specify the type name of the record. This is an example of a function that returns a Todo item and a message based on an HTTP `Response`.

```dart
class Todo {
  Todo(this.id, this.title, this.completed);

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        json['id'] as int,
        json['title'] as String,
        json['completed'] as bool,
      );

  final int id;
  final String title;
  final bool completed;
}

//A call that either gets a Todo or an error message. This is particularly useful for HTTP calls. because they can fail, and the response may not represent
//a Todo
(Todo?, String) getTodo(
  Response response,
) =>
    (Todo(1, 'Title', false), 'Success');
```

## Records as Futures

The syntax for records as futures is similar to normal records. The only difference is that the fields are wrapped inside pointy braces, so the `Future`'s generic type argument is the record. The function must return a `Future` with the record type, so async is usually appropriate here.

```dart
//A call that either gets a Todo or an error message
Future<(Todo?, String)> getTodoAsFuture(
  Response response,
) async =>
    (Todo(1, 'Title', false), 'Success');
```

Records solve a common problem when fetching data from APIs. Any time we call an API, the API could return an error message, which differs from the JSON we expect. Also, our code could fail because of an internet connectivity issue. Records as futures allow us to do this elegantly. 

Here is an example function that fetches a `Todo` from an API and returns a `Future` with a `Todo` and a message. The message is either an error message or a success message. The function randomly decides whether to return an error or an actual Todo. This example uses the new Dart [switch expression](/blog/dart-switch-expressions).

This approach introduces a more functional-style approach to making API calls in Dart. We don't throw exceptions, so the control flow is not interrupted whenever something goes wrong. 

```dart
Future<(Todo?, String)> _getTodoOrError() async {
    try {
      //Attempt to fetch the data from JSONPlaceholder
      final response = await http.get(
        Uri.parse(
          random.nextBool()
              ? 'https://jsonplaceholder.typicode.com/incorrect'
              : 'https://jsonplaceholder.typicode.com/todos/1${random.nextInt(100)}',
        ),
      );

      //We have a response, but we don't know if it was successful or not
      return switch (response) {
        (final r) when r.statusCode == 200 =>
          //We have a successful response so that we can return the data
          (
            Todo.fromJson(jsonDecode(response.body) as Map<String, dynamic>),
            'Data fetched successfully!'
          ),
        //We have an unsuccessful response so that we can return the error message
        _ => (null, 'Failed to fetch data. Error: ${response.statusCode}'),
      };
    } catch (e) {
      //We have an exception, so we can return the error message
      return (null, 'Failed to fetch data. Error: $e');
    }
  }
```

## Flutter Example
Based on the example above, we can display a Todo item on a `Card` or display an error message when there is an error message. Try this example out live and experiment with the code here.

<figure>
  <iframe style="width:99%;height:400px;" src="https://dartpad.dev/embed-flutter.html?id=c013c66d86b2b4b10073df489ac6476c"></iframe>
</figure>

## Conclusion

Dart 3's introduction of Records and their integration with Futures offers a more functional-style approach to handling API calls. This feature enhances the robustness of Dart applications by allowing for the bundling of multiple objects into a single, immutable object. Records with Futures elegantly handle potential errors when fetching data from APIs. It ensures the control flow is not interrupted even when things go wrong. This makes Dart 3 a powerful tool for developers, particularly those working with Flutter, as it provides a more efficient and reliable way to manage asynchronous programming. 