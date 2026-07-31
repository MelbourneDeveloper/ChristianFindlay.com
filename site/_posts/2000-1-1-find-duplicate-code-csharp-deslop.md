---
layout: post
title: "Find Duplicate Code in C# with Deslop"
description: "Find duplicate C# code with Deslop, a live analysis tool that detects exact, renamed, near-miss, and semantic clones in VS Code, CI, and AI-agent workflows."
date: "2026/07/31 00:00:00 +1000"
author: "Christian Findlay"
post_image: "/assets/images/blog/deslop/csharp-duplicate-code.webp"
post_image_width: 1600
post_image_height: 900
image: "/assets/images/blog/deslop/csharp-duplicate-code.webp"
tags: csharp code-quality visual-studio ai deslop
categories: [dotnet]
permalink: /blog/:title
keywords: [duplicate code, code quality tools, code quality analysis, static code analysis tool, SonarQube static code analysis, Visual Studio static code analysis, open source static code analysis, C# duplicate code, C# code duplication tool, code clone detection, Deslop]
---

Duplicate code looks harmless until you fix a bug in one copy and miss the other three. C# makes extracting shared code easy. Visual Studio can extract a method, Roslyn can enforce hundreds of rules, and mature tools can measure duplication across a repository. The hard part is finding the copies early enough.

This is the problem I built [Deslop](https://deslop.live) to solve. Deslop is a live duplicate-code analysis server with a C# parser, a VS Code extension, an LSP for editor feedback, an MCP server for AI coding agents, and a CLI for CI. It doesn't just wait for a pull request. It updates after you save and lets an agent call `find-similar` before it writes another version of something that already exists.

If you're looking for a C# code duplication tool, the short answer is to [install Deslop for VS Code](https://marketplace.visualstudio.com/items?itemName=nimblesite.deslop-live). The rest of this article explains why.

> **Key Takeaways**: Deslop finds exact, renamed, and near-miss duplicate C# code with syntax-aware analysis. Optional local embeddings help find semantic matches. The VS Code extension gives you live feedback, while MCP lets coding agents check before they create a duplicate. For eligible exact clones in the same C# file, Deslop can offer a guarded `Extract identical code to shared method` action. It refuses cases it cannot rewrite safely, so you remain in control of the refactor.

## What Is Duplicate Code?

Duplicate code repeats logic in more than one place. Sometimes somebody literally copied and pasted it. Sometimes two developers independently wrote the same thing. Increasingly, an AI agent produces a new implementation because it didn't know the canonical one already existed.

Researchers usually split code clones into four types. The names sound academic, but the idea is simple:

| Type | What It Means | C# Example |
| --- | --- | --- |
| Type-1 | The same code apart from whitespace or comments | A copied method with different formatting |
| Type-2 | The same structure with renamed identifiers or changed literals | The same calculation with different variable names |
| Type-3 | A near-miss with added, removed, or changed statements | A copied validation block with one extra check |
| Type-4 | The same behaviour expressed with different code | A loop and a LINQ query that calculate the same result |

A widely cited [comparison of code clone detection techniques](https://doi.org/10.1016/j.scico.2009.02.007) uses this taxonomy. It matters because plain exact-text search reliably finds only the easiest case. The expensive duplicates have often drifted so far apart that nobody remembers they began as one piece of logic.

Not all repetition is bad. Generated code, framework scaffolding, and test data may be fine. So may two pieces of code that will evolve independently. A detector should give you evidence, not make the architectural decision for you.

## A C# Duplicate That Text Search Misses

These methods do the same calculation, but the names are different:

```csharp
static Receipt CreateRetailReceipt(Order order)
{
    var subtotal = order.Items.Sum(item => item.Price * item.Quantity);
    var tax = Math.Round(subtotal * 0.1m, 2);
    return new Receipt(subtotal, tax, subtotal + tax);
}

static Invoice CreateWholesaleInvoice(Purchase purchase)
{
    var net = purchase.Lines.Sum(line => line.UnitPrice * line.Count);
    var gst = Math.Round(net * 0.1m, 2);
    return new Invoice(net, gst, net + gst);
}
```

Searching for `subtotal` won't find the second copy. A raw text comparison won't match it either. Structurally, however, these methods are almost identical. They both sum each price multiplied by its quantity, calculate ten percent tax, and return the three totals.

You could extract that calculation into a small, strongly typed function:

```csharp
readonly record struct Totals(decimal Subtotal, decimal Tax, decimal Total);

static Totals CalculateTotals<TLine>(
    IEnumerable<TLine> lines,
    Func<TLine, decimal> price,
    Func<TLine, int> quantity)
{
    var subtotal = lines.Sum(line => price(line) * quantity(line));
    var tax = Math.Round(subtotal * 0.1m, 2);
    return new(subtotal, tax, subtotal + tax);
}
```

Notice that detection and refactoring are separate decisions. A shared method works for this example. In a real codebase, the right answer might be an extension method, a domain service, a common type, a source generator, or no refactor at all. Deslop finds the relationship. You decide what the relationship means.

## Why Roslyn Analyzers Aren't Enough

I strongly recommend turning on C# code rules. I wrote a whole article about [configuring Roslyn analyzers](code-rules) because warnings and style rules stop a codebase from degrading in many predictable ways. Microsoft's [.NET code analysis documentation](https://learn.microsoft.com/en-us/dotnet/fundamentals/code-analysis/overview) explains how the SDK analyzers cover quality, security, performance, design, and style.

Repository-wide clone detection is a different job. An analyzer normally inspects syntax or symbols against a rule. A clone detector must compare fragments across many files, survive renamed variables and edited statements, group related occurrences, suppress noise, and rank the results. You need both kinds of analysis.

## C# Code Duplication Tools Compared

There are already good duplicate-code tools. I don't think you should throw them away just because Deslop exists.

| Tool | Where It Is Strong | What to Know |
| --- | --- | --- |
| [Deslop](https://deslop.live) | Live C# clone detection, worst-first ranking, VS Code feedback, MCP prevention, CLI and CI | Its C# extraction actions are deliberately guarded and may refuse unsafe cases. Semantic matching requires an optional local embedding model. |
| [SonarQube](https://docs.sonarsource.com/sonarqube-server/user-guide/code-metrics/metrics-definition) | Team dashboards, duplicated-lines metrics, and quality gates | For non-Java languages such as C#, a duplicated block needs at least 100 successive tokens across at least 10 lines. Small clones can sit below that threshold. |
| [PMD CPD](https://pmd.github.io/pmd/pmd_userdocs_cpd.html) | Free, open-source, command-line copy-paste detection with C# support | It is a token-based batch tool. It is excellent for audits and CI, but it doesn't put prevention into an agent's authoring loop. |
| [NDepend](https://blog.ndepend.com/find-c-code-duplicate/) | Deep .NET metrics and a duplicate-code Power Tool that finds methods with similar dependencies | Its heuristic finds useful suspects even after edits. NDepend is a much broader commercial .NET analysis product. |
| [ReSharper](https://www.jetbrains.com/help/resharper/DuplicatedStatements.html) | C# inspections and refactoring inside Visual Studio | Its current duplicated-statements inspection targets repeated statements in conditional branches rather than general repository clone analysis. |

SonarQube is a good choice when you need an organization-wide quality gate. CPD is a good choice when you want a simple open-source command-line detector. NDepend gives .NET teams a much larger code-quality and architecture toolbox. ReSharper remains one of the best C# refactoring tools.

I built Deslop for a different point in the workflow: the moment a human or agent is about to add another copy. It complements those tools.

## How Deslop Finds Duplicate C# Code

Deslop does not compare C# files as raw text. It parses the code and compares several kinds of evidence.

First, it removes comments and formatting, then normalizes names and literals. That lets it recognize the same structure when one method uses `customerTotal` and another uses `invoiceTotal`.

Next, it compares syntax fragments and neighbouring statements. MinHash and locality-sensitive hashing narrow the search, so Deslop can find near misses without comparing every fragment against the entire codebase. Optional local embeddings help surface candidates that may behave similarly despite looking different.

Finally, it clusters the matches and ranks the worst offenders first. A five-line clone that occurs twice should not bury a large repeated block spread across six files.

The full, auditable mapping from those algorithms to Deslop's implementation is in the [Deslop research background](https://deslop.live/docs/research-background/).

## The Research Behind Deslop

Nobody has peer reviewed Deslop itself, and I think that distinction matters. It implements a clone-detection pipeline grounded in published research.

[Baxter and colleagues](https://doi.org/10.1109/ICSM.1998.738528) presented a practical AST-based approach to clone detection in 1998. Instead of treating code as plain text, their work compared normalized program structure.

[SourcererCC](https://doi.org/10.1145/2884781.2884877) showed that token-based near-miss detection could scale to 250 million lines of code on a standard workstation. Deslop adapts that general line of research with normalized syntax-kind k-grams, MinHash, and candidate filtering.

[SSCD](https://doi.org/10.1002/spe.3355) combined BERT-derived embeddings with approximate nearest-neighbour search for Type-3 and Type-4 clones at industrial scale. Deslop uses optional local embeddings to surface additional Type-3 and Type-4 candidates. Deterministic structural analysis remains the foundation, so an AI similarity score does not make the decision by itself.

AI makes prevention more important. A 2025 study of [19 code language models](https://arxiv.org/abs/2504.12608) found repetition at character, statement, and block levels. Another [FSE 2025 study of commercial AI code generators](https://doi.org/10.1145/3729397) reported combined Type-1 and Type-2 clone rates as high as 7.50% in the systems it studied.

That doesn't prove every AI-generated function is bad. It does show that agents can produce duplicate logic, and that we should give them a way to check the repository before they write more code.

## Live Duplicate Detection in VS Code

The [Deslop VS Code extension](https://marketplace.visualstudio.com/items?itemName=nimblesite.deslop-live) shows the same live report in three places: a worst-first tree in the sidebar, a clone warning beside your code, and a side-by-side comparison with the canonical occurrence.

[![Deslop in VS Code showing top duplicate-code offenders, an inline clone warning, and a side-by-side comparison](/assets/images/blog/deslop/vscode-duplicate-code.webp)](https://marketplace.visualstudio.com/items?itemName=nimblesite.deslop-live)

The screenshot shows Rust, but Deslop uses a dedicated parser when you open C#. The workflow remains the same: select the highest-impact cluster, compare the copies, and decide whether to extract a canonical implementation.

The report refreshes after you save or another tool changes a file on disk, so you don't need to remember to run a separate scan.

## Stop AI Agents Before They Copy and Paste

Detection after the code lands is useful. Prevention is better.

Deslop exposes the same live analysis through MCP. An agent can call `find-similar` before it writes a function, method, helper, or test setup. If a strong match already exists, the agent can reuse the canonical implementation instead of producing another one.

1. The agent plans a new piece of C# code.
2. It asks Deslop whether similar code already exists.
3. Deslop compares the proposed snippet with the latest saved workspace analysis.
4. The agent reuses the canonical code or explains why a new implementation is necessary.

This is not another prompt telling the model to follow DRY. Deslop searches the repository and returns the matching code before the model writes the new function. See the [Deslop AI integration guide](https://deslop.live/docs/ai-integration/) for the MCP setup.

## How to Remove Duplicate C# Code Safely

Don't start by deleting every clone. Start with the worst offender and make one defensible change.

1. Install Deslop and let it analyze the C# workspace.
2. Open the top-ranked cluster and compare every occurrence.
3. Confirm that the copies represent the same knowledge and should change together.
4. Choose one canonical implementation.
5. For an eligible exact clone in one C# file, review Deslop's guarded extraction action. Otherwise, use Visual Studio's [Extract Method refactoring](https://learn.microsoft.com/en-us/visualstudio/ide/reference/refactoring-extract-inline?view=vs-2022), or make the appropriate domain-level refactor.
6. Run the tests and check the cluster disappears.
7. Dismiss a noisy bubble for the session, or [configure path exclusions](https://deslop.live/docs/configuration/) for known intentional duplication.

Similar-looking code may have different reasons to change and should sometimes remain separate. Deslop tells you where to look, but you still need to decide whether the copies represent the same knowledge.

## Try Deslop

Install the extension from the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=nimblesite.deslop-live), or run:

```text
code --install-extension nimblesite.deslop-live
```

Then open a C# workspace and inspect the first three clusters. Don't try to clean the entire codebase in one afternoon. Remove one genuine duplicate, review one intentional clone, and wire `find-similar` into your agent workflow.

Visit [deslop.live](https://deslop.live) for the CLI, CI, MCP, configuration, and research documentation.

I built Deslop to move duplicate-code detection earlier. Finding existing copies is useful, but stopping the next one before it lands is better.

<small>Note that some or all of the content here was written with the assistance of AI. [View the AI Content Policy](ai-writing)</small>
