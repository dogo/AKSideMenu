# AKSideMenu

![Building](https://github.com/dogo/AKSideMenu/workflows/Building/badge.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/AKSideMenu.svg)](https://cocoapods.org/pods/AKSideMenu)
[![License](https://img.shields.io/cocoapods/l/AKSideMenu.svg)](https://github.com/dogo/AKSideMenu/blob/master/LICENSE)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

AKSideMenu is a UIKit side menu controller for iOS. It supports left and right menus, pan gestures, menu transitions, content scaling, shadows, fade effects, and optional parallax motion.

<p>
  <img src="https://github.com/dogo/AKSideMenu/raw/master/Screenshots/Screenshot.png" alt="AKSideMenu screenshot" width="320">
  <img src="https://github.com/dogo/AKSideMenu/raw/master/Screenshots/Demo.gif?2" alt="AKSideMenu demo" width="260">
</p>

## Requirements

- iOS 12.0+
- Swift 5.6+
- UIKit
- ARC

## Installation

### Swift Package Manager

In Xcode, open **File > Add Package Dependencies...** and use:

```text
https://github.com/dogo/AKSideMenu.git
```

Or add it to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/dogo/AKSideMenu.git", from: "1.4.7")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["AKSideMenu"]
    )
]
```

### CocoaPods

Add AKSideMenu to your `Podfile`:

```ruby
pod 'AKSideMenu'
```

Then run:

```sh
pod install
```

### Carthage

Add AKSideMenu to your `Cartfile`:

```ruby
github "dogo/AKSideMenu" "1.4.7"
```

Then run:

```sh
carthage update --use-xcframeworks
```

## Quick Start

Create your content controller, optional left and right menu controllers, and make `AKSideMenu` the root controller.

```swift
import AKSideMenu
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)

        let contentViewController = UINavigationController(rootViewController: FirstViewController())
        let leftMenuViewController = LeftMenuViewController()
        let rightMenuViewController = RightMenuViewController()

        let sideMenuViewController = AKSideMenu(
            contentViewController: contentViewController,
            leftMenuViewController: leftMenuViewController,
            rightMenuViewController: rightMenuViewController
        )

        sideMenuViewController.contentViewShadowEnabled = true
        sideMenuViewController.contentViewShadowOpacity = 0.4
        sideMenuViewController.contentViewScaleValue = 0.8

        window.rootViewController = sideMenuViewController
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        self.window = window
        return true
    }
}
```

## Presenting Menus

Every child controller can access the nearest side menu controller through `sideMenuViewController`.

```swift
sideMenuViewController?.presentLeftMenuViewController()
sideMenuViewController?.presentRightMenuViewController()
sideMenuViewController?.hideMenuViewController()
```

You can also wire buttons directly in Interface Builder using these `IBAction` helpers:

```swift
@IBAction func presentLeftMenuViewController(_: AnyObject)
@IBAction func presentRightMenuViewController(_: AnyObject)
```

## Switching Content

Use `setContentViewController(_:animated:)` when a menu item should replace the main content.

```swift
let nextViewController = UINavigationController(rootViewController: SettingsViewController())

sideMenuViewController?.setContentViewController(nextViewController, animated: true)
sideMenuViewController?.hideMenuViewController()
```

## Storyboard Setup

AKSideMenu can instantiate its content and menu controllers directly from storyboard identifiers.

1. Add a root view controller to your storyboard.
2. Set its class to `AKSideMenu` or to your own `AKSideMenu` subclass.
3. Add controllers for the content, left menu, and right menu.
4. Set their Storyboard IDs.
5. In the Attributes inspector for the side menu controller, set:
   - `contentViewStoryboardID`
   - `leftMenuViewStoryboardID`
   - `rightMenuViewStoryboardID`

You can also configure the controllers manually in a subclass:

```swift
import AKSideMenu
import UIKit

final class RootViewController: AKSideMenu {
    override func awakeFromNib() {
        super.awakeFromNib()

        contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentViewController")
        leftMenuViewController = storyboard?.instantiateViewController(withIdentifier: "leftMenuViewController")
        rightMenuViewController = storyboard?.instantiateViewController(withIdentifier: "rightMenuViewController")
    }
}
```

## Delegate

Set the delegate to observe menu presentation, hiding, and gesture-recognizer behavior.

```swift
sideMenuViewController.delegate = self
```

```swift
extension RootViewController: AKSideMenuDelegate {
    func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("Will show menu")
    }

    func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("Did show menu")
    }

    func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("Will hide menu")
    }

    func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("Did hide menu")
    }

    func sideMenu(_ sideMenu: AKSideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer) {
        print("Pan gesture recognized")
    }
}
```

Available delegate methods:

```swift
optional func sideMenu(_ sideMenu: AKSideMenu, shouldRecognizeGesture recognizer: UIGestureRecognizer, simultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
optional func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool
optional func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
optional func sideMenu(_ sideMenu: AKSideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer)
optional func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController)
optional func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController)
optional func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController)
optional func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController)
```

## Configuration

| Property | Default | Description |
| --- | --- | --- |
| `contentViewController` | `nil` | Main controller displayed above the menus. |
| `leftMenuViewController` | `nil` | Controller used as the left menu. |
| `rightMenuViewController` | `nil` | Controller used as the right menu. |
| `backgroundImage` | `nil` | Optional image displayed behind the menu and content containers. |
| `animationDuration` | `0.35` | Duration used for menu and content animations. |
| `panGestureEnabled` | `true` | Enables or disables pan gesture handling. |
| `panFromEdge` | `true` | Requires the pan gesture to begin near the screen edge. |
| `panFromEdgeZoneWidth` | `20.0` | Width of the edge zone that starts menu panning. |
| `panMinimumOpenThreshold` | `60.0` | Minimum pan distance needed to open a menu. |
| `panGestureLeftEnabled` | `true` | Enables pan gestures for the left menu. |
| `panGestureRightEnabled` | `true` | Enables pan gestures for the right menu. |
| `interactivePopGestureRecognizerEnabled` | `true` | Keeps navigation controller interactive pop gestures available when possible. |
| `scaleContentView` | `true` | Scales the content view while a menu is visible. |
| `contentViewScaleValue` | `0.7` | Scale applied to the content view. |
| `contentViewFadeOutAlpha` | `1.0` | Alpha applied to the content view while a menu is visible. |
| `contentViewInLandscapeOffsetCenterX` | `30.0` | Horizontal content offset in landscape. |
| `contentViewInPortraitOffsetCenterX` | `30.0` | Horizontal content offset in portrait. |
| `contentViewShadowEnabled` | `false` | Enables a shadow around the content view. |
| `contentViewShadowColor` | `.black` | Shadow color for the content view. |
| `contentViewShadowOffset` | `.zero` | Shadow offset for the content view. |
| `contentViewShadowOpacity` | `0.4` | Shadow opacity for the content view. |
| `contentViewShadowRadius` | `8.0` | Shadow blur radius for the content view. |
| `scaleMenuView` | `true` | Applies `menuViewControllerTransformation` before the menu animates in. |
| `menuViewControllerTransformation` | `CGAffineTransform(scaleX: 1.5, y: 1.5)` | Initial menu transform. |
| `fadeMenuView` | `true` | Fades the menu view during presentation and dismissal. |
| `scaleBackgroundImageView` | `true` | Scales the background image before the menu opens. |
| `backgroundTransformScale` | `1.7` | Scale applied to the background image view. |
| `parallaxEnabled` | `true` | Enables motion-effect parallax. |
| `parallaxMenuMinimumRelativeValue` | `-15` | Minimum menu parallax value. |
| `parallaxMenuMaximumRelativeValue` | `15` | Maximum menu parallax value. |
| `parallaxContentMinimumRelativeValue` | `-25` | Minimum content parallax value. |
| `parallaxContentMaximumRelativeValue` | `25` | Maximum content parallax value. |
| `bouncesHorizontally` | `true` | Allows horizontal panning past the fully opened menu position. |
| `menuPreferredStatusBarStyle` | `.default` | Preferred status bar style while a menu is visible. |
| `menuPrefersStatusBarHidden` | `false` | Controls status bar visibility while a menu is visible. |

## Examples

The repository includes sample apps in `AKSideMenuExamples`:

- `Simple`: programmatic UIKit setup.
- `Storyboard`: storyboard-based setup.

Open either example project in Xcode and run the shared scheme.

## Contributing

Ideas, issues, and pull requests are welcome. Please keep changes focused and include an example or test when the behavior changes.

## Credits

AKSideMenu was inspired by [RESideMenu](https://github.com/romaonthego/RESideMenu) by Roman Efimov.

## License

AKSideMenu is available under the MIT license. See [LICENSE](LICENSE) for details.
