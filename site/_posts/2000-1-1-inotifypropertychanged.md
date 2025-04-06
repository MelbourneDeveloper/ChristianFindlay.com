---
layout: post
title: "XAML: How to Implement INotifyPropertyChanged"
date: "2020/09/11 00:00:00 +0000"
author: "Christian Findlay"
post_image: "/assets/images/blog/inotify/header.jpeg"
image: "/assets/images/blog/inotify/header.jpeg"
tags: xaml
categories: dotnet
permalink: /blog/:title
redirect_from: /2020/09/11/inotifypropertychanged
---

The [INotifyPropertyChanged](https://docs.microsoft.com/en-us/dotnet/api/system.componentmodel.inotifypropertychanged?view=netcore-3.1) changed interface is at the heart of XAML apps and has been a part of the .NET ecosystem since the early days of Windows Forms. The [PropertyChanged](https://docs.microsoft.com/en-us/dotnet/api/system.componentmodel.inotifypropertychanged.propertychanged?view=netcore-3.1) event notifies the UI that a property in the [binding source](https://docs.microsoft.com/en-us/windows/uwp/data-binding/data-binding-in-depth#binding-source) (usually the ViewModel) has changed. It allows the UI to update accordingly. The interface exists for WPF, Silverlight, UWP, Uno Platform, and Xamarin.Forms (that will become .NET MAUI). This article will give examples for UWP, but it is possible to write code from the ViewModel down that is compatible with all these platforms.

Before I go any further, I will mention the [MVVM pattern](https://docs.microsoft.com/en-us/archive/msdn-magazine/2009/february/patterns-wpf-apps-with-the-model-view-viewmodel-design-pattern) but point out that this article does not expect you to follow this pattern. Implementing INotifyPropertyChanged is a fundamental part of MVVM, but MVVM is not required to achieve data binding with INotifyPropertyChanged. If you would like to follow MVVM, I recommend using one of these frameworks: [MvvmCross](https://www.mvvmcross.com/), [Prism](https://prismlibrary.com/), or [ReactiveUI](https://www.reactiveui.net/). 

PropertyChanged Event
---------------------

The interface only requires you to implement this one property. According to Microsoft it,

Occurs when a property value changes.

So, raise this event in the setter of your property. Here is an example of the Name property of a Person class. This class should work on any platform with any XAML technology.

```csharp
public class Person : INotifyPropertyChanged
{
    private string _name;

    public string Name
    {
        get => _name; set
        {
            _name = value;
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Name)));
        }
    }

    public event PropertyChangedEventHandler PropertyChanged;
}
```

<iframe width="560" height="315" src="https://www.youtube.com/embed/gQykzOhMwvY" title="How To Implement INotifyPropertyChanged" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
    
    

Property Paths
--------------

The example above tells the UI that the "Name" property changed. In this case, "Name" is the property path. However, there may cases where a property of a property has changed, or the property path is more complicated. In these cases, you need to qualify the path fully. Read the Microsoft documentation about WPF property paths [here](https://docs.microsoft.com/en-in/dotnet/desktop/wpf/advanced/propertypath-xaml-syntax?view=netframeworkdesktop-4.8). Property paths generally work the same across XAML technologies, but you should test your code on all platforms.

Another thing to note is that if you specify null or string.empty, this generally tells the UI that all properties on the binding source have changed. 