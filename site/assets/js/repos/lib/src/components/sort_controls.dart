/// Sort controls component
library;

import 'dart:js_interop';

import 'package:dart_node_react/dart_node_react.dart';
import 'package:repos/src/types.dart';

/// Build sort controls using existing site button styles
DivElement buildSortControls(
  String currentSort,
  void Function(String) onSortChange,
) => div(
  className: 'sort-controls',
  style: {
    'display': 'flex',
    'flexWrap': 'wrap',
    'gap': '8px',
    'justifyContent': 'center',
    'marginBottom': '32px',
  },
  children: [
    for (final option in sortOptions)
      _buildSortButton(option, currentSort, onSortChange),
  ],
);

ReactElement _buildSortButton(
  SortOption option,
  String currentSort,
  void Function(String) onSortChange,
) {
  final isActive = option.id == currentSort;
  return createElement(
    'button'.toJS,
    createProps({
      'key': option.id,
      'className': isActive
          ? 'taxonomy-chip category-chip'
          : 'taxonomy-chip tag-chip',
      'onClick': ((JSAny? _) => onSortChange(option.id)).toJS,
      'style': {
        'cursor': 'pointer',
        'border': 'none',
        'fontSize': '0.85rem',
        'padding': '8px 16px',
        'transition': 'all 0.2s ease',
      }.jsify(),
    }),
    option.label.toJS,
  );
}
