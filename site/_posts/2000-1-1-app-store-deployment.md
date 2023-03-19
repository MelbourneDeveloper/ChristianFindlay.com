---
layout: post
title: "App Store Deployment"
date: "2019/03/23 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/appdev/header.jpg"
image: "/assets/images/blog/appdev/header.jpg"
tags: deployment app-store
categories: [software development]
permalink: /blog/:title
---

App Stores are a great advancement in Software Deployment. They offer something like the Zero Footprint model while still allowing the application to have access to the resources on the device at the discretion of the user. This solves one of the oldest of Software Deployment problems: getting the app on to client devices without having to physically install the app on their device yourself. However, there is still the issue left of how to deploy to the store in the first place.Here I will be talking about the [Google Play](https://play.google.com/store) Store, [Apple Store](https://www.apple.com/au/ios/app-store/), and [Microsoft Store,](https://www.microsoft.com/en-au/store/apps/windows) although there could potentially be other stores that might require deployment now or in future. This series of articles is generally aimed introducing developers and deployment engineers to the challenges around native mobile app deployments, and hopefully offer some breadcrumbs on how to deal with the issues.

Challenges
----------

### Store Submission Hurdles

Each App Store has its own submission policies, submission front-ends, submission APIs, and submission validation processes. As an app developer, you may easily find yourself overwhelmed by the rigid systems that are in place for getting your app in to the store. Once the app is first accepted in to the store, the process for submitting updates are often not trivial either. Your submission can be rejected for any number of reasons, and processing could take days to finish. Some stores are faster than others.Understanding the policies is crucial. Get familiar with what the big tech giants are asking you to do:

[App Store Review Guidelines (Apple)](https://developer.apple.com/app-store/review/guidelines/)

[Developer Policy Center (Google)](https://play.google.com/about/developer-content-policy/#!?modal_active=none)

[App Submissions (Microsoft)](https://docs.microsoft.com/en-us/windows/uwp/publish/app-submissions)

### Back-End Front-End Versioning

There are no guarantees that versions will be in sync when it comes to the world of App Store deployment. There will always be some waiting period for your app submission to be accepted. If users decide not to upgrade, or their OS actually prohibits them from upgrading because the application targets a version higher than their OS, their application will be trying to talk to the previous version of the back-end. Assuming that your app does depend on a back-end API, you will need to support some kind of back-end API versioning system. This may be as simple as checking that the version between client and server match, and  refusing to let the user log in if there is a disparity. But this creates a poor user experience and down time.Please have a read of this article on [Back-end Front-End Versioning](/back-end-front-end-versioning/) for a more in-depth understanding of the problem.If you've deployed browser based apps in the past you will notice that versioning browser based apps isn't as difficult because HTML and JavaScript can be tweaked after deployment. However, tweaking a native mobile application usually requires a full redeploy. Often front-end browser based apps are deployed with the back-end, and there is no need for a 3rd party (App Store) to mediate when the front-end is deployed. If you've had this luxury in the past, say goodbye when you reach the world of App Store deployment.

### Multi Tenancy

Have you found [multi tenancy](https://en.wikipedia.org/wiki/Multitenancy) difficult? Well, wait until you throw App Store deployment in to the mix! If you are planning on releasing in to an App Store, the first thing you are going to realise is that it is probably designed to allow only one app in the store. Apple's policy is explicit about [this point](https://developer.apple.com/app-store/review/guidelines/#spam).

> Don’t create multiple Bundle IDs of the same app. If your app has different versions for specific locations, sports teams, universities, etc., consider submitting a single app and provide the variations using in-app purchase.

That said, the stores will probably not consider naming your app separately for each of your customers to be Spam. However, there is always a risk that the store might notice that the apps are almost identical and hassle you. You also may decide that maintaining multiple store apps is too much overhead, and it may be a design decision to have your front end point at multiple different APIs divided by customer and version. If this is the design decision, you are definitely going to need to look at [Back-end Front-End Versioning](/back-end-front-end-versioning/).At this point, it's important to note that App Stores are generally only fit for general app consumers. They are generally not aimed at enterprise level customers. So, you should be looking at the option of deploying a front-end version per customer through an enterprise, or custom app store solution. If you have many customers, you are going to need to look at automating this process. A tool like [Jenkins](https://jenkins.io/) may be a starting point for automating some of this. Something to remember is that the public app stores are public. When you deploy there, regular consumers will see your app, and this is not ideal when your customers don't want the app being available to the general public.Here are the enterprise offerings[.](https://developer.apple.com/programs/enterprise/)

[Apple Developer Enterprise Program](https://developer.apple.com/programs/enterprise/)

This option purports to allow you to deploy in house apps, to your organization and probably expedites to the process of submission - if not reduces the time to nil. This will probably be a good option if you are only deploying an app to your organisation.[‍](https://developer.apple.com/business/distribute/)

[Apple Customised Apps For Businesses](https://developer.apple.com/business/distribute/)‍

This option is similar to the enterprise option but allows your organisation to privately deploy and sell apps to multiple customers. This will probably be a good option if you are a software house with a large system that deploys to many customers with back-ends that are isolated from each other. This option might be good for staggering version releases across customers.[‍](https://support.google.com/a/answer/2494992?hl=en)

[Google Play Private Apps](https://support.google.com/a/answer/2494992?hl=en)‍

This option purports to be similar to the Apple Enterprise Program. It probably expedites to the process of submission. This will probably be a good option if you are only deploying an app to your organisation. This might be a deployment option if your customer has the technical skills to create a Google Play account, and hand you the keys to administer it for them.[](https://docs.microsoft.com/en-us/microsoft-store/distribute-apps-from-your-private-store)

[Microsoft Private Apps](https://docs.microsoft.com/en-us/microsoft-store/distribute-apps-from-your-private-store)

This option purports to be similar to the Apple Enterprise Program. It probably expedites to the process of submission. This will probably be a good option if you are only deploying an app to your organisation. This might be a deployment option if your customer has the technical skills to create a Windows developer account, and hand you the keys to administer it for them.

Conclusion
----------

I have outlined the challenges involved with app store deployment, and listed some resources for further investigation. Unfortunately, this topic is complicated and requires a lot of thinking. In the next article I will offer one strategy on how to deploy an application to multiple App Stores for multiple customers.Next article: Strategy: [Back-end First](/app-store-deployment-back-end-first/)


<sub><sup>[Photo by Lisa Fotios from Pexels](https://www.pexels.com/photo/person-holding-midnight-black-samsung-galaxy-s8-turn-on-near-macbook-pro-1092671/)</sup></sub>