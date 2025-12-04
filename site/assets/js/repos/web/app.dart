import 'package:dart_node_react/dart_node_react.dart';
import 'package:repos/src/app.dart';

void main() {
  final root = Document.getElementById('repos-root');
  (root != null)
      ? ReactDOM.createRoot(root).render(App())
      : throw StateError('Root element #repos-root not found');
}
