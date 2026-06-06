# agent-pmo:2c6a5ba
# =============================================================================
# Makefile — ChristianFindlay.com (Jekyll static site + Dart browser app)
# Cross-platform: Linux, macOS, Windows (via GNU Make)
# =============================================================================

.PHONY: build test lint fmt clean ci setup serve

# ---------------------------------------------------------------------------
# OS Detection
# ---------------------------------------------------------------------------
ifeq ($(OS),Windows_NT)
  SHELL := powershell.exe
  .SHELLFLAGS := -NoProfile -Command
  RM = Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
  MKDIR = New-Item -ItemType Directory -Force
  HOME ?= $(USERPROFILE)
else
  RM = rm -rf
  MKDIR = mkdir -p
endif

_SITE_DIR := site
_DART_DIR := site/assets/js/repos
_REPOS_JS := site/assets/js/repos.js

# =============================================================================
# Standard Targets
# Canonical portfolio-wide names. Only the subset that applies to this repo.
# See REPO-STANDARDS-SPEC [MAKE-TARGETS].
# =============================================================================

## build: Compile the Dart app to JS, then build the Jekyll site into ./_site
build:
	@echo "==> Building Dart app -> JS..."
	cd $(_DART_DIR) && dart pub get && dart compile js web/app.dart -o ../repos.js -O2
	@echo "==> Building Jekyll site -> ./_site ..."
	cd $(_SITE_DIR) && bundle install && bundle exec jekyll build --destination ../_site

## lint: Analyze the Dart app (austerity rules). Read-only — does NOT format.
lint:
	@echo "==> Analyzing Dart (austerity)..."
	cd $(_DART_DIR) && dart pub get && dart analyze

## fmt: Format Dart code in-place. Pass CHECK=1 for read-only check (no writes).
fmt:
	@echo "==> Formatting Dart$(if $(CHECK), (check mode),)..."
	cd $(_DART_DIR) && dart format $(if $(CHECK),--output=none --set-exit-if-changed,) .

## test: Run the Dart browser test suite (Chrome).
##       NOTE: package:test has no native --fail-fast flag (REPO-STANDARDS-SPEC
##       [TEST-RULES]); a coverage gate is intentionally omitted for this content site.
test:
	@echo "==> Running Dart tests (Chrome)..."
	cd $(_DART_DIR) && dart pub get && dart test

## clean: Remove build artifacts and caches
clean:
	@echo "==> Cleaning..."
	$(RM) _site
	$(RM) $(_SITE_DIR)/_site
	$(RM) $(_SITE_DIR)/.jekyll-cache
	$(RM) $(_DART_DIR)/.dart_tool
	$(RM) $(_REPOS_JS) $(_REPOS_JS).deps $(_REPOS_JS).map

## ci: lint + test + build (full CI simulation)
ci: lint test build

## setup: Install Ruby (bundler) and Dart dependencies
setup:
	@echo "==> Installing dependencies..."
	cd $(_SITE_DIR) && bundle install
	cd $(_DART_DIR) && dart pub get
	@echo "==> Setup complete. Run 'make ci' to validate."

# =============================================================================
# Repo-Specific Targets (owned by this repo — see [MAKE-REPO-SPECIFIC])
# =============================================================================

## serve: Build the Dart app and run the Jekyll site locally (macOS/Linux)
serve:
	cd $(_SITE_DIR) && ./serve.sh
