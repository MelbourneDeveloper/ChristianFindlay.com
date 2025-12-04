#!/bin/bash
set -e

echo "Getting dependencies..."
dart pub get

echo "Compiling Dart to JavaScript..."
dart compile js web/app.dart -o ../repos.js -O2

echo "Build complete! The compiled JS is at assets/js/repos.js"
