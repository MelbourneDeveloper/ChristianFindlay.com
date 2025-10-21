---
layout: post
title: "RestClient.Net 7: Compile-Time Safety and OpenAPI MCP Generation"
date: "2025/10/21 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/restclientdotnet/logo.png"
image: "/assets/images/blog/restclientdotnet/logo.png"
tags: restclient-net csharp functional-programming mcp openapi
description: Generate an MCP server in .NET from an OpenAPI (Swagger) YAML/JSON document and use exhaustiveness checks on pattern matching in C# with RestClient.Net 7
categories: [dotnet]
permalink: /blog/:title
---

RestClient.Net 7 is a complete architectural rewrite from the ground up, bringing discriminated union-style Result types, compile-time exhaustiveness checking, and Model Context Protocol integration to C#. If you've been burned by hidden exceptions or missed error cases in production, RestClient.Net 7 is the right choice for you.

## The Problem: C# Doesn't Have Exhaustive Pattern Matching on Type

Traditional C# pattern matching has a critical flaw that causes production bugs:

```csharp
public enum Status { Success, Error, Pending }

// This compiles just fine...
var result = status switch
{
    Status.Success => "OK",
    Status.Error => "Failed",
 // Missing Status.Pending case
};
// ...but throws SwitchExpressionException at runtime!
```

When you're making HTTP calls, you have multiple distinct failure modes: success responses, client errors (400s), server errors (500s), network timeouts, DNS failures, and serialization exceptions. Each requires different handling. Missing any case means production bugs.

This is probably going to become a core part of the C# language soon, but for the time being, [discriminated unions are only at the proposal](https://github.com/dotnet/csharplang/blob/18a527bcc1f0bdaf542d8b9a189c50068615b439/proposals/TypeUnions.md) stage in the C# GitHub repo.

RestClient.Net 7 solves this problem now with exhaustive pattern matching that catches missing cases at compile-time, not runtime.

## Result Types: No Exceptions

RestClient.Net 7 uses the [Outcome Nuget package](https://www.nuget.org/packages/Outcome). It contains result types (basically, discriminated unions) like `Result<TSuccess, HttpError<TError>>`. They represent all possible outcomes explicitly:

```csharp
using var httpClient = new HttpClient();

var result = await httpClient.GetAsync(
    url: "https://api.example.com/posts/1".ToAbsoluteUrl(),
    deserializeSuccess: DeserializePost,
    deserializeError: DeserializeError
);

// The compiler FORCES you to handle all cases
var output = result switch
{
    OkPost(var post) => 
        $"Success: {post.Title}",
    ErrorPost(ResponseErrorPost(var errorBody, var statusCode, _)) => 
        $"HTTP Error {statusCode}: {errorBody.Message}",
    ErrorPost(ExceptionErrorPost(var exception)) => 
        $"Network Exception: {exception.Message}",
 // Missing a case? Your build fails!
};
```

There are exactly three possible outcomes in the closed type hierarchy:

1. **Ok** - Success with your data
2. **Error with ResponseError** - HTTP error response (4xx, 5xx) with the error body
3. **Error with ExceptionError** - Network exception (timeout, DNS failure, connection refused)

No hidden exceptions. No surprise throws. All error paths are visible in your code.

## Exhaustion Analyzer:  Compile-Time Safety Net

Here's how I fixed a core deficiency in C#. RestClient.Net 7 includes the [Exhaustion package](https://www.nuget.org/packages/Exhaustion) I created specifically for this purpose. It's a Roslyn analyzer that provides compile-time exhaustiveness checking. If you forget to handle a case, your build fails with this error:

```
error EXHAUSTION001: Switch on Result is not exhaustive;
Matched: Ok<Post, HttpError<ErrorResponse>>, 
 Error<Post, HttpError<ErrorResponse>> with ErrorResponseError<ErrorResponse>
Missing: Error<Post, HttpError<ErrorResponse>> with ExceptionError<ErrorResponse>
```

This shifts errors from runtime (production) to compile-time (development). You literally cannot ship code that doesn't handle all possible outcomes. For critical applications involving payments, authentication, or data processing, this compile-time guarantee is invaluable.

## Model Context Protocol: Make Your APIs AI-Ready

RestClient.Net 7 appears to be the first .NET HTTP client with native [Model Context Protocol](https://modelcontextprotocol.io/) server code generation. MCP is Anthropic's open standard (now adopted by OpenAI and Google) that lets AI applications like Claude Code or Cursor discover and invoke your API operations.

Here's how it works:

```bash
# Install the MCP generator
dotnet add package RestClient.Net.McpGenerator.Cli

# Generate an MCP server from your OpenAPI spec
dotnet run --project RestClient.Net.McpGenerator.Cli -- \
 --openapi-url api.yaml \
  --output-file Generated/McpTools.g.cs \
 --namespace YourApi.Mcp \
  --server-name YourApi
```

Now AI agents can discover and call your API operations through natural language. You've essentially created a bridge between your enterprise APIs and the GenAI ecosystem. This positions your APIs so that AI can easily leverage them. You can essentially automate your app with an AI agent.

## OpenAPI Code Generation with Type Safety

RestClient.Net 7 generates type-safe C# clients from OpenAPI 3.x specifications:

```bash
dotnet add package RestClient.Net.OpenApiGenerator
```

Unlike other generators that just produce DTOs, RestClient.Net generates complete extension methods on HttpClient with Result type aliases for pattern matching:

```csharp
// All of this is generated from your OpenAPI spec
var user = await httpClient.GetUserById("123", cancellationToken);

var message = user switch
{
    OkUser(var success) => $"User: {success.Name}",
    ErrorUser(ResponseError(var body, 404, _)) => "User not found",
    ErrorUser(ResponseError(_, var status, _)) when status >= 500 => 
        "Service unavailable",
    ErrorUser(ExceptionError(var ex)) => $"Network error: {ex.Message}",
};
```

Notice how the generated code maintains compile-time safety throughout. If you add a new error type to your result type, every switch expression fails to compile until you handle it. It makes the error handling impossible to miss.

## Design Philosophy: Functional Programming in C#

RestClient.Net 7 embraces functional programming principles:

- **Pure functions** with no interfaces to mock
- **Immutable types** throughout (including the Urls library for safe URL construction)
- **Zero exceptions** - Result types instead of throwing
- **Explicit over implicit** - all error paths visible

The architecture uses extension methods on HttpClient, which means it works naturally with `IHttpClientFactory` for proper connection pooling. No more socket exhaustion issues:

```csharp
var httpClient = httpClientFactory.CreateClient();
var result = await httpClient.GetAsync(url, deserialize, deserializeError);
```

For testing, use the standard `DelegatingHandler` pattern - no special mocking framework required.

## Getting Started

Install the core package:

```bash
dotnet add package RestClient.Net
```

This includes the Result types (Outcome package), Exhaustion analyzer, and Urls library. For OpenAPI generation, add:

```bash
dotnet add package RestClient.Net.OpenApiGenerator
```

Check out the [samples folder](https://github.com/MelbourneDeveloper/RestClient.Net/tree/main/Samples) for complete working examples.

## Why This Matters

I've been working on RestClient.Net for over seven years, and version 7 represents everything I've learned about making HTTP calls safely and reliably. The combination of Result types, exhaustive pattern matching, and MCP integration creates something unique in the .NET ecosystem.

If you're building AI-powered applications, need compile-time guarantees for critical systems, or just want to stop debugging production crashes from missing error cases, give RestClient.Net 7 a try. The analyzer will make your life easier.

The package targets .NET Standard 2.1, which means you can use it with .NET Framework 4.5+ through .NET 9+, supports all platforms, and maintains [100% test coverage with a 100%+ mutation score](https://github.com/MelbourneDeveloper/RestClient.Net/blob/8f997cd3dfde475c58cc9d6a6f068412e68ce80a/.github/workflows/pr-build.yml#L40) according to [Stryker Mutator](https://stryker-mutator.io/docs/stryker-net/introduction/). It has an MIT license and is ready for production use.

**Try it**: Install the package and experience compile-time safety with exhaustive pattern matching. Generate an MCP server from your OpenAPI spec. Let the compiler catch bugs before they reach production.

The safest way to make REST calls in C# is here.