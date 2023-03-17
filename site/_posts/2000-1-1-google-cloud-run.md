---
layout: post
title: "Google Cloud Run"
date: "2022/07/26 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/gcp/header.png"
tags: google-cloud-platform serverless
categories: [software development]
permalink: /blog/:title
---

[Google Cloud Run](https://cloud.google.com/run) is a serverless container app service. You can deploy containerised apps to the cloud, which will autoscale horizontally with minimal configuration. It is an alternative to [Kubernetes](https://kubernetes.io/), but you only pay for usage. You do not pay for server uptime when there is no server usage.   

Why Containers?
---------------

Containers give your app portability. If your app runs on a Linux [Docker](https://www.docker.com/) container, your app will run just about anywhere in the cloud, on-prem or on a well-speced computer. Containers decouple your app from the Cloud Host.   

_A container is a runtime instance of a_ [_docker image_](https://docs.docker.com/glossary/#image)_._

> A Docker container consists of

*   A Docker image
*   An execution environment
*   A standard set of instructions

> The concept is borrowed from shipping containers, which define a standard to ship goods globally. Docker defines a standard to ship software.

[https://docs.docker.com/glossary/#container](https://docs.docker.com/glossary/#container)

  

For example, if I build a .NET Web API, it will require the .NET runtime and perhaps other dependencies. I can deploy the app to a cloud host that supports .NET, but what if they change one of the .NET dependencies? It might mean that my app becomes incompatible with their version of .NET. My app needs to be compatible with their service and not the other way around.

Containerization solves this issue. I can install any version of .NET on the container and deploy it. The cloud host doesn't need to know anything about the version of .NET I am using. I can configure the container however I like. Infact, I can install any version of any runtime that suits my needs on the container. _‍_

> Docker images are the basis of [containers](https://docs.docker.com/glossary/#container). An Image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime. An image typically contains a union of layered filesystems stacked on top of each other. An image does not have state and it never changes.  

  

[https://docs.docker.com/glossary/#image](https://docs.docker.com/glossary/#image)

  

I can create a container image and upload it to [Docker Hub](https://hub.docker.com/) or other container image library. I can then reference this image from anywhere. Using it is just like turning on a computer. Any cloud host that supports Docker containers can run these images.  

Containers help you avoid [Cloud Host Lock-In](https://www.infoworld.com/article/3623721/cloud-lock-in-is-real.html).  

Read more about why Docker is a good choice [here](https://www.docker.com/why-docker/).  

Why Serverless Container Apps? 
-------------------------------

Serverless is basically a variant of the PaaS cloud hosting model. It means you don't have to manage infrastructure. More importantly, you only pay for usage. Most PaaS app hosting services require you to keep at least one server running and will allow you to add servers in times of heavy load. This can be efficient but does not allow for a granular pricing model. You will pay a fixed monthly price per running server. That generally means at minimum, you will pay to keep one server up and running all month.  

Serverless is very different. The cloud host tracks things like compute-time, bandwidth and other metrics about your app to calculate the cost. If there is no traffic, you will pay very little. If there is more traffic, you will pay more.    

Serverless vs. Managed Servers
------------------------------

Some people like taking control of the scaling, OS or physical infrastructure. That's understandable, but it comes at a cost and with risk. Managing the server means ensuring the OS and software dependencies are up to date. You still need to configure scaling even in a typical PaaS hosting situation. You can also use Kubernetes to scale up or down, but this typically comes with the similar issue of managing multiple servers.   

Serverless computing takes all these issues off your hands. You do not need to manage any servers. In most scenarios, the cluster will automatically scale up or down without you needing to do anything and you do not need a Kubernetes expert to configure anything. Kubernetes is [notoriously complicated](https://www.theregister.com/2021/02/25/google_kubernetes_autopilot/).  

What About Cost? 
-----------------

It's difficult to calculate the cost difference between traditional Paas and serverless. However, since October last year, I've been using Cloud Run as my test server. You can clearly see that it's cheap, and this cost also includes Firebase.  

![Cost](/assets/images/blog/gcp/cost.png){:width="100%"}

There may come a point where serverless becomes more expensive than traditional Paas. I don't know what point that cutover occurs, but as you can see, setting up Cloud Run to do some testing is a no brainer. It's cheap and easy to start. As I mentioned above, containers give you portability. If migrating to Kubernetes is cheaper, you can do that. You already avoided lock-in when you opted for Docker containers.    

Moreover, you can also split traffic between Kubernetes and Cloud Run. Nothing is stopping you from deploying your container to Cloud Run and Kubernetes. You can split the traffic if you put a [load balancer](https://cloud.google.com/load-balancing/) in front of these instances. This may allow you to do an objective cost comparison of the two.  

How Does Deployment Work?
-------------------------

You create a Docker image by defining a [Docker File](https://docs.docker.com/engine/reference/builder/). Generally, you put this in the same folder as your app in a git repo. The file is a set of instructions to set up the app on the container. Google Cloud has a service called [Cloud Build](https://cloud.google.com/build), a CI/CD platform that builds your app in the cloud. You version your code in a git repo such as GitHub or Bitbucket and cloud build will run your docker file to create the docker image. You can trigger a build whenever you push to a branch of your repo, and you can have a new version of your app running in minutes.  

Stateless Testing
-----------------

When you run your app in Cloud Run, multiple servers will run simultaneously, and any of these servers could stop after processing a request. These servers do not have any guaranteed state persistence. If your app depends on state, you will encounter issues with Cloud Run. Good API design usually means designing for stateless scenarios and Cloud Run gives you the perfect test bed. Even if you don't use Cloud Run to host your app long term, it is a fast and cheap option to test statelessness.  

Are There Alternatives?
-----------------------

Yes. AWS has [AWS App Runner](https://aws.amazon.com/apprunner/) and [Azure Container Apps](https://docs.microsoft.com/en-us/azure/container-apps/overview). I have not fully investigated these options and cannot comment on them. However, I like Google Cloud Run because it is so simple to set up, cheap, and plays nicely with Google authentication which I happen to use.  

Wrap-up
-------

Serverless containers deliver on the original promise of the cloud: host your code in the cloud with autoscaling. It's that simple. There are multiple options for serverless container apps, but my experience with Google Cloud Run has been very good. You can get started easily and it should cost you almost nothing initially. Check out the alternatives and experiment, but always remember to keep an eye on the price no matter which host you choose. 

This post does not imply any affiliation with or endorsement from Google