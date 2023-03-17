---
layout: post
title: ".NET Application Frameworks - Part 1"
date: 2019/12/19 00:00:00 +0000
tags: frameworks
categories: [dotnet]
author: "Christian Findlay"
post_image: "/assets/images/blog/appframework/header.png"
permalink: /blog/:title
---

Every system needs a framework. The main hubs that a framework should cover are UI/UX, database, and logic. These are the indispensable parts of the application that change over time and make up the bulk of a system. A useful framework frees the system builder or other team members up to focus on these things. However, teams often neglect this and end up reinventing the wheel by focusing on plumbing that shouldn't be necessary. This series puts a case forward for using Application Frameworks with .NET and introduces some such frameworks.

System builders and configuration experts should be able to focus on UI, database, and logic, and it should be possible to develop these with minimal code. When confronted with a new project, the first questions are: what ORM should we use? Which CSS framework? How can the business team communicate logic to developers? It's usually a scramble for developers to hunt around and find the most popular bits and pieces to facilitate this. Resume driven development usually comes in to play here, and developers often choose the technologies that help them get their next job.

Some application frameworks encompass all these parts and put a layer over the top, so that building an application is more declarative and less code is necessary. Let's take a detour to talk about why declarative development is essential and usually superior to imperative programming. [Declarative programming](https://en.wikipedia.org/wiki/Declarative_programming) allows the builder to focus on _what_ the application must accomplish, rather than _how_ the code should accomplish it. 

For example, when building an Excel spreadsheet, numbers are calculated with mathematical formulae. As Excel users, we do not concern ourselves with looping through every row in the spreadsheet, and adding the numbers to perform the Sum() function. We leave this up to the Excel engine. It frees the user to focus on calculating data in the spreadsheet rather than the minutiae of coding. HTML is another example of declarative programming. Defining HTML elements with CSS is far faster than manually coding controls or drawing them on a canvas. The developer hands the rendering part over to the HTML DOM, and this is something with which the developer does not concern themselves. This part could be handed over to a designer, for example. An application framework should take this a step further and allow UI, database, and logic to be defined declaratively. 

I can speak from experience on this. For the majority of my career, I worked on a system whose framework focused on allowing non-developers to build modules on top of the existing framework. A person configuring the system could design the database with their favorite tool such as Microsoft SQL Server Manager, define the UI and its behavior with XAML, and logic could be edited with [Windows Workflow](https://docs.microsoft.com/en-us/dotnet/framework/windows-workflow-foundation/) or with an app inbuilt C# IDE. 

The most gratifying part of building this system came the first time a non-developer team member built an entire module for the system in two weeks. The module was for bridge engineering auditing. The system had never had this functionality before. Still, the team member built the data structures and then wrote the XAML to connect the UI functionality to the underlying data structures. They modified the logic from within the application without redeployment, and the module was ready without my help. It was a complicated module that I didn't have to build. I didn't write a line of code. Moreover, the maintenance of the module proved to be far less onerous because the team member could make changes without the need for a developer.

Off-the-shelf, or From Scratch?
-------------------------------

In my case, I was lucky enough to have enough time to build a framework from scratch carefully and slowly. I had many years to test, refine, enhance the framework to a point where many clients could run the same version of the framework with completely different configurations and app content. However, this isn't the norm. In most cases, development has deadlines, and prototypes need to be delivered quickly without spending time fixing up the framework on the fly. You would hope that we would be living in a time where building an application framework from scratch would not be necessary, and yet, development teams are doing it again, and again _ad infinitum_. 

For my two cents, it's not worth building an application framework from scratch. Except for the case where the business has a guaranteed source of income for a long time, the technology the team is building on is unlikely to become deprecated soon, and there is a strong need to have a custom framework to meet the business's specific needs. One thing I know is that building an application framework takes a long time to refine and expand. Do you have time to build a database editor? Workflow editing? A form designer? It never happens in six months. 

Frameworks
----------

The below is not an exhaustive list, and it is not an endorsement of any frameworks. It is merely a pointer to some example frameworks that seem to allow building systems with minimal coding. In the next part of the series, more frameworks receive mention.

[DWKit](https://dwkit.com)
--------------------------

_Sponsored_

_Business processes, Workflow, and Forms in a self-hosted or cloud low-code platform._

DWKit offers the ability to modify UI/UX, database, and logic, all within a neat web-based user interface. It is based on .NET Core, and React, which are two of the most popular modern development platforms. It supports Microsoft SQL Server and PostgreSQL with more platforms in the pipeline.

[Documentation](https://dwkit.com/documentation)

UI/UX
-----

The [Form Builder](https://dwkit.com/documentation/forms/form-builder/) allows builders to build forms from scratch and edit existing ones. All of the standard controls like checkboxes, textboxes, combo boxes, are supported, and builders can edit without having to write C# code.

<iframe width="560" height="315" src="https://www.youtube.com/embed/-LhBNY46upQ" title="Form builder in DWKit and building your first form" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Database
--------

The [Data Model editor](https://dwkit.com/documentation/data-model/data-model-editing/) allows builders to define the database structure without having to write SQL or to understand the underlying mechanisms of the database platform. These structures then load as part of the UI on forms.

Logic
-----

The powerful [Workflow Editor](https://dwkit.com/documentation/workflow/workflow-features-overview/) allows graphical customization of logic, or with C# code. It puts the power in the hands of the builder to build or modify application logic without the need for busy developers. However, it doesn't cut off the ability for C# developers to write more sophisticated logic with code.

Conclusion
==========

If a team is building a system, there's a need for a framework. Building one from scratch is a distinct option, but I've seen it fail many times, and it ends up costing the business obscene amounts of money and time. If this is the path the team decides to go down, there must be a substantial commitment to doing it correctly and shooting for the long term. It's not a short term project.

Take the time to evaluate some existing frameworks and try them on for size. There are many frameworks to choose from, and backing the right framework might allow the team to build rapidly, and free up developers to focus on only the necessary coding. In the next part, I introduce some other frameworks and go a bit deeper into configuring UI, database, and logic. 