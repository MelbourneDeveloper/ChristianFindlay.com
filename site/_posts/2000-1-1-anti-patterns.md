---
layout: post
title: "Anti-patterns: A Misused Term"
date: "2019/06/01 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/antipatterns/header.jpg"
image: "assets/images/blog/antipatterns/header.jpg"
description: An article about how developers misuse the term anti-pattern.
tags: 
categories: [software development]
permalink: /blog/:title
---

The term "anti-pattern" is a derogatory term used to disparage software design approaches that a given developer or group of developers may not like. The term started its life as a useful way to describe approaches that generally lead to adverse outcomes, and already have a proven solution. While some approaches often do usually lead to adverse outcomes, there are very few problems simple enough where a one size fits all solution is adequate for all scenarios. This article is part of a series on Critical Thinking in Software Development and talks about how people often misuse the term.

According to Wikipedia, a software design pattern is:

> [a general, reusable solution to a commonly occurring problem within a given context in software design \[...\] It is a description or template for how to solve a problem that can be used in many different situations. Design patterns are formalized best practices that the programmer can use to solve common problems when designing an application or system.](https://en.wikipedia.org/wiki/Software_design_pattern)

The definition is perfectly reasonable. If a solution solved some problem, and the solution proved to be fruitful time and time again, it's reasonable to consider it as a template for solving similar problems again in the future. However, when some group proves an approach through some formal process to be superior to all others, it becomes a pattern, and ultimately "best practice". An approach that earns the title of "best practice" not only becomes one tool in the toolbox; it also becomes _dogma_. At this point, developers tend to label anything that runs contrary to a given pattern as an "anti-pattern". It is a misuse of the term.

The book [AntiPatterns](https://en.wikipedia.org/wiki/AntiPatterns) popularized the term "anti-pattern". For an amusing read, please check out the website called [AntiPatterns](http://antipatterns.com/) by the original authors. Wikipedia says that

there must be at least two key elements present to formally distinguish an actual anti-pattern from a simple bad habit, bad practice, or bad idea:

> [A commonly used process, structure, or pattern of action that despite initially appearing to be an appropriate and effective response to a problem, has more bad consequences than good ones](https://en.wikipedia.org/wiki/Anti-pattern)

> [Another solution exists that is documented, repeatable, and proven to be effective](https://en.wikipedia.org/wiki/Anti-pattern)

This definition sounds reasonable and useful. However, it becomes a problem when developers take the second part by itself. It implies that because an approach has proven to be effective at solving a problem, it is pointless to attempt to solve the problem in any other way. It is where the issue of misusing the term becomes a problem. Approaches are routinely singled out as anti-patterns simply because another pattern exists without making a case that the approach has been found to have harmful consequences in the past. Developers often use it as the only argument against a particular approach with no explanation necessary for why the approach leads to adverse consequences.

The existence of a pattern for solving some problem does not mean that other approaches are inherently incorrect, or valueless. The phrase "there is more than one way to skin a cat" is a truism that we all intuitively understand. While some approaches tend to lead to wrong results, and some that tend to lead to good results, there is no correct or incorrect approach for all scenarios.

Evolution of Ideas
------------------

Engineering ideas evolve. What may be impossible today may be possible and recommended tomorrow. What was possible yesterday may not be possible or desirable today. Moreover, problems are not isolated. When an engineer is attempting to solve a problem, there is always more than one thing to consider. Let's take transportation as an analogy.

Before horses were domesticated, people must have assumed that walking or running from place to place was the most efficient way to travel. People must have had the fixed idea that it was impossible to travel long distances quickly. When horses were domesticated, people discovered that they could travel over long distances in a shorter period. With the use of carts and maritime travel, they could also move more food and supplies over more considerable distances.

Later, engineers invented trains, automobiles, and airplanes. Imagine if society declared that trains were the only valid pattern for solving the problem of transportation. Imagine that the combustion engine had been declared an anti-pattern because of its absurd wastage of fuel. The automobile has emancipated people from the tyranny of distance, and trucks have allowed goods to flow freely across borders and supply remote communities with much-needed items.

If one asks the question today, "Which form of transport is best?", there is no single answer. Horse riding solved the problem of traveling long distances quickly, but there were many inefficiencies - much like the automobile. Engineers invented many other forms of transport and yet, [rail and shipping remain](https://pubs.acs.org/doi/10.1021/es9039693) the most environmentally friendly forms of transport. No single design pattern for transportation was _correct_, and no one approach used today is an anti-pattern. A square wheel could easily qualify as a good use of the term anti-pattern because there is no scenario in which a square wheel is an excellent design pattern, but air travel is not an anti-pattern. The invention of the automobile as a form of transport did not relegate airplanes to the anti-pattern bucket. However, at the same time, airplanes do not make automobiles obsolete either.

Ideas, practices, principles, approaches, and the like evolve. Declaring one of these as correct and all others to be incorrect is an oversimplification and a [logical fallacy](https://en.wikipedia.org/wiki/False_dilemma). Using the words pattern and anti-pattern as synonyms for correct or incorrect ignore reality and further cement software development dogma.

Prototyping
-----------

Developers need to consider the [importance of prototyping](https://build2think.wordpress.com/2013/04/11/learning-prototyping-with-the-marshmallow-challenge/) here. They bring with them years of received knowledge from universities, blogs, other developers, and other sources. It's easy to rely on preconceived ideas and practices habitually, but prototyping often proves to be the best way to road-test an approach. If a given pattern is the best way to solve a problem, then prototyping it, and comparing it with other prototypes highlights its benefits. The marshmallow challenge highlights how children tend to approach problems by quickly experimenting without preconceived ideas, reevaluating ideas, and learning from past mistakes.

Developers need to evaluate every approach on its merits for the use in a specific scenario, and trialing multiple approaches to gain objective insights into what works best in a given scenario is always going to be superior to blindly following received knowledge. When developers reject "anti-patterns" as being incorrect, they discourage prototyping, and this leads to avoiding valuable lines of exploration. It would be a mistake to think that just because a problem has been solved with a given pattern, that a developer should solve every other similar problem with the same pattern. Only trialing an approach can demystify potential benefits and costs that an approach may yield.

Points To Consider
------------------

*   The existence of a pattern for solving a problem does not mean the absence of valid alternative solutions. In other words, categorizing an approach as an anti-pattern is not a valid argument against an approach
*   Some accepted patterns have been proven to be bad
*   There is no authority that a developer can turn to on all decision making
*   Developers may need to get burned by approaches a few times to understand why an approach is generally bad
*   The best way to evaluate an approach is to prototype and compare them in your scenario

However,

*   Following established patterns is _usually_ a good idea
*   Being guided by validated studies is likely to enhance the chance of project success
*   Reinventing the wheel is risky and time-consuming
*   Following patterns that other developers can recognize and understand is likely to save time and enhance the chance of project success
*   Developers should unfavorably view approaches that have been studied and proven to reduce the chance of success

Conclusion
----------

My general contention is that people or groups considered to be authorities often dominate the field of software development. It creates pervasive dogma that socializes developers out of critical thinking. Learning lessons based on experience rather than rote memorization of views is essential. When pundits categorize an approach as an anti-pattern, there is no further explanation necessary for critical thinking on the topic, and other developers feel they can safely ignore the approach. It creates a toxic culture in the field of software development where developers often overlook useful approaches. A positive path forward is to keep an open mind, continue evaluating knowledge-based experience and experimentation, and to learn not to shoot down others based on received knowledge. Most importantly, stop categorizing people's ideas as anti-patterns when you disagree with them.

_Note: This article was substantially edited for clarity. Please contact me for earlier revisions._