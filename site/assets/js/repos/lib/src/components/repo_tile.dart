/// Repository tile component
library;

import 'dart:js_interop';

import 'package:dart_node_react/dart_node_react.dart';
import 'package:repos/src/types.dart';

/// Build a single repo tile using existing post-card CSS
DivElement buildRepoTile(Repo repo, int index) {
  final starUrl = '${repo.htmlUrl}/stargazers';
  final language = repo.language;
  final desc = repo.description.isEmpty
      ? 'No description available'
      : _truncate(repo.description, 100);

  return div(
    className: 'post-card-wrapper',
    props: {
      'key': repo.name,
      'style': {
        'animationDelay': '${index * 50}ms',
      }.jsify(),
    },
    child: div(
      className: 'post-card',
      children: [
        div(
          className: 'post-card-inner',
          children: [
            div(
              className: 'post-card-content',
              style: {'paddingTop': '24px'},
              children: [
                // Language badge
                if (language != null && language.isNotEmpty)
                  div(
                    className: 'post-card-taxonomy',
                    child: div(
                      className: 'taxonomy-chips',
                      child: span(
                        language,
                        className: 'taxonomy-chip category-chip language-badge',
                      ),
                    ),
                  )
                else
                  div(className: 'post-card-taxonomy'),

                // Title
                createElement(
                  'h3'.toJS,
                  createProps({'className': 'post-card-title'}),
                  createElement(
                    'a'.toJS,
                    createProps({
                      'href': repo.htmlUrl,
                      'target': '_blank',
                      'rel': 'noopener noreferrer',
                    }),
                    repo.name.toJS,
                  ),
                ),

                // Stats row
                div(
                  className: 'post-card-meta repo-stats',
                  children: [
                    span('\u2605 ${repo.stars}', className: 'repo-stat'),
                    span('\u{1F374} ${repo.forks}', className: 'repo-stat'),
                    span(
                      '\u{1F41B} ${repo.openIssues}',
                      className: 'repo-stat',
                    ),
                  ],
                ),

                // Description
                div(
                  className: 'post-card-excerpt',
                  child: pEl(desc),
                ),

                // Star button - links to GitHub
                createElement(
                  'a'.toJS,
                  createProps({
                    'href': starUrl,
                    'target': '_blank',
                    'rel': 'noopener noreferrer',
                    'className': 'star-button',
                  }),
                  '\u2605 Star this repo'.toJS,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

String _truncate(String text, int maxLength) =>
    text.length <= maxLength ? text : '${text.substring(0, maxLength)}...';
