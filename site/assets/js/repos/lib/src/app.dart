/// Main App component for repos viewer
library;

import 'dart:async';
import 'dart:js_interop';

import 'package:dart_node_react/dart_node_react.dart';
import 'package:nadz/nadz.dart' as nadz;
import 'package:repos/src/components/repo_grid.dart';
import 'package:repos/src/components/sort_controls.dart';
import 'package:repos/src/services/github_api.dart';
import 'package:repos/src/types.dart';

/// Type for fetch function (injectable for testing)
typedef FetchReposFn = Future<nadz.Result<List<Repo>, String>> Function();

// Store repos outside React - avoids jsify/dartify type loss
List<Repo> _cachedRepos = [];

/// Reset cached repos (for testing)
void resetCachedRepos() => _cachedRepos = [];

/// Main App component
// ignore: non_constant_identifier_names
ReactElement App({FetchReposFn? fetchFn}) => createElement(
  ((JSAny props) {
    final sortState = useState('active');
    final loadingState = useState(true);
    final errorState = useStateJS(null);

    // Fetch repos on mount
    useEffect(() {
      Future<void> loadRepos() async {
        final result = await (fetchFn ?? fetchRepos)();
        switch (result) {
          case nadz.Success(value: final repos):
            _cachedRepos = repos;
            errorState.set(null);
          case nadz.Error(error: final err):
            errorState.set(err.toJS);
        }
        loadingState.set(false);
      }

      unawaited(loadRepos());
      return null;
    }, []);


    // Sort repos when sort option changes
    final sortedRepos = sortRepos(_cachedRepos, sortState.value);
    final gridKey = sortState.value;

    return div(
      className: 'content-wrapper',
      children: [
        // Header section
        div(
          className: 'blog-header-wrapper',
          child: div(
            className: 'blog-header',
            children: [
              h1('What Should I Work On?'),
              div(className: 'header-divider'),
              pEl(
                'Star the repos you want me to prioritize! '
                    'Your stars help me decide what to work on next.',
                className: 'blog-subtitle',
              ),
            ],
          ),
        ),

        // Main content
        div(
          className: 'container',
          children: [
            // Sort controls
            buildSortControls(sortState.value, sortState.set),

            // Repo grid or states
            if (loadingState.value)
              buildLoadingState()
            else if (errorState.value case final JSString err)
              buildErrorState(err.toDart)
            else if (sortedRepos.isEmpty)
              buildEmptyState()
            else
              buildRepoGrid(sortedRepos, sortKey: gridKey),
          ],
        ),
      ],
    );
  }).toJS,
);
