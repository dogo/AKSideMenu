AKSideMenu
============

[![Build Status](https://travis-ci.org/dogo/AKSideMenu.svg?branch=master)](https://travis-ci.org/dogo/AKSideMenu)
[![Cocoapods](http://img.shields.io/cocoapods/v/AKSideMenu.svg)](http://cocoapods.org/?q=AKSideMenu)
[![Pod License](http://img.shields.io/cocoapods/l/AKSideMenu.svg)](https://github.com/dogo/AKSideMenu/blob/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

AKSideMenu is a double side menu library with parallax effect.

<img src="https://github.com/dogo/AKSideMenu/raw/master/Screenshots/Screenshot.png" alt="AKSideMenu Screenshot" width="400" height="568" />
<img src="https://github.com/dogo/AKSideMenu/raw/master/Screenshots/Demo.gif?2" alt="AKSideMenu Screenshot" width="320" height="568" />

## Example Project
See the contained examples to get a sample of how `AKSideMenu` can easily be integrated in your project.

Build the examples from the `AKSideMenuExamples` directory.

## Installation

### [CocoaPods](https://cocoapods.org/).

To install, add the following line to your Podfile:
```ruby
pod 'AKSideMenu'
```
 
### [Carthage](https://github.com/Carthage/Carthage).

To install, add the following line to your  Cartfile: 
 
```ruby
github "dogo/AKSideMenu" "1.4.0"
```

## Easy to use

### Simple implementation
In your AppDelegate, add the code below.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    self.window = UIWindow.init(frame: UIScreen.main.bounds)

    // Create content and menu controllers
    let navigationController: UINavigationController = UINavigationController.init(rootViewController: FirstViewController.init())
    let leftMenuViewController: LeftMenuViewController = LeftMenuViewController.init()
    let rightMenuViewController: RightMenuViewController = RightMenuViewController.init()

    // Create side menu controller
    let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)

    // Make it a root controller
    self.window!.rootViewController = sideMenuViewController

    self.window!.backgroundColor = UIColor.white
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

open func sideMenu(_ sideMenu: AKSideMenu, shouldRecognizeGesture recognizer: UIGestureRecognizer, simultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // return true to allow both gesture recognizers to recognize simultaneously. Returns false by default
    return false
}

open func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // return true or false based on your failure requirements. Returns false by default
    return false
}

open func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    // return true or false based on your failure requirements. Returns false by default
    return false
}

open func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
    print("willShowMenuViewController")
}

open func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
    print("didShowMenuViewController")
}

open func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
    print("willHideMenuViewController")
}

open func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
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

### Properties
```swift
public var animationDuration: TimeInterval
```
The animation duration. Defaults to 0.35.
```swift
public var backgroundImage: UIImage
```
The content background image. Defaults to white.
```swift
public var panGestureEnabled: Bool
```
The content view corner radius. Defaults to 0.
```swift
public var contentViewCornerRadius: CGFloat
```
Enables panGesture detection. Defaults to True.
```swift
public var panFromEdge: Bool
```
Enables panGesture detection from the edge. Defaults to True.
```swift
public var panMinimumOpenThreshold: Float
```
The minimum pan gesture amount to open the side menu. Defaults to 60.0.
```swift
public var interactivePopGestureRecognizerEnabled: Bool
```
Enables interactive pop gesture recognizer. Defaults to True.
```swift
public var scaleContentView: Bool
```
TODO. Defaults to True.
```swift
public var scaleBackgroundImageView: Bool
```
TODO. Defaults to False.
```swift
public var scaleMenuView: Bool
```
TODO. Defaults to True.
```swift
public let contentViewShadowEnabled: Bool
```
TODO. Defaults to False.
```swift
public var contentViewShadowOffset: CGSize
```
TODO. Defaults to CGSizeZero.
```swift
public var contentViewShadowOpacity: Float
```
TODO. Defaults to 0.4.
```swift
public var contentViewShadowRadius: CGFloat
```
TODO. Defaults to 8.0.
```swift
public var contentViewScaleValue: CGFloat
```
TODO. Defaults to 0.7.
```swift
public var contentViewInLandscapeOffsetCenterX: CGFloat
```
TODO. Defaults to 30.0.
```swift
public var contentViewInPortraitOffsetCenterX: CGFloat
```
TODO. Defaults to 30.0.
```swift
public var parallaxMenuMinimumRelativeValue: CGFloat
```
TODO. Defaults to -15.
```swift
public var parallaxMenuMaximumRelativeValue: CGFloat
```
TODO. Defaults to 15.
```swift
public var parallaxContentMinimumRelativeValue: CGFloat
```
TODO. Defaults to -25.
```swift
public var parallaxContentMaximumRelativeValue: CGFloat
```
TODO. Defaults to 25.
```swift
public var menuViewControllerTransformation: CGAffineTransform
```
TODO. Defaults to nil.
```swift
public var parallaxEnabled: Bool
```
TODO. Defaults to True.
```swift
public var bouncesHorizontally: Bool
```
TODO. Defaults to True.
```swift
public var menuPreferredStatusBarStyle: UIStatusBarStyle
```
Preferred UIStatusBarStyle when the menu is visible. Defaults to UIStatusBarStyle.default.
```swift
public var menuPrefersStatusBarHidden: Bool
```
Sets StatusBar hidden or not when the menu is visible. Defaults to False.
```swift
public var backgroundTransformScale: CGFloat
```
Sets the transform scale amount applied to the background imageview. Defaults to 1.7.
```swift
public var panFromEdgeZoneWidth: CGFloat
```
Sets the width of the pan gesture zone should be recognized. Defaults to 20.0.
```swift
public var panGestureLeftEnabled: Bool
```
Enable or disable left pan gesture recognition. Defaults to True.
```swift
public var panGestureRightEnabled: Bool
```
Enable or disable right pan gesture recognition. Defaults to True.

## Collaboration
I tried to build an easy way to use API, while being flexible enough for multiple variations, but I'm sure there are ways of improving and adding more features, so feel free to collaborate with ideas, issues and/or pull requests.

## ARC
AKSideMenu needs ARC.

## Licence
AKSideMenu is available under the MIT license.

### Thanks to the original team
Roman Efimov [@romaonthego](http://twitter.com/romaonthego)

https://github.com/romaonthego/RESideMenu
