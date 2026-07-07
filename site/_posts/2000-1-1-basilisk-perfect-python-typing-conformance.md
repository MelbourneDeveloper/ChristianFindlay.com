---
layout: post
title: "Basilisk Lands in the Python Typing Repo With a 100% Score"
description: "How an independent, Rust-based type checker landed in Python's official conformance results at 100% — ahead of Microsoft's Pyright, Meta's Pyrefly, and Astral's ty."
date: "2026/07/07 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/basilisk/header.webp"
image: "/assets/images/blog/basilisk/header.webp"
tags: python ai
categories: [software development]
permalink: /blog/:title
keywords: [Basilisk, Python type checker, python typing conformance, Pyright, Pyrefly, ty, mypy, Rust type checker, Ruff, Astral]
---

Python has a great type system, but most people don't realize this. The TLDR; is that a Python type checker basically works the same way as Typescript. Type checked Python is to regular Python what Typescript is to JavaScript. For a long time `mypy` was the most common type checker, then Pyright, and the gradual typing story went on. Today there are seven officially recognized type checkers listed in the Python typing repo and the only one with a 100% score is Basilisk, my tool.

The Python type repo has a way to measure who is right. The Python typing team maintains a [conformance test suite](https://github.com/python/typing/tree/main/conformance/tests) — a large body of Python files that each type checker is run against, with the expected errors marked line by line. It is the closest thing the ecosystem has to an objective referee. A tool doesn't get to grade its own homework. The suite grades everyone on the same run and [publishes the results](https://github.com/python/typing/blob/main/conformance/results/results.html).

Today, as of the 7th of July, 2026, [Basilisk](https://www.basilisk-python.dev) was added to those official results. It scored 141 out of 141. A perfect 100%. And it is the only tool on the board that did.

## Key Takeaways

- Basilisk is now listed in the [official python/typing conformance results](https://github.com/python/typing/blob/main/conformance/results/results.html) — merged via [PR #2316](https://github.com/python/typing/pull/2316).
- It passes **141 of 141** conformance test files: 100%, with zero missed errors and zero false positives.
- It is the **sole** tool at a perfect score, ahead of Pyright (Microsoft), Pyrefly (Meta), ty (Astral), mypy, zuban, and pycroscope.
- It is written in Rust and is the fastest type checker according to [my benchmarks](https://www.basilisk-python.dev/docs/benchmarks/).
- None of this would exist without [Ruff](https://github.com/astral-sh/ruff) and the work [Astral](https://astral.sh) put into a fast, correct Python parser.

## What the Conformance Suite Actually Tests

The test suite is a direct encoding of the [Python typing specification](https://typing.python.org/en/latest/spec/index.html). Each test file exercises one corner of the spec — variance, overloads, `TypedDict` readonly semantics, `NewType`, recursive aliases, `ParamSpec`, exhaustive pattern matching, and dozens more. Every line that should produce an error is marked. A file passes only if the checker emits an error on *every* line the suite expects, and emits *nothing* on the lines it doesn't.

That second half is the hard part. Catching required errors is table stakes — every serious tool does that. The place tools lose points is the false positive: firing a diagnostic on code that is perfectly valid according to the spec. A checker that screams at correct code is worse than useless, because you learn to ignore it, and then it's just noise with a progress bar.

Basilisk's score on that suite is 141/141, and the underlying numbers are what I actually care about: **970 required errors caught, 0 missed, 0 false positives.** It is graded by the *unmodified* `python/typing` calculator — the same Python script the typing team runs — pinned to the exact upstream commit, in Basilisk's default configuration with every spec rule turned on. Nothing tuned, nothing disabled, nothing hand-edited. The number you see is the number you get out of the box.

## Why a Perfect Score Is a Big Deal

Here is the leaderboard from the official results, all graded on the same run:

| Tool | Backer | Pass | Score |
|---|---|---|---|
| **Basilisk** | [Nimblesite](https://www.nimblesite.co) | **141 / 141** | **100.0%** |
| zuban | *independent* | 140.5 / 141 | 99.6% |
| Pyrefly | Meta | 138 / 141 | 97.9% |
| Pyright | Microsoft | 136.5 / 141 | 96.8% |
| pycroscope | *independent* | 130 / 141 | 92.2% |
| ty | Astral | 116 / 141 | 82.3% |
| mypy | *independent* | 109 / 141 | 77.3% |

*Source: [python/typing conformance results](https://github.com/python/typing/blob/main/conformance/results/results.html), as published in the run that added Basilisk (July 6, 2026). Each tool links to its live results folder, so you can check the current figures — competitors improve, and these numbers will move.*

Look at who is on that list. Pyright is Microsoft's. Pyrefly is Meta's. ty is [Astral's](https://astral.sh). These are teams with real headcount and real budgets, and they build genuinely good tools. Pyright in particular has been the reference-quality checker for years, and it shows on the board. This is not me saying they're bad. They're excellent.

But none of them is at 100%. Basilisk is.

That's the significance. The conformance suite is not a marketing benchmark you can game. This is the ecosystem's shared definition of "correct," maintained by the same people who write the spec. Being listed in those results at all means Basilisk is now a recognised type checker in the reference set. Being listed at 100% — as the *only* tool there — means an independent project, with a tiny company standing behind it, currently implements the Python type system more completely than the tools shipped by three of the largest software companies on earth. That is not a claim I get to make. The [python/typing repository](https://github.com/python/typing/pull/2316) makes it.

## How Is It This Fast?

Conformance is only half the story, and honestly it's the half people expect to trade away. The usual bargain is that a checker gets more correct by getting slower — more analysis, more passes, more waiting. Basilisk doesn't pay that tax.

It's written in Rust. There's no Node.js runtime to spin up, no Python interpreter to import, no warm-up before the first byte of your code gets looked at. On a cold, from-scratch, single-file check, here's how a representative fixture times out:

| Tool | Cold check |
|---|---|
| **Basilisk** | **~12 ms** (warm cache: **~3.5 ms**) |
| ty | ~31 ms (bear in mind that Ty also uses Salsa caching and is probably just as fast as Basilisk) |
| zuban | ~32 ms |
| Pyrefly | ~111 ms |
| Pyright | ~531 ms |
| mypy `--strict` | ~635 ms |

*Measured with [hyperfine](https://github.com/sharkdp/hyperfine), mean of 10 runs, Apple M4 Max. Every tool runs a cold, full-file CLI check from scratch; `--strict` is used where a tool needs it to perform the analysis the fixture stresses. The two tools with a real cross-run cache (Basilisk and mypy) also report a warm figure. This is Basilisk's own reproducible benchmark harness, not an upstream number — the raw CSV lives in the repo.*

Basilisk is over **40× faster than Pyright** and roughly **50× faster than mypy** on a cold check of the same file. Warm the result cache and it lands under 4 ms — the kind of latency where the feedback feels like syntax highlighting rather than a build step. When your type checker answers before you've finished glancing away, you actually leave it on. And a type checker you leave on is the only kind that helps.

So the trade everyone expects — correctness *or* speed — isn't a trade here. It's both, at the same time, and both directions ratchet. Conformance can only go up; the benchmarks can only go down. That's enforced in CI, not on a promise.

## None of This Exists Without Ruff

Basilisk does not have its own hand-rolled Python parser. It uses [`ruff_python_parser`](https://github.com/astral-sh/ruff) to turn your source into an AST, and it formats code with `ruff_python_formatter`. Both come from [Ruff](https://github.com/astral-sh/ruff), the linter and formatter built by [Astral](https://astral.sh). Charlie Marsh is the man behind all this and it now looks as though Astral is being [acquired by OpenAI](http://localhost:8080/blog/openai-acquires-astral-what-it-means-for-basilisk/). 

Writing a fast, correct, spec-faithful Python parser is a brutal, thankless, multi-year job. It is the kind of foundational work that everyone depends on and nobody thanks anyone for. Charlie Marsh and the team at Astral did that work, in Rust, and — this is the part that matters — they made it *reusable*. Because Ruff's parser is a real crate rather than a locked box, a project like Basilisk can stand on it and put its energy into the type system instead of re-litigating Python's grammar for the tenth time.

If you have enjoyed how fast `ruff` and `uv` made your Python workflow, that's the same team. And frankly, the whole reason a Rust-based Python type checker is even a sane thing to attempt in 2026 is that Astral proved the foundation could carry it. Basilisk's numbers are Basilisk's. The ground they're standing on is theirs.

## Try It

If you want to see it, the fastest path is to [install it in Vscode](https://marketplace.visualstudio.com/items?itemName=Nimblesite.basilisk), or your own IDE. The [website](https://www.basilisk-python.dev) is also full of information and docs. Everything is there — the checker, the LSP, the IDE extension, and the per-rule documentation for every diagnostic it can emit.

Basilisk is strict by default and opinionated on purpose, but it has no modes: every behaviour is a rule you can turn up to an error, down to a warning, or off entirely. You can adopt the full type system on day one, or you can flick the noise down and use it purely as a fast LSP with autofixes and formatting while you migrate an existing codebase at your own pace. That's the point of it — it meets you where your code is, and it gets stricter as you're ready for it.

A perfect conformance score is a nice headline. But it means that when Basilisk tells you your Python is wrong, it is telling you the truth, measured against the spec, with nothing lost in translation. And it tells you in about twelve milliseconds. And the thing is, this is not even the most important aspect of Basilisk. Basilisk is a completely new Python development experience with debugging, refactoring, profiling and all the things that make development easier. Try it out in your IDE today.
