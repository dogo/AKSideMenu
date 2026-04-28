AKSideMenu
============

![Building](https://github.com/dogo/AKSideMenu/workflows/Building/badge.svg)
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
github "dogo/AKSideMenu" "1.4.6"
```

## Easy to use

### Simple implementation
In your AppDelegate, add the code below.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)

    // Create content and menu controllers
    let navigationController = UINavigationController(rootViewController: FirstViewController())
    let leftMenuViewController = LeftMenuViewController()
    let rightMenuViewController = RightMenuViewController()

    // Create side menu controller
    let sideMenuViewController = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)

    // Make it a root controller
    window?.rootViewController = sideMenuViewController

    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
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
    contentViewController = storyboard!.instantiateViewController(withIdentifier: "contentViewController")
    leftMenuViewController = storyboard!.instantiateViewController(withIdentifier: "leftMenuViewController")
    rightMenuViewController = storyboard!.instantiateViewController(withIdentifier: "rightMenuViewController")
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
Scales the content view down when a menu is visible. Defaults to True.
```swift
public var scaleBackgroundImageView: Bool
```
Scales the background image view before the menu is opened, then animates it back to its normal size while presenting the menu. Defaults to True.
```swift
public var scaleMenuView: Bool
```
Scales the menu view during menu presentation. Defaults to True.
```swift
public var contentViewShadowEnabled: Bool
```
Shows a shadow around the content view while the menu is visible. Defaults to False.
```swift
public var contentViewShadowOffset: CGSize
```
Sets the content view shadow offset. Defaults to CGSizeZero.
```swift
public var contentViewShadowOpacity: Float
```
Sets the content view shadow opacity. Defaults to 0.4.
```swift
public var contentViewShadowRadius: CGFloat
```
Sets the content view shadow blur radius. Defaults to 8.0.
```swift
public var contentViewScaleValue: CGFloat
```
Sets the scale applied to the content view when a menu is visible. Defaults to 0.7.
```swift
public var contentViewInLandscapeOffsetCenterX: CGFloat
```
Sets the horizontal center offset applied to the content view in landscape orientation when a menu is visible. Defaults to 30.0.
```swift
public var contentViewInPortraitOffsetCenterX: CGFloat
```
Sets the horizontal center offset applied to the content view in portrait orientation when a menu is visible. Defaults to 30.0.
```swift
public var parallaxMenuMinimumRelativeValue: CGFloat
```
Sets the minimum relative value for menu view parallax motion effects. Defaults to -15.
```swift
public var parallaxMenuMaximumRelativeValue: CGFloat
```
Sets the maximum relative value for menu view parallax motion effects. Defaults to 15.
```swift
public var parallaxContentMinimumRelativeValue: CGFloat
```
Sets the minimum relative value for content view parallax motion effects. Defaults to -25.
```swift
public var parallaxContentMaximumRelativeValue: CGFloat
```
Sets the maximum relative value for content view parallax motion effects. Defaults to 25.
```swift
public var menuViewControllerTransformation: CGAffineTransform?
```
Sets the initial transform applied to the menu view before it is animated into place. Defaults to `CGAffineTransform(scaleX: 1.5, y: 1.5)`.
```swift
public var parallaxEnabled: Bool
```
Enables motion-effect parallax for the menu and content views. Defaults to True.
```swift
public var bouncesHorizontally: Bool
```
Allows horizontal pan gestures to move past the fully opened menu position. Defaults to True.
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
