---
layout: post
title: "Performance Vs. Scalability"
date: "2022/02/13 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/performance/header.jpg"
image: "/assets/images/blog/performance/header.jpg"
tags: serverless
categories: [software development]
permalink: /blog/:title
---

Performance and scalability are two related but separate aspects of a system. However, there is a lot of confusion around the two terms, which often leads to architectural mistakes. This article talks about the difference between the two concepts and how to improve them.

Performance
-----------

[Performance](https://en.wikipedia.org/wiki/Computer_performance) is about how fast your system works. It's the experience users have when waiting for your system to do something, and it's how fast your underlying code runs. Network latency, bandwidth, and other factors also affect performance. 

When the system does not have a lot of data or users, performance is usually acceptable and easy to manage. When the amount of data and number of concurrent users grow, the servers' resources may reach their maximum, and this will cause performance degradation.

However, there is a key point here. The system's design and the code quality have a huge impact on how quickly the server's resources reach their maximum capacity. You can pay for an extremely expensive database server, but data retrieval will consume a lot of resources if you do not put indexes in the right place. Conversely, efficient code can avoid resource depletion even on cheap servers.

If you've done elementary computer science and learned the basics of data structures and algorithms, you will be aware of how quickly a poor implementation can chew memory or CPU power. This is what we mean by resources. Poor code will chew these up, your system will reach capacity, and users will experience poor performance.

Basically, bad code and database design will slow your servers down and potentially max out your server's resources.

Scalability
-----------

[Scalability](https://en.wikipedia.org/wiki/Scalability) is the ability to handle larger amounts of work when the system is under heavy load by throwing more resources at the problem. This generally means improving performance by buying faster servers or adding more servers. A system is scalable if you can increase the computing power of the existing servers (vertical scaling or scaling up) or increase the number of servers (horizontal scaling or scaling out), and you can also scale back down when there is less system load.

Automatic scaling means that resources become available during busier times but become unavailable when not needed. This is pretty important because you may not be available to add resources during busy times, and you don't want to pay for extra resources when it's quiet. 

A system is not horizontally scalable if the code design does not allow multiple servers to respond to requests. For example, if a service depends on the local state of the server, another server may not be able to serve the same requests. If server a) writes local files to the hard drive and needs those to respond, server b) cannot see those files and will give incorrect responses. Horizontal scalability requires special attention to state.

Independent Scalability
-----------------------

Sometimes architects divide systems into smaller parts. They may separate a data store into two physically different parts. This means that one part of the system can scale up or down separately from the other parts of the system. This can be useful when one part of the system receives more traffic than other parts. 

For example, the menu part of the system may receive thousands of requests per second, while the ordering part may only receive a few transactions per second. If the menu part of the system maxes out resources, it may slow down ordering even though ordering is not doing much work. Independent scaling would allow you to throw resources at the menu so that ordering doesn't suffer performance degradation.

On its face, this seems like a nice-to-have feature of the architecture. However, this may massively increase the system's complexity, and it may actually increase costs. Database instances are often expensive, and you often pay a flat monthly fee whether you use them heavily or not. Moreover, the busier part of the system should only affect the performance of the less active part if the active part maxes out resources.

The important thing to be clear about here is that you do not need independent scalability to achieve vertical or horizontal scalability in your app. All things being equal, the server will respond to requests across different parts of the app simultaneously. If the server cannot, it probably means that it doesn't have enough resources or a code issue is causing blocking.

The System is Slow. What do I do?
---------------------------------

The first thing you need is [monitoring and observability](https://cloud.google.com/architecture/devops/devops-measurement-monitoring-and-observability). You need to log information about what is happening, and you need to have information about the resource usage of the servers that are serving up the system. You cannot answer any questions without this information. So, when your boss comes to you and says, "Please make the system go faster.", the first thing you need to look at is whether you can measure how the system is performing.

When you have some data on what is happening, you will be in a position to speculate about whether you need to work on performance, scale-up, or both. 

Let's say that your GetMenu endpoint takes three seconds, even during quiet times. The server's CPU is hovering at 10%, and there is plenty of free memory. This is a clear sign that you have a typical performance problem. The system is running slowly, even when there is no extra load on the server. It may be as simple as adding an index to a database table. You should use the existing telemetry (logging) data and [performance profiling](https://en.wikipedia.org/wiki/Profiling_(computer_programming)) to figure out what is wrong. This scenario is a clear case where you need to optimize code or the software design. Scaling up will not help you in this scenario.

Take a different scenario. During quiet times, the performance is good, but during peak times, all endpoints take 3+ seconds to run, the server is constantly hovering at around 90%+ CPU usage, and there is very little memory left. This suggests that you could alleviate the problem by scaling up or scaling out the servers. But, it does not prove that you don't have a simple code quality issue. In this scenario, you may want to scale up to improve the experience for users temporarily, but you still need to determine if there is some bad code that is maxing out resources. Again, you will need to use telemetry data and profiling to understand what is happening. There may simply be one code piece that slows the entire system down. Quite often it's a database query.

Does the System Need Scalability?
---------------------------------

It's important to distinguish between vertical and horizontal scalability. You can usually get vertical scalability for free if you deploy to the cloud. Most cloud providers allow you to upgrade the server with a faster CPU and more memory. However, it may shock many people to read that most systems probably do not need horizontal scalability. Unless you are dealing with a very high-end system with thousands of users, the chances are that you will not need it. Assuming that you will need horizontal scalability is a massive underestimation of modern computing power. 

In 2001 I worked on a warehouse management system for Nike. The team bought a Sun Microsystems server that cost around $100,000 at the time, was about 1 meter cubed and weighed more than one person could carry. The server ran an Oracle database server and served the whole warehouse system. I worked on box scanning, and this took around 10 seconds. I optimized the code and added some indexes to the database, which reduced the time to less than 2 seconds which was satisfactory for performance at the time. This system didn't need horizontal scalability even though it serviced a large operation. My smartphone is probably more powerful than that server at this point. Computers are fast and getting faster. 

If you build a Saas application and plan to store data from many organizations in one system, you probably need scalability. Let's say that your application will service businesses that employ 100+ users, and you plan to onboard 100+ businesses to your system. Your app could potentially have 10,000+ concurrent users. In this scenario, you will probably need to spread the load over multiple servers, and this is where horizontal scalability is critical. 

You should design for horizontal scalability because you may need at least two servers running incase one server becomes unavailable. In this sense horizontal scalability relates to availability. But bear in mind that you are far more likely to encounter bad code that slows down your system than hitting a genuine requirement for horizontal scalability. My experience has shown that 9 times out of 10, you can fix performance issues by optimizing the code or database query. I have seen technology or framework upgrades improve response times by 200% to 300%. 

Think about horizontal scalability, but don't be preoccupied with it. Focus on good code quality and observability. These are core ingredients for systems that perform well.

Our Code is Old, Messy, and We Don't Want to Change It.
-------------------------------------------------------

This leads to the big mistake. Almost all businesses allow their codebase to degrade over time. The system slows down, refactoring gets harder, and users start complaining. Attempts to improve performance fail and cause bugs instead. This is the point at which many people conclude it's necessary to rewrite completely and with extreme scalability in mind. Often, people add in the independenct scalability clause. The thinking is that the system is performing so badly right now that only going to the extreme opposite will fix the problems. 

This is where the derogatory term "monolith" comes in. People point to the existing system, note that it only has one database, and then there is no further argumentation necessary to justify massive expenditure on building a new system that supports independent scalability. I've seen this mistake over and over. The mistake here is the belief that engineers cannot improve existing code and that upgrading code to newer technologies is too hard. They can, and they need to improve code continuously. If they don't, you will have the same issue in a few years.

I've witnessed companies burning countless months of time and money to rebuild parts of a system only to abandon the project in the end. 

Your company can improve existing code. You can use things like conditional compilation symbols to target two technologies so you can upgrade, and you can add tests to your existing code to make refactoring easier. I can definitely say that this is almost always the cheaper, easier solution. I recently entered a project where the plan was to implement massive scalability. I led a team to upgrade from .NET Framework to .NET Core, and the performance issues disappeared. There was no need for horizontal scaling at all. 

Your business needs to allocate time and resources to improve code over time. You cannot escape this. Not doing this will only ensure that you end up in the same situation again soon.

Wrap-Up
-------

Performance and scalability are things you will have to deal with in your career. It's important to understand the difference and how they relate to each other. Sometimes you will need to decide which one to focus on, but don't let the existing slow system with poor code guide your decision-making. Poor performance is the inevitable result of neglecting performance over time. Exhaust the performance optimization approach before you reach for scaling out. Scaling out will cost your business money and won't address underlying issues. Use monitoring and observability to guide your decisions instead of buzzwords and architecture trends, and don't get confused between scalability and independent scalability. You don't necessarily need independent scalability to scale horizontally.
