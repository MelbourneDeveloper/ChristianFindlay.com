#!/bin/bash
set -e

echo "Building Dart React app..."
cd assets/js/repos
dart pub get
dart compile js web/app.dart -o ../repos.js -O2
cd ../../..

echo "Starting Jekyll..."
bundle exec jekyll serve "$@"
