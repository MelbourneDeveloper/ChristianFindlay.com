---
layout: post
title: "Why You Should Care About Functional Programming"
description: "Why functional programming matters for .NET and Flutter developers: simpler code, practical guardrails, and readable logic in the age of AI."
date: "2026/11/01 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/functional-programming.webp"
image: "/assets/images/blog/functional-programming.webp"
tags: [functional programming]
categories: [software development]
permalink: /blog/:title
---

Most of you know that I have been working with .NET for a long time and also work with Flutter. C# and Dart mostly come from an Object Oriented Programming (OOP) background, but I've drifted towards Functional Programming (FP) more and more over the last few years. You can see it in several of my blog posts, but I wanted to go into what led me to this point. The TLDR; is that I've ended up building an FP language [Osprey](https://www.ospreylang.dev/) from scratch over the last year and a half, this language should be of interest to all .NET and Flutter devs and that there are good reasons to get more interested in FP as a style and FP languages in general.

We're living in a time where a lot of people are saying "The language doesn't matter anymore". There's some truth to that because AI can build software in literally any language, even made up ones. A few years ago, AI couldn't consistently write code in languages it didn't know. Claude Code with Opus 5.5 now usually writes well-structured Osprey code. It's been building apps from scratch in the different Osprey syntax flavors without flinching, but the point is that it's time to have a think about whether programming languages are important at all, and if so, what aspects of the language are important.

Elon Musk [said that he thinks AI will start building apps by directly writing to machine code](https://x.com/XFreeze/status/2021699619927781842). Robert C. Martin (Uncle Bob) said that he doesn't look at the code anymore.

<iframe
  src="https://platform.twitter.com/embed/Tweet.html?id=2080257779395154409&theme=dark&dnt=true"
  width="550"
  height="420"
  frameborder="0"
  scrolling="no"
  allowtransparency="true"
  title="Uncle Bob Martin on not reading agent-written code">
</iframe>

This is not in the least bit shocking to me because I've seen how powerful AI coding agents have become. I've also seen how they can seamlessly jump from language to language without getting muddled in any way. This is something that humans just cannot do. So why should we care about the programming language at all?

Well, the answer is that the programming language still matters a lot, and FP languages routinely get overlooked. We may get to a point where we can directly build simple apps from prompts to machine code, but the problem is that there is absolutely no way for a human to be able to tell what machine code is doing without using a disassembler. It is not auditable, and if a security flaw creeps in, we'd have to depend on AI to catch it. We need programming languages because they are **deterministic** ways of expressing programming logic. We can't store programs as natural language because it's not deterministic, and machine code would banish humans from the equation altogether simply because we cannot understand it.

## Why Functional Programming

If you ask a lot of FP programmers why they like FP, they will often tell you that it's because it satisfies their interest in set theory or math. Those are fine reasons to be interested in a programming language, but they're not pragmatic when you just want to build a shiny app or maintain a twenty-year-old legacy system. 

The thing that they often forget to mention is that FP languages are often very simple to work with, are fast and have more guardrails to prevent you from running into trouble than the more mainstream languages. FP is inherently pragmatic, but you wouldn't know it because so many of the proponents live in a world that seems very disconnected from what everyday programmers do.

Let me tell you about the personal story that led me to FP. The first programming languages I got serious about were C and Visual Basic 6. C is neither FP oriented, nor OOP. VB6 was object oriented to an extent, but you still had the ability to use functions. Most of the code I wrote at that time used top-level functions, and then C# arrived and suddenly everything was OOP and top-level functions were toxic.

I adapted to C# and .NET, mostly because there was a wave of OOP fever at that time. People had more or less decided that the coding paradigm matter had been settled and that OOP was the only way to build a successful system. I remember having recruiters tell me that VB6 "wasn't real OOP" and therefore my development experience was useless. But, in the background the FP paradigm was growing and languages like [Haskell](https://www.haskell.org) were paving the way. [F#](https://fsharp.org) became an officially supported .NET language with the release of [Visual Studio 2010](https://fsharp.org/history/hopl-final/hopl-fsharp.pdf), after starting life at Microsoft Research in 2002.

### Trouble Brewing With OOP

I never really felt as though OOP code was a good fit for the kinds of apps and systems that I was working on. The mental model always seemed off for some reason. We have properties, which represent the data, and methods for processing. I inherited some code where each model had a `Save` method. Seemed reasonable given that we were working within the OOP paradigm, but the more I tried to make this work, the more I realized it created too much friction.

I wanted to pass the model through from the DB to the server and back because it was C# on both sides. So, I decided to convert the `Save` methods to static (like top-level functions) so the models would be independent of the data layer. That only makes sense. The models should be decoupled from the data layer, and that's how most systems work these days. But, why wasn't the OOP approach the right approach?

Then came the mocking frameworks. I was horrified when people first explained these contorted monstrosities to me. The idea of test doubles makes sense for certain scenarios, but why did we need the heavyweight OOP solutions when we could just use functions or lambdas? It never made a lot of sense to me and it still doesn't.

I wanted to use the features of C# to their fullest to make the code as reusable as possible, but the other big problem that I kept hitting was inheritance. If I build a type hierarchy with inheritance, my logic is baked into that structure and I cannot use the methods as functions in other parts of the code. I would have to refactor these methods into static functions and move them elsewhere, which again, defeats the purpose of OOP.

But by far the worst thing about C#, which is [about to be fixed](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/union), is the lack of unions. Most modern programming languages have unions or allow for something like a union. I constantly hit cases where a type would need one set of data, ***or*** some other completely different set of data. 

C# is getting unions in C# 15 and most other modern languages either have unions like TypeScript and F#, or allow for closed type hierarchies with sealed classes like Kotlin and Dart. It's about time because it's almost impossible to model data when you can't specify that the data set is either one strict set of data fields, or another strict set of fields. 

Suffice it to say that after about a decade of working with C# I clearly saw the cracks in the paradigm and so did everyone else. Today, C# is a mish mash of OOP and FP constructs, just like nearly every other popular programming language. C# has immutable records and various other FP constructs, and will have unions in C# 15. We now call these languages "hybrid" languages, which is another way of saying that the language doesn't properly belong to any paradigm. Yet another way to put it is that most modern programming languages have become garbage dumps for features that are supposed to make it easy for any developer to adopt.

### FP Is Nice By Default

All the issues I just mentioned are just not issues in the FP world. Data is immutable by default. You don't generally mix behavior and state and FP deals with effects (the stuff we write mocks for) in a much more structured way. 

I gradually drifted towards writing all my Dart and C# code in an FP style and it ended up solving a lot of the kinds of problems that used to rack my brain when trying to come up with an elegant solution ten years ago. For example, I now use sealed classes in Dart to specify that an API endpoint can either return a typed Success value, ***or*** a failure value of a different type. The exhaustiveness checks in Dart force me to deal with either side.

The Rust community must have had the same opinion, given Rust takes a mostly FP approach. Recently, I've been working with Rust a lot and I can clearly see that it promotes performance and safety through the FP style type system.

### But What About The AI Era?

AI understands most languages easily. You can easily vibe-code any app, and most of the time, AI will do a reasonable job of structuring the code as long as you guide it and push it in the right direction when it goes off course. AI knows about the performance nuances of most modern languages and it can use profilers to find bottlenecks in code when it's slow. So why care about the language at all?

The studies are clear that some languages are safer and more performant than others. C++ is a very fast language but [Rust has better memory safety out of the box](https://blog.google/security/rust-in-android-move-fast-fix-things/).

The third axis is elegance. It's about doing more with less code because all code is a liability.

> The more code you have, the more places there are for bugs to hide.

~ [Rich Skrenta, quoted by Jeff Atwood in The Best Code is No Code At All](https://blog.codinghorror.com/the-best-code-is-no-code-at-all/)

It is a [well-established principle](https://www.cs.utexas.edu/~EWD/transcriptions/EWD10xx/EWD1036.html) that the more code you have, the more work you or the AI need to do.

Every language makes trade-offs on these three things: safety, performance and elegance. They're not always direct trade-offs but good programming languages get a balance of all these things right. It's about where the language designers put their resources and efforts. 

All these things matter whether you write the code or the AI writes the code. If you can write less code, you will have fewer bugs and spend fewer tokens. If you use a fast language, you will provide a better user experience and save on cloud costs. Memory safety is just a no-brainer. You don't mess with this unless you're doing things that require extreme performance without major risk.

So how does this lead to FP?

### FP Gets It Mostly Right

Languages like [OCaml](https://ocaml.org), [Haskell](https://www.haskell.org), [Rust](https://rust-lang.org) and [F#](https://fsharp.org) are elegant, safe and performant. Rust in particular, while not a pure FP language, nails the balance of safety and performance, giving you fine grained control of these aspects with minimal costs.

Moreover, these languages are not bloated to the moon with features that you probably wouldn't even want to use. The language designers were careful. They took their time to design these languages properly and not add core features without very careful deliberation over time.

C# on the other hand adds features like a hobo stuffing pigeons in a sack after sprinkling bird seed. This adds to the cognitive load of having too many different approaches to doing the same thing in a codebase. Do I want a class? A record? Should I ban unions? Primary constructors? It never ends and the complexity is more than most people can keep track of.

All this is why I've come to prefer FP and FP languages, and it's why I ended up building [Osprey](https://www.ospreylang.dev). Osprey isn't the reason I started writing this article but my instincts were right. The progress on Osprey has been breathtaking. Just check out the showcase video on the main page to see what I've been able to build on top of Osprey recently.

## Wrap-up

This isn't a tribal thing. If you like OOP, there is no problem with sticking with it. But just understand that there have been very few pure OOP languages since Smalltalk and you're going to be dealing with a mish mash of constructs in any modern hybrid language you work with. I like FP because it narrows the construct down to a simple handful of necessary ones and ignores all the fluff that seems to exist in the hybrid languages.

