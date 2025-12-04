/// Test helpers and mock utilities for repos tests.
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:dart_node_react/src/testing_library.dart';
import 'package:nadz/nadz.dart' as nadz;
import 'package:repos/src/app.dart';
import 'package:repos/src/types.dart';

/// Create a JSObject from a Dart map
JSObject createJSObject(Map<String, Object?> map) {
  final json = switch (globalContext['JSON']) {
    final JSObject o => o,
    _ => throw StateError('JSON not available'),
  };
  final parseFn = switch (json['parse']) {
    final JSFunction f => f,
    _ => throw StateError('JSON.parse not available'),
  };
  final jsonStr = _toJsonString(map);
  return switch (parseFn.callAsFunction(null, jsonStr.toJS)) {
    final JSObject o => o,
    _ => throw StateError('Failed to parse JSON'),
  };
}

String _toJsonString(Map<String, Object?> map) {
  final entries = map.entries.map((e) {
    final value = e.value;
    String valueStr;
    if (value is String) {
      valueStr = '"${_escapeJson(value)}"';
    } else if (value is bool) {
      valueStr = value.toString();
    } else if (value is int) {
      valueStr = value.toString();
    } else if (value is double) {
      valueStr = value.toString();
    } else if (value == null) {
      valueStr = 'null';
    } else if (value is Map) {
      valueStr = _toJsonString(value.cast<String, Object?>());
    } else if (value is List) {
      valueStr = _toJsonList(value.cast<Object?>());
    } else {
      valueStr = '"$value"';
    }
    return '"${e.key}":$valueStr';
  });
  return '{${entries.join(',')}}';
}

String _toJsonList(List<Object?> list) {
  final items = list.map((item) {
    if (item is String) return '"${_escapeJson(item)}"';
    if (item is bool) return item.toString();
    if (item is int) return item.toString();
    if (item is double) return item.toString();
    if (item == null) return 'null';
    if (item is Map) return _toJsonString(item.cast<String, Object?>());
    if (item is List) return _toJsonList(item.cast<Object?>());
    return '"$item"';
  });
  return '[${items.join(',')}]';
}

String _escapeJson(String s) => s
    .replaceAll(r'\', r'\\')
    .replaceAll('"', r'\"')
    .replaceAll('\n', r'\n');

/// Create a mock repo for testing
Repo createMockRepo({
  String name = 'test-repo',
  String fullName = 'user/test-repo',
  String description = 'Test repo description',
  int stars = 10,
  int forks = 5,
  int watchers = 8,
  int openIssues = 2,
  String url = 'https://api.github.com/repos/user/test-repo',
  String htmlUrl = 'https://github.com/user/test-repo',
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? pushedAt,
  String? language = 'Dart',
  bool fork = false,
  bool archived = false,
}) => (
  name: name,
  fullName: fullName,
  description: description,
  stars: stars,
  forks: forks,
  watchers: watchers,
  openIssues: openIssues,
  url: url,
  htmlUrl: htmlUrl,
  createdAt: createdAt ?? DateTime(2023),
  updatedAt: updatedAt ?? DateTime(2024),
  pushedAt: pushedAt,
  language: language,
  fork: fork,
  archived: archived,
);

/// Create a list of mock repos for testing
List<Repo> createMockRepoList(int count) => [
  for (var i = 0; i < count; i++)
    createMockRepo(
      name: 'repo-$i',
      fullName: 'user/repo-$i',
      description: 'Description for repo $i',
      stars: count - i,
      forks: (count - i) ~/ 2,
      watchers: count - i,
      openIssues: i,
      htmlUrl: 'https://github.com/user/repo-$i',
      createdAt: DateTime(2023, 1, i + 1),
      updatedAt: DateTime(2024, 1, count - i),
      language: ['Dart', 'TypeScript', 'Rust', 'Go'][i % 4],
      fork: i % 5 == 0 && i > 0,
      archived: i % 7 == 0 && i > 0,
    ),
];

/// Create a successful fetch result
FetchReposFn successFetch(List<Repo> repos) =>
    () async => nadz.Success<List<Repo>, String>(repos);

/// Create an error fetch result
FetchReposFn errorFetch(String error) =>
    () async => nadz.Error<List<Repo>, String>(error);

/// Create a never-completing fetch for loading state tests
FetchReposFn neverCompleteFetch() =>
    () => Future<nadz.Result<List<Repo>, String>>.delayed(
      const Duration(hours: 1),
      () => const nadz.Success<List<Repo>, String>([]),
    );

// --- Wait Helpers ---

Future<void> waitForText(
  TestRenderResult result,
  String text, {
  int maxAttempts = 20,
  Duration interval = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < maxAttempts; i++) {
    if (result.container.textContent.contains(text)) return;
    await Future<void>.delayed(interval);
  }
  throw StateError('Text "$text" not found after $maxAttempts attempts');
}

Future<void> waitForElement(
  TestRenderResult result,
  String selector, {
  int maxAttempts = 20,
  Duration interval = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < maxAttempts; i++) {
    if (result.container.querySelector(selector) != null) return;
    await Future<void>.delayed(interval);
  }
  throw StateError(
    'Element "$selector" not found after $maxAttempts attempts',
  );
}

Future<void> waitForNoElement(
  TestRenderResult result,
  String selector, {
  int maxAttempts = 20,
  Duration interval = const Duration(milliseconds: 100),
}) async {
  for (var i = 0; i < maxAttempts; i++) {
    if (result.container.querySelector(selector) == null) return;
    await Future<void>.delayed(interval);
  }
  throw StateError('Element "$selector" still present after $maxAttempts');
}
