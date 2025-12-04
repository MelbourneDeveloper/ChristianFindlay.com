/// Type definitions for the repos app
library;

/// Represents a GitHub repository
typedef Repo = ({
  String name,
  String fullName,
  String description,
  int stars,
  int forks,
  int watchers,
  int openIssues,
  String url,
  String htmlUrl,
  DateTime createdAt,
  DateTime updatedAt,
  DateTime? pushedAt,
  String? language,
  bool fork,
  bool archived,
});

/// Sort option for repos
typedef SortOption = ({String id, String label});

/// Available sort options
const sortOptions = <SortOption>[
  (id: 'popular', label: 'Most Popular'),
  (id: 'stars', label: 'Most Stars'),
  (id: 'forks', label: 'Most Forks'),
  (id: 'updated', label: 'Recently Updated'),
  (id: 'created', label: 'Newest'),
  (id: 'oldest', label: 'Oldest'),
  (id: 'active', label: 'Most Active (Last Year)'),
];

/// Calculate popularity score for a repo (weighted composite)
int popularityScore(Repo repo) =>
    (repo.stars * 3) + (repo.forks * 2) + repo.watchers + repo.openIssues;

/// Calculate activity score for a repo based on last year's activity
/// Weights: recent pushes heavily, plus issues, forks, and stars
int activityScore(Repo repo, {DateTime? now}) {
  final currentTime = now ?? DateTime.now();
  final oneYearAgo = currentTime.subtract(const Duration(days: 365));

  // If not pushed in last year, activity is 0
  final pushed = repo.pushedAt;
  if (pushed == null || pushed.isBefore(oneYearAgo)) {
    return 0;
  }

  // Calculate recency score (0-100 based on how recently pushed)
  final daysSincePush = currentTime.difference(pushed).inDays;
  final recencyScore = ((365 - daysSincePush) * 100) ~/ 365;

  // Weight: recency (40%) + issues (30%) + forks (20%) + stars (10%)
  return (recencyScore * 4) +
      (repo.openIssues * 3) +
      (repo.forks * 2) +
      repo.stars;
}

/// Sort repos by the given sort option
List<Repo> sortRepos(List<Repo> repos, String sortId, {DateTime? now}) {
  final sorted = List<Repo>.from(repos);
  switch (sortId) {
    case 'popular':
      sorted.sort((a, b) => popularityScore(b).compareTo(popularityScore(a)));
    case 'stars':
      sorted.sort((a, b) => b.stars.compareTo(a.stars));
    case 'forks':
      sorted.sort((a, b) => b.forks.compareTo(a.forks));
    case 'updated':
      sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    case 'created':
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case 'oldest':
      sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    case 'active':
      sorted.sort(
        (a, b) =>
            activityScore(b, now: now).compareTo(activityScore(a, now: now)),
      );
  }
  return sorted;
}
