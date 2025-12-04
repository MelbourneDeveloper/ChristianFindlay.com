/// GitHub API service for fetching repositories
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:nadz/nadz.dart' as nadz;
import 'package:repos/src/types.dart';

const _apiUrl = 'https://api.github.com/users/MelbourneDeveloper/repos';

@JS('fetch')
external JSPromise<JSObject> _jsFetch(JSString url, [JSObject? options]);

/// Fetch all public repos for MelbourneDeveloper
Future<nadz.Result<List<Repo>, String>> fetchRepos() async {
  try {
    final options = <String, Object>{
      'headers': {'Accept': 'application/vnd.github.v3+json'},
    }.jsify()! as JSObject;

    final response =
        await _jsFetch('$_apiUrl?per_page=100&sort=updated'.toJS, options)
            .toDart;
    final ok = response.getProperty<JSBoolean>('ok'.toJS);

    if (!ok.toDart) {
      final status = response.getProperty<JSNumber>('status'.toJS).toDartInt;
      return nadz.Error('GitHub API error: $status');
    }

    final jsonFn = response.getProperty<JSFunction>('json'.toJS);
    final jsonPromise = jsonFn.callAsFunction(response)! as JSPromise<JSArray>;
    final data = await jsonPromise.toDart;
    final repos = _parseRepos(data);
    return nadz.Success(repos);
  } on Object catch (e) {
    return nadz.Error('Failed to fetch repos: $e');
  }
}

List<Repo> _parseRepos(JSArray data) {
  final repos = <Repo>[];
  for (final item in data.toDart) {
    if (item case final JSObject obj) {
      final repo = _parseRepo(obj);
      // Skip forks and archived repos
      if (!repo.fork && !repo.archived) {
        repos.add(repo);
      }
    }
  }
  return repos;
}

Repo _parseRepo(JSObject obj) {
  String getString(String key) {
    final val = obj.getProperty(key.toJS);
    return switch (val) {
      final JSString s => s.toDart,
      _ => '',
    };
  }

  int getInt(String key) {
    final val = obj.getProperty(key.toJS);
    return switch (val) {
      final JSNumber n => n.toDartInt,
      _ => 0,
    };
  }

  bool getBool(String key) {
    final val = obj.getProperty(key.toJS);
    return switch (val) {
      final JSBoolean b => b.toDart,
      _ => false,
    };
  }

  DateTime? parseDate(String key) {
    final val = obj.getProperty(key.toJS);
    return switch (val) {
      final JSString s => DateTime.tryParse(s.toDart),
      _ => null,
    };
  }

  return (
    name: getString('name'),
    fullName: getString('full_name'),
    description: getString('description'),
    stars: getInt('stargazers_count'),
    forks: getInt('forks_count'),
    watchers: getInt('watchers_count'),
    openIssues: getInt('open_issues_count'),
    url: getString('url'),
    htmlUrl: getString('html_url'),
    createdAt: parseDate('created_at') ?? DateTime.now(),
    updatedAt: parseDate('updated_at') ?? DateTime.now(),
    pushedAt: parseDate('pushed_at'),
    language: getString('language'),
    fork: getBool('fork'),
    archived: getBool('archived'),
  );
}
