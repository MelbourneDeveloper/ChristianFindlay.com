---
layout: post
title: "Device.Net (Usb.Net, Hid.Net) 4.0"
date: "2021/01/31 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/devicenet/logo.png"
image: "/assets/images/blog/devicenet/logo.png"
tags: device-net usb hid cross-platform
categories: dotnet
permalink: /blog/:title
---

Device.Net is a cross-platform .NET framework for talking to connected devices such as USB, Serial Port and Hid devices. It aims to make device communication uniform across all platforms and device types. It runs on .NET 5, .NET Framework, UWP, Android, and other platforms. The new version 4.0 brings an array of fixes and features to make device communication more manageable and stable. Star the repo on [GitHub](https://github.com/MelbourneDeveloper/Device.Net) and join the conversation on the [Device.Net Discord Server](https://discord.gg/ZcvXARm).

### What's New?

Check out the [4.0 Project](https://github.com/MelbourneDeveloper/Device.Net/projects/11) for a full list of bugs and features.

### [#131](https://github.com/MelbourneDeveloper/Device.Net/issues/131) - Logging with Microsoft standard [ILogger](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-5.0)

Logging and tracing is a vast topic for device communication. You need to send telemetry data to a location where it is readable and queryable. Device.Net brings improved logging throughout the system with adjustable log levels. Send your telemetry to a system like Application Insights to store logs and a central queryable location.

```csharp
//Configure logging
var loggerFactory = LoggerFactory.Create((builder) =>
{
    _ = builder.AddDebug().SetMinimumLevel(LogLevel.Trace);
});

//Register the factory for creating Hid devices. 
var hidFactory =
    new FilterDeviceDefinition(vendorId: 0x534C, productId: 0x0001, label: "Trezor One Firmware 1.6.x", usagePage: 65280)
    .CreateWindowsHidDeviceFactory(loggerFactory);
```

### [#126](https://github.com/MelbourneDeveloper/Device.Net/issues/126) - USB Control Transfers

USB devices require special transfer when uploading firmware and performing setup operations. Version 4.0 implements control transfer across all platforms. This example clears the status of the device.

### [#105](https://github.com/MelbourneDeveloper/Device.Net/issues/105) \- Improved Public Interface

The public interface is much simpler. Use extension methods to create factories, and quickly enumerate the devices.

### [#2](https://github.com/MelbourneDeveloper/Device.Net/issues/2) - Cancellation Tokens (Timeouts)

You can now implement timeouts with cancellation tokens. Long-running tasks accept CancellationToken as a parameter.

```csharp
var cancellationTokenSource = new CancellationTokenSource();
//Fire a timeout after 1000 milliseconds
cancellationTokenSource.CancelAfter(1000);
var result = await device.WriteAndReadAsync(writeData, cancellationTokenSource.Token);
```

### [#182](https://github.com/MelbourneDeveloper/Device.Net/issues/182) - SourceLink Support (Stepping into the code)

SourceLink is a debugging feature that allows you to step into code in the Device.Net libraries. It downloads the code from Github so you can step into the code to see what is going wrong.

.NET Resilience and Transient-Fault-Handling with Polly
-------------------------------------------------------

Use [Polly](https://github.com/App-vNext/Polly) to deal with retries for transient faults. Devices often don't work as expected, and users sometimes bump cables. This [sample](https://github.com/MelbourneDeveloper/Device.Net/blob/c8d148b796941bcd554376de47cfa14a81d6d35b/src/Device.Net.UnitTests/StmDfuExtensions.cs#L26) uses Polly to retry on failed control transfers.

```csharp
public static Task<T> PerformControlTransferWithRetry<T>(
    this IUsbDevice usbDevice,
    Func<IUsbDevice, Task<T>> func,
    int retryCount = 3,
    int sleepDurationMilliseconds = 250)
{
    var retryPolicy = Policy
        .Handle<ApiException>()
        .Or<ControlTransferException>()
        .WaitAndRetryAsync(
            retryCount,
            i => TimeSpan.FromMilliseconds(sleepDurationMilliseconds),
            onRetryAsync: (e, t) => usbDevice.ClearStatusAsync()
            );

    return retryPolicy.ExecuteAsync(() => func(usbDevice));
}
```

Reactive Programming
--------------------

Use the [Reactive Extensions](https://github.com/dotnet/reactive) to use messaging with a composable, modern syntax. This sample reads from a thermometer and only reports the result when the temperature changes.

```csharp
private static async Task DisplayTemperature()
{
    //Connect to the device by product id and vendor id
    var temperDevice = await new FilterDeviceDefinition(vendorId: 0x413d, productId: 0x2107, usagePage: 65280)
        .CreateWindowsHidDeviceFactory(_loggerFactory)
        .ConnectFirstAsync()
        .ConfigureAwait(false);

    //Create the observable
    var observable = Observable
        .Timer(TimeSpan.Zero, TimeSpan.FromSeconds(.1))
        .SelectMany(_ => Observable.FromAsync(() => temperDevice.WriteAndReadAsync(new byte[] { 0x00, 0x01, 0x80, 0x33, 0x01, 0x00, 0x00, 0x00, 0x00 })))
        .Select(data => (data.Data[4] & 0xFF) + (data.Data[3] << 8))
        //Only display the temperature when it changes
        .Distinct()
        .Select(temperatureTimesOneHundred => Math.Round(temperatureTimesOneHundred / 100.0m, 2, MidpointRounding.ToEven));

    //Subscribe to the observable
    _ = observable.Subscribe(t => Console.WriteLine($"Temperature is {t}"));

    //Note: in a real scenario, we would dispose of the subscription afterwards. This method runs forever.
}
```

### Improved Documentation

The documentation is far better and is still improving. XML doc now comes inside the Nuget package, and all documentation is published on Github pages [here](https://melbournedeveloper.github.io/Device.Net/index.html). 

### Stability

There are many more fixes and features, but stability is a significant step up in this version. There are far more unit and integration tests, and abstractions make many parts of the system testable. Each revision is an improvement, we have about 70% code coverage, and we will work toward 90% + code coverage.

### Community

The community moved to the [Device.Net Discord Server](https://discord.gg/ZcvXARm). Here you will find other people who work with connected devices in the .NET space. Join and say hello. Feel free to ask questions here before reporting bugs. 

### Wrap-up

Device.Net has gained momentum, and I'm personally working toward bringing this framework up the standard you'd expect from the .NET Foundation. I plan to bring Device.Net to browsers with Blazor and continue to add support for more device types. Please contribute or sponsor if you can.