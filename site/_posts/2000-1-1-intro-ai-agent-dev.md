---
layout: post
title: "Introduction To Development With AI Coding Agents"
date: "2025/04/10 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/ai-agent/header.webp"
image: "/assets/images/blog/ai-agent/header.webp"
tags: ai
categories: [software development]
permalink: /blog/:title
---

AI agents are new LLM (AI) based tools tools that can really enhance your productivity. They are transforming how we approach coding, testing, and deployment tasks. This article introduces you to the various tooling available right now, talks a little about the theory and mentions how development-based AI agents might evolve over the next few years.

## What Are AI Agents?
AI agents are virtual assistants that can take action to achieve specific goals on your behalf. [According to Oracle](https://www.oracle.com/au/artificial-intelligence/ai-agents/),

> AI agents are software entities that can be assigned tasks, examine their environments, take actions as prescribed by their roles, and adjust based on their experiences.

They can operate autonomously, use tools, and make and implement plans. This is different from something like ChatGPT, which simply responds to your messages.

> For example, you could create an agent to know everything about your company's product catalog so it can draft detailed responses to customer questions or automatically compile product details for an upcoming presentation.

[Microsoft](https://news.microsoft.com/source/features/ai/ai-agents-what-they-are-and-how-theyll-change-the-way-we-work/)

The term "agentic AI" refers to systems that actively pursue goals and objectives versus merely performing simple tasks or responding to queries. 

## What are Software Development AI Agents or Coding Agents?

Most agents perform specific types of tasks. Coding agents perform software development tasks like writing or refactoring code, writing tests, or performing other software development activities. They have access to your code and can run CLI tools to perform tasks on your computer.

## Types of Coding Agents

### IDE-Based Agents

IDE-based AI agents are built into your development environment. They offer real-time assistance as you code. These tools provide code completion with AI and automated refactoring and can respond to natural language. They usually have a chat interface, much like ChatGPT. Most importantly, the have built-in AI agents that have access to your code and can edit it directly as you work.

**Examples:**

- [**Cursor:**](https://www.cursor.com) A popular AI-powered code editor based on a fork of Vscode that offers features like intelligent code completion and real-time assistance[5].

<!-- <video controls src="[/assets/images/blog/nimble_charts/iosdemo.mp4](https://assets.basehub.com/191e7e6d/2c99e8a087f981290dc74d2b621a7192/current-best-for-two-mp4.mp4)" title="Cursor"  width="100%" height="360" style="border-radius: 6px;align-items: center;" alt="Cursor Demo"></video> -->

- [**GitHub Copilot:**](https://github.com/features/copilot) GitHub's flagship AI integration product. This VSCode extension recently gained an AI agent.

- [**Cline:**](https://cline.bot/) Another Vscode extension with similar agent functionality to Cursor. This agent has a pay-as-you-go model but tends to be more accurate than the others, in my experience.

### CLI-Based Agents

CLI agents allow developers to interact with the terminal using natural language. You can give instructions in plain English instructions and the agent will attempt to execute the commands to achieve your goals.

**Examples:**

- [**Nimble agent:**](https://github.com/Nimblesite/nimble_agent) This my own open source porject. It's not complete, but I am looking for contributors. It's a LangChain, CLI based AI coding assistant and library aimed at fixing common issues that exist in other AI agents. 


<video controls width="100%" height="360" poster="/assets/images/blog/ai-agent/moviethumbnail.png" style="border-radius: 6px; max-width: 100%; display: block; margin: 20px auto;" title="Nimble Agent Demo">
  <source src="/assets/images/blog/ai-agent/nimble_agent.mov" type="video/quicktime">
  Your browser does not support the video tag. You can <a href="/assets/images/blog/ai-agent/video/nimble_agent.mov" download>download the video</a> instead.
</video>

- [**Claude code:**](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) This is a very popular agent from Anthropic, the maker of the Claude model. This has a pay-as-you-go model and uses the Claude model.

- [**Aider**](https://github.com/Aider-AI/aider) This has emerged as a very popular and stable open-source tool and allows you to BYO API key.

![Aider](https://camo.githubusercontent.com/6d2d9a8d839bed3d9dc1bf62d47f0767e19906ce76d369a78ef9805dbfb34609/68747470733a2f2f61696465722e636861742f6173736574732f73637265656e636173742e737667)
  
### Cloud-Based Agents

Cloud-based AI agents operate remotely, offering powerful capabilities without the constraints of local computing resources.

**Examples:**

- [**Devin.ai:**](https://devin.ai) boasts the ability to act as a virtual programmer in the cloud but with a pretty hefty price tag.

<iframe 
    width= "100%" 
    height= "315" 
    src="https://www.youtube.com/embed/fjHtjT7GO1c" 
    title= "Devin AI Demo"
    frameborder= "0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
</iframe>

- **[Amazon Q Developer](https://aws.amazon.com/q/developer/):** A cloud based AI coding agent from Amazon.

## Agent Frameworks

You can build your own AI agent. Agents extend basic LLM functionality. This usually involves getting the LLM to produce a plan to achieve the goal and then executing that plan in steps with tools. Surprisingly, it's not that hard, and you can build one with no framework at all in your favorite language.

However, the game is changing so quickly that it will be almost impossible to keep up with the feature sets of all the other AI agents that you can use for free. So, if you do want to build an agent, check out one of these frameworks. You will be able to leverage code that many large companies are already using and get features like [MCP Server](https://modelcontextprotocol.io) integration out of the box.

- [**LangChain**](https://www.langchain.com/) specializes in creating multi-step language processing workflows. It [excels in tasks like content generation and language translation by chaining together different language model operations](https://www.getzep.com/ai-agents/langchain-agents-langgraph). It's particularly useful for building simple, linear LLM workflows with strong modularity.

- [**LangGraph**](https://www.langchain.com/langgraph) takes things further by offering a flexible framework for building stateful applications. It handles complex scenarios involving multiple agents and [facilitates human-agent collaboration with features like built-in statefulness and human-in-the-loop workflows](https://www.getzep.com/ai-agents/langchain-agents-langgraph).

### Python Is King

Frankly, I'm not really sure why ML and AI engineers have opted for Python, especially when Python uses dynamic typing, and this confuses the hell out of AI agents. But this is where the industry is at. However, it's not all bad. Python does have a great type system if you extend it with type hints.

When working with AI agent frameworks like LangChain, Python's type hinting system becomes invaluable. [Type hints promote clear and reliable code](https://dagster.io/blog/python-type-hinting) by providing explicit information about the data types your functions expect and return. This makes the code a lot easier for agents to navigate.

## Conclusion

AI agents absolutely will change software development. Whether integrated into your IDE, accessible via the command line, or powered by cloud resources, these tools will dramatically increase productivity.

The landscape is rapidly evolving. The competition between established players and newcomers, particularly from China's tech ecosystem, promises to drive innovation and accessibility in the coming years. There are tonnes of AI agents floating around and they are getting better and better all the time.

Experimenting with these AI agents offers productivity gains today. Your company needs to leverage these tools or they will lose the competitive edge. And you need to learn how to automate some of your jobs because the software engineering profession is changing quickly. Developers won't be writing the majority of code by hand in five years.