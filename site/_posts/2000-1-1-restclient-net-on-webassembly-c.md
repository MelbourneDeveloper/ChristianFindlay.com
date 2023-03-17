---
layout: post
title: "RestClient.Net on WebAssembly (C#)"
date: 2019/08/15 00:00:00 +0000
categories: [dotnet]
tags: restclient-net csharp
author: "Christian Findlay"
post_image: "/assets/images/blog/restclientdotnet/logo.png"
permalink: /blog/:title
---

[RestClient.Net](https://github.com/MelbourneDeveloper/RestClient.Net) is a simple wrapper for HttpClient. It adds strong typing to REST calls and speeds up writing basic Http Request/Response operations. [WebAssembly](https://webassembly.org/) (Wasm) is a platform that allows languages other than JavaScript to be run inside the browser. [Uno Platform](https://platform.uno/) is a Cross Platform framework for building apps that target Wasm. I was very pleasantly surprised to find out that RestClient.Net works on Wasm. Grab the repo with the [sample](https://github.com/MelbourneDeveloper/RestClient.Net/tree/master/RestClient.Net.Samples.Uno) to skip the pep talk, or read on to find out a little more about what it does.

Enroll in my course [Introduction To Uno Platform](https://www.udemy.com/course/introduction-to-uno-platform/?referralCode=C9FE308096EADFB5B661).

If you're a C#/XAML developer, you may have been wanting a UI framework that allows you to build C# apps that target the browser. That's exactly what Uno does (among other things). Once you are using a UI framework on Wasm with C#, you will want a REST client library. RestClient.Net makes it easy to make calls to 3rd party APIs from within the browser. Here is a sample.

### Firefox on Uno

![firefox](/assets/images/restclientwasm/loginscreen.png)

### UWP

![uwp.png](/assets/images/restclientwasm/uwplogin.png)

The sample uses the BitBucket REST API. It retrieves repos for a given user with a GET, and then allows that repo to be modified with a PUT. Here is the [code](https://github.com/MelbourneDeveloper/RestClient.Net/blob/8b67f09de3fa7b94e392bdd447ffc476b3915a5d/RestClient.Net.Samples.Uno/RestClient.Net.Samples.Uno.Shared/MainPage.xaml.cs#L57) for getting repos. You don't need to enter a password. You only need to enter a password to get private repos.

```csharp
private async void OnGetReposClick()
{
    ToggleBusy(true);

    try
    {
        ReposBox.ItemsSource = null;
        ReposBox.IsEnabled = false;

        //Ensure the client is ready to go
        GetBitBucketClient(GetPassword(), true);

        //Download the repository data
        var repos = (await _BitbucketClient.GetAsync<RepositoryList>());

        //Put it in the List Box
        ReposBox.ItemsSource = repos.values;
        ReposBox.SelectedItem = repos.values.FirstOrDefault();
        ReposBox.IsEnabled = true;
    }
    catch (Exception ex)
    {
        await HandleException($"An error occurred while attempting to get repos.");
    }

    ToggleBusy(false);
}
```

Here is the code for saving the repos:

```dart
private async Task OnSavedClicked()
{
    ToggleBusy(true);

    try
    {
        var selectedRepo = ReposBox.SelectedItem as Repository;
        if (selectedRepo == null)
        {
            return;
        }

        //Ensure the client is ready to go
        GetBitBucketClient(GetPassword(), false);

        var requestUri = $"{UsernameBox.Text}/{selectedRepo.full_name.Split('/')[1]}";

        //Put the change
        var retVal = await _BitbucketClient.PutAsync<Repository, Repository>(selectedRepo, requestUri);

        await DisplayAlert("Saved", "Your repo was updated.");
    }
    catch (Exception ex)
    {
        await HandleException($"Save error. Please ensure you entered your credentials.");
    }

    ToggleBusy(false);
}
```

Run The Sample
--------------

*   Clone the repo
*   Ensure .NET Core 3.0 installed
*   Open the solution RestClient.Net.Samples.sln in Visual Studio 2017 (2019 will probably also work)
*   Switch to debug
*   Unload or remove any projects whose frameworks are not installed (e.g. Android/iOS)
*   Restore NuGet packages and wait for them to be restored
*   Build RestClient.Net.Samples.Uno.Wasm
*   Run the project RestClient.Net.Samples.Uno.Wasm (It should be the default project)
*   Click "Get My Repos" to get my public repos, or enter your own username/password for your private repos
*   If you run the RestClient.Net.Samples.Uno.UWP project, you will see that the app is almost identicle to the one in the browser
*   You can change the description of your repo, and click save to change it for real.

A Few Notes
-----------

HttpClient on Wasm requires a special HttpHandler. You will notice that the code [here](https://github.com/MelbourneDeveloper/RestClient.Net/blob/8b67f09de3fa7b94e392bdd447ffc476b3915a5d/RestClient.Net.Samples.Uno/RestClient.Net.Samples.Uno.Shared/MainPage.xaml.cs#L42) is slightly different to the UWP code. Other than that, the code is pretty much the same between UWP and Wasm. If you're a UWP developer, you will find Uno very familiar. If you have a basic UWP app that makes basic REST calls, you'll have a good chance at porting your app to Wasm from UWP. The serialization used here is Json.Net, but any type of serializer can be used. Hit me up on Github in the issues section if you have any issues with the sample.