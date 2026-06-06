<!-- agent-pmo:2c6a5ba -->
# ChristianFindlay.com — Agent Instructions

> ⚠️ **TOKEN DISCIPLINE.** Check file size first. `Grep` over `Read`. Use `offset`/`limit`.
> Smallest diff that solves the problem. Delete dead code, unused CSS, stale comments.
> Bloat degrades reasoning.

> Read this file in full. Rules below are NON-NEGOTIABLE.

> ⚠️ **ACT AUTONOMOUSLY. DO NOT STOP TO ASK THE USER QUESTIONS.** When something is
> ambiguous, choose the most reasonable default, note the assumption, and keep working
> to completion. Deliver finished work plus a short summary of any assumptions made. ⚠️

## Project Overview

The source for **[ChristianFindlay.com](https://www.christianfindlay.com)** — Christian Findlay's
personal Flutter/.NET blog and website. It is a **[Jekyll](https://jekyllrb.com/) static site**
(Ruby) deployed to GitHub Pages on every push to `main`. Blog posts are Markdown in
[`site/_posts/`](site/_posts). A small **Dart** browser app in
[`site/assets/js/repos/`](site/assets/js/repos) (React-in-Dart via `dart_node_react`) compiles to
`site/assets/js/repos.js` and renders the GitHub-repos viewer.

**Primary stack:** Ruby/Jekyll (site) + Dart (the `repos` browser app)
**Build command:** `make build`
**Lint command:** `make lint`
**Test command:** `make test`
**Serve locally:** `make serve` (or `cd site && ./serve.sh`)

## Hard Rules — Universal (no exceptions)

- **Git discipline:**
  - On THIS repo, **direct pushes to `main` are the workflow** — every push to `main` builds and
    deploys to GitHub Pages. There is no PR gate. Keep `main` always-deployable.
  - **NEVER list yourself (the agent) as a commit co-author.** No `Co-Authored-By` trailer.
  - **Work on exactly ONE branch at a time.** Never run `git worktree`.
  - **Do not run git commands unless explicitly requested.**
- **Auto-memory is OFF.** Persistent rules go through an edit to this file — never auto-captured
  memory. (Claude Code: `"autoMemoryEnabled": false` in `.claude/settings.json`.)
- **ZERO DUPLICATION — the highest priority.** Always SEARCH before adding code, CSS, or content.
  **MOVE code/files; do not COPY them.** Use the Deslop MCP tools before and after Dart changes —
  see **Duplication — Deslop** below.
- **NO PLACEHOLDERS.** If a section must be left blank, fail LOUDLY (throw) — never silently no-op.
- **No linter suppressions.** Fix the code.
- **Functions < 20 lines. Files < 500 lines.** Refactor when over.

## CSS / Front-End Rules

- **CONSOLIDATE CSS and remove duplicates.** This is critical.
- **Do NOT name CSS after the section it appears in.** Give classes generic, reusable names so a
  class can be used anywhere on the site.
- Search existing styles before adding new ones; reuse over re-declare.

## Dart Rules (`site/assets/js/repos/`)

- **All Dart, absolutely minimal JS.** The library packages put a TYPED layer over JS interop —
  do **not** expose `JSObject` / `JSAny` etc. in public APIs.
- **Use `async`/`await`. Never `.then()`.**
- **Prefer typedef records with named fields over classes** for data (structural typing, mirrors
  TypeScript).
- **Return `Result<T,E>` from [nadz](https://pub.dev/packages/nadz) for anything that could throw.
  NO THROWING EXCEPTIONS** (the only exception: failing loudly on an unfilled placeholder).
- **No casting.** `as`, `!`, and `late` are ILLEGAL.
- **Use pattern-matching switch expressions or ternaries** — except inside arrays/maps, which are
  declarative.
- **No global state.**
- **Mandatory packages:** [austerity](https://pub.dev/packages/austerity) (lint, via
  `analysis_options.yaml`) and [nadz](https://pub.dev/packages/nadz) (`Result<T,E>`).

## Testing Rules

- **No skipping tests, EVER.** Aggressively unskip any skipped test you find.
- **Failing tests are OK. Removing assertions or tests is ILLEGAL.** Tests must FAIL HARD — never
  add allowances that print warnings instead of failing.
- **Specific assertions only.** `assert(true)` is illegal.
- Dart tests run in Chrome (`platforms: [chrome]` in `dart_test.yaml`) and double as
  integration/widget-style tests. Run with `make test`.

## Duplication — Deslop (Dart)

Deslop earns its keep through **prevention, not cleanup.** The repo's `.deslop-cache/` is local
state (gitignored). Use Deslop's MCP tools on every Dart change:

- **BEFORE authoring** any function, method, class, helper, or test setup → call **`find-similar`**.
  - `signals.fused ≥ 0.85`, or an `identical` / `nearly_identical` bucket → **REUSE it. Do NOT
    write a duplicate.**
  - `0.6 ≤ fused < 0.85` → open the canonical occurrence and bias hard toward reusing it.
  - `fused < 0.6` or empty → proceed.
- **AFTER changing code** → call **`rescan`**, then **`top-offenders`** and **`cluster-by-id`** for
  any cluster you intend to merge. Call **`schema-doc`** once per session to learn the report shape.

## Website — SEO + AI Search

When writing or editing web content, optimise for SEO and AI search:
- [Succeeding in Google's AI search experiences](https://developers.google.com/search/blog/2025/05/succeeding-in-ai-search)
- [SEO Starter Guide](https://developers.google.com/search/docs/fundamentals/seo-starter-guide)

`site/llms.txt`, `site/llms-full.txt`, `site/robots.txt`, and the sitemap (jekyll-sitemap) are part
of the AI/SEO surface — keep them current when content structure changes.

## Build Commands (cross-platform GNU Make, root `Makefile`)

```bash
make build   # compile Dart -> JS, then Jekyll build into ./_site
make lint    # dart analyze (austerity rules) — read-only
make fmt     # dart format (CHECK=1 for read-only CI check)
make test    # run the Dart browser test suite (Chrome)
make clean   # remove _site/, compiled repos.js, .dart_tool, caches
make ci      # lint + test + build
make setup   # bundle install + dart pub get
make serve   # build Dart app and run Jekyll locally
```

`make fmt` formats in-place; `make lint` only analyzes (no formatting); `make test` only tests —
three separate, non-overlapping targets.

## Repo Structure

```
.
├── site/                       # Jekyll site root
│   ├── _config.yml             # Jekyll config (theme: minima, plugins, pagination)
│   ├── Gemfile / Gemfile.lock  # Ruby deps
│   ├── _posts/                 # Blog posts (Markdown)
│   ├── _layouts/  _includes/   # Templates
│   ├── _authors/  _data/       # Collections / data
│   ├── assets/                 # CSS, JS, images
│   │   └── js/repos/           # Dart browser app -> compiled to ../repos.js
│   │       ├── lib/  web/  test/
│   │       ├── pubspec.yaml  analysis_options.yaml  dart_test.yaml
│   │       └── build.sh
│   ├── llms.txt / llms-full.txt / robots.txt
│   └── serve.sh                # local build + serve helper
├── .github/workflows/jekyll.yml  # build + deploy to GitHub Pages on push to main
├── Makefile
├── CNAME                       # christianfindlay.com
└── README.md
```
