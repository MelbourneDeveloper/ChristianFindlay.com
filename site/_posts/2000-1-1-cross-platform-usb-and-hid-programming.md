---
layout: post
title: "Cross Platform USB and Hid Programming"
date: 2018-12-30 00:00:00 +0000
author: "Christian Findlay"
post_image: "/assets/images/blog/xplatusb/usbcable.jpg"
categories: [dotnet]
tags: usb hid csharp cross-platform
permalink: /blog/:title
---

Delving in to the world of crypto hardwarewallets has led me deep in to the rabbit hole of USB and Hid  programming. I didn't want or expect to be doing any low level programming, yet here I am - screwing around with USB sticks and and cables for hours on end. When I first started writing Hardfolio, I thought that there would be libraries out there to make USB access easy. I was dead wrong. Fortunately, for you, I've done all the hard work on Android, Windows, and UWP, so you can just reap the benefits and integrate devices in to your software.

_Note: some of the code here is out of date. Refer to the [GitHub repo](https://github.com/MelbourneDeveloper/Device.Net)_

USB.Net and Hid.Net
-------------------

These libraries started their life inside Hardfolio as the communication layer to the hardwarewallets. As I realized that there really wasn't any other C# libraries out there that make cross platform communication easy, I started developing these libraries. The code is all open source, and can be found [here](https://github.com/MelbourneDeveloper/Device.Net). While most Hid devices are USB devices, not all USB devices support Hid. So, it's necessary to communicate with them with different API calls. USB.Net, and Hid.Net hide all this nastiness from you.

Here are the API calls for Hid on Windows as an example.

```csharp
[DIlImport("hid.dll", SetLastError = true)]
private static extern bool HidD_GetPreparsedData(SafefileHandle hidDeviceObject, out IntPtr pointerToPreparsedData);

[DIlImport("hid.dll", SetLastError = true, CallingConvention = CallingConvention.StdCall)]
private static extern bool HidD_GetManufacturerString(SafefileHandle hidDeviceObject, IntPtr pointerToBuffer, uint bufferLength);

[DIlImport("hid.dll", SetLastError = true, CallingConvention = CallingConvention.StdCall)]
private static extern bool HidD_GetProductString(SafefileHandle hidDeviceObject, IntPtr pointerToBuffer, uint bufferlength);

[DIlImport("hid.dll", SetLastError = true, CallingConvention = CallingConvention.StdCall)]
private static extern bool HidD_GetSerialNumberString(SafeFileHandle hidDeviceObject, IntPtr pointerToBuffer, uint bufferLength);

[DIlImport("hid.dll", SetLastError = true)]
private static extern int HidP_GetCaps (IntPtr pointerToPreparsedData, out HidCollectionCapabilities hidCollectionCapabilities);

[DIlImport("hid.dll", SetLastError = true) ]
private static extern bool HidD_GetAttributes(SafefileHandle hidDeviceObject, out HidAttributes attributes) ;

[DilImport ("hid.dll", SetLastError = true)]
private static extern bool HidD_FreePreparsedData(ref IntPtr pointerToPreparsedData);

[DIlImport ("hid.dll", SetlastError = true)]
private static extern void HidD_GetHidGuid(ref Guid hidGuid);
```

Here are the equivalent USB calls:

```csharp
[DIlImport("winusb.dil", SetLastError = true)]
public static extern bool WinUsb_ControlTransfer(IntPtr InterfaceHandle, WINUSB_SETUP_PACKET SetupPacket, byte[] Buffer, uint BufferLengt

[DIlImport("winusb.dll", SetlastError = true, CharSet = CharSet.Auto)]
public static extern bool WinUsb_GetAssociatedInterface(SafefileHandle InterfaceHandle, byte AssociatedInterfaceIndex, out SafeFileHandle

[DIlImport("winusb.dll", SetLastError = true)]
public static extern bool WinUsb_GetDescriptor(SafefileHandle InterfaceHandle, byte DescriptorType, byte Index, ushort LanguageID, out US

[DIlImport("winusb.dll", SetLastError = true)]
public static extern bool WinUsb_GetDescriptor(SafefileHandle InterfaceHandle, byte DescriptorType, byte Index, UInt16 LanguageID, byte[]

[DIlImport("winusb.dll", SetLastError = true)]
public static extern bool WinUsb_Free(SafefileHandle InterfaceHandle);

[DIlImport("winusb.dll", SetlastError = true)]
public static extern bool WinUsb_Initialize(SafefileHandle DeviceHandle, out SafefileHandle InterfaceHandle);

[DIlImport("winusb.dll", SetlastError = true)]
public static extern bool WinUsb_QueryDeviceInformation(IntPtr InterfaceHandle, uint InformationType, ref uint Bufferlength, ref byte Buf

[DIlImport("winusb.dll", SetlastError = true)]
public static extern bool WinUsb_QueryInterfaceSettings(SafeFileHandle InterfaceHandle, byte AlternateInterfaceNumber, out USB_INTERFACE.

[DIlImport("winusb.dil", SetlastError = true)]
public static extern bool WinUsb_QueryPipe(SafefileHandle InterfaceHandle, byte AlternateInterfaceNumber, byte PipeIndex, out WINUSB_PIPE

[DIlImport("winusb.dil", SetlastError = true)]
public static extern bool WinUsb_ReadPipe(SafefileHandle InterfaceHandle, byte PipeID, byte[] Buffer, uint Bufferlength, out uint LengthT

[DIlImport("winusb.dil", SetlastError = true)]
public static extern bool WinUsb_SetPipePolicy(IntPtr InterfaceHandle, byte PipeID, uint PolicyType, uint Valuelength, ref uint Value) ;

[DIlImport("winusb.dil", SetlastError = true)]
public static extern bool WinUsb_WritePipe(SafefileHandle InterfaceHandle, byte PipelD, byte[I Buffer, uint Bufferlength, out wint Length
```

You might ask why these two things are so different... You'd be completely justified in thinking that this is madness. But luckily, here is some code that automatically switched between Hid, or USB and hides all the stuff from you:

```csharp
//Register the factory for creating Usb devices. This only needs to be done once.
WindowsUsbDeviceFactory.Register ();
WindowsHidDeviceFactory.Register ();

//Note: other custom device types could be added here
//Define the types of devices to search for. This particular device can be connected to via USB, or Hid
var deviceDefinitions = new List<DeviceDefinition>
{
  new DeviceDefinition{ 
    DeviceType= DeviceType.Hid, 
    VendorId= 0x534C, 
    ProductId=0x0001, 
    Label="Trezor One Firmware 1.6.x"}, 
  new DeviceDefinition{
    DeviceType= DeviceType.Usb, 
    VendorId= 0x1209, 
    ProductId=0x53C1, 
    ReadBuffersize=64, 
    WriteBuffersize=64, 
    Label= "Tr"},
  new DeviceDefinition{
    DeviceType= DeviceType.Usb, 
    VendorId= 0x1209, 
    ProductId=@x53C0, 
    ReadBufferSize=64, 
    WriteBufferSize=64, 
    Label= "Mo"};
};

//Get the first available device and connect to it
var devices = await DeviceManager.Current.GetDevices (deviceDefinitions);
using (var trezorDevice = devices.FirstOrDefault ())
{
  await trezorDevice.InitializeAsync();
  //Create a buffer with 3 bytes (initialize)
  var buffer = new byte[64];
  buffer[0] = 0x3f;
  buffer[1] = 0x23;
  buffer [2] = 0x23;
  Write the data to the device and get the response
  var readBuffer = await trezorDevice.WriteAndReadAsync(buffer);
  Console.WriteLine("All good");
}
```

The code above can be found [here](https://github.com/MelbourneDeveloper/Device.Net/blob/master/src/Usb.Net.WindowsSample/Program.cs).

I'll save the boring details about the underlying for each of the platforms. If you're interested in understanding more about how each of the platforms handle USB and Hid access, you can clone the repo and inspect each part. However, if you're anything like me, you'll just want a library that works. I have gone to great detail about how to use the libraries in the documentation [here](https://github.com/MelbourneDeveloper/Device.Net/wiki). Please have a read through it there and let me know if you have any problems.