---
layout: post
title: "C# Serial Port Access - Windows"
date: 2019/09/14 00:00:00 +0000
tags: csharp
categories: [dotnet]
author: "Christian Findlay"
post_image: "/assets/images/blog/xplatusb/usbcable.jpg"
permalink: /blog/:title
---

There are various ways connected devices communicate with your computer. One of the oldest ways is via the [Serial Port](https://en.wikipedia.org/wiki/Serial_port). In some ways, serial port access is more straightforward than Hid, or USB access, but there are some tricks to it. Some USB devices communicate with your computer via the Serial Port. This post discusses the basics of reading to and from serial ports with C#. This post is specific to Windows with .NET, but subsequent articles look at UWP and Android. This article relates to the [Device.Net](https://github.com/MelbourneDeveloper/Device.Net) framework.

Join the conversation on the [Device.Net Discord Server](https://discord.gg/ZcvXARm)

The [Device.Net](https://github.com/MelbourneDeveloper/Device.Net) framework is a framework dedicated to making it easy to communicate with connected devices. So far, it has covered USB and Hid communication, but recently [SerialPort.Net](https://github.com/MelbourneDeveloper/Device.Net/tree/master/src/SerialPort.Net) was added to the framework. It is a library for communication via the serial port which is usually a [COM](https://en.wikipedia.org/wiki/COM_(hardware_interface)) port. Like any other communication with connected devices, the first step is to scan for a connected device. On Windows, this generally means iterating through COM ports until data can be received.

Some typical examples of serial port devices are GPS units and weigh scales. GPS units and weigh scales send a constant stream of data to your computer, which the app can then interpret as latitude and longitude or weight.

Find The Device
---------------

The app can find COM port devices on Windows in HARDWARE\\DEVICEMAP\\SERIALCOMM of the registry. If you have access to the registry from your app, you can check which devices are connected by calling this code. Each key contains the name of the COM port, which includes a number. Here is the Device.Net [code](https://github.com/MelbourneDeveloper/Device.Net/blob/91780b7ffc7364e63e09d8eef17347233303b256/src/SerialPort.Net/WindowsSerialPortDeviceFactory.cs#L47).

_Note: these code samples are out of date. Check out the repo for the latest_

```csharp
using (var key = Registry.LocalMachine.OpenSubKey (@"HARDWARE\DEVICEMAP \SERIALCOMM"))
if (key != null)
{
  registryAvailable = true;
  //we can look at the registry
  var valueNames = key.GetValueNames();
  foreach (var valueName in valueNames)
  {
    var comPortName - key.GetValue (valueName);
    returnValue.Add(new ConnectedDeviceDefinition($@"\\. \{comPortName}") { Label = valueName });
  }
}
```

If there is no registry access, it is necessary to iterate through the ports and try to connect on each one.

```csharp
if (!registryAvailable)
  //We can't look at the registry so try connecting to the devices
  for (var i = 0; i < 9; i++)
  var portName = $@"\\. \coM{i}"
  using (var serialPortDevice = new WindowsSerialPortDevice (portName))
  {
    await serialPortDevice. InitializeAsync();
    if (serialPortDevice. IsInitialized) 
      returnValue.Add (new ConnectedDeviceDefinition (portName) );
  }
```

Connect
-------

Once the app detects a device COM port, streams must be opened to read or write from the device. The method for doing this is this [CreateFile](https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea)  Windows API. The first parameter is the id of the COM port and looks like the text below. CreateFile creates a filehandle that can be used to access the device's data. Device.Net uses SafeFileHandle because it implements IDisposable. It ensures that the end of the using block closes the handle automatically.

\\\\.\\COM1

```csharp
private SafeFileHandle CreateConnection(string deviceld, FileAccessRights desiredAccess, uint shareMode, uint creationDisposition)
{
  Logger?.Log ($"Calling {nameof (APICalls Createfile)} for DeviceId: {deviceld}. Desired Access: {desiredAccess}. Share mode: {shareMode}. Creation Disposition: (creationDisposition}", nameof (ApiService), null, LogLevel. Information);
  return APICalls.CreateFile(deviceId, desiredAccess, shareMode, IntPtr.Zero, creationDisposition, 0, IntPtr .Zero);
}
```

```csharp
_ReadSafeFileHandle = ApiService.CreateReadConnection(DeviceId,FileAccessRights.GenericRead|FileAccessRights.GenericWrite);
if (ReadSafeFileHandle.IsInvalid) return;
var deb = new Deb();
var isSuccess = ApiService.AGetCommState(_ReadSafeFileHandle, ref dcb);
WindowsDeviceBase.HandleError(isSuccess, Messages ErrorCouldNotGet CommState);
```

If this is successful, the app must call [SetCommState](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setcommstate) to specify the settings for serial port communication. It includes things like [Baud rate](https://en.wikipedia.org/wiki/Baud), [parity](https://en.wikipedia.org/wiki/Parity_bit), byte size and other settings which are specific to the device. If you don't know these, you should look at the documentation for the device. If the documentation doesn't specify this, it might be necessary to contact the manufacturer. [SetCommTimeouts](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-setcommtimeouts) should be called to specify the maximum time a call should take.

```csharp
private void Initialize()
{
    _ReadSafeFileHandle = ApiService.CreateReadConnection(DeviceId, FileAccessRights.GenericRead | FileAccessRights.GenericWrite);

    if (_ReadSafeFileHandle.IsInvalid) return;

    var dcb = new Dcb();

    var isSuccess = ApiService.AGetCommState(_ReadSafeFileHandle, ref dcb);

    WindowsDeviceBase.HandleError(isSuccess, Messages.ErrorCouldNotGetCommState);

    dcb.ByteSize = _ByteSize;
    dcb.fDtrControl = 1;
    dcb.BaudRate = (uint)_BaudRate;
    dcb.fBinary = 1;
    dcb.fTXContinueOnXoff = 0;
    dcb.fAbortOnError = 0;

    dcb.fParity = 1;
    switch (_Parity)
    {
        case Parity.Even:
            dcb.Parity = 2;
            break;
        case Parity.Mark:
            dcb.Parity = 3;
            break;
        case Parity.Odd:
            dcb.Parity = 1;
            break;
        case Parity.Space:
            dcb.Parity = 4;
            break;
        default:
            dcb.Parity = 0;
            break;
    }

    switch (_StopBits)
    {
        case StopBits.One:
            dcb.StopBits = 0;
            break;
        case StopBits.OnePointFive:
            dcb.StopBits = 1;
            break;
        case StopBits.Two:
            dcb.StopBits = 2;
            break;
        default:
            throw new ArgumentException(Messages.ErrorMessageStopBitsMustBeSpecified);
    }

    isSuccess = ApiService.ASetCommState(_ReadSafeFileHandle, ref dcb);
    WindowsDeviceBase.HandleError(isSuccess, Messages.ErrorCouldNotSetCommState);

    var timeouts = new CommTimeouts
    {
        WriteTotalTimeoutConstant = 0,
        ReadIntervalTimeout = 1,
        WriteTotalTimeoutMultiplier = 0,
        ReadTotalTimeoutMultiplier = 0,
        ReadTotalTimeoutConstant = 0
    };

    isSuccess = ApiService.ASetCommTimeouts(_ReadSafeFileHandle, ref timeouts);
    WindowsDeviceBase.HandleError(isSuccess, Messages.ErrorCouldNotSetCommTimeout);
}
```

```csharp
isSuccess = ApiService.ASetCommState(_ReadSafeFileHandle, ref dcb);
WindowsDeviceBase.HandleError(isSuccess, Messages. ErrorCouldNotSetCommState);
var timeouts = new CommTimeouts
  {
    WriteTotalTimeoutConstant = 0,
    ReadIntervalTimeout = 1,
    WriteTotalTimeoutMultiplier = 0,
    ReadTotalTimeoutMultiplier = 0,
    ReadTotalTimeoutConstant = 0
  };
isSuccess = ApiService.ASetCommTimeouts(_ReadSafeFileHandle, ref timeouts);
WindowsDeviceBase.HandleError(isSuccess, Messages. ErrorCouldNotSetCommTimeout):
```

[Code](https://github.com/MelbourneDeveloper/Device.Net/blob/91780b7ffc7364e63e09d8eef17347233303b256/src/SerialPort.Net/WindowsSerialPortDevice.cs#L120)

Reading and Writing
-------------------

Call [ReadFile](https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-readfile) to get data from the device. It can be called in a loop so that whenever data arrives on the port, the app can consume the data for the principal purpose.

Call [WriteFile](https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile) to write a buffer of data to the device. It is not necessary for all devices. However, many devices require a request/response pattern like Http calls. The app sends a buffer of data to the device and then waits to receive a buffer of data with ReadFile.

```csharp
private uint Read (byte[] data)
{
  if (ApiService.AReadFile(_ReadSafeFileHandle, data, data. Length, out var bytesRead, 0)) return bytesRead;
  throw new IOException (Messages. EccorMessageRead);
}
```

Using SerialPort.Net
--------------------

Check out the documentation for Device.Net [here](https://github.com/MelbourneDeveloper/Device.Net/wiki). SerialPort.Net is not yet fully documented, but documentation is on its way. Clone the repo to see a sample. The Windows sample should list devices connected to COM ports like so.

![Sample Output](/assets/images/serial/console.png)

Conclusion
----------

SerialPort.Net is a good starting point for connecting and reading from the COM ports. UWP and Android versions are on their way. If you're building your own Serial Port library, feel free to clone the code and use whatever you like. However, Device.Net has a bunch of tools that make communication with devices easier, so if the framework doesn't help you, reach out on Github and help make Device.Net more comprehensive.