---
layout: post
title: "Publish Source Link NuGet Packages with Azure Pipelines"
date: "2020/12/25 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/dotnet/logo.svg"
image: "/assets/images/blog/dotnet/logo.svg"
tags: nuget azure ci-cd visual-studio
categories: dotnet
permalink: /blog/:title
---

Source Link allows you to publish debuggable NuGet packages. Source Link adds debug symbols to compiled code that point back to your Git repository. That means consumers can step into your code based on a Git commit in a public or private repo. Visual Studio automatically downloads the code as needed. This solves a massive problem that might otherwise discourage developers from moving code into NuGet feeds. This article is a part of a two-part series. The second as yet unpublished article will explain how to consume Source Link NuGet packages. For now, [this article](https://www.meziantou.net/how-to-debug-nuget-packages-using-sourcelink.htm) is useful for consuming Source Link Nuget packages.

### What are Debug Symbols?

Debug symbols are very similar to JavaScript [source mapping](https://developers.google.com/web/tools/chrome-devtools/javascript/source-maps). They map compiled code back to the original source code. By default, Visual Studio outputs files called [PDB files](https://en.wikipedia.org/wiki/Program_database) when you compile the Debug configuration. These have been around since the beginning of .NET, and they contain debug symbols. This means that any app that consumes the library with the PDBs and has access to the source code can directly step into the code.

Debugging symbols are also great for general diagnostics. When you log a stack trace, the runtime can use the symbols to point back to the actual code line where an exception occurred. This often makes logs far more valuable and sometimes allows you to pinpoint where code is going wrong. Tooling often strips the debug symbols from production builds, but there is usually no reason to do this. Some companies want to strip the symbols to make it harder to recognise the source code. However, do this properly, you will need an actual obfuscation tool. Simply removing the symbols will not achieve this.

You can also embed the source symbols in the assembly (DLL) without the need for a PDB file. There is not complete agreement on whether you should embed the symbols in the DLL or the PDB file, but [Claire Novotny](https://twitter.com/clairernovotny) recommends embedding.

> If you distribute the library via a package published to [NuGet.org](https://nuget.org), you should use embedded PDB’s so the debug information is always available with your library. Alternatively, you can build a [symbol package](https://docs.microsoft.com/nuget/create-packages/symbol-packages-snupkg) and publish it to [NuGet.org](https://nuget.org) as well.

[Don't Repeat Yourself](https://devblogs.microsoft.com/dotnet/producing-packages-with-source-link/#dont-repeat-yourself)

The downside of embedding is your libraries, and NuGet packages will be slightly larger, but there is a significant advantage. The library will never separate from the debug symbols. This makes debugging and diagnostics easier as mentioned. This tutorial will explain the embedded approach for the sake of simplicity.

_Note: embedding debug symbols may affect the debugging experience – especially on platforms other than .NET like Android Mono or UWP. Test that you can debug your code._

### What is Source Link?

> [Source Link is a language- and source-control agnostic system for providing first-class source debugging experiences for binaries.](https://github.com/dotnet/sourcelink)

Basically, it’s just extra information that tooling adds to debug symbols that point back to a Git repository. When Visual Studio encounters these symbols, it learns the Url of the code and automatically downloads the relevant file from the Git repository such as a Github repo. This means that if you step into a line of code, you will be able to see the original source code like any other project in your solution.

### Prepare Your Projects

You need to do a few things to your projects to make them Source Link compliant – i.e. make them debuggable. You should do this for any project whose output you want to deploy with the NuGet package. You should use [SDK style](https://docs.microsoft.com/en-us/dotnet/core/project-sdk/overview) projects if you can, but it should work with other csproj formats and .NET platforms such as .NET Framework. Be careful to apply settings to the relevant build configuration, or all configurations. For example, you may choose to apply the settings to the “Release” config only. You need to use a text editor such as Visual Studio code to edit the csproj directly.

1.  Add the appropriate Sourcelink NuGet package. This is based on where your repo is hosted. For Github, use the Microsoft.SourceLink.GitHub NuGet package. For Azure repos, use Microsoft.SourceLink.AzureRepos.Git. These special packages don’t act as a normal dependencies. They simply insert the Git URLs into the debug symbols. See more information [here](https://github.com/dotnet/sourcelink#githubcom-and-github-enterprise).

![](/assets/images/blog/dotnet/nuget.png){:width="100%"}

Add the Source Link NuGet package

2.  Use a text editor to modify the csproj. Change DebugType to “embedded” and turn on the other switches DebugSymbols, PublishRepositoryUrl, ContinuousIntegrationBuild, EmbedUntrackedSources as below. ContinuousIntegrationBuild is significant because it also adds determinacy to the build process, which guarantees that the output is the same no matter where we compile the assembly. Here is the Device.Net csproj file.

<script src="https://gist.github.com/MelbourneDeveloper/0151dc2e6da2cc41f4e9901a4f66b253.js"></script>

Here are some examples from the libraries in [Device.Net](https://github.com/MelbourneDeveloper/Device.Net/blob/57cdf6b00b64bf651d943eca1946f85b1c5035e3/src/Device.Net/Device.Net.csproj#L9) [Usb.Net.UWP](https://github.com/MelbourneDeveloper/Device.Net/blob/57cdf6b00b64bf651d943eca1946f85b1c5035e3/src/Usb.Net.UWP/Usb.Net.UWP.csproj#L21)

### Prepare Nuspec Files

Nuspec files both specify metadata about the NuGet package and some directives for creating the NuGet Package.

1.  Create a NuSpec file for each NuGet Package you want to deploy. If you’re unsure how to create a NuSpec file, go to project settings -> Package -> Generate NuGet Package on Build (GeneratePackageOnBuild) and build the project in release mode. This will output a NuGet package. You can get the NuSpec file by opening the package as a zip file (it’s just a zip file and you can rename the file to .zip to see the contents).
2.  Add the repository element to the NuSpec file. It needs to point to a Git commit. This piece of XML in the file specifies the Git repo for Source Link.

<repository type="git" url="https://github.com/MelbourneDeveloper/Device.Net" commit="38b74bf1bc73735a161642b496c8b04b342c8d28" />

Note: alternatively, you can turn on “GeneratePackageOnBuild” at the project level, and then the build will create a NuGet package.

Here is an example Nuspec file for Device.Net. Notice that I specify every output file manually. If you choose not to embed the debug symbols in this file, you will also need to specify the PDB file. But, I didn’t have much luck with getting this to work.

<script src="https://gist.github.com/MelbourneDeveloper/86e7eb5dfac6b121758cc409a042eda4.js"></script>

### Build Locally

A simple build will usually require you to clean your repo, perform NuGet restore, build the solution, and then NuGet pack each NuSpec file. This will compile all the projects with Source Link debug symbols, and then NuGet pack will place the compiled assemblies with the symbols in the NuGet packages. You need to have msbuild and NuGet installed on your computer. Here is a simple [batch file](https://github.com/MelbourneDeveloper/Device.Net/blob/57cdf6b00b64bf651d943eca1946f85b1c5035e3/Build.bat#L1) to do this locally. It creates 5 NuGet packages. You can see all the NuSpec files [here](https://github.com/MelbourneDeveloper/Device.Net/tree/develop/Build/NuSpecs).

```bat
git clean -x -f -d

"c:\temp\nuget" restore src/Device.Net.Pipelines.sln

msbuild src/Device.Net.Pipelines.sln /property:Configuration=Release

"c:\temp\nuget" pack Build/NuSpecs/Device.Net.nuspec
"c:\temp\nuget" pack Build/NuSpecs/Device.Net.LibUsb.nuspec
"c:\temp\nuget" pack Build/NuSpecs/Hid.Net.nuspec
"c:\temp\nuget" pack Build/NuSpecs/SerialPort.Net.nuspec
"c:\temp\nuget" pack Build/NuSpecs/Usb.Net.nuspec
```

If you want to see the structure of all this, clone the develop branch of [Device.Net](https://github.com/MelbourneDeveloper/Device.Net/tree/develop) .

### Azure Pipelines YAML

If you don’t have an Azure Pipelines account, [create one](https://azure.microsoft.com/en-au/free/search/). It’s free. Then, follow these steps to [create your first pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/create-first-pipeline?view=azure-devops&tabs=java%2Ctfs-2018-2%2Cbrowser). Azure Pipelines is just a part of [Azure Devops](https://azure.microsoft.com/en-au/services/devops/). Most Microsoft based organisations are now using Azure DevOps for CI/CD.

Building in the pipeline is no different to building locally. You use YAML instead of PowerShell or batch programming. The steps include NuGet restore, which is the same as performing a NuGet restore locally, MSBuild on the solution, and then NuGet pack. These all do the same thing as the batch file, but it does them on a virtual machine in the cloud. The packagesToPack parameter is neat because it allows us to select all Nuspec files instead of packing one by one. Lastly, there is a command called for NuGet push. This [automatically pushes the NuGet package to a feed](https://docs.microsoft.com/en-us/azure/devops/pipelines/artifacts/nuget?view=azure-devops&tabs=yaml). You just need to create a feed in DevOps. I used the “windows-latest” image, but I think you could use any image.

Note that the NuGet push pushes to my private feed. [You can push](https://docs.microsoft.com/en-us/azure/devops/pipelines/artifacts/nuget?view=azure-devops&tabs=yaml) to your private feed, or NuGet.org.

### Output

You will end up with a nupkg file for each nuspec file. You should open these files up in the [Nuget Package Explorer](https://github.com/NuGetPackageExplorer/NuGetPackageExplorer) app to check that they are valid. It should look like this:

![](/assets/images/blog/dotnet/nugetexplorer.png){:width="100%"}

### Further Automation

You should [automate the version number](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/run-number?view=azure-devops&tabs=yaml) in the csproj files and nuspec files. Also, you need to be careful about the Git commit. If this is incorrect, Source Link will not work. Stay tuned for following articles on how to pick this up automatically.

### Wrap-up

You should now have published Source Link NuGet packages. You can now consume these packages, and you should be able to step into the code in Visual Studio. [Follow me on Twitter](https://twitter.com/CFDevelop) for an update on the next article. In the next article, I will give explicit instructions on how to debug your Source Link NuGet packages. If your team needs help automating NuGet builds with Source Link, please contact me on Twitter or [LinkedIn](https://www.linkedin.com/in/christian-findlay/). I can help to get you started and mentor your team on configuring dependencies throughout your ecosystem.