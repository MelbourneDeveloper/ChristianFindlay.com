---
layout: post
title: "App Store Deployment - Back-end First"
date: "2019/03/23 00:00:00 +00000"
author: "Christian Findlay"
post_image: "/assets/images/blog/appdev/header.jpg"
image: "/assets/images/blog/appdev/header.jpg"
tags: deployment app-store
categories: [software development]
permalink: /blog/:title
---

This follows on from my article about [App Store Deployment](app-store-deployment). Here I am going to offer a strategy for dealing with App Store Deployment where you have one or more customers who have their own back-end service or services. This article will assume that you are going to implement [API Versioning](back-end-front-end-versioning/#api-versioning). The advantage of this pattern is that the back-end can be deployed at any time without having to wait for the front-end. A public API can be published independently of the App Store front-end

API Versioning
--------------

At this point, the assumption is that you have either already versioned your API, or you have decided that this is the path you are going to go down. A full description about how to do this is outside the scope of this article. [This](https://restfulapi.net/versioning/) is a handy resource. You will need to implement:

*   A system where by calls are routed via a version numbering system
*   An API set for each version you wish to maintain, and a way to deploy them (hopefully [automated](https://octopus.com/docs/packaging-applications/versioning))
*   Testing of these APIs in the wild

If you have API versioning covered, the rest is almost a no-brainier. API versioning is the hardest part of this strategy._It is strongly recommended that the versioned API be mostly finished and tested before full swing development of the front end begins_. This is not to say that back-end development should be done in isolation. There must be a solid effort made in the back-end to make sure that it provides all that is needed for the front-end to successfully deliver the user experience. However, the front-end developers should not be working and testing against shifting sands. The API should be mostly ready, or the front-end should depend on a mock up service like [JSONPlaceholder](https://jsonplaceholder.typicode.com/). If a mockup is used, it should closely match a finished API public interface.Of course, front-end developers will find holes, and there will need to be some give and take once the front-end developers are in full swing development mode. The back-end API will change during that period, so don't be too eager to release the back-end until it has been proven that the front-end has everything it needs from the back-end.  At the same time, this must be balanced with getting your public API out the door for consumption for other purposes.If you're struggling to envision how back-end API versioning works, just think about how all the big tech companies version their APIs.[Twitter](https://developer.twitter.com/en/docs/ads/general/overview/versions.html)[Facebook](https://developers.facebook.com/docs/apps/versions/)[GitHub](https://developer.github.com/v3/versions/)I need to touch on [Microservices](https://microservices.io/) here. Microservices are becoming a common pattern. When I talk about the "back-end" I am not excluding a collection of services. A set of Microservices could be considered a "back-end". However, if the back-end is a set of Microservices, decisions need to be made about what constitutes a version. Again, this is outside the scope of this article, but the front-end facing API needs a version number so that the front-end can be sure it is talking to the right thing.

Developing the Front End
------------------------

Your front end will target a particular version of the back-end API. This means that theoretically, you should have a stable API, or API mock up to test against. The assumption while developing should be that the API you are working on now will be the same API that will be working against when you deploy to the App Store.It must be easy to switch to a different version of the API. This will probably mean abstracting Uris in your code so that they are not littered throughout the code base. When it's time to upgrade the API target, you do not want to be sifting through Uris everywhere in the code base to make sure you are pointing to the correct Uris and sending the right http headers. [Dependency Injection](https://en.wikipedia.org/wiki/Dependency_injection) is probably the best pattern to help you achieve this. You will probably want to create an interface for API calls. And that interface should probably depend on another interface which is responsible for constructing Uris based on version.

Back-End Deployment
-------------------

Once the back-end version is complete, and there is confidence that the back-end is ready enough to support the front-end, it can be deployed in to production at any time. There is no need to wait for the front-end to be finished. However, deployment of an API should not be considered a trivial effort. It should only be deployed when necessary. Patching a buggy API will become expensive, and potentially create instability in the front-end. The back-end should be considered a product in and of itself. So, if possible, it would be ideal for the front-end to be tested before the back-end is deployed. This is not always possible however.It's a given that the undertaking that you are embarking upon is going to be difficult. You will probably end up with multiple separate apps installed on your server, or cluster that represent each version. This should not be left up to deployment engineers to deal with manually. An automated CI/CD process should be established as early as possible. Whether you are installing back-ends onsite, or in to a managed server in the cloud, [Jenkins](https://jenkins.io/) is a good option because you will be setting up the framework for deploying the front-end as a two step process.

Front-end (App Store) Deployment
--------------------------------

Once the front-end has been tested against the back-end in the wild, it is ready to be deployed to the store(s). I have already discussed this process in [App Store Deployment](app-store-deployment). However, as per the previous section, it is important to start thinking about automated deployment. Each of the stores offers their own API for deploying to the store:[Google Play Developer API](https://developers.google.com/android-publisher/)[App Store Connect (Apple)](https://developer.apple.com/app-store-connect/)[REST API reference for Microsoft Store for Business](https://docs.microsoft.com/en-us/windows/client-management/mdm/rest-api-reference-windows-store-for-business)Automation of this process is tricky because there are parts that cannot be automated. If an app is submitted overnight, it may be rejected. At this point, there is not much an automated process can do, but processes should be put in place to make sure that the responsible parties is alerted when failure occurs so that they can resubmit. If the APIs are used for nothing else, alerts alone would be a worthwhile measure to implement.

Conclusion
----------

This is an _ideal world_ strategy. It's hard to get right, and API versioning will create maintenance nightmares. It's something to work toward, but don't try biting this off without a solid plan of how to get to end game. That will just result in a mess. That said, it is a common pattern embraced by large corporations, and can promote good practices which create multi-purpose APIs good for front-ends and as public facing services.Deployment is time consuming, and the last thing you want your developers burning their time on is sitting around for apps to be deployed in to the stores, so at every step of the way, attempt to find a way to automate the steps involved.