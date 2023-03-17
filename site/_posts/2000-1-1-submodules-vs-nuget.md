---
layout: post
title: "Git Submodules Vs. NuGet Dependencies"
date: "2020/08/28 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/git/header.jpg"
tags: git
categories: [software development]
permalink: /blog/:title
---

Breaking your solutions up into manageable chunks (libraries) is one of the most important aspects of code maintainability. This article is .NET centric, but the principle applies to any technology and packaging manager such as NPM. Generally speaking, a library (or project/assembly in the .NET world) should only be concerned with one thing and should have as few external dependencies as possible. This leads to a situation where you will have a mesh of dependencies. The simplest way to deal with this is to keep all projects in a single repo under a single solution. However, if you’re doing something right, other people in your organization or the general public will want to use some of your libraries. The question is, should they reference them as NuGet packages? Or, as Git Submodules? This article discusses some pros, cons, and pitfalls of both.

Just a little heads up. This topic will probably end up spanning a few posts because dependency management is very complicated!

### Some Scenarios

Let’s take a look at my scenario. I created an app called [Hardfolio](https://www.microsoft.com/en-au/p/hardfolio/9p8xx70n5d2j). It is a cryptocurrency portfolio app that gathers balances for multiple currencies. It is available on the Google Play Store, the Microsoft Store, and talks to two different cryptocurrency hardwarewallets: [Trezor](https://trezor.io/), and [KeepKey](https://shapeshift.com/keepkey). The app started it’s life in a single repo with a few different projects. As I worked through building the app, I noticed a clear delineation between the layers of the app: USB/Hid, cryptocurrency APIs, and the rest. I hunted around for 3rd party, cross-platform libraries to fill in the abstractions for this, but there were none. A few libraries roughly did the job, but nothing that worked across platforms, so I separated the code into multiple repos in the hope that the community would contribute. This is how the dependency graph looks.

_Note: this app is languishing and requires funding, so hit me up if you want to help me relaunch it._

![Diagram](/assets/images/blog/git/diagram.jpeg){:width="100%"}

[Device.Net](https://github.com/MelbourneDeveloper/Device.Net) 

[Trezor.Net](https://github.com/MelbourneDeveloper/Trezor.Net) 

[Ledger.Net](https://github.com/MelbourneDeveloper/KeepKey.Net) 

[CryptoCurrency.Net](https://github.com/MelbourneDeveloper/CryptoCurrency.Net) 

[Hardwarewallets.Net](https://github.com/MelbourneDeveloper/Hardwarewallets.Net)

I started out testing the projects individually and then launching them on NuGet.org. The problem I ran in to straight away was that every time I needed to change some little detail, I needed to rerelease the dependencies on NuGet.org. It simply isn’t feasible for USB libraries because the testing process is very onerous. I need to physically connect devices to my computer to do integration tests. The public interface was not stable, and I was still making refactors that ripple through all the dependencies. On top of this, debugging wasn’t working. I believe that I could have solved this by [including debugging symbols](https://docs.microsoft.com/en-us/nuget/create-packages/symbol-packages-snupkg) in the NuGet package, but I’m still not sure if this is best practice for public releases.

I would make a change somewhere, and then when I went to do a release for one of the libraries, I would find that the library was broken somewhere. So, I more or less gave up and dragged the projects into the main solution directly. It immediately gave me the ability to do mass refactors across the board, and no need to add PDB files to the NuGet package. This was the key – being able to do refactoring across all libraries. But, I still had loose ends all over the place because I had to manually take care of making sure that changes in a given library made its way into a NuGet version. This was a nightmare to manage. This is the problem that submodules solve. More on that to come…

Recently, I worked at a company where we moved common libraries into a NuGet feed that we all shared. We put this into a DevOps pipeline that automatically versioned the NuGet package. Immediately, we ran into the same problem. The public interfaces of the common libraries were not stable, so refactors often broke libraries that depended on them. But, even when it did become stable, you still have to wait for the pipeline to build and deploy your change before you can access new APIs. I don’t believe it’s appropriate to publish Nuget packages while a public interface is constantly changing. I believe that submodules are more appropriate in this case.

### Publishing Artifacts Automatically

You can read about Azure artifacts [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/artifacts/artifacts-overview?view=azure-devops), and you can read about deploying them via a pipeline [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/artifacts?view=azure-devops). Ultimately, if you want to publish APIs, you need to version them and put them in some pipeline. There’s no avoiding this. The pipeline will need to deploy to a Nuget feed such as Nuget.org or your company’s DevOps artifacts feed for most of us.

However, nothing stops you from working with submodules instead during periods where you are not regularly releasing to an audience. If you are working within an organization, you may decide not to publish code to a Nuget feed. You can break your code up into manageable repos. This is not an excuse for not testing a particular version and not having [consumer-driven contracts](https://martinfowler.com/articles/consumerDrivenContracts.html) that guarantee some given public interface quality. It just means that versioning is driven by commit Id rather than build version.

### What is a Git Submodule?

> [Submodules allow you to keep a Git repository as a subdirectory of another Git repository. This lets you clone another repository into your project and keep your commits separate.](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

A submodule is essentially just a pointer to a commit in a different Git repo. When you initialize the submodule, it clones the repo into a subfolder, and the repo can act as a standard git repo. You can commit, push, and check out branches in this repo. The base repo will keep track of the commit on these submodules and monitor if the submodule has uncommitted changes. Any changes in the submodules will be considered as a change in the base repo.

A key to understanding submodules is that a commit in your repo encompasses all the necessary commits in the external submodules. As long as all changes in the tree of repos are committed, your most recent commit id guarantees that the code can be reproduced. Unless of course someone deletes commits in the submodule repos, but this is poor form anyway.

### How Do I Add a Submodule?

`git submodule add \[INSERT REPO URL\]`

For example, I added Device.Net as a submodule of Trezor.Net with this command:

`git submodule add https://github.com/MelbourneDeveloper/Device.Net.git`

This clones the Device.Net repo into a subfolder of Trezor.Net, and then I am free to reference the Device.Net projects from Trezor.Net directly. This adds a file called .gitmodules and looks like this:

> [submodule “Device.Net”]

path = Device.Net

url = https://github.com/MelbourneDeveloper/Device.Net.git

It also adds a git history pointer commit to the submodule repo that looks like this.

Commit 8642e094850b3c1a1d65f0195e963353de68d2d9  
Commit MessageUpdate README.md

Full documentation [here](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

### A Note on Workflow

A full explanation of my workflow will need to come in a follow-up article, but the crux is this. I break libraries up into repos based on the community that might be interested in the code. For example, Device.Net will be attractive to any community that needs to communicate with USB devices. But, most of them won’t need Trezor.Net because that’s specific to the crypto community. Conversely, the crypto community is not interested in USB communication specifics, so all that USB code was moved out of Trezor.Net

When I create an app or framework, I pull in all the repos as submodules that I need. I do this on the develop branch. They are sometimes my own libraries, but can also be libraries of others. I then manage the commits to all the repos. It helps to have a tool like [GitKraken](https://www.gitkraken.com/) because it allows you to keep multiple repo tabs open, and switch between submodules as tabs. On the release branch, I switch to Nuget dependencies so that if a community member clones the repo, they will be pointing the live Nuget. Developers expect live Nugets so you still need to version your Nugets. Developers don’t want to have to clone a Github repo to use the dependencies.

Pitfalls
--------

*   You need to be vigilant with all repos. If you don’t commit on one of the repos, you may end up with unreproducable code.
*   When you release any library that points to a submodule, you will probably need to create NuGet release versions for all the submodule libraries. You will then need to point the highest level library to these NuGet dependencies manually or through some automated process.
*   Unit tests at all levels are critical. You need to have some level of confidence that you can do a release of any of the dependencies at any point in time
*   I haven’t personally tested submodules within a build pipeline, but there is no reason why it shouldn’t work. You may want to create an automated process that strips the direct project references and replaces them with Nuget versions when the code hits release branch.

Wrap-up
-------

As mentioned, the reality is that if your libraries are public-facing or you are in a large organization that depends on your code, you will need to manage NuGet versioning, and this is not a bad thing. But, you can use submodules to make this easier – especially when the dependencies are in a state of constant flux. It’s not an either-or situation. Carefully managed submodules increase simplicity and allow you to break your repos up more readily.