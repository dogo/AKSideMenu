//
//  AKSideMenu.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

@objc public protocol AKSideMenuDelegate {
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, shouldRecognizeGesture recognizer: UIGestureRecognizer, simultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController)
}

@IBDesignable open class AKSideMenu: UIViewController, UIGestureRecognizerDelegate {

    var visible: Bool = false
    var leftMenuVisible: Bool = false
    var rightMenuVisible: Bool = false
    var sideMenuDelegateNotify: Bool = false
    var originalPoint: CGPoint = CGPoint.zero
    var contentButton: UIButton = UIButton()
    var backgroundImageView: UIImageView?
    var menuViewContainer: UIView = UIView()
    var contentViewContainer: UIView = UIView()

    @IBInspectable public var contentViewStoryboardID: String?
    @IBInspectable public var leftMenuViewStoryboardID: String?
    @IBInspectable public var rightMenuViewStoryboardID: String?
    @IBInspectable public var panFromEdgeZoneWidth: CGFloat = 20.0
    @IBInspectable public var panGestureLeftEnabled: Bool = true
    @IBInspectable public var panGestureRightEnabled: Bool = true
    @IBInspectable public var interactivePopGestureRecognizerEnabled: Bool = true
    @IBInspectable public var scaleContentView: Bool = true
    @IBInspectable public var fadeMenuView: Bool = true
    @IBInspectable public var backgroundTransformScale: CGFloat = 1.7
    @IBInspectable public var scaleBackgroundImageView: Bool = true
    @IBInspectable public var scaleMenuView: Bool = true
    @IBInspectable public var contentViewShadowEnabled: Bool = false
    @IBInspectable public var contentViewShadowColor: UIColor?
    @IBInspectable public var contentViewShadowOffset: CGSize = CGSize.zero
    @IBInspectable public var contentViewShadowOpacity: Float = 0.4
    @IBInspectable public var contentViewShadowRadius: CGFloat = 8.0
    @IBInspectable public var contentViewCornerRadius: CGFloat = 8.0
    @IBInspectable public var contentViewFadeOutAlpha: CGFloat = 1.0
    @IBInspectable public var contentViewScaleValue: CGFloat = 0.7
    @IBInspectable public var contentViewInLandscapeOffsetCenterX: CGFloat = 30.0
    @IBInspectable public var contentViewInPortraitOffsetCenterX: CGFloat = 30.0
    @IBInspectable public var parallaxMenuMinimumRelativeValue: CGFloat = -15
    @IBInspectable public var parallaxMenuMaximumRelativeValue: CGFloat = 15
    @IBInspectable public var parallaxContentMinimumRelativeValue: CGFloat = -25
    @IBInspectable public var parallaxContentMaximumRelativeValue: CGFloat = 25
    @IBInspectable public var parallaxEnabled: Bool = true
    @IBInspectable public var bouncesHorizontally: Bool = true
    @IBInspectable public var menuPrefersStatusBarHidden: Bool = false

    public weak var delegate: AKSideMenuDelegate?
    public var animationDuration: TimeInterval =  0.35
    public var menuViewControllerTransformation: CGAffineTransform?
    public var panGestureEnabled: Bool = true
    public var panFromEdge: Bool = true
    public var panMinimumOpenThreshold: Float = 60.0
    public var menuPreferredStatusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
    public var contentViewController: UIViewController?

    private var _leftMenuViewController: UIViewController?
    private var _rightMenuViewController: UIViewController?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    required public init(contentViewController: UIViewController, leftMenuViewController: UIViewController?, rightMenuViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        self.commonInit()
        self.contentViewController = contentViewController
        self.leftMenuViewController = leftMenuViewController
        self.rightMenuViewController = rightMenuViewController
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        if let storybroadID = self.contentViewStoryboardID {
            self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: storybroadID)
        }
        if let storybroadID = self.leftMenuViewStoryboardID {
            self.leftMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: storybroadID)
        }
        if let storybroadID = self.rightMenuViewStoryboardID {
            self.rightMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: storybroadID)
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = self.backgroundImage
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundImageView = imageView

        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(AKSideMenu.hideMenuViewController), for: .touchUpInside)
        self.contentButton = button

        self.view.addSubview(imageView)
        self.view.addSubview(self.menuViewContainer)
        self.view.addSubview(self.contentViewContainer)

        self.menuViewContainer.frame = self.view.bounds
        self.menuViewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let leftMenuViewController = self.leftMenuViewController {
            self.addChildViewController(leftMenuViewController)
            leftMenuViewController.view.frame = self.view.bounds
            leftMenuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.menuViewContainer.addSubview(leftMenuViewController.view)
            leftMenuViewController.didMove(toParentViewController: self)
        }

        if let rightMenuViewController = self.rightMenuViewController {
            self.addChildViewController(rightMenuViewController)
            rightMenuViewController.view.frame = self.view.bounds
            rightMenuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.menuViewContainer.addSubview(rightMenuViewController.view)
            rightMenuViewController.didMove(toParentViewController: self)
        }

        self.contentViewContainer.frame = self.view.bounds
        self.contentViewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let contentViewController = self.contentViewController {
            self.addChildViewController(contentViewController)
            contentViewController.view.frame = self.view.bounds
            self.contentViewContainer.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)
        }

        if self.fadeMenuView {
            self.menuViewContainer.alpha = 0
        }

        if self.scaleBackgroundImageView {
            self.backgroundImageView?.transform = self.backgroundTransformMakeScale()
        }

        self.addMenuViewControllerMotionEffects()

        if self.panGestureEnabled {
            self.view.isMultipleTouchEnabled = false
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(AKSideMenu.panGestureRecognized(_:)))
            panGestureRecognizer.delegate = self
            self.view.addGestureRecognizer(panGestureRecognizer)
        }

        self.updateContentViewShadow()
    }

    func commonInit() {
        self.menuViewContainer = UIView()
        self.contentViewContainer = UIView()

        self.animationDuration = 0.35
        self.interactivePopGestureRecognizerEnabled = true

        self.menuViewControllerTransformation = CGAffineTransform(scaleX: 1.5, y: 1.5)

        self.scaleContentView = true
        self.backgroundTransformScale = 1.7
        self.scaleBackgroundImageView = true
        self.scaleMenuView = true
        self.fadeMenuView = true

        self.parallaxEnabled = true
        self.panGestureLeftEnabled = true
        self.panGestureRightEnabled = true
        self.parallaxMenuMinimumRelativeValue = -15
        self.parallaxMenuMaximumRelativeValue = 15
        self.parallaxContentMinimumRelativeValue = -25
        self.parallaxContentMaximumRelativeValue = 25

        self.bouncesHorizontally = true

        self.panGestureEnabled = true
        self.panFromEdge = true
        self.panFromEdgeZoneWidth = 20.0
        self.panMinimumOpenThreshold = 60.0

        self.contentViewShadowEnabled = false
        self.contentViewShadowColor = UIColor.black
        self.contentViewShadowOffset = CGSize.zero
        self.contentViewShadowOpacity = 0.4
        self.contentViewShadowRadius = 8.0
        self.contentViewFadeOutAlpha = 1.0
        self.contentViewInLandscapeOffsetCenterX = 30.0
        self.contentViewInPortraitOffsetCenterX  = 30.0
        self.contentViewScaleValue = 0.7
    }

    // MARK: - Public

    public func presentLeftMenuViewController() {
        guard let leftMenuViewController = self.leftMenuViewController else { return }

        self.presentMenuViewContainerWithMenuViewController(leftMenuViewController)
        self.showLeftMenuViewController()
    }

    public func presentRightMenuViewController() {
        guard let rightMenuViewController = self.rightMenuViewController else { return }

        self.presentMenuViewContainerWithMenuViewController(rightMenuViewController)
        self.showRightMenuViewController()
    }

    @objc public func hideMenuViewController() {
        self.hideMenuViewControllerAnimated(true)
    }

    public func setContentViewController(_ contentViewController: UIViewController, animated: Bool) {
        if self.contentViewController == contentViewController {
            return
        }

        if !animated {
            self.contentViewController = contentViewController
        } else {
            self.addChildViewController(contentViewController)
            contentViewController.view.alpha = 0
            contentViewController.view.frame = self.contentViewContainer.bounds
            self.contentViewContainer.addSubview(contentViewController.view)

            UIView.animate(withDuration: self.animationDuration, animations: {
                contentViewController.view.alpha = 1
                }, completion: { (_) in
                    if let contentViewController = self.contentViewController {
                        self.hideViewController(contentViewController)
                    }
                    contentViewController.didMove(toParentViewController: self)
                    self.contentViewController = contentViewController

                    self.statusBarNeedsAppearanceUpdate()
                    self.updateContentViewShadow()

                    if self.visible {
                        self.addContentViewControllerMotionEffects()
                    }
            })
        }
    }

    // MARK: - Private

    func presentMenuViewContainerWithMenuViewController(_ menuViewController: UIViewController) {
        self.menuViewContainer.transform = .identity

        if self.scaleBackgroundImageView {
            self.backgroundImageView?.transform = .identity
            self.backgroundImageView?.frame = self.view.bounds
        }

        self.menuViewContainer.frame = self.view.bounds

        if let transform = menuViewControllerTransformation, self.scaleMenuView {
            self.menuViewContainer.transform = transform
        }

        if self.fadeMenuView {
            self.menuViewContainer.alpha = 0
        }

        if self.scaleBackgroundImageView {
            self.backgroundImageView?.transform = self.backgroundTransformMakeScale()
        }

        self.delegate?.sideMenu?(self, willShowMenuViewController: menuViewController)
    }

    func showLeftMenuViewController() {
        if self.leftMenuViewController == nil {
            return
        }
        self.leftMenuViewController?.beginAppearanceTransition(true, animated: true)
        self.leftMenuViewController?.view.isHidden = false
        self.rightMenuViewController?.view.isHidden = true
        self.view.window?.endEditing(true)
        self.addContentButton()
        self.updateContentViewShadow()
        self.resetContentViewScale()

        UIView.animate(withDuration: self.animationDuration, animations: {
            if self.scaleContentView {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
                self.updateContentViewAdditionalSafeAreaInsets()
            } else {
                self.contentViewContainer.transform = .identity
            }

            self.contentViewContainer.center = CGPoint(x: (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? self.contentViewInLandscapeOffsetCenterX + self.view.frame.width : self.contentViewInPortraitOffsetCenterX + self.view.frame.width), y: self.contentViewContainer.center.y)

            if self.fadeMenuView {
                self.menuViewContainer.alpha = 1.0
            }
            self.contentViewContainer.alpha = self.contentViewFadeOutAlpha
            self.menuViewContainer.transform = .identity
            if self.scaleBackgroundImageView {
                self.backgroundImageView?.transform = .identity
            }
        }, completion: { (_: Bool) in
            self.addContentViewControllerMotionEffects()
            self.leftMenuViewController?.endAppearanceTransition()

            if let leftMenuViewController = self.leftMenuViewController, !self.visible {
                self.delegate?.sideMenu?(self, didShowMenuViewController: leftMenuViewController)
            }
            self.visible = true
            self.leftMenuVisible = true
        })
        self.statusBarNeedsAppearanceUpdate()
    }

    func showRightMenuViewController() {
        if self.rightMenuViewController == nil {
            return
        }
        self.rightMenuViewController?.beginAppearanceTransition(true, animated: true)
        self.leftMenuViewController?.view.isHidden = true
        self.rightMenuViewController?.view.isHidden = false
        self.view.window?.endEditing(true)
        self.addContentButton()
        self.updateContentViewShadow()
        self.resetContentViewScale()

        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: self.animationDuration, animations: {
            if self.scaleContentView {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
                self.updateContentViewAdditionalSafeAreaInsets()
            } else {
                self.contentViewContainer.transform = .identity
            }
            self.contentViewContainer.center = CGPoint(x: (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX), y: self.contentViewContainer.center.y)

            if self.fadeMenuView {
                self.menuViewContainer.alpha = 1.0
            }
            self.contentViewContainer.alpha = self.contentViewFadeOutAlpha
            self.menuViewContainer.transform = .identity
            if self.scaleBackgroundImageView {
                self.backgroundImageView?.transform = .identity
            }
        }, completion: { (_: Bool) in
            self.rightMenuViewController?.endAppearanceTransition()

            if let rightMenuViewController = self.rightMenuViewController, !self.rightMenuVisible {
                self.delegate?.sideMenu?(self, didShowMenuViewController: rightMenuViewController)
            }
            self.visible = !(self.contentViewContainer.frame.size.width == self.view.bounds.size.width && self.contentViewContainer.frame.size.height == self.view.bounds.size.height && self.contentViewContainer.frame.origin.x == 0 && self.contentViewContainer.frame.origin.y == 0)
            self.rightMenuVisible = self.visible
            UIApplication.shared.endIgnoringInteractionEvents()
            self.addContentViewControllerMotionEffects()
        })
        self.statusBarNeedsAppearanceUpdate()
    }

    func hideViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }

    func hideMenuViewControllerAnimated(_ animated: Bool) {
        let rightMenuVisible: Bool = self.rightMenuVisible

        if let visibleMenuViewController = (rightMenuVisible ? self.rightMenuViewController : self.leftMenuViewController) {

            visibleMenuViewController.beginAppearanceTransition(false, animated: animated)

            self.delegate?.sideMenu?(self, willHideMenuViewController: visibleMenuViewController)

            self.visible = false
            self.leftMenuVisible = false
            self.rightMenuVisible = false
            self.contentButton.removeFromSuperview()

            let animationBlock = { [unowned self] in
                self.contentViewContainer.transform = .identity
                self.contentViewContainer.frame = self.view.bounds
                self.updateContentViewAdditionalSafeAreaInsets()

                if let transform = self.menuViewControllerTransformation, self.scaleMenuView {
                    self.menuViewContainer.transform = transform
                }
                if self.fadeMenuView {
                    self.menuViewContainer.alpha = 0
                }
                self.contentViewContainer.alpha = 1

                if self.scaleBackgroundImageView {
                    self.backgroundImageView?.transform = self.backgroundTransformMakeScale()

                }
                if self.parallaxEnabled {
                    for effect in self.contentViewContainer.motionEffects {
                        self.contentViewContainer.removeMotionEffect(effect)
                    }
                }
            }

            let completionBlock = { [unowned self] in
                visibleMenuViewController.endAppearanceTransition()
                self.statusBarNeedsAppearanceUpdate()
                if self.visible == false {
                    self.delegate?.sideMenu?(self, didHideMenuViewController: visibleMenuViewController)
                }
            }

            if animated {
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIView.animate(withDuration: self.animationDuration, animations: {
                    animationBlock()
                    }, completion: { (_) in
                        UIApplication.shared.endIgnoringInteractionEvents()
                        completionBlock()
                })
            } else {
                animationBlock()
                completionBlock()
            }
        }
    }

    func addContentButton() {
        guard self.contentButton.superview == nil else {
            return
        }

        self.contentButton.autoresizingMask = UIViewAutoresizing()
        self.contentButton.frame = self.contentViewContainer.bounds
        self.contentButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentViewContainer.addSubview(self.contentButton)
    }

    func statusBarNeedsAppearanceUpdate() {
        if self.responds(to: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate)) {
            UIView.animate(withDuration: 0.3, animations: {
                self.perform(#selector(UIViewController.setNeedsStatusBarAppearanceUpdate))
            })
        }
    }

    func updateContentViewShadow() {
        if self.contentViewShadowEnabled {
            let layer = self.contentViewContainer.layer
            let path = UIBezierPath(rect: layer.bounds)
            layer.shadowPath = path.cgPath
            layer.shadowOffset = self.contentViewShadowOffset
            layer.shadowOpacity = self.contentViewShadowOpacity
            layer.shadowRadius = self.contentViewShadowRadius
            layer.cornerRadius = self.contentViewCornerRadius
            layer.masksToBounds = true
            if let color = self.contentViewShadowColor?.cgColor {
                layer.shadowColor = color
            }
        }
    }

    func resetContentViewScale() {
        let transform = self.contentViewContainer.transform
        let scale: CGFloat = sqrt(transform.a * transform.a + transform.c * transform.c)
        let frame = self.contentViewContainer.frame
        self.contentViewContainer.transform = .identity
        self.contentViewContainer.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.contentViewContainer.frame = frame
    }

    func backgroundTransformMakeScale() -> CGAffineTransform {
        return CGAffineTransform(scaleX: self.backgroundTransformScale, y: self.backgroundTransformScale)
    }

    func updateContentViewAdditionalSafeAreaInsets() {
        if #available(iOS 11.0, *) {
            if var insets = self.contentViewController?.additionalSafeAreaInsets {
                insets.top = self.contentViewContainer.frame.minY
                let topSafeArea = self.view.safeAreaLayoutGuide.layoutFrame.minY
                if insets.top > topSafeArea {
                    insets.top = topSafeArea
                } else if insets.top < 0.0 {
                    insets.top = 0.0
                }
                self.contentViewController?.additionalSafeAreaInsets = insets
            }
        }
    }

    // MARK: - Motion Effects (Private)

    func addMenuViewControllerMotionEffects() {
        if self.parallaxEnabled {
            for effect in self.menuViewContainer.motionEffects {
                self.menuViewContainer.removeMotionEffect(effect)
            }
            let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            interpolationHorizontal.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue
            interpolationHorizontal.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue

            let interpolationVertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            interpolationVertical.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue
            interpolationVertical.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue

            self.menuViewContainer.addMotionEffect(interpolationHorizontal)
            self.menuViewContainer.addMotionEffect(interpolationVertical)
        }
    }

    func addContentViewControllerMotionEffects() {
        if self.parallaxEnabled {
            for effect in self.contentViewContainer.motionEffects {
                self.contentViewContainer.removeMotionEffect(effect)
            }

            UIView.animate(withDuration: 0.2, animations: {
                let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
                interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue

                let interpolationVertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
                interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue

                self.contentViewContainer.addMotionEffect(interpolationHorizontal)
                self.contentViewContainer.addMotionEffect(interpolationVertical)
            })
        }
    }

    // MARK: - <UIGestureRecognizerDelegate>

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return delegate?.sideMenu?(self, shouldRecognizeGesture: gestureRecognizer, simultaneouslyWith: otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return delegate?.sideMenu?(self, gestureRecognizer: gestureRecognizer, shouldRequireFailureOf: otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return delegate?.sideMenu?(self, gestureRecognizer: gestureRecognizer, shouldBeRequiredToFailBy: otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.interactivePopGestureRecognizerEnabled && self.contentViewController is UINavigationController {
            if let navigationController = self.contentViewController as? UINavigationController {
                if navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer?.isEnabled ?? false {
                    return false
                }
            }
        }

        if self.panFromEdge && gestureRecognizer is UIPanGestureRecognizer && !self.visible {
            let point: CGPoint = touch.location(in: gestureRecognizer.view)
            if (self.panGestureLeftEnabled && point.x < self.panFromEdgeZoneWidth) || (self.panGestureRightEnabled && point.x > self.view.frame.size.width - self.panFromEdgeZoneWidth) {
                return true
            } else {
                return false
            }
        }
        return true
    }

    // MARK: - Pan gesture recognizer (Private)

    @objc func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {

        self.delegate?.sideMenu?(self, didRecognizePanGesture: recognizer)

        if !self.panGestureEnabled {
            return
        }

        var point = recognizer.translation(in: self.view)

        if recognizer.state == .began {
            self.updateContentViewShadow()

            self.originalPoint = CGPoint(x: self.contentViewContainer.center.x - self.contentViewContainer.bounds.width / 2.0,
                                             y: self.contentViewContainer.center.y - self.contentViewContainer.bounds.height / 2.0)
            self.menuViewContainer.transform = .identity
            if self.scaleBackgroundImageView {
                self.backgroundImageView?.transform = .identity
                self.backgroundImageView?.frame = self.view.bounds
            }
            self.menuViewContainer.frame = self.view.bounds
            self.view.window?.endEditing(true)
            self.sideMenuDelegateNotify = false
        }

        if recognizer.state == .changed {
            var delta: CGFloat = 0.0
            if self.visible {
                delta = self.originalPoint.x != 0 ? (point.x + self.originalPoint.x) / self.originalPoint.x : 0
            } else {
                delta = point.x / self.view.frame.size.width
            }
            delta = min(fabs(delta), 1.6)

            var contentViewScale: CGFloat = self.scaleContentView ? 1 - ((1 - self.contentViewScaleValue) * delta) : 1

            var backgroundViewScale: CGFloat = self.backgroundTransformScale - (0.7 * delta)
            var menuViewScale: CGFloat = 1.5 - (0.5 * delta)

            if !self.bouncesHorizontally {
                contentViewScale = max(contentViewScale, self.contentViewScaleValue)
                backgroundViewScale = max(backgroundViewScale, 1.0)
                menuViewScale = max(menuViewScale, 1.0)
            }

            if self.fadeMenuView {
                self.menuViewContainer.alpha = delta
            }
            self.contentViewContainer.alpha = 1 - (1 - self.contentViewFadeOutAlpha) * delta

            if self.scaleBackgroundImageView {
                self.backgroundImageView?.transform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
            }

            if self.scaleMenuView {
                self.menuViewContainer.transform = CGAffineTransform(scaleX: menuViewScale, y: menuViewScale)
            }

            if self.scaleBackgroundImageView && (backgroundViewScale < 1) {
                self.backgroundImageView?.transform = .identity
            }

            if !self.bouncesHorizontally && self.visible {
                if self.contentViewContainer.frame.origin.x > self.contentViewContainer.frame.size.width / 2.0 {
                    point.x = min(0.0, point.x)
                }

                if self.contentViewContainer.frame.origin.x < -(self.contentViewContainer.frame.size.width / 2.0) {
                    point.x = max(0.0, point.x)
                }
            }

            // Limit size
            //
            if point.x < 0 {
                point.x = max(point.x, -UIScreen.main.bounds.size.height)
            } else {
                point.x = min(point.x, UIScreen.main.bounds.size.height)
            }
            recognizer.setTranslation(point, in: self.view)

            if !self.sideMenuDelegateNotify {
                if point.x > 0 {
                    if let leftMenuViewController = self.leftMenuViewController, !self.visible {
                        self.delegate?.sideMenu?(self, willShowMenuViewController: leftMenuViewController)
                    }
                }
                if point.x < 0 {
                    if let rightMenuViewController = self.rightMenuViewController, !self.visible {
                        self.delegate?.sideMenu?(self, willShowMenuViewController: rightMenuViewController)
                    }
                }
                self.sideMenuDelegateNotify = true
            }

            if contentViewScale > 1 {
                let oppositeScale: CGFloat = (1 - (contentViewScale - 1))
                self.contentViewContainer.transform = CGAffineTransform(scaleX: oppositeScale, y: oppositeScale)
                self.contentViewContainer.transform = self.contentViewContainer.transform.translatedBy(x: point.x, y: 0)
            } else {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: contentViewScale, y: contentViewScale)
                self.contentViewContainer.transform = self.contentViewContainer.transform.translatedBy(x: point.x, y: 0)
            }

            self.leftMenuViewController?.view.isHidden = self.contentViewContainer.frame.origin.x < 0
            self.rightMenuViewController?.view.isHidden = self.contentViewContainer.frame.origin.x > 0

            if self.leftMenuViewController == nil && (self.contentViewContainer.frame.origin.x > 0) {
                self.contentViewContainer.transform = .identity
                self.contentViewContainer.frame = self.view.bounds
                self.visible = false
                self.leftMenuVisible = false
            } else  if self.rightMenuViewController == nil && (self.contentViewContainer.frame.origin.x < 0) {
                self.contentViewContainer.transform = .identity
                self.contentViewContainer.frame = self.view.bounds
                self.visible = false
                self.rightMenuVisible = false
            }

            self.updateContentViewAdditionalSafeAreaInsets()
            self.statusBarNeedsAppearanceUpdate()
        }

        if recognizer.state == .ended {
            self.sideMenuDelegateNotify = false
            if self.panMinimumOpenThreshold > 0 && ((self.contentViewContainer.frame.origin.x < 0 && self.contentViewContainer.frame.origin.x > -(CGFloat(self.panMinimumOpenThreshold))) ||
                (self.contentViewContainer.frame.origin.x > 0 && self.contentViewContainer.frame.origin.x < CGFloat(self.panMinimumOpenThreshold))) {
                self.hideMenuViewController()
            } else if self.contentViewContainer.frame.origin.x == 0 {
                self.hideMenuViewControllerAnimated(false)
            } else {
                if recognizer.velocity(in: self.view).x > 0 {
                    if self.contentViewContainer.frame.origin.x < 0 {
                        self.hideMenuViewController()
                    } else {
                        if self.leftMenuViewController != nil {
                            self.showLeftMenuViewController()
                        }
                    }
                } else {
                    if self.contentViewContainer.frame.origin.x < 20 {
                        if self.rightMenuViewController != nil {
                            self.showRightMenuViewController()
                        }
                    } else {
                        self.hideMenuViewController()
                    }
                }
            }
        }
    }

    // MARK: - Custom Setters

    public var backgroundImage: UIImage? {
        didSet(newValue) {
            self.backgroundImageView?.image = newValue
        }
    }

    public var leftMenuViewController: UIViewController? {
        get {
            return self._leftMenuViewController
        }
        set {
            guard self._leftMenuViewController != nil else {
                self._leftMenuViewController = newValue
                return
            }
            guard let oldViewController = newValue else { return }

            self.hideViewController(oldViewController)

            guard let newViewController = _leftMenuViewController else {
                self._leftMenuViewController = nil
                return
            }

            self._leftMenuViewController = newViewController

            self.addChildViewController(newViewController)
            newViewController.view.frame = self.view.bounds
            newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.menuViewContainer.addSubview(newViewController.view)
            newViewController.didMove(toParentViewController: self)

            self.addContentViewControllerMotionEffects()
            self.view.bringSubview(toFront: self.contentViewContainer)
        }
    }

    public var rightMenuViewController: UIViewController? {
        get {
            return self._rightMenuViewController
        }
        set {
            guard self._rightMenuViewController != nil else {
                self._rightMenuViewController = newValue
                return
            }
            guard let oldViewController = newValue else { return }

            self.hideViewController(oldViewController)

            guard let newViewController = _rightMenuViewController else {
                self._rightMenuViewController = nil
                return
            }

            self._rightMenuViewController = newViewController

            self.addChildViewController(newViewController)
            newViewController.view.frame = self.view.bounds
            newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.menuViewContainer.addSubview(newViewController.view)
            newViewController.didMove(toParentViewController: self)

            self.addContentViewControllerMotionEffects()
            self.view.bringSubview(toFront: self.contentViewContainer)
        }
    }

    // MARK: - ViewController Rotation handler

    override open var shouldAutorotate: Bool {
        return self.contentViewController?.shouldAutorotate ?? false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.contentViewController?.supportedInterfaceOrientations ?? .all
    }

    override open func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if self.visible {
            self.menuViewContainer.bounds = self.view.bounds
            self.contentViewContainer.transform = .identity
            self.contentViewContainer.frame = self.view.bounds

            if self.scaleContentView {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
                self.updateContentViewAdditionalSafeAreaInsets()
            } else {
                self.contentViewContainer.transform = .identity
            }

            let center: CGPoint
            if self.leftMenuVisible {
                center = CGPoint(x: (UIDeviceOrientationIsLandscape(UIDevice.current.orientation) ? self.contentViewInLandscapeOffsetCenterX + self.view.frame.width : self.contentViewInPortraitOffsetCenterX + self.view.frame.width), y: self.contentViewContainer.center.y)
            } else {
                center = CGPoint(x: (UIDeviceOrientationIsLandscape(UIDevice.current.orientation) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX), y: self.contentViewContainer.center.y)
            }
            self.contentViewContainer.center = center
        }
        self.updateContentViewShadow()
    }

    // MARK: - Status Bar Appearance Management

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        var statusBarStyle = self.contentViewController?.preferredStatusBarStyle ?? .default

        if self.scaleContentView {
            if self.contentViewContainer.frame.origin.y > 10 {
                statusBarStyle = self.menuPreferredStatusBarStyle
            }
        } else {
            if self.contentViewContainer.frame.origin.x > 10 || self.contentViewContainer.frame.origin.x < -10 {
                statusBarStyle = self.menuPreferredStatusBarStyle
            }
        }
        return statusBarStyle
    }

    override open var prefersStatusBarHidden: Bool {
        var statusBarHidden = self.contentViewController?.prefersStatusBarHidden ?? false

        if self.scaleContentView {
            if self.contentViewContainer.frame.origin.y > 10 {
                statusBarHidden = self.menuPrefersStatusBarHidden
            }
        } else {
            if self.contentViewContainer.frame.origin.x > 10 || self.contentViewContainer.frame.origin.x < -10 {
                statusBarHidden = self.menuPrefersStatusBarHidden
            }
        }
        return statusBarHidden
    }

    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        var statusBarAnimation = self.contentViewController?.preferredStatusBarUpdateAnimation ?? .fade

        if self.scaleContentView {
            if self.contentViewContainer.frame.origin.y > 10 {
                statusBarAnimation = self.leftMenuViewController?.preferredStatusBarUpdateAnimation ?? statusBarAnimation
            }
        } else {
            if self.contentViewContainer.frame.origin.x > 10 || self.contentViewContainer.frame.origin.x < -10 {
                statusBarAnimation = self.leftMenuViewController?.preferredStatusBarUpdateAnimation ?? statusBarAnimation
            }
        }

        return statusBarAnimation
    }
}
