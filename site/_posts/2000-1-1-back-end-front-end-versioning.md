---
layout: post
title: "Back-end - Front-End Versioning"
date: "2019/03/23 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/versioning/header.jpeg"
tags: deployment app-store
categories: [software development]
permalink: /blog/:title
---

This article is part of a larger series that I am writing on [App Store Deployment](/app-store-deployment/), but this is not limited to App Store Deployment. Versioning between other front-ends and public APIs have similar issues so the problem is not unique to store deployment. This article is oriented toward any situation where the back-end may go out of sync with the front-end for different reasons. API design patterns are also changing and generally shifting toward looser coupling between client and server. The general trend is for front-end apps to become increasingly decoupled from their back-end counterparts. There are several reasons for this.

I'm not going to go in to the nitty gritty of the difficulties in getting apps in to the Google Play, Apple, and Microsoft stores. Suffice it to say, it can be difficult, and time consuming. A submission can be rejected for any number of reasons, and it can take up to several days for any one submission to reach the store.  On top of this, any user can choose to delay an upgrade, and many users will be on older phones that are not compatible with your current front-ends API version. This leaves leaves a situation where front-end versions may be out of sync with each other, or out of sync with the latest back-end version. Here is a quick look at two patterns that might emerge as a strategy to solve the problem.

API Versioning
--------------

[REST API Versioning](https://restfulapi.net/versioning/)

Back-end API versioning can be a very big part of the solution. If you have enough resources and know how in your team, it is possible to have deployed multiple versions of your back-end API. The idea is that any released API version will remain stable, and have some lifespan before being deprecated. This means that front-end versions can rely on any given API for a period of time. This will often disrupt the pattern where  the front-end is stored in the same repo as the back-end repo.

Take GitHub as an example. If you integrate with the GitHub API, your app will not be in the same repo as the GitHub API's codebase. Your version control will not be tied to GitHub's version control. There is no shared code between the front-end and the back-end. GitHub is handing over an API that can be consumed by developers, but when GitHub releases a new API version, they are not taking in to account already tested apps that have been written on for their public API. They may decide not to deploy breaking changes in their latest APIs, but it is their prerogative to do so if they believe that removing parts of APIs will improve their ecosystem. So, the onus is on the front-end developers to make sure that what is released is going to work against a current API, and that that API is not going be deprecated any time soon.

API Versioning is a general trend in public APIs. The basic concept is that once an API has been released in to the wild, it will not be altered or revoked - at least for some period of time. This is more or less necessary for very large APIs like [Facebook's](https://developers.facebook.com/docs/apps/versions/).  Of course no API publisher can guarantee that it will support a given API version forever, and no publisher can guarantee that all calls will be available forever. Some APIs calls may be unexpectedly removed due to security concerns or otherwise, which will require a redeploy of the front-end.

Strengths

*   Decouples versioning from back-end to front-end
*   Gives some level of reliability that any front-end can depend on an existing API version for some period of time
*   The front-end does not need to constantly change to meet shifting goal posts because released APIs attempt to stay stable

Weaknesses

*   Code maintenance becomes much harder because high impact bugs like security fixes and so on need to be applied to multiple versions of the API
*   Database changes can become harder. If a mandatory field is added to the database, but the older API versions do not contain said field, the older APIs will break because they will not insert that data
*   Deployment maintenance becomes much harder because multiple versions need to be deployed and maintained. This means that a given service will end up having multiple sets of dependencies deployed, and the margin for error in deployment is very high. Attempting this without a solid automated deployment system is not recommended.

Using the API Versioning pattern, a team can kill two birds with one stone. A public facing API can be created that can also serve as the back-end that can be consumed by the front-end. However, unless you're a big tech company like Google, Microsoft, Facebook, or so on, the resources required to get this right could be a stretch. Whatever the case may be, if your team decides to implement this pattern, the crucial thing is to make sure that your code, and [version methodology](https://octopus.com/docs/deployment-process/releases/release-versioning) are set up to handle this in the first place. Furthermore it is important that you deprecate often and communicate to your consumers when deprecation is going to be. Ideally, you would support as few versions of your API as possible.

See [this article](/app-store-deployment-back-end-first/) for how this pattern can be used as part of App Store Deployment.

Back-ends For Front-ends (BFF)
------------------------------

[Backends For Frontends](https://samnewman.io/patterns/architectural/bff/)

Your team could develop a back-end service which is a custom fit for your front-end application. The aim of this pattern is different to versioned APIs. In this pattern, the back-end will know about the front-end. The two will be tightly coupled together. They will be best friends forever!

👬👭
====

This pattern can be part of the solution, or part of the problem. Because the two parts know about each other, there will be room for sharing code, and perhaps putting the code in the same code base. But, the problem shifts to the back-end service to create compatibility. Instead of having multiple versions of the back-end API deployed, the back-end must appropriately switch between payload versions based on requests from the front-end. The front-end will probably send HTTP request headers letting the back-end know which version it expects.

This can and will be very difficult because the logic of versioning needs to be baked in to every REST call. The developer needs to take note of the version coming from the client, and return a different version of the payload based on what is requested. This is fraught with difficulty. Instead of using version control to maintain the history between versions, the code base will be filled with if version _x_, then do _y_, else do _z_. In this sense, API versioning is still achieved, it's just done within one deployment rather than multiple deployments.

Strengths

*   Easier deployment
*   Tight coupling will allow for code sharing between front-end and back-end
*   Tight coupling reduces data transfer

Weaknesses

*   Not useful for public APIs
*   If spaghetti will almost certainly ensue and version control will not accurately represent a given version
*   Testing between the front-end and back-end becomes exponentially harder because the back-end is not stable. It will continuously change to accommodate new versions of the front-end.

I don't feel as though this pattern is a good choice for solving the problem of back-end front-end compatibility. It feels more like a hack, but it may be the only hack at the disposal of some teams. If your APIs are not set up to be routed based on versioning, and your team does not have time to take a back step to create a version routing protocol, BFF may be your only choice.

A glance at [Consumer Driven Contracts](https://www.martinfowler.com/articles/consumerDrivenContracts.html) pattern is worthwhile. The general idea is that both sides share a contract based on payloads and their behavior, and that these contracts are individually testable. Again, this is not a full solution, but can be part of the overall solution toward orienting compatibility between front-end, and back-end.

Conclusion
----------

I have looked at two patterns here. The first is shaping up to be the Internet's go to option. Most of us are becoming familiar with the pattern and expect the APIs we work in the same way. However, what I have witnessed is that most development teams are not ready for the kind of discipline that is required for API versioning. This will probably need to change in future, and in your development team, you should be thinking about this problem - especially if you are considering mobile app development, or public API deployment. The BFF pattern might give you a bit of wiggle room when you have a tight deadline, but it's not a very good long term solution. If you're looking at deploying to the app store, you should look at alternative deployment options like [Apple Developer Enterprise Program](https://developer.apple.com/programs/enterprise/), and [Google Play for enterprises](https://developer.android.com/distribute/google-play/work). I will add more on these in subsequent articles.

See this article on [how to detail with mandatory columns](/api-versioning-mandatory-columns/) with API Versioning.
