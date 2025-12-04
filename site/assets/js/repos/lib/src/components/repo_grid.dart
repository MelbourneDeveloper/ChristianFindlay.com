/// Repository grid component
library;

import 'package:dart_node_react/dart_node_react.dart';
import 'package:repos/src/components/repo_tile.dart';
import 'package:repos/src/types.dart';

/// Build the repo grid using existing blog grid CSS
DivElement buildRepoGrid(List<Repo> repos) => div(
  className: 'blog grid',
  style: {
    'transition': 'all 0.4s ease',
  },
  children: [
    for (var i = 0; i < repos.length; i++) buildRepoTile(repos[i], i),
  ],
);

/// Build empty state when no repos
DivElement buildEmptyState() => div(
  className: 'empty-state',
  style: {
    'textAlign': 'center',
    'padding': '48px',
  },
  child: pEl(
    'No repositories found.',
    className: 'blog-subtitle',
  ),
);

/// Build loading state
DivElement buildLoadingState() => div(
  className: 'loading-state',
  style: {
    'textAlign': 'center',
    'padding': '48px',
  },
  child: pEl(
    'Loading repositories...',
    className: 'blog-subtitle',
  ),
);

/// Build error state
DivElement buildErrorState(String error) => div(
  className: 'error-state',
  style: {
    'textAlign': 'center',
    'padding': '48px',
    'color': 'var(--danger)',
  },
  child: pEl(
    'Error: $error',
    className: 'blog-subtitle',
  ),
);
