#!/bin/bash
set -e

bundle_cmd=(bundle)
ruby_cmd=(ruby)
if command -v rbenv >/dev/null 2>&1; then
  bundle_cmd=(rbenv exec bundle)
  ruby_cmd=(rbenv exec ruby)
fi

echo "Building Dart React app..."
cd assets/js/repos
dart pub get
dart compile js web/app.dart -o ../repos.js -O2
cd ../../..

echo "Starting Jekyll..."
if [[ " $* " =~ [[:space:]](--port|-P)(=|[[:space:]]) ]]; then
  "${bundle_cmd[@]}" exec jekyll serve "$@"
else
  port="$("${ruby_cmd[@]}" -rsocket -e 'port = ENV.fetch("JEKYLL_PORT", "4000").to_i; loop do; server = TCPServer.new("127.0.0.1", port); server.close; puts port; break; rescue Errno::EADDRINUSE; port += 1; end')"
  echo "Serving on port ${port}..."
  "${bundle_cmd[@]}" exec jekyll serve --port "$port" "$@"
fi
