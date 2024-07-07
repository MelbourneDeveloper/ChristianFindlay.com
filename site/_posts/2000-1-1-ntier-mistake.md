---
layout: post
title: "N-tier Architecture Was a Mistake: Long Live Apps That Talk Directly to the Database"
date: "2023/06/12 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/ntier/tiers.webp"
post_image_height: 662
post_image_height: 800
image: "/assets/images/blog/ntier/tiers.webp"
tags: architecture
categories: [software development]
permalink: /blog/:title
---

Back in the day, many desktop apps talked directly to the database. We didn't have APIs over the top of the database, and quite often, there was literally no security. The software industry eventually transitioned to the n-tier architecture, which places a physical API layer over the top of the database to provide security.  

A robust security model is critical for a modern system, but thinking about why things changed is interesting. This article explores how BaaS can salvage the simplicity of direct database communication while providing a robust security model.

## What Is N-Tier?

N-tier or [Multitier architecture](https://en.wikipedia.org/wiki/Multitier_architecture) aims at separating the various layers. In the case of a web API, the most important separation is the physical separation between the database and the API itself. This separates the API's business logic from the persistence. In its simplest form, an API performs business logic and persists data to/from a database. Typically, n-tier uses relational databases, but modern apps also talk to NoSQL databases like [CosmosDB](https://azure.microsoft.com/en-us/products/cosmos-db/). 

N-tier architecture is predicated on the separation of concerns, which means dividing a system into distinct sections, each responsible for specific functionality. For instance, in a 3-tier architecture, we would have a presentation layer (user interface, or the API endpoints in the case of a Web API), a business logic layer (processing), and a data layer (database), but the system could have further layers, all of which add complexity and maintenance overhead.

## Why N-Tier?

N-tier became popular because modern programming languages like Java and C# made writing business logic in a single language easy. At the same time, database concerns could remain at the database level. Developers didn't have to implement business logic in stored procedures, which were difficult to debug and maintain. Instead, they could write business logic in a familiar language, and the database would handle the data storage and retrieval. This is perfectly reasonable.

The security model of N-Tier architecture treats the API as the central authority that controls access to data and resources. This ensures that clients can only perform operations and access data that the server allows them to access. This model often uses API keys, OAuth tokens, or similar mechanisms. While this approach can provide a robust and flexible security model, it also introduces significant complexity, as the server must manage many different authentication tokens and permissions.

## N-tier Architecture Is Complicated

While this separation is great for clarity and modular development, it also introduces complexity. Each layer has its own dependencies and interfaces, which we must manage and maintain. Moreover, the communication between layers often involves data mapping, which introduces additional overhead and potential points of failure. Each layer introduces latency, which can impact the application's overall performance.

However, the biggest leap in complexity comes from putting a physical API layer over the top of the database. Traditional apps talked directly to the database, so there were only two physical components to maintain. N-tier introduces a 3rd tier and a whole new app to maintain. 

### 3 Tier

![3 Tier](/assets/images/blog/ntier/3tier.svg){:width="50%"}

Instead of only finding a host that will serve up your database, you also need one that will serve up a scalable API. Moreover, those two things must be in the same data center to avoid latency issues. 

## The Simplicity of Direct Database Communication

Consider a more direct approach: allow the application to communicate directly with the database. This is where Backend as a Service (BaaS) systems like [Firebase](https://firebase.google.com/) and [Supabase](https://supabase.com/) come into the picture.

These systems handle many server-side operations that we would typically manage in the business logic layer of the n-tier architecture. They provide APIs for directly interacting with the database and remove the need for a separate server-side application to mediate between the client and the database.

BaaS systems like Firebase and Supabase also offer two-way communication, user authentication, and other services typically part of the business logic layer in an n-tier architecture. This reduces the amount of code you need to write, simplifies your application architecture, and allows you to focus on building features that deliver value to your users.

### BaaS

![BaaS](/assets/images/blog/ntier/baas.svg){:width="50%"}

## Row Level Security (RLS): The Superior Security Model

One of the key arguments for n-tier architecture is its supposed security advantage, achieved by isolating the database from direct external access. However, this argument loses much weight with the rise of sophisticated security models like [Row-level security](https://supabase.com/docs/guides/auth/row-level-security) (RLS).

Row-level security provides fine-grained control over which certain users or roles can access rows in a database table. This is a more flexible and powerful model than the traditional approach of securing APIs. With RLS, you can define policies that govern who can access what data. That provides a level of security that tightly integrates with your data rather than being an additional layer of complexity.

RLS keeps the security model close to the data, which makes it easier to reason about and maintain. It also reduces the code you need to write, as you don't have to implement security checks in your business logic layer. Instead, you rely on the database to enforce the security policies you define. This is more secure because it reduces the risk of bugs in your code that could lead to security vulnerabilities.

BaaS systems like Firebase and Supabase offer built-in support for row-level security. This allows you to leverage this powerful security model without managing it yourself, further simplifying your application architecture.

## Real-Life Scenario

Take a situation where your business needs a mobile app to talk to a database. In the n-tier model, you must build a server-side application to mediate between the client and the database. You must build, host, and maintain the server-side application and the database separately. You also need to ensure that the server-side application is secure and can scale to meet the demands of your users. You'd require a backend developer to build the API.

BaaS systems like Firebase or Supabase allow you to build your app and connect it directly to the database. These platforms allow you to write endpoints or triggers with modern languages like Typescript ([Supabase Edge Functions](https://supabase.com/docs/guides/functions), [Firebase Cloud Functions](https://firebase.google.com/docs/functions)). You no longer need to write in an esoteric language like procedural SQL. You don't need to build a server-side application, and you don't need to worry about hosting or scaling. The BaaS infrastructure takes care of that for you. You can focus on building your app and delivering value to your users, and mobile developers can typically do this themselves.

## Conclusion

To summarise, we can say that the original approach of apps talking directly to the database was a lot simpler. It wasn't easy to secure the data with this approach, and that's one reason that n-tier became popular. But, in a sense, it threw the baby out of the bathwater. It introduced a lot of complexity and overhead that could have been avoided with the RLS model, which is better than the n-tier security model.

While n-tier architecture has served us well, the software development landscape is rapidly changing, and it's time to consider a change back to simplicity. With BaaS and row-level security, you can build simpler, more secure, and easier-to-maintain applications.

Some apps won't be able to use BaaS systems. Supabase supports very complex querying, but BaaS functions may not provide your system with the most maintainable codebase. If these functions become unmaintainable, it may be necessary to move back to the n-tier model. Just understand that there is a simplicity trade-off when you do this.

The n-tier architecture was not a mistake per se, but clinging to it despite its drawbacks is a bad idea. The future of application development has returned. Let's once again embrace writing apps that talk directly to the database. 