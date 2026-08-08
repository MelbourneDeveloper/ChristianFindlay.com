---
layout: post
title: "Basilisk's 100% Python Conformance Score Was Not Real"
description: "Basilisk's rules matched raw source text instead of resolved symbols, so its 141/141 conformance score measured the spelling of the test files. An apology to the python/typing maintainers and the Python community."
date: "2026/08/08 00:00:00 +1000"
author: "Christian Findlay"
post_image: "/assets/images/blog/basilisk/conformance-apology.webp"
post_image_width: 1672
post_image_height: 941
image: "/assets/images/blog/basilisk/conformance-apology.webp"
tags: python ai
categories: [software development]
permalink: /blog/:title

---

I recently built a Python type checker called Basilisk and submitted it to the [Python typing repo](https://github.com/python/typing). It passed on the first attempt with a perfect score, but the score was wrong. The code matched the text of the specific tests rather than implementing the specification. I used AI to build the checker and didn't pay enough attention to how it passed the conformance tests. What's worse is that I then went on to advertise the results on social media and the Basilisk website. This is a public apology to all the people involved and the Python community in general.

On 5 August I asked the typing maintainers to remove Basilisk from the conformance results, and [they did](https://github.com/python/typing/pull/2330).

I'm sorry. I made a claim that I didn't verify, and somebody else had to do the work of finding out it was wrong.

To be clear about one thing: I did not set out to publish a number I knew was false, and I did not understand how the rules were passing until it was demonstrated. I didn't verify the code, which is my failure. As soon as I understood the code was wrong I retracted it.

## What was broken

A lot of Basilisk's rules matched against raw source text and hard-coded typing symbol names rather than against resolved symbols on the AST. The rules were looking for the literal characters `Final` in the file instead of asking what the name `Final` actually resolves to in that scope.

On 5 August, David Peter ([sharkdp](https://github.com/sharkdp)) published a [conformance test mutator](https://gist.github.com/sharkdp/3f3266fd9c67d22137e2b6c015c5f206). It does two things to the conformance suite. It renames imported typing symbols (`List` becomes `AuditList`) and it shifts whitespace. Same AST. Same expected errors. Same line numbers. A checker that resolves symbols scores identically before and after, because nothing about the program changed.

Basilisk's results moved on 113 of the 141 test files. That finding makes it clear that Basilisk wasn't doing real type checking in many cases. If renaming an import breaks a rule, the rule was never checking the type system. 141/141 was never a measurement of conformance to the specification. It was a measurement of how closely Basilisk's code had converged on the exact bytes of a fixed, public, well-known test suite.

## How it happened

I built Basilisk with heavy AI assistance, and I used the conformance score as the acceptance criterion. This was a colossal mistake.

That is the worst possible target to hand to AI. The conformance suite is a fixed set of public files, so matching their text is a far cheaper route to pass the tests than implementing the spec. Code that should only ever have been a placeholder passed the test and then it proliferated in the codebase. I reviewed the score without properly reviewing the code. Then I wrote a blog post with the typing results leaderboard on it. I had been using AI to check the work, and this left a huge blind spot.

Not to downplay my own lapse in judgment, but I made a genuine attempt to prevent this kind of failure by implementing what I thought was rigorous mutation testing. I didn't pay attention to what the mutation scores were verifying and it turns out that the mutation tests were not preventing the kind of situation that was actually happening.

## Who I owe this apology to

**The python/typing maintainers.** [Jelle Zijlstra](https://github.com/jellezijlstra) reviewed the submission in good faith, ran the workflows, merged it, and congratulated me on building the tool. There was nothing in what I submitted that should have raised a flag, because the failure was mine and it sat upstream of anything a reviewer could reasonably have caught. [Alex Waygood](https://github.com/AlexWaygood) approved the removal and was more gracious about it than I deserved. [Carl Meyer](https://github.com/carljm) took the time to explain publicly how the submission came to be accepted, and to note that the project now needs submission guidelines it never previously needed. That is what I feel the most regret about. This is a repository that ran on good faith, and is maintained by volunteers. It now has to add a gate because of what I did. I'm sorry for the time I took from you and for the process you now have to build.

**[David Peter](https://github.com/sharkdp).** He wrote and published the harness that caught this. I benchmarked Basilisk against everyone else using hyperfine, which is also [his work](https://github.com/sharkdp/hyperfine). He did the verification I should have done before I published anything.

**[Charlie Marsh](https://github.com/charliermarsh)**, whose groundbreaking work on [Ruff](https://docs.astral.sh/ruff/) is the reason Basilisk is possible at all.

**The other type checker teams.** Pyright, Pyrefly, ty, mypy, zuban and pycroscope. The scores from these tools came from real symbol resolution and years of specification work. I didn't do that as part of building Basilisk. Printing them in the same table implied I somehow figured out how to magically skip all that work. A commenter on the removal PR said I had promoted Basilisk over other tools on social media. I can't argue with how that looked from the outside, and I regret it.

**Anyone who installed Basilisk because of that number.** You trusted the claim. I hadn't checked it. The number wasn't measuring what I said it measured.

Publishing that comparison without checking it was wrong, and it must have come across as an insult to all the people that have worked hard on solving complex computer science issues. The work they have done is the foundation for quality in countless projects and is becoming a part of the AI ecosystem.

## On the "is a human even involved" question

On the PR, DetachHead asked whether I was even aware the removal had been filed, since the apology in it read as AI generated. Yes. I wrote it and my name is on it. I am using AI to help write my responses as a guard against innaccuracy and deflecting from responsibility. I want to make it clear that I own the responsibility. Building with AI requires more scrutiny, not less, but I completely shirked that part of the process, which is exactly the kind of abrogation of responsibility that my writing over the years has been aimed at remedying.

## Was This Due To AI Hallucination?

No. This happened because of my own lack of judgement. I am not blaming AI for this. I threw all my experience and engineering expertise out the window and allowed myself to believe that there was a magical genie in a lamp that could outsmart the humans that toiled on difficult computer science problems for years or decades. 

After re-reading the instructions I had given the AI, I realized that they could be read as prioritizing getting the tests green over accuracy.

I have seen AI pull off legitimately incredible solutions to existing problems and that was the thing that lulled me into a belief that this was possible at all. The belief turned into delusion when I allowed myself to believe that it could skip all the years of investigating corner cases, responding to GitHub issues, debugging code, working towards deadlines and putting in the hard work generally.

## What changes

- **David Peter's mutation harness becomes a gate, in CI.** If renaming an imported symbol or reformatting whitespace changes any diagnostic, the rule isn't implemented, and it doesn't count toward any score.

- **A full audit of every rule for source-text pattern matching**, tracked publicly in the [Basilisk repo](https://github.com/Nimblesite/Basilisk) so it can be checked rather than taken on trust. Anything that can't be proven trustworthy will be removed from Basilisk until it can be.

- **[The July post](/blog/basilisk-perfect-python-typing-conformance) is retracted** with a notice on it. I will correct or retract every other statement that turned out to be wrong.

- **No conformance claim from me until it survives the mutation test.** If we submit again, the mutation-tested figure gets published next to the raw one. If the honest score is lower than the tools I ranked myself above, I won't publish anything.

- **No resubmission until there's evidence rather than intent.** Alex said that he personally would have no problem with a resubmission assuming the underlying issues are addressed, while making clear he couldn't speak for the other maintainers. Carl said the project needs submission guidelines and more due diligence before accepting pull requests like mine in future. I'm sorry that my actions led to a situation where this is necessary. The last thing I ever wanted was to waste the time of maintainers or create a situation where the maintainers are constantly having to fend off false attempts. Hopefully, I can at least offer some assistance with helping to detect some signals that I should have picked up on.

The point of building Basilisk was that Python developers deserve a tool that tells them the truth about their code. I then published a number about it that turned out to be wrong. I know this hurts my credibility and Basilisk's credibility. I'm going to do whatever it takes to restore that credibility but I know that only comes from years of hard work and can't be restored with a blog post.

Sorry. To the typing maintainers in particular, and to the Python community generally.

<small>Note that some or all of the content here was written with the assistance of AI. [View the AI Content Policy](ai-writing)</small>
