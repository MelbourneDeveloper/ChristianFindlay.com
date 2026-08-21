---
layout: post
title: "Find Duplicate Dart and Flutter Code with Kevin Moore's Deslop Skill"
description: "Kevin Moore built an agent skill that runs a Deslop duplication audit over Dart and Flutter repos. Here is what it does, and why it tells the agent to reject some duplicates."
date: "2026/08/15 00:00:00 +1000"
author: "Christian Findlay"
post_image: "/assets/images/blog/deslop/dart-flutter-duplication-audit.webp"
post_image_width: 1672
post_image_height: 941
image: "/assets/images/blog/deslop/dart-flutter-duplication-audit.webp"
tags: dart code-quality ai deslop
categories: [flutter]
permalink: /blog/:title
keywords: [Dart duplicate code, Flutter duplicate code, Flutter code quality, Dart code duplication, code clone detection Dart, Deslop, agent skills, Claude Code skills, Flutter refactoring, dart analyze, Flutter clean architecture]
---

Deslop is a code deduplication tool I've been working on recently. It supports Dart, C# and seven other languages. Last week, [Kevin Moore](https://x.com/kevmoo) the Google Product Manager for Flutter and Dart published an [agent skill](https://github.com/kevmoo/kevmoo_skills/blob/main/skills/deslop-duplication-audit/SKILL.md) that runs [Deslop](https://deslop.live) over Dart and Flutter repositories. It's the procedure around detection: when to scan, when to stop, and which findings to leave alone.

> **Key Takeaways**: Kevin Moore's `deslop-duplication-audit` skill turns a Deslop scan into a four-phase protocol: read-only discovery, a hard stop for user confirmation, an architectural verdict on each cluster, then test-gated refactoring. The verdict phase is the important one, because it explicitly tells the agent to reject some duplicates and leave the code alone. 

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">github.com/kevmoo/kevmoo_… - another skill, wrapping the amazing tool by <a href="https://twitter.com/CFDevelop?ref_src=twsrc%5Etfw">@CFDevelop</a> - this CLI is super useful. The skill just streamlines bits for your favorite agent!</p>&mdash; Kevin Moore (@kevmoo) <a href="https://twitter.com/kevmoo/status/2087782702993084791?ref_src=twsrc%5Etfw">August 13, 2026</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## What an Agent Skill Actually Is

A skill is a Markdown file with front matter. `SKILL.md` describes what the skill does and when to use it, the agent loads the body only when the task matches, and the body contains instructions the agent follows instead of improvising. Kevin's [skills repo](https://github.com/kevmoo/kevmoo_skills) has fourteen of them, covering Gerrit stacked CLs, PR triage, worktrees, and semantic diffs.

The duplication audit skill ships with a Dart package next to the Markdown. `bin/deslop_report.dart` shells out to the Deslop CLI, parses the JSON report, and prints a compact Markdown summary with clickable source links. That matters more than it sounds. A raw duplication report on a real repository is thousands of lines of JSON, and an agent that reads thousands of lines of JSON has less room left to think.

## The Four Phases

The skill splits the work into phases, and each phase has a gate at the end.

**Phase 1 is read-only.** The agent runs the report script and nothing else. It can scan a whole directory, or it can filter clusters against a diff so it only reports duplication introduced by the current pull request:

```bash
dart run skills/deslop-duplication-audit/bin/deslop_report.dart \
  --dir {repo_dir} \
  --diff-cmd "git diff main...HEAD" \
  --only-changed
```

That flag is the difference between a useful review and a useless one. Point a clone detector at a five-year-old Flutter codebase and it will find plenty. Almost none of it is your problem today. `--only-changed` narrows the report to code the current change touched, which is the code somebody is still willing to modify.

There's a `--diff-cmd "jj diff"` variant in the skill too, because Kevin works in Google3, where the version control is Jujutsu and the unit of change is a CL rather than a PR.

**Phase 2 is a hard stop.** The agent presents what it found and is forbidden from editing anything. It has to ask whether you want to remediate, and where: the current branch, a new feature branch, or an isolated git worktree.

**Phase 3 is the architectural verdict**, which I'll come back to below.

**Phase 4 is empirical verification.** Run the tests before touching anything, and stop immediately if the baseline is already broken. Make surgical edits. Re-run `dart analyze --fatal-infos` and the test suite. Stage the diff locally, report the line delta, and stop without committing.

None of these steps are clever. All of them are things an unsupervised agent skips.

## The Verdict Phase Is the Interesting One

Most tooling around code quality assumes every finding is a defect. Kevin's skill assumes the opposite, and the wording is blunt:

> **Do not treat every duplicate finding as a bug or mandatory refactoring target.** Deslop compares tree-sitter AST shapes, which can flag legitimate structural patterns.

He then lists the cases the agent should refuse to refactor. Type-unsafe polymorphic AST targets, where two similar-looking classes have no shared interface and unifying them means `dynamic` or a cast. Performance-critical solver loops, where combining a horizontal and a vertical traversal means allocating a closure inside a tight loop. Trivial `try/catch` wrappers in standalone `bin/*.dart` entry points, where the abstraction costs you scannability and buys nothing.

When a cluster falls into that bucket, the skill says to record a verdict of **Rejected**, write down the technical reason, and leave the code completely untouched.

I think that's the right split. Deslop's job is to produce evidence: these six fragments have the same shape, here they are ranked worst-first. Deciding whether six fragments represent the same *knowledge* is a design judgement. An agent that treats a similarity score as a work order will happily destroy a perfectly good codebase and report a net line reduction as if that were the goal.

## A Dart Duplicate That Grep Won't Find

Here's the shape the scanner cares about. Two decoders, written by two different people or two different agent sessions, six months apart:

```dart
typedef Product = ({String id, String name, double price});
typedef Customer = ({String id, String fullName, double balance});

List<Product> decodeProducts(List<Map<String, Object?>> rows) => [
  for (final row in rows)
    if (row case {
      'id': final String id,
      'name': final String name,
      'price': final num price,
    })
      (id: id, name: name, price: price.toDouble()),
];

List<Customer> decodeCustomers(List<Map<String, Object?>> records) => [
  for (final record in records)
    if (record case {
      'id': final String key,
      'full_name': final String label,
      'balance': final num amount,
    })
      (id: key, fullName: label, balance: amount.toDouble()),
];
```

Searching for `decodeProducts` finds one of these. Searching for `rows` finds one of these. The identifiers differ, the JSON keys differ, and the return types differ, so a text comparison has nothing to grab. Structurally they are the same function: iterate rows, destructure with a map pattern, skip anything that doesn't match, build a record. Researchers call this a Type-2 clone, and it's the point where plain search stops working. I covered the full clone taxonomy in the [C# version of this article](find-duplicate-code-csharp-deslop).

You can collapse the shape without giving up type safety:

```dart
List<T> decodeRows<T>(
  List<Map<String, Object?>> rows,
  T? Function(Map<String, Object?> row) decode,
) => [
  for (final row in rows)
    if (decode(row) case final T value) value,
];

final products = decodeRows(
  rows,
  (row) => switch (row) {
    {
      'id': final String id,
      'name': final String name,
      'price': final num price,
    } =>
      (id: id, name: name, price: price.toDouble()),
    _ => null,
  },
);
```

No casts, no `!`, and the null filtering happens in the pattern. If you haven't used this style, [Dart switch expressions](dart-switch-expressions) and [algebraic data types in Dart](dart-algebraic-data-types) are the two things to read first.

Now apply Kevin's Phase 3 gate to it honestly. With two decoders, extracting `decodeRows` is arguably a wash — you've traded two readable functions for one generic function plus two closures. With twelve decoders across four feature folders, and a backend that keeps changing its date format, it isn't a wash at all. The detector can't tell you which situation you're in. That's why the skill makes a human answer.

## Detection and Prevention Are Two Different Jobs

Kevin's skill is an audit. It runs when you ask it to, over a repository or a diff.

The other half of the loop runs continuously. Deslop's MCP server exposes `find-similar`, which an agent calls *before* it writes a function, and gets back the canonical implementation if one already exists. I have that enforced in the `AGENTS.md` of every repo I work in: call `find-similar` before authoring anything, and if the fused similarity signal comes back above 0.85, reuse the existing code instead of adding a fourth copy.

Prevention is cheaper than remediation, because the second copy is free to not write and expensive to delete once three files import it. But prevention only covers code written from now on. Every repository already contains the copies made before anyone was watching, and that's what an audit skill is for. Use both.

## Running It Yourself

Install the CLI:

```bash
brew install nimblesite/tap/deslop
```

Or `scoop install deslop` on Windows, or grab a binary from the [releases page](https://deslop.live/releases/). If you want live warnings in the editor as well, the [VS Code extension](https://marketplace.visualstudio.com/items?itemName=nimblesite.deslop-live) bundles the CLI, the LSP, and the MCP server in one install, and it handles `.dart` alongside eight other languages.

Then run a scan directly:

```bash
deslop . --min-nodes 30
```

Or copy `skills/deslop-duplication-audit/` out of [Kevin's repo](https://github.com/kevmoo/kevmoo_skills) into your project's skills directory and let the agent drive the protocol.

Start with the top three clusters. Refactor one. Reject one, and write down why you rejected it. The rejection isn't a failure of the tool — it's the part of the process that keeps the tool from becoming a liability.

<small>Note that some or all of the content here was written with the assistance of AI. [View the AI Content Policy](ai-writing)</small>
