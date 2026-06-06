---
layout: post
title: "Why I Built Basilisk"
date: "2026/06/07 00:00:00 +1000"
author: "Christian Findlay"
post_image: "/assets/images/blog/basilisk/header.webp"
post_image_width: 1672
post_image_height: 941
image: "/assets/images/blog/basilisk/header.webp"
description: "Why I built Basilisk: an open-source Python language server, type checker, debugger, and profiler for VS Code, Cursor, Windsurf, Antigravity, Zed, and Neovim."
tags: python ai
categories: [software development]
permalink: /blog/:title
keywords: [Basilisk, Python type checker, Python language server, Pylance alternative, Pyright alternative, Cursor Python, Windsurf Python, Antigravity Python, Open VSX Python, AI coding agents Python]
---

> **Key Takeaways**: Python has a tooling problem, not a typing problem. Pylance is proprietary, editor-locked, and too fragile for the way many developers work now. Basilisk is Nimblesite's attempt to build a complete open-source Python language server, type checker, debugger, and profiler that works everywhere.

A while back, I started building [Nimble Agent](https://github.com/Nimblesite/nimble_agent). It's a Python AI coding agent built around a simple idea: an agent shouldn't be allowed to hand-wave its way to "done". It should have acceptance criteria. It should test its work. It should understand the codebase instead of spraying text into files and hoping for the best.

That led me straight into Python's type system.

Python is where the AI agent world lives. LangChain, LangGraph, CrewAI, AutoGen, OpenAI's Python SDK, Anthropic's Python SDK, and half the ML ecosystem are all Python-first. That's slightly annoying, because Python is dynamically typed, and dynamic typing confuses the hell out of AI agents. Humans can usually infer intent from messy code. Agents aren't as good at that. They need contracts. They need explicit shapes. They need a type system that says things out loud.

Python actually has a decent type system now. It's not TypeScript, but it's far better than people give it credit for. The problem isn't the syntax. The problem is enforcement.

[PEP 484](https://peps.python.org/pep-0484/) made type hints explicitly voluntary. It says no type checking happens at runtime, and it assumes a separate checker that you run over your source. That's fine as a language design choice, but it means the entire value of typing depends on tooling. If the tooling is weak, optional, proprietary, or locked to one editor, your type annotations aren't contracts. They're comments with nicer syntax.

That's what finally pushed me to build [Basilisk](https://www.basilisk-python.dev).

## The Pylance Wall

The obvious answer was supposed to be Pylance, and that's exactly the problem. Pylance is the thing Python developers are told to use, but the experience is brittle. Large workspaces get slow or memory hungry. Whole-workspace diagnostics and indexing come with tradeoffs. Import and module resolution often need `python.analysis.extraPaths`, workspace reshaping, or other settings before Pylance sees the same code Python can already run. Microsoft's own [Pylance FAQ](https://github.com/microsoft/pylance-release/blob/main/FAQ.md) has whole sections on import and module resolution, and its [configuration tips](https://github.com/microsoft/pylance-release/wiki/Pylance-Configuration-Tips) describe tuning analysis and indexing for large workspaces.

That's a lot of ceremony for the default Python experience.

That same [FAQ](https://github.com/microsoft/pylance-release/blob/main/FAQ.md) explains the relationship clearly: Pylance uses the open-source Pyright type checker underneath, then bolts extra language server features on top.

[Pyright](https://github.com/microsoft/pyright) is open source, and it's a very good checker. It has excellent conformance to the Python typing spec, and you can use it outside VS Code. Pyright isn't the problem. Pylance is.

Pylance is the richer language server experience Python developers know from VS Code, and it's proprietary. The [Pylance license](https://marketplace.visualstudio.com/items/ms-python.vscode-pylance/license) limits installation and use to Microsoft Visual Studio products and services, and Microsoft documents that [some extensions use proprietary licenses](https://code.visualstudio.com/docs/supporting/oss-extensions) even when the related source projects are open.

So you get a weird split. Pyright is open. Pylance isn't. The core checker is right there, but the IDE experience is locked to Microsoft's distribution. That might have been fine in 2020. It's a lot less fine now.

## The World Moved To VS Code Forks

The most interesting developer tools aren't just VS Code anymore.

Cursor is a VS Code fork. Windsurf is a VS Code fork. Google's [Antigravity](https://antigravity.google/docs/editor?id=GoogleAntigravity) is based on the VS Code codebase and uses Open VSX for extensions. Developers move between VS Code, Cursor, Windsurf, Antigravity, Zed, Neovim, and whatever comes next. The editor is becoming a shell around agents, LSPs, debuggers, terminals, and project context.

That should be great. The whole point of the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/) is that language intelligence is portable. The editor shouldn't own the language.

But Python isn't in a great place here. If you use official VS Code, you get Pylance. If you use one of the AI-first forks, you get a confusing mix of old Pylance builds, Pyright forks, Basedpyright, marketplace remapping, or custom extensions trying to recreate the thing developers expected in the first place.

This isn't theoretical. Cursor users have been complaining about it in their own forum. There are threads about [not being able to install the latest Pylance extension](https://forum.cursor.com/t/cursor-cannot-install-latest-pylance-extension/50654), [Pylance not being supported in Cursor](https://forum.cursor.com/t/unable-to-find-pylance-in-the-extension-marketplace/105099), and [Cursor's Python/Pyright extension getting stuck while analyzing files](https://forum.cursor.com/t/python-pyright-extension-loading-problem/100607). In one of them, Cursor staff tell users to install Anysphere's Python extension, because Pylance isn't supported inside Cursor.

Windsurf has the same shape of problem. Its own documentation recommends [Windsurf Pyright](https://docs.windsurf.com/windsurf/recommended-extensions), described as a Pylance-like language server from Open VSX. That wording tells you everything: the market wants complete Python code intelligence, just outside Pylance's licensing boundary.

Antigravity users are already asking the same question. There are Reddit threads asking for a [Pylance alternative in Google Antigravity](https://www.reddit.com/r/GoogleAntigravityIDE/comments/1pmyoyi/pylance_alternative_in_google_antigravity/) and a [working Python language server for Antigravity](https://www.reddit.com/r/GoogleAntigravityIDE/comments/1r3ow7e/any_working_python_language_server_for_antigravity/). The pattern keeps repeating because the underlying ecosystem is fractured.

## Geoffrey Huntley Was Right

Geoffrey Huntley wrote an article called [Visual Studio Code is designed to fracture](https://ghuntley.com/fracture/), and it's worth reading in full.

His argument is that VS Code's source being open isn't the same thing as the VS Code ecosystem being open. Microsoft can publish an open-source editor codebase, ship proprietary binaries, control marketplace access, and make proprietary extensions the default. That splits the open version from the version developers actually want to use.

Huntley specifically called out Python. He pointed to the replacement of Microsoft's open-source Python Language Server with Pylance, and argued the default had quietly moved to a proprietary extension. [Visual Studio Magazine](https://visualstudiomagazine.com/articles/2021/11/05/vscode-python-nov21.aspx?p=1) reported the same shift: the open-source Microsoft Python Language Server reached end of life, and Pylance became the replacement. [The Register](https://www.theregister.com/2021/09/07/python_extension_vs_code_september/) noted the open-source cost of swapping the old language server for a closed one.

This isn't a Microsoft hate piece. Microsoft employs great engineers, Pyright is good software, and VS Code is genuinely useful. None of that makes Pylance a healthy default for the Python ecosystem.

But we should be honest about the incentives. When the best default experience is proprietary and tied to one vendor's product, the whole ecosystem bends around that product. Every fork, cloud IDE, open-source build, and AI-first editor either accepts a worse Python experience or burns engineering time recreating what should have been a portable language server in the first place.

That's bad for Python.

## Python Typing Is Better Than People Think

Python's type system isn't the problem. The [Python typing spec](https://typing.python.org/en/latest/spec/) is genuinely good, and in some areas it's ahead of languages people reflexively think of as "more typed".

Take unions. Since [PEP 604](https://peps.python.org/pep-0604/), you can write this:

```python
from pathlib import Path

def load_config(source: str | Path | bytes) -> dict[str, str]:
    ...
```

That's a real union type. The value can be a `str`, a `Path`, or `bytes`, and the checker narrows it as the code proves what it has. You can compose it with `None` too:

```python
def find_user(id: str) -> User | None:
    ...
```

C# still doesn't have that as an ordinary, stable language feature. You reach for `User?` for nullability, pattern matching, `object`, overloads, custom wrapper types, or a third-party library. Microsoft has a [C# union types proposal](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/unions), which proves the need is real, but Python already lets you express the idea directly in everyday code.

Dart has a sound type system, and Dart 3's [sealed classes](https://dart.dev/language/class-modifiers) and [patterns](https://dart.dev/language/patterns) are great. But Dart still won't let you write a lightweight free union like `String | Uri | Uint8List`. You model it with a sealed hierarchy or fall back to `Object`, then write all the surrounding plumbing.

Python can express tagged results without that ceremony:

```python
from dataclasses import dataclass
from typing import Literal

@dataclass(frozen=True)
class Success:
    kind: Literal["success"]
    value: int

@dataclass(frozen=True)
class Failure:
    kind: Literal["failure"]
    message: str

Result = Success | Failure

def render(result: Result) -> str:
    match result:
        case Success(value=value):
            return str(value)
        case Failure(message=message):
            return message
```

In C#, you'd create a base record or interface and derive the cases. In Dart, you'd create a sealed class and subclasses. Those approaches work, but they're heavier. Python lets you write the union directly, and the annotation is the contract. Add `Literal`, `TypedDict`, `Protocol`, `TypeGuard`, and [`TypeIs`](https://typing.python.org/en/latest/spec/narrowing.html), and Python typing gets a lot more sophisticated than the industry narrative suggests.

Most developers don't know this, because the tooling has trained them not to care. The [2024 Python typing survey from Meta, JetBrains, and Microsoft](https://engineering.fb.com/2024/12/09/developer-tools/typed-python-2024-survey-meta/) found that type hints are well adopted but tooling usability is still a major problem. A big chunk of developers use types regularly without running a checker in CI. The survey also called out inconsistent checker behavior and poor discoverability as sources of friction.

That's the real damage. Python has a good type system, and the default tooling lets people miss it. Teams add type hints because they know they help, then forget to turn on strict checking. Or they configure it in the editor but not CI. Or one developer gets different errors from another, because the editor extension and the CLI checker aren't the same version. Or the checker is technically present, but it lets untyped code drift through the codebase anyway.

Pylance even has several type checking modes. [Pyright's configuration docs](https://github.com/microsoft/pyright/blob/main/docs/configuration.md) describe `off`, `basic`, `standard`, and `strict`, with `standard` as the Pyright default. Pylance's own [`python.analysis.typeCheckingMode` documentation](https://github.com/microsoft/pylance-release/blob/main/docs/settings/python_analysis_typeCheckingMode.md) lists `off` as the Pylance default. Either way, strictness is something you have to opt into.

That's the wrong default for AI-generated Python. An agent will happily write this:

```python
def enrich_customer(customer, metadata):
    if metadata["active"]:
        customer.score = metadata["score"]
    return customer
```

That code might be fine. It might also be nonsense. What's `customer`? What's `metadata`? Is `metadata["score"]` an `int`, a `float`, a `str`, or `None`? What happens when an agent refactors this later and invents a field that never existed?

In a dynamic language, that ambiguity spreads. The agent reads ambiguous code, writes more ambiguous code, and eventually your test suite is the only thing standing between you and a runtime failure.

Tests are necessary. Tests aren't a type system.

## Basedpyright Proves The Demand Exists

Basedpyright is another sign the problem is real.

[Basedpyright](https://docs.basedpyright.com/) is a fork of Pyright that adds stricter defaults and reimplements some Pylance features outside the closed-source extension. That's a clear signal from the community. People want stronger defaults. People want Pylance-like behavior in editors that aren't official VS Code. People want the editor and the CLI to agree.

It solves real problems, and I'm glad it exists. But I wanted to go further. I didn't want a better Pyright wrapper. I wanted a complete open-source Python developer experience that doesn't fundamentally depend on Microsoft's closed extension, Node.js, or a specific editor marketplace.

That's Basilisk.

## What Basilisk Is

[Basilisk](https://www.basilisk-python.dev) is an open-source Python language server, type checker, debugger, and profiler. It's written in Rust, ships as a single binary, and targets VS Code, Cursor, Windsurf, Antigravity, Zed, and Neovim.

The idea is simple:

**Python should have a complete open-source language server that works everywhere.**

Not a degraded fallback. Not a half-compatible substitute. Not a tool that only works properly in one editor. One language server, one set of diagnostics, one CLI, one editor experience.

Basilisk is strict by default. There's no permissive mode to forget about, and no global "relax everything" switch. If a function parameter is untyped, Basilisk says so. If a function has no return annotation, Basilisk says so. If an assignment conflicts with its declared type, Basilisk says so.

For example:

```python
def greet(name):
    return "Hello " + name
```

Basilisk reports:

```text
error[BSK-E0001]: Missing parameter type annotation for `name`
error[BSK-E0002]: Missing return type annotation
```

The fixed version is explicit:

```python
def greet(name: str) -> str:
    return "Hello " + name
```

This isn't about making Python annoying. It's about making contracts visible.

## The Checker Is Only The Start

The type checker is the wedge, but Basilisk isn't only a type checker. The goal is a complete Python development stack:

- Type checking and inference, strict by default
- LSP diagnostics, hover, go-to-definition, inlay hints, and code actions
- Refactorings like extract variable, extract function, inline variable, move to file, rename symbol, and change signature
- Debugging through `debugpy`
- Profiling through `py-spy`
- Ruff-backed formatting and import organization where it makes sense
- uv integration for modern Python project workflows

I'm not interested in reinventing every good Python tool. Ruff is excellent. uv is excellent. debugpy and py-spy already exist. The point is to pull the developer experience together behind one open language server and make it portable across editors.

This matters more now, because AI agents are editor-native. Cursor, Windsurf, and Antigravity aren't just editors with autocomplete. They're agent environments. If Python language intelligence is degraded in those environments, the agent is degraded with it. An agent that can't trust the type information in a project is a worse agent.

## This Is Political

I don't usually like turning tooling choices into ideology. Use what works, ship software, and don't waste your life performing loyalty to a toolchain. But some tooling decisions are political, because they shape what the ecosystem can become.

If the Python community accepts that the best Python IDE experience lives inside a proprietary Microsoft extension, then every new editor starts behind. Open-source builds start behind. Cloud IDEs start behind. AI-first forks start behind. Neovim and Zed users start behind. The community keeps rebuilding around a proprietary center, over and over.

That's not healthy. And the fix isn't to yell at Microsoft. Microsoft is behaving exactly like a large platform vendor, and large platform vendors create defaults that benefit their platform. The fix is to build better open tools.

That's why Basilisk exists. It isn't a revenge project, and it isn't an anti-Microsoft project. It's a pro-Python, pro-open-tooling project, for people who want the same excellent Python experience in Cursor, Windsurf, Antigravity, Zed, Neovim, VS Code, and whatever comes after them.

## Where Basilisk Is At

Basilisk is still early, and I won't pretend otherwise. Pyright has far more maturity today. Pylance has years of production use. mypy has the oldest ecosystem. Basedpyright is already useful for a lot of developers. Astral's ty and Meta's Pyrefly are pushing the space forward too. That's a good thing. Python needs more serious type checking work, not less.

What makes Basilisk different is the stance:

- Strict by default
- Open source
- Single Rust binary
- A complete LSP, not just a CLI checker
- The same experience across editors
- Built for the AI-agent era

I built it because I wanted my Python agent code to be honest. I wanted missing types to be errors, not vibes. I wanted one language server that didn't care whether I was in VS Code, Cursor, Windsurf, Antigravity, Zed, or Neovim.

Python developers shouldn't have to choose between an amazing AI editor and a proper Python language experience. That's the problem Basilisk is trying to fix.

If you've ever opened a VS Code fork, searched for Pylance, found some weird substitute, and wondered why Python suddenly felt second-class, Basilisk is for you.

Give it a try: [basilisk-python.dev](https://www.basilisk-python.dev).

<small>Note that some or all of the content here was written with the assistance of AI. [View the AI Content Policy](ai-writing)</small>
