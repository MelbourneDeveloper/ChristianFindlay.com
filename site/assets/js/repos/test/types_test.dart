/// Unit tests for types and sorting logic.
///
/// These tests don't need browser - they test pure Dart logic.
library;

import 'package:repos/src/types.dart';
import 'package:test/test.dart';

import 'test_helpers.dart';

void main() {
  group('popularityScore', () {
    test('calculates weighted score correctly', () {
      final repo = createMockRepo(
        stars: 11,
        forks: 6,
        watchers: 3,
        openIssues: 1,
      );
      // 11*3 + 6*2 + 3 + 1 = 33 + 12 + 3 + 1 = 49
      expect(popularityScore(repo), equals(49));
    });

    test('returns 0 for repo with all zeros', () {
      final repo = createMockRepo(
        stars: 0,
        forks: 0,
        watchers: 0,
        openIssues: 0,
      );
      expect(popularityScore(repo), equals(0));
    });

    test('stars have highest weight', () {
      final highStars = createMockRepo(stars: 100, forks: 0, watchers: 0);
      final highForks = createMockRepo(stars: 0, forks: 100, watchers: 0);
      final highWatchers = createMockRepo(stars: 0, forks: 0, watchers: 100);

      expect(
        popularityScore(highStars),
        greaterThan(popularityScore(highForks)),
      );
      expect(
        popularityScore(highForks),
        greaterThan(popularityScore(highWatchers)),
      );
    });
  });

  group('activityScore', () {
    test('returns 0 for repo not pushed in last year', () {
      final now = DateTime(2024, 6, 15);
      final repo = createMockRepo(
        pushedAt: DateTime(2023, 6, 14), // just over 1 year ago
        openIssues: 100,
        forks: 50,
        stars: 200,
      );

      expect(activityScore(repo, now: now), equals(0));
    });

    test('returns 0 for repo with null pushedAt', () {
      final now = DateTime(2024, 6, 15);
      final repo = createMockRepo(openIssues: 100);

      expect(activityScore(repo, now: now), equals(0));
    });

    test('calculates score based on recency, issues, forks, stars', () {
      final now = DateTime(2024, 6, 15);
      // Pushed today (0 days ago): recency = 100
      final repo = createMockRepo(
        pushedAt: DateTime(2024, 6, 15),
        openIssues: 10,
        forks: 20,
        stars: 30,
      );

      // recency*4 + issues*3 + forks*2 + stars
      // 100*4 + 10*3 + 20*2 + 30 = 400 + 30 + 40 + 30 = 500
      expect(activityScore(repo, now: now), equals(500));
    });

    test('recent pushes score higher than old pushes', () {
      final now = DateTime(2024, 6, 15);
      final recentPush = createMockRepo(
        name: 'recent',
        pushedAt: DateTime(2024, 6, 10), // 5 days ago
        openIssues: 1,
        forks: 1,
        stars: 1,
      );
      final oldPush = createMockRepo(
        name: 'old',
        pushedAt: DateTime(2023, 12, 15), // 6 months ago
        openIssues: 1,
        forks: 1,
        stars: 1,
      );

      expect(
        activityScore(recentPush, now: now),
        greaterThan(activityScore(oldPush, now: now)),
      );
    });

    test('repos pushed exactly 1 year ago have 0 score', () {
      final now = DateTime(2024, 6, 15);
      final repo = createMockRepo(
        pushedAt: DateTime(2023, 6, 15), // exactly 1 year ago
        openIssues: 100,
      );

      expect(activityScore(repo, now: now), equals(0));
    });
  });

  group('sortRepos', () {
    group('popular sort', () {
      test('sorts by popularity score descending', () {
        final repos = [
          createMockRepo(name: 'low', stars: 1, forks: 1),
          createMockRepo(name: 'high', stars: 100, forks: 50),
          createMockRepo(name: 'mid', stars: 11, forks: 6),
        ];

        final sorted = sortRepos(repos, 'popular');

        expect(sorted[0].name, equals('high'));
        expect(sorted[1].name, equals('mid'));
        expect(sorted[2].name, equals('low'));
      });

      test('does not mutate original list', () {
        final repos = [
          createMockRepo(name: 'z'),
          createMockRepo(name: 'a'),
        ];

        sortRepos(repos, 'popular');

        expect(repos[0].name, equals('z'));
        expect(repos[1].name, equals('a'));
      });
    });

    group('stars sort', () {
      test('sorts by star count descending', () {
        final repos = [
          createMockRepo(name: 'few', stars: 5),
          createMockRepo(name: 'many', stars: 500),
          createMockRepo(name: 'some', stars: 50),
        ];

        final sorted = sortRepos(repos, 'stars');

        expect(sorted[0].name, equals('many'));
        expect(sorted[1].name, equals('some'));
        expect(sorted[2].name, equals('few'));
      });
    });

    group('forks sort', () {
      test('sorts by fork count descending', () {
        final repos = [
          createMockRepo(name: 'few', forks: 2),
          createMockRepo(name: 'many', forks: 200),
          createMockRepo(name: 'some', forks: 20),
        ];

        final sorted = sortRepos(repos, 'forks');

        expect(sorted[0].name, equals('many'));
        expect(sorted[1].name, equals('some'));
        expect(sorted[2].name, equals('few'));
      });
    });

    group('updated sort', () {
      test('sorts by updated date descending', () {
        final repos = [
          createMockRepo(name: 'old', updatedAt: DateTime(2020)),
          createMockRepo(name: 'new', updatedAt: DateTime(2024, 12)),
          createMockRepo(name: 'mid', updatedAt: DateTime(2022, 6)),
        ];

        final sorted = sortRepos(repos, 'updated');

        expect(sorted[0].name, equals('new'));
        expect(sorted[1].name, equals('mid'));
        expect(sorted[2].name, equals('old'));
      });
    });

    group('created sort', () {
      test('sorts by created date descending (newest first)', () {
        final repos = [
          createMockRepo(name: 'oldest', createdAt: DateTime(2015)),
          createMockRepo(name: 'newest', createdAt: DateTime(2024)),
          createMockRepo(name: 'middle', createdAt: DateTime(2020)),
        ];

        final sorted = sortRepos(repos, 'created');

        expect(sorted[0].name, equals('newest'));
        expect(sorted[1].name, equals('middle'));
        expect(sorted[2].name, equals('oldest'));
      });
    });

    group('oldest sort', () {
      test('sorts by created date ascending (oldest first)', () {
        final repos = [
          createMockRepo(name: 'oldest', createdAt: DateTime(2015)),
          createMockRepo(name: 'newest', createdAt: DateTime(2024)),
          createMockRepo(name: 'middle', createdAt: DateTime(2020)),
        ];

        final sorted = sortRepos(repos, 'oldest');

        expect(sorted[0].name, equals('oldest'));
        expect(sorted[1].name, equals('middle'));
        expect(sorted[2].name, equals('newest'));
      });
    });

    group('active sort', () {
      test('sorts by activity score descending', () {
        final now = DateTime(2024, 6, 15);
        final repos = [
          createMockRepo(
            name: 'inactive',
            pushedAt: DateTime(2022), // > 1 year ago
            openIssues: 100,
            forks: 100,
            stars: 100,
          ),
          createMockRepo(
            name: 'very-active',
            pushedAt: DateTime(2024, 6, 10), // 5 days ago
            openIssues: 10,
            forks: 20,
            stars: 30,
          ),
          createMockRepo(
            name: 'somewhat-active',
            pushedAt: DateTime(2024), // ~6 months ago
            openIssues: 5,
            forks: 10,
            stars: 16,
          ),
        ];

        final sorted = sortRepos(repos, 'active', now: now);

        expect(sorted[0].name, equals('very-active'));
        expect(sorted[1].name, equals('somewhat-active'));
        expect(sorted[2].name, equals('inactive'));
      });

      test('repos not pushed in last year have 0 activity', () {
        final now = DateTime(2024, 6, 15);
        final repos = [
          createMockRepo(
            name: 'old',
            pushedAt: DateTime(2023, 6, 14), // just over 1 year
            openIssues: 100,
          ),
          createMockRepo(
            name: 'recent',
            pushedAt: DateTime(2024, 6, 14), // 1 day ago
            openIssues: 1,
          ),
        ];

        final sorted = sortRepos(repos, 'active', now: now);

        expect(sorted[0].name, equals('recent'));
        expect(sorted[1].name, equals('old'));
      });
    });

    group('unknown sort', () {
      test('returns list unchanged for unknown sort id', () {
        final repos = [
          createMockRepo(name: 'a'),
          createMockRepo(name: 'b'),
          createMockRepo(name: 'c'),
        ];

        final sorted = sortRepos(repos, 'unknown_sort');

        expect(sorted[0].name, equals('a'));
        expect(sorted[1].name, equals('b'));
        expect(sorted[2].name, equals('c'));
      });
    });

    group('edge cases', () {
      test('handles empty list', () {
        final sorted = sortRepos(<Repo>[], 'stars');
        expect(sorted, isEmpty);
      });

      test('handles single item list', () {
        final repos = [createMockRepo(name: 'only')];
        final sorted = sortRepos(repos, 'stars');
        expect(sorted.length, equals(1));
        expect(sorted[0].name, equals('only'));
      });

      test('handles repos with equal values', () {
        final repos = [
          createMockRepo(name: 'a', stars: 15),
          createMockRepo(name: 'b', stars: 15),
          createMockRepo(name: 'c', stars: 15),
        ];

        final sorted = sortRepos(repos, 'stars');

        expect(sorted.length, equals(3));
        // All have same stars, so order is stable
      });
    });
  });

  group('sortOptions', () {
    test('contains expected sort options', () {
      expect(sortOptions.length, equals(7));

      final ids = sortOptions.map((o) => o.id).toList();
      expect(ids, contains('popular'));
      expect(ids, contains('stars'));
      expect(ids, contains('forks'));
      expect(ids, contains('updated'));
      expect(ids, contains('created'));
      expect(ids, contains('oldest'));
      expect(ids, contains('active'));
    });

    test('all options have labels', () {
      for (final option in sortOptions) {
        expect(option.label, isNotEmpty);
      }
    });

    test('all options have unique ids', () {
      final ids = sortOptions.map((o) => o.id).toSet();
      expect(ids.length, equals(sortOptions.length));
    });
  });

  group('Repo typedef', () {
    test('can create repo with all fields', () {
      final repo = createMockRepo(
        name: 'test',
        fullName: 'user/test',
        description: 'A test repo',
        stars: 42,
        forks: 10,
        watchers: 35,
        openIssues: 5,
        url: 'https://api.github.com/repos/user/test',
        htmlUrl: 'https://github.com/user/test',
        createdAt: DateTime(2020),
        updatedAt: DateTime(2024),
        pushedAt: DateTime(2024, 1, 2),
      );

      expect(repo.name, equals('test'));
      expect(repo.fullName, equals('user/test'));
      expect(repo.description, equals('A test repo'));
      expect(repo.stars, equals(42));
      expect(repo.forks, equals(10));
      expect(repo.watchers, equals(35));
      expect(repo.openIssues, equals(5));
      expect(repo.language, equals('Dart'));
      expect(repo.fork, isFalse);
      expect(repo.archived, isFalse);
    });

    test('can create repo with nullable pushedAt', () {
      final repo = createMockRepo();
      expect(repo.pushedAt, isNull);
    });

    test('can create repo with nullable language', () {
      final repo = createMockRepo(language: null);
      expect(repo.language, isNull);
    });
  });
}
