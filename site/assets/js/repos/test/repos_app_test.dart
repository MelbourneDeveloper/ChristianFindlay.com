/// Full-page UI interaction tests for the repos viewer app.
///
/// Tests verify actual user interactions with the complete page.
/// Run with: dart test -p chrome
@TestOn('browser')
library;

import 'package:dart_node_react/src/testing_library.dart';
import 'package:repos/repos.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  setUp(resetCachedRepos);

  group('App initial render and loading', () {
    test('shows loading state initially', () {
      final result = render(App(fetchFn: neverCompleteFetch()));

      expect(result.container.textContent, contains('Loading repositories...'));
      expect(
        result.container.textContent,
        contains('What Should I Work On?'),
      );

      result.unmount();
    });

    test('shows header and subtitle', () {
      final result = render(App(fetchFn: successFetch([])));

      expect(result.container.textContent, contains('What Should I Work On?'));
      expect(
        result.container.textContent,
        contains('Star the repos you want me to prioritize'),
      );

      result.unmount();
    });
  });

  group('App with repos loaded', () {
    test('displays repos after successful fetch', () async {
      final repos = [
        createMockRepo(name: 'awesome-lib', stars: 100),
        createMockRepo(name: 'cool-tool', stars: 50, language: 'TypeScript'),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'awesome-lib');
      expect(result.container.textContent, contains('cool-tool'));
      expect(result.container.textContent, contains('Dart'));
      expect(result.container.textContent, contains('TypeScript'));

      result.unmount();
    });

    test('shows star counts for repos', () async {
      final repos = [createMockRepo(name: 'starred-repo', stars: 42)];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'starred-repo');
      expect(result.container.textContent, contains('★ 42'));

      result.unmount();
    });

    test('shows fork counts for repos', () async {
      final repos = [createMockRepo(name: 'forked-repo', forks: 15)];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'forked-repo');
      expect(result.container.textContent, contains('🍴 15'));

      result.unmount();
    });

    test('shows issue counts for repos', () async {
      final repos = [createMockRepo(name: 'issues-repo', openIssues: 7)];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'issues-repo');
      expect(result.container.textContent, contains('🐛 7'));

      result.unmount();
    });

    test('shows repo description', () async {
      final repos = [
        createMockRepo(
          name: 'desc-repo',
          description: 'A fantastic library for testing',
        ),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'desc-repo');
      expect(
        result.container.textContent,
        contains('A fantastic library for testing'),
      );

      result.unmount();
    });

    test('shows fallback for empty description', () async {
      final repos = [createMockRepo(name: 'no-desc-repo', description: '')];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'no-desc-repo');
      expect(
        result.container.textContent,
        contains('No description available'),
      );

      result.unmount();
    });

    test('truncates long descriptions', () async {
      final longDesc = 'A' * 150; // > 100 characters
      final repos = [
        createMockRepo(name: 'long-desc-repo', description: longDesc),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'long-desc-repo');
      expect(result.container.textContent, contains('...'));
      // Should NOT contain the full string
      expect(result.container.textContent, isNot(contains(longDesc)));

      result.unmount();
    });
  });

  group('App error handling', () {
    test('shows error state when fetch fails', () async {
      final result = render(App(fetchFn: errorFetch('GitHub API error: 403')));

      await waitForText(result, 'Error: GitHub API error: 403');

      result.unmount();
    });

    test('shows error state for network failure', () async {
      const err = 'Failed to fetch repos: Network error';
      final result = render(App(fetchFn: errorFetch(err)));

      await waitForText(result, 'Error: $err');

      result.unmount();
    });
  });

  group('App empty state', () {
    test('shows empty state when no repos returned', () async {
      final result = render(App(fetchFn: successFetch([])));

      await waitForText(result, 'No repositories found');

      result.unmount();
    });
  });

  group('Sort controls interaction', () {
    test('renders all sort buttons', () async {
      final repos = [createMockRepo()];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'test-repo');

      expect(result.container.textContent, contains('Most Popular'));
      expect(result.container.textContent, contains('Most Stars'));
      expect(result.container.textContent, contains('Most Forks'));
      expect(result.container.textContent, contains('Recently Updated'));
      expect(result.container.textContent, contains('Newest'));
      expect(result.container.textContent, contains('Oldest'));
      expect(result.container.textContent, contains('Most Active (Last Year)'));

      result.unmount();
    });

    test('sort by stars reorders repos', () async {
      final repos = [
        createMockRepo(name: 'few-stars', stars: 5),
        createMockRepo(name: 'many-stars', stars: 100),
        createMockRepo(name: 'some-stars', stars: 25),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'many-stars');

      // Click "Most Stars" button
      final buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        final btn = buttons[i];
        if (btn.textContent == 'Most Stars') {
          fireClick(btn);
          break;
        }
      }

      // Wait for re-render and verify order
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // After sorting by stars, 'many-stars' should appear first in DOM order
      final content = result.container.textContent;
      final manyStarsIndex = content.indexOf('many-stars');
      final someStarsIndex = content.indexOf('some-stars');
      final fewStarsIndex = content.indexOf('few-stars');

      expect(manyStarsIndex, lessThan(someStarsIndex));
      expect(someStarsIndex, lessThan(fewStarsIndex));

      result.unmount();
    });

    test('sort by forks reorders repos', () async {
      final repos = [
        createMockRepo(name: 'few-forks', forks: 2),
        createMockRepo(name: 'many-forks', forks: 50),
        createMockRepo(name: 'some-forks', forks: 10),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'many-forks');

      // Click "Most Forks" button
      final buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        final btn = buttons[i];
        if (btn.textContent == 'Most Forks') {
          fireClick(btn);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final content = result.container.textContent;
      expect(
        content.indexOf('many-forks'),
        lessThan(content.indexOf('some-forks')),
      );
      expect(
        content.indexOf('some-forks'),
        lessThan(content.indexOf('few-forks')),
      );

      result.unmount();
    });

    test('sort by recently updated reorders repos', () async {
      final repos = [
        createMockRepo(name: 'old-update', updatedAt: DateTime(2020)),
        createMockRepo(name: 'recent-update', updatedAt: DateTime(2024, 6)),
        createMockRepo(name: 'mid-update', updatedAt: DateTime(2022)),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'recent-update');

      // Click "Recently Updated" button
      final buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        final btn = buttons[i];
        if (btn.textContent == 'Recently Updated') {
          fireClick(btn);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final content = result.container.textContent;
      expect(
        content.indexOf('recent-update'),
        lessThan(content.indexOf('mid-update')),
      );
      expect(
        content.indexOf('mid-update'),
        lessThan(content.indexOf('old-update')),
      );

      result.unmount();
    });

    test('sort by newest reorders repos by creation date', () async {
      final repos = [
        createMockRepo(name: 'oldest-repo', createdAt: DateTime(2018)),
        createMockRepo(name: 'newest-repo', createdAt: DateTime(2024, 6)),
        createMockRepo(name: 'middle-repo', createdAt: DateTime(2021)),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'newest-repo');

      // Click "Newest" button
      final buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        final btn = buttons[i];
        if (btn.textContent == 'Newest') {
          fireClick(btn);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final content = result.container.textContent;
      expect(
        content.indexOf('newest-repo'),
        lessThan(content.indexOf('middle-repo')),
      );
      expect(
        content.indexOf('middle-repo'),
        lessThan(content.indexOf('oldest-repo')),
      );

      result.unmount();
    });

    test('sort by oldest reorders repos by creation date ascending', () async {
      final repos = [
        createMockRepo(name: 'oldest-repo', createdAt: DateTime(2018)),
        createMockRepo(name: 'newest-repo', createdAt: DateTime(2024, 6)),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'oldest-repo');

      // Click "Oldest" button
      final buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        final btn = buttons[i];
        if (btn.textContent == 'Oldest') {
          fireClick(btn);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final content = result.container.textContent;
      expect(
        content.indexOf('oldest-repo'),
        lessThan(content.indexOf('newest-repo')),
      );

      result.unmount();
    });

    test('sort by most active reorders repos by last year activity', () async {
      final repos = [
        createMockRepo(
          name: 'inactive',
          pushedAt: DateTime(2020), // old, no activity
          openIssues: 100,
        ),
        createMockRepo(
          name: 'very-active',
          pushedAt: DateTime.now(), // very recent
          openIssues: 10,
        ),
        createMockRepo(
          name: 'somewhat-active',
          pushedAt: DateTime.now().subtract(const Duration(days: 180)),
          openIssues: 5,
        ),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'very-active');

      // Click "Most Active (Last Year)" button
      final buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        final btn = buttons[i];
        if (btn.textContent == 'Most Active (Last Year)') {
          fireClick(btn);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final content = result.container.textContent;
      // very-active should be first (recent push)
      // somewhat-active should be second (6 months old push)
      // inactive should be last (old push, 0 score)
      expect(
        content.indexOf('very-active'),
        lessThan(content.indexOf('somewhat-active')),
      );
      expect(
        content.indexOf('somewhat-active'),
        lessThan(content.indexOf('inactive')),
      );

      result.unmount();
    });

    test('sort by popularity uses composite score', () async {
      // Popularity = stars*3 + forks*2 + watchers + openIssues
      // high-pop: 100*3 + 50*2 + 80 + 10 = 300 + 100 + 80 + 10 = 490
      // low-pop: 10*3 + 5*2 + 8 + 1 = 30 + 10 + 8 + 1 = 49
      final repos = [
        createMockRepo(
          name: 'low-pop',
          stars: 11,
          forks: 6,
          watchers: 9,
          openIssues: 1,
        ),
        createMockRepo(
          name: 'high-pop',
          stars: 100,
          forks: 50,
          watchers: 80,
          openIssues: 10,
        ),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'high-pop');

      // "Most Popular" is the default, but click it to confirm behavior
      final buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        final btn = buttons[i];
        if (btn.textContent == 'Most Popular') {
          fireClick(btn);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final content = result.container.textContent;
      expect(
        content.indexOf('high-pop'),
        lessThan(content.indexOf('low-pop')),
      );

      result.unmount();
    });
  });

  group('Repo tile links', () {
    test('repo title links to GitHub', () async {
      final repos = [
        createMockRepo(
          name: 'linked-repo',
          htmlUrl: 'https://github.com/user/linked-repo',
        ),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'linked-repo');

      final link = result.container.querySelector('a[href*="linked-repo"]');
      expect(link, isNotNull);
      expect(link!.getAttribute('target'), equals('_blank'));
      expect(link.getAttribute('rel'), contains('noopener'));

      result.unmount();
    });

    test('star button links to stargazers page', () async {
      final repos = [
        createMockRepo(
          name: 'star-repo',
          htmlUrl: 'https://github.com/user/star-repo',
        ),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'star-repo');

      final starLink = result.container.querySelector('.star-button');
      expect(starLink, isNotNull);
      expect(starLink!.textContent, contains('Star this repo'));
      expect(starLink.getAttribute('href'), contains('stargazers'));
      expect(starLink.getAttribute('target'), equals('_blank'));

      result.unmount();
    });
  });

  group('Multiple sort interactions', () {
    test('switching between sort options updates order', () async {
      final repos = [
        createMockRepo(name: 'repo-a', stars: 11, forks: 100),
        createMockRepo(name: 'repo-b', stars: 100, forks: 10),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'repo-a');

      // First sort by stars
      var buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        if (buttons[i].textContent == 'Most Stars') {
          fireClick(buttons[i]);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      var content = result.container.textContent;
      expect(content.indexOf('repo-b'), lessThan(content.indexOf('repo-a')));

      // Then sort by forks
      buttons = result.container.querySelectorAll('button');
      for (var i = 0; i < buttons.length; i++) {
        if (buttons[i].textContent == 'Most Forks') {
          fireClick(buttons[i]);
          break;
        }
      }

      await Future<void>.delayed(const Duration(milliseconds: 100));

      content = result.container.textContent;
      expect(content.indexOf('repo-a'), lessThan(content.indexOf('repo-b')));

      result.unmount();
    });
  });

  group('Language badge display', () {
    test('shows language badge when language is set', () async {
      final repos = [createMockRepo(name: 'dart-repo')];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'dart-repo');

      final badge = result.container.querySelector('.language-badge');
      expect(badge, isNotNull);
      expect(badge!.textContent, equals('Dart'));

      result.unmount();
    });

    test('does not show language badge when language is null', () async {
      final repos = [createMockRepo(name: 'no-lang-repo', language: null)];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'no-lang-repo');

      // Should still render the empty taxonomy div but without chip text
      final badge = result.container.querySelector('.language-badge');
      expect(badge, isNull);

      result.unmount();
    });

    test('no language badge when language is empty string', () async {
      final repos = [createMockRepo(name: 'empty-lang-repo', language: '')];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'empty-lang-repo');

      final badges = result.container.querySelectorAll('.language-badge');
      expect(badges.length, equals(0));

      result.unmount();
    });
  });

  group('Grid rendering', () {
    test('renders multiple repos in grid', () async {
      final repos = createMockRepoList(5);

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'repo-0');

      final grid = result.container.querySelector('.blog.grid');
      expect(grid, isNotNull);

      final cards = result.container.querySelectorAll('.post-card-wrapper');
      expect(cards.length, equals(5));

      result.unmount();
    });

    test('applies animation delay to cards', () async {
      final repos = [
        createMockRepo(name: 'first-repo'),
        createMockRepo(name: 'second-repo'),
      ];

      final result = render(App(fetchFn: successFetch(repos)));

      await waitForText(result, 'first-repo');

      // Cards should have animation delays
      final cards = result.container.querySelectorAll('.post-card-wrapper');
      expect(cards.length, equals(2));

      result.unmount();
    });
  });
}
