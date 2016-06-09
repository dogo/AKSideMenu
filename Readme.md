AKSideMenu
============

Beautiful iOS side menu library with parallax effect. Written in Swift

[![Build Status](https://travis-ci.org/dogo/AKSideMenu.svg?branch=master)](https://travis-ci.org/dogo/AKSideMenu)
[![Cocoapods](http://img.shields.io/cocoapods/v/AKSideMenu.svg)](http://cocoapods.org/?q=AKSideMenu)
[![Pod License](http://img.shields.io/cocoapods/l/AKSideMenu.svg)](https://github.com/dogo/AKSideMenu/blob/master/LICENSE)

AKSideMenu is a double side menu library with parallax effect.

![](https://github.com/dogo/AKSideMenu/raw/master/Screenshots/Screenshot.png) 
![](https://github.com/dogo/AKSideMenu/raw/master/Screenshots/Demo.gif)

## Example Project
See the contained examples to get a sample of how `AKSideMenu` can easily be integrated in your project.

Build the examples from the `AKSideMenuExamples` directory.

## Installation

AKSideMenu is available through [CocoaPods](http://cocoapods.org).

To install, add the following line to your Podfile:

    pod 'AKSideMenu'

## Easy to use

###Simple implementation
In your AppDelegate, add the code below.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
    
    // Create content and menu controllers
    let navigationController: UINavigationController = UINavigationController.init(rootViewController: FirstViewController.init())
    let leftMenuViewController: LeftMenuViewController = LeftMenuViewController.init()
    let rightMenuViewController: RightMenuViewController = RightMenuViewController.init()

    // Create side menu controller
    let sideMenuViewController: AKSideMenu =  AKSideMenu.init(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)

    // Make it a root controller
    self.window!.rootViewController = sideMenuViewController

    self.window!.backgroundColor = UIColor.whiteColor()
    self.window?.makeKeyAndVisible()
    return true
}        
```
### Storyboards Example

1. Create a subclass of `AKSideMenu`. In this example we call it `RootViewController`.
2. In the Storyboard designate the root view's owner as `RootViewController`.
3. Add more view controllers to your Storyboard, and give them identifiers "leftMenuViewController", "rightMenuViewController" and "contentViewController". Note that in the new XCode the identifier is called "Storyboard ID" and can be found in the Identity inspector.
4. Add a method `awakeFromNib` to `RootViewController.swift` with the following code:

```swift
override public func awakeFromNib() {    
    self.contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("contentViewController")
    self.leftMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("leftMenuViewController")
    self.rightMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier("rightMenuViewController")
}
```

Here is an example of a delegate implementation. Please adapt the code to your context.

```swift
...
sideMenuViewController.delegate = self
...

// MARK: - <AKSideMenuDelegate>
func sideMenu(sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
    print("willShowMenuViewController")
}

func sideMenu(sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
    print("didShowMenuViewController")
}

func sideMenu(sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
    print("willHideMenuViewController")
}

func sideMenu(sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
    print("didHideMenuViewController")
}
```

Present the menu view controller:

```swift
self.sideMenuViewController!.presentLeftMenuViewController()
```

or

```swift
self.sideMenuViewController!.presentRightMenuViewController()
```

Switch content view controllers:

```swift
self.sideMenuViewController!.setContentViewController(viewController, animated: true)
self.sideMenuViewController!.hideMenuViewController()
```

###Properties
```swift
public var animationDuration: NSTimeInterval
```
The animation duration. Defaults to 0.5.
```swift
public var backgroundImage: UIImage
```
The background color. Defaults to transparent black.
```swift
public var panGestureEnabled: Bool
```
Enables defocus on vertical swipe. Defaults to True.
```swift
public var panFromEdge: Bool
```
Returns whether the animation has an elastic effect. Defaults to True.
```swift
public var panMinimumOpenThreshold: Int
```
Returns whether zoom is enabled on fullscreen image. Defaults to True.
```swift
public var interactivePopGestureRecognizerEnabled: Bool
```
Enables focus on pinch gesture. Defaults to False.
```swift
public var scaleContentView: Bool
```
Returns whether gesture is disabled during zooming. Defaults to True.
```swift
public var scaleBackgroundImageView: Bool
```
Returns whether defocus is enabled with a tap on view. Defaults to False.
```swift
public var scaleMenuView: Bool
```
Returns wheter a play icon is automatically added to video thumbnails. Defaults to True.
```swift
public let contentViewShadowEnabled: UIColor
```
Image used to show a play icon on video thumbnails. Defaults to nil (uses internal image).
```swift
public var contentViewShadowOffset: CGSize
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var contentViewShadowOpacity: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var contentViewShadowRadius: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var contentViewScaleValue: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var contentViewInLandscapeOffsetCenterX: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var contentViewInPortraitOffsetCenterX: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var parallaxMenuMinimumRelativeValue: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var parallaxMenuMaximumRelativeValue: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var parallaxContentMinimumRelativeValue: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var parallaxContentMaximumRelativeValue: CGFloat
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var menuViewControllerTransformation: CGAffineTransform
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var parallaxEnabled: Bool
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var bouncesHorizontally: Bool
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var menuPreferredStatusBarStyle: UIStatusBarStyle
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.
```swift
public var menuPrefersStatusBarHidden: Bool
```
Controller used to show custom accessories. If none is specified a default controller is used with a simple close button.

## Collaboration
I tried to build an easy way to use API, while being flexible enough for multiple variations, but I'm sure there are ways of improving and adding more features, so feel free to collaborate with ideas, issues and/or pull requests.

## ARC
AKSideMenu needs ARC.

## Licence
AKSideMenu is available under the MIT license.

### Thanks to the original team
Roman Efimov [@romaonthego](http://twitter.com/romaonthego)

https://github.com/romaonthego/RESideMenu