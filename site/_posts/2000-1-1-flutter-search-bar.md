---
layout: post
title: "Add A Search Bar To The AppBar In Flutter"
date: "2023/03/19 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/searchbar/search.gif"
image: "/assets/images/blog/searchbar/search.gif"
description: Learn to create a search bar in Flutter with this concise guide, covering TextEditingController for user input management, data filtering, and displaying results with ListView.builder. Enhance your app's interactivity and user experience.
tags: testing dart cross-platform
categories: [flutter]
permalink: /blog/:title
keywords: [
  "Flutter search bar",
  "AppBar search Flutter",
  "TextEditingController Flutter",
  "Flutter ListView.builder",
  "Flutter search functionality",
  "Flutter UI components",
  "StatefulWidget Flutter",
  "Flutter data filtering",
  "Flutter app development",
  "Flutter widget testing",
  "CircularProgressIndicator Flutter",
  "Flutter TextField",
  "Flutter search results display",
  "Flutter user input handling",
  "Material Design Flutter",
  "Flutter app testing",
  "Flutter search implementation",
  "Flutter state management",
  "Flutter UI design",
  "Flutter performance testing"
]
---

Search bars are often an essential UI component in a Flutter app. This blog post walks you through creating a search bar in Flutter and provides you with an example app to get started. We create a basic [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html) to manage the state, but you can use the same approach with a controller to [separate the UI from the business logic](https://www.christianfindlay.com/blog/separate-business-logic-and-presentation).

## Layout Example

This layout is a simple flutter app with an [AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html). This is a basic element that [appears in most Material Design apps](https://m3.material.io/components/top-app-bar/overview) and appears at the top of the screen. The [`TextField`](https://api.flutter.dev/flutter/material/TextField-class.html) allows the user to enter the search text, and the [`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html) handles the state of the text.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Search Bar Example',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // Perform search functionality here
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Search results will appear here',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.deepPurple.shade900,
    );
}
```


## Implement Search Functionality

We will use a list of strings as our data source and filter this list based on the user's input in the search bar. The app simulates an API call with a delay of 1000 milliseconds (1 second) and displays a CircularProgressIndicator while waiting for the search to complete. Replace the `_MyHomePageState` class with the following code:

Try this [live in Dartpad](https://dartpad.dev/?id=7ad4c8915310f86b4107dcefff36f66a)

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _data = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Fig',
    'Grape',
    'Lemon',
    'Mango',
    'Orange',
    'Papaya',
    'Peach',
    'Plum',
    'Raspberry',
    'Strawberry',
    'Watermelon',
  ];
  List<String> _filteredData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _filteredData = _data;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    //Simulates waiting for an API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _filteredData = _data
          .where((element) => element
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    _filteredData[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
        backgroundColor: Colors.deepPurple.shade900,
      );
}
```

This example implements filtering a list of strings according to the user's input in the search bar. Here is a break-down of how it works.

- The [`TextEditingController`](https://api.flutter.dev/flutter/widgets/TextEditingController-class.html) named `_searchController` listens for changes. This allows us to perform actions accordingly.

- We create a list of strings called _data to act as our data source. This list contains various fruit names. We also create another list called _filteredData to store the filtered results based on the user's input.

- In the `initState()` method, we initialize _filteredData with the content of _data. We also add a `listener`, `_performSearch`, to the `_searchController`. This listener function gets called whenever the user types something in the search bar.

- We define a `_performSearch()` function that filters the _data list based on the user's input. It simulates calling an API and waits for one second. Inside the function, we call `setState()` to update the UI with the new filtered data. We filter the elements using the `where()` method on the `_data` list. The filtering condition checks if each element in the list, when converted to lowercase, contains the user's input, also converted to lowercase. This makes the search case insensitive. After filtering, we store the result in the `_filteredData` list.

- In the `build()` method, we create a `ListView.builder` to display the filtered data. This `ListView.builder` takes the length of the `_filteredData` list as its `itemCount` and uses a lambda function as its `itemBuilder`. This function receives the current context and index as parameters and returns a `ListTile` with the corresponding item's text from the `_filteredData` list.

As a result, whenever a user types something in the search bar, the `_performSearch()` function filters the data source based on the input, and the `ListView.builder` updates the UI to display the filtered results.

## Widget Testing

We also need to test the app. Full app widget tests are the best way to test Flutter apps. You can read more about testing [here](https://www.christianfindlay.com/blog/test-isolation-expensive). They can easily cover all the code instead of focusing on the logic only. Create a `test` folder if it doesn't exist and add the file `search_bar_example_test.dart`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_application_7/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App should display AppBar with Search TextField',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('App should display CircularProgressIndicator when searching',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    //Wait for the progress indicator to disappear
    await tester.pumpAndSettle();

    //Make sure it's gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('App should display search results after search is complete',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pump(const Duration(milliseconds: 1000));

    //We expect 3 results
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('App should display no search results for non-existent query',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'non-existent query');
    await tester.pump(const Duration(milliseconds: 1000));

    expect(find.byType(ListTile), findsNothing);
  });
}
```

The provided tests validate various aspects of a search bar app built using Flutter. The first test ensures that the app displays an `AppBar` containing a `TextField` for search input. The second test verifies that a `CircularProgressIndicator` is shown during the search process and disappears once the search is complete. The third test checks that the app displays the correct number of search results (in this case, three) after the search is completed. Finally, the fourth test confirms that the app displays no search results when a non-existent query is entered. These tests help ensure the app functions as expected, providing a solid foundation for further development and improvements.


## Conclusion
This blog post guided you through the process of creating a search bar in Flutter and implementing search functionality. You can apply this to other data sources and use cases, such as searching for items in a database, filtering items from an API, or implementing more complex search algorithms. Lastly, you learned how to test the search bar app using widget tests. 