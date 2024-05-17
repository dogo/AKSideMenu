//
//  AKSideMenu.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

@objc
public protocol AKSideMenuDelegate {
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, shouldRecognizeGesture recognizer: UIGestureRecognizer, simultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer)
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController)
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController)
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController)
    @objc
    optional func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController)
}

@IBDesignable
open class AKSideMenu: UIViewController, UIGestureRecognizerDelegate {
    var visible = false
    var leftMenuVisible = false
    var rightMenuVisible = false
    var sideMenuDelegateNotify = false
    var originalPoint: CGPoint = .zero
    var contentButton = UIButton()
    var backgroundImageView: UIImageView?
    var menuViewContainer = UIView()
    var contentViewContainer = UIView()

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
    @IBInspectable public var contentViewShadowOffset: CGSize = .zero
    @IBInspectable public var contentViewShadowOpacity: Float = 0.4
    @IBInspectable public var contentViewShadowRadius: CGFloat = 8.0
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
    public var animationDuration: TimeInterval = 0.35
    public var menuViewControllerTransformation: CGAffineTransform?
    public var panGestureEnabled = true
    public var panFromEdge = true
    public var panMinimumOpenThreshold: Float = 60.0
    public var menuPreferredStatusBarStyle = UIStatusBarStyle.default
    public var contentViewController: UIViewController?

    private var _leftMenuViewController: UIViewController?
    private var _rightMenuViewController: UIViewController?

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public required init(contentViewController: UIViewController, leftMenuViewController: UIViewController?, rightMenuViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        commonInit()
        self.contentViewController = contentViewController
        self.leftMenuViewController = leftMenuViewController
        self.rightMenuViewController = rightMenuViewController
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        if let storybroadID = contentViewStoryboardID {
            contentViewController = storyboard?.instantiateViewController(withIdentifier: storybroadID)
        }
        if let storybroadID = leftMenuViewStoryboardID {
            leftMenuViewController = storyboard?.instantiateViewController(withIdentifier: storybroadID)
        }
        if let storybroadID = rightMenuViewStoryboardID {
            rightMenuViewController = storyboard?.instantiateViewController(withIdentifier: storybroadID)
        }
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let imageView = UIImageView(frame: view.bounds)
        imageView.image = backgroundImage
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView = imageView

        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(AKSideMenu.hideMenuViewController), for: .touchUpInside)
        contentButton = button

        view.addSubview(imageView)
        view.addSubview(menuViewContainer)
        view.addSubview(contentViewContainer)

        menuViewContainer.frame = view.bounds
        menuViewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let leftMenuViewController = leftMenuViewController {
            addChild(leftMenuViewController)
            leftMenuViewController.view.frame = view.bounds
            leftMenuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            menuViewContainer.addSubview(leftMenuViewController.view)
            leftMenuViewController.didMove(toParent: self)
        }

        if let rightMenuViewController = rightMenuViewController {
            addChild(rightMenuViewController)
            rightMenuViewController.view.frame = view.bounds
            rightMenuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            menuViewContainer.addSubview(rightMenuViewController.view)
            rightMenuViewController.didMove(toParent: self)
        }

        contentViewContainer.frame = view.bounds
        contentViewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let contentViewController = contentViewController {
            addChild(contentViewController)
            contentViewController.view.frame = view.bounds
            contentViewContainer.addSubview(contentViewController.view)
            contentViewController.didMove(toParent: self)
        }

        if fadeMenuView {
            menuViewContainer.alpha = 0
        }

        if scaleBackgroundImageView {
            backgroundImageView?.transform = backgroundTransformMakeScale()
        }

        addMenuViewControllerMotionEffects()

        if panGestureEnabled {
            view.isMultipleTouchEnabled = false
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(AKSideMenu.panGestureRecognized(_:)))
            panGestureRecognizer.delegate = self
            view.addGestureRecognizer(panGestureRecognizer)
        }

        updateContentViewShadow()
    }

    func commonInit() {
        menuViewContainer = UIView()
        contentViewContainer = UIView()

        animationDuration = 0.35
        interactivePopGestureRecognizerEnabled = true

        menuViewControllerTransformation = CGAffineTransform(scaleX: 1.5, y: 1.5)

        scaleContentView = true
        backgroundTransformScale = 1.7
        scaleBackgroundImageView = true
        scaleMenuView = true
        fadeMenuView = true

        parallaxEnabled = true
        panGestureLeftEnabled = true
        panGestureRightEnabled = true
        parallaxMenuMinimumRelativeValue = -15
        parallaxMenuMaximumRelativeValue = 15
        parallaxContentMinimumRelativeValue = -25
        parallaxContentMaximumRelativeValue = 25

        bouncesHorizontally = true

        panGestureEnabled = true
        panFromEdge = true
        panFromEdgeZoneWidth = 20.0
        panMinimumOpenThreshold = 60.0

        contentViewShadowEnabled = false
        contentViewShadowColor = .black
        contentViewShadowOffset = .zero
        contentViewShadowOpacity = 0.4
        contentViewShadowRadius = 8.0
        contentViewFadeOutAlpha = 1.0
        contentViewInLandscapeOffsetCenterX = 30.0
        contentViewInPortraitOffsetCenterX = 30.0
        contentViewScaleValue = 0.7
    }

    // MARK: - Public

    public func presentLeftMenuViewController() {
        guard let leftMenuViewController = leftMenuViewController else { return }

        presentMenuViewContainerWithMenuViewController(leftMenuViewController)
        showLeftMenuViewController()
    }

    public func presentRightMenuViewController() {
        guard let rightMenuViewController = rightMenuViewController else { return }

        presentMenuViewContainerWithMenuViewController(rightMenuViewController)
        showRightMenuViewController()
    }

    @objc
    public func hideMenuViewController() {
        hideMenuViewControllerAnimated(true)
    }

    public func setContentViewController(_ contentViewController: UIViewController, animated: Bool) {
        if self.contentViewController == contentViewController {
            return
        }

        if !animated {
            self.contentViewController = contentViewController
        } else {
            addChild(contentViewController)
            contentViewController.view.alpha = 0
            contentViewController.view.frame = contentViewContainer.bounds
            contentViewContainer.addSubview(contentViewController.view)

            UIView.animate(withDuration: animationDuration, animations: {
                contentViewController.view.alpha = 1
            }, completion: { _ in
                if let contentViewController = self.contentViewController {
                    self.hideViewController(contentViewController)
                }
                contentViewController.didMove(toParent: self)
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
        menuViewContainer.transform = .identity

        if scaleBackgroundImageView {
            backgroundImageView?.transform = .identity
            backgroundImageView?.frame = view.bounds
        }

        menuViewContainer.frame = view.bounds

        if let transform = menuViewControllerTransformation, scaleMenuView {
            menuViewContainer.transform = transform
        }

        if fadeMenuView {
            menuViewContainer.alpha = 0
        }

        if scaleBackgroundImageView {
            backgroundImageView?.transform = backgroundTransformMakeScale()
        }

        delegate?.sideMenu?(self, willShowMenuViewController: menuViewController)
    }

    func showLeftMenuViewController() {
        guard leftMenuViewController != nil else { return }

        leftMenuViewController?.beginAppearanceTransition(true, animated: true)
        leftMenuViewController?.view.isHidden = false
        rightMenuViewController?.view.isHidden = true
        view.window?.endEditing(true)
        addContentButton()
        updateContentViewShadow()
        resetContentViewScale()

        UIView.animate(withDuration: animationDuration, animations: {
            if self.scaleContentView {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
                self.updateContentViewAdditionalSafeAreaInsets()
            } else {
                self.contentViewContainer.transform = .identity
            }

            let centerX = UIApplication.shared.statusBarOrientation.isLandscape ?
                self.contentViewInLandscapeOffsetCenterX : self.contentViewInPortraitOffsetCenterX
            self.contentViewContainer.center = CGPoint(x: centerX + self.view.frame.width,
                                                       y: self.contentViewContainer.center.y)

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
        statusBarNeedsAppearanceUpdate()
    }

    func showRightMenuViewController() {
        guard rightMenuViewController != nil else { return }

        rightMenuViewController?.beginAppearanceTransition(true, animated: true)
        leftMenuViewController?.view.isHidden = true
        rightMenuViewController?.view.isHidden = false
        view.window?.endEditing(true)
        addContentButton()
        updateContentViewShadow()
        resetContentViewScale()

        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: animationDuration, animations: {
            if self.scaleContentView {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
                self.updateContentViewAdditionalSafeAreaInsets()
            } else {
                self.contentViewContainer.transform = .identity
            }
            self.contentViewContainer.center = CGPoint(x: UIApplication.shared.statusBarOrientation.isLandscape ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX,
                                                       y: self.contentViewContainer.center.y)

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
        statusBarNeedsAppearanceUpdate()
    }

    func hideViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    func hideMenuViewControllerAnimated(_ animated: Bool) {
        let rightMenuVisible: Bool = rightMenuVisible

        let visibleMenuViewController = (rightMenuVisible ? rightMenuViewController : leftMenuViewController)

        visibleMenuViewController?.beginAppearanceTransition(false, animated: animated)

        if let viewController = visibleMenuViewController {
            delegate?.sideMenu?(self, willHideMenuViewController: viewController)
        }

        visible = false
        leftMenuVisible = false
        self.rightMenuVisible = false
        contentButton.removeFromSuperview()

        let animationBlock = { [unowned self] in
            contentViewContainer.transform = .identity
            contentViewContainer.frame = view.bounds
            updateContentViewAdditionalSafeAreaInsets()

            if let transform = menuViewControllerTransformation, scaleMenuView {
                menuViewContainer.transform = transform
            }
            if fadeMenuView {
                menuViewContainer.alpha = 0
            }
            contentViewContainer.alpha = 1

            if scaleBackgroundImageView {
                backgroundImageView?.transform = backgroundTransformMakeScale()
            }
            if parallaxEnabled {
                for effect in contentViewContainer.motionEffects {
                    contentViewContainer.removeMotionEffect(effect)
                }
            }
        }

        let completionBlock = { [unowned self] in
            visibleMenuViewController?.endAppearanceTransition()
            statusBarNeedsAppearanceUpdate()
            if !visible {
                if let viewController = visibleMenuViewController {
                    delegate?.sideMenu?(self, didHideMenuViewController: viewController)
                }
            }
        }

        if animated {
            UIApplication.shared.beginIgnoringInteractionEvents()
            UIView.animate(withDuration: animationDuration, animations: {
                animationBlock()
            }, completion: { _ in
                UIApplication.shared.endIgnoringInteractionEvents()
                completionBlock()
            })
        } else {
            animationBlock()
            completionBlock()
        }
    }

    func addContentButton() {
        guard contentButton.superview == nil else {
            return
        }

        contentButton.autoresizingMask = []
        contentButton.frame = contentViewContainer.bounds
        contentButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentViewContainer.addSubview(contentButton)
    }

    func statusBarNeedsAppearanceUpdate() {
        if responds(to: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate)) {
            UIView.animate(withDuration: 0.3) {
                self.perform(#selector(UIViewController.setNeedsStatusBarAppearanceUpdate))
            }
        }
    }

    func updateContentViewShadow() {
        if contentViewShadowEnabled {
            let layer = contentViewContainer.layer
            let path = UIBezierPath(rect: layer.bounds)
            layer.shadowPath = path.cgPath
            layer.shadowOffset = contentViewShadowOffset
            layer.shadowOpacity = contentViewShadowOpacity
            layer.shadowRadius = contentViewShadowRadius
            if let color = contentViewShadowColor?.cgColor {
                layer.shadowColor = color
            }
        }
    }

    func resetContentViewScale() {
        let transform = contentViewContainer.transform
        let scale: CGFloat = sqrt(transform.a * transform.a + transform.c * transform.c)
        let frame = contentViewContainer.frame
        contentViewContainer.transform = .identity
        contentViewContainer.transform = CGAffineTransform(scaleX: scale, y: scale)
        contentViewContainer.frame = frame
    }

    func backgroundTransformMakeScale() -> CGAffineTransform {
        CGAffineTransform(scaleX: backgroundTransformScale, y: backgroundTransformScale)
    }

    func updateContentViewAdditionalSafeAreaInsets() {
        if #available(iOS 11.0, *) {
            if var insets = self.contentViewController?.additionalSafeAreaInsets {
                insets.top = self.contentViewContainer.frame.minY
                let topSafeArea = self.view.safeAreaLayoutGuide.layoutFrame.minY
                if insets.top > topSafeArea {
                    insets.top = topSafeArea
                } else if insets.top < .zero {
                    insets.top = .zero
                }
                insets.bottom = self.view.frame.maxY - self.contentViewContainer.frame.maxY
                let bottomSafeArea = self.view.frame.maxY - self.view.safeAreaLayoutGuide.layoutFrame.maxY
                if insets.bottom > bottomSafeArea {
                    insets.bottom = bottomSafeArea
                } else if insets.bottom < .zero {
                    insets.bottom = .zero
                }
                self.contentViewController?.additionalSafeAreaInsets = insets
            }
        }
    }

    // MARK: - Motion Effects (Private)

    func addMenuViewControllerMotionEffects() {
        if parallaxEnabled {
            for effect in menuViewContainer.motionEffects {
                menuViewContainer.removeMotionEffect(effect)
            }
            let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
            interpolationHorizontal.minimumRelativeValue = parallaxMenuMinimumRelativeValue
            interpolationHorizontal.maximumRelativeValue = parallaxMenuMaximumRelativeValue

            let interpolationVertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
            interpolationVertical.minimumRelativeValue = parallaxMenuMinimumRelativeValue
            interpolationVertical.maximumRelativeValue = parallaxMenuMaximumRelativeValue

            menuViewContainer.addMotionEffect(interpolationHorizontal)
            menuViewContainer.addMotionEffect(interpolationVertical)
        }
    }

    func addContentViewControllerMotionEffects() {
        if parallaxEnabled {
            for effect in contentViewContainer.motionEffects {
                contentViewContainer.removeMotionEffect(effect)
            }

            UIView.animate(withDuration: 0.2) {
                let interpolationHorizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
                interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue

                let interpolationVertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
                interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue

                self.contentViewContainer.addMotionEffect(interpolationHorizontal)
                self.contentViewContainer.addMotionEffect(interpolationVertical)
            }
        }
    }

    // MARK: - <UIGestureRecognizerDelegate>

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        delegate?.sideMenu?(self, shouldRecognizeGesture: gestureRecognizer, simultaneouslyWith: otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        delegate?.sideMenu?(self, gestureRecognizer: gestureRecognizer, shouldRequireFailureOf: otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        delegate?.sideMenu?(self, gestureRecognizer: gestureRecognizer, shouldBeRequiredToFailBy: otherGestureRecognizer) ?? false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if interactivePopGestureRecognizerEnabled, contentViewController is UINavigationController {
            if let navigationController = contentViewController as? UINavigationController {
                if navigationController.viewControllers.count > 1, navigationController.interactivePopGestureRecognizer?.isEnabled ?? false {
                    return false
                }
            }
        }

        if panFromEdge, gestureRecognizer is UIPanGestureRecognizer, !visible {
            let point: CGPoint = touch.location(in: gestureRecognizer.view)
            if (panGestureLeftEnabled && point.x < panFromEdgeZoneWidth) || (panGestureRightEnabled && point.x > view.frame.size.width - panFromEdgeZoneWidth) {
                return true
            } else {
                return false
            }
        }
        return true
    }

    // MARK: - Pan gesture recognizer (Private)

    @objc
    func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        delegate?.sideMenu?(self, didRecognizePanGesture: recognizer)

        if !panGestureEnabled {
            return
        }

        if recognizer.state == .began {
            recognizerBegan()
        }

        if recognizer.state == .changed {
            recognizerChanged(recognizer)
        }

        if recognizer.state == .ended {
            recognizerEnded(recognizer)
        }
    }

    // MARK: - Regonizer States

    private func recognizerBegan() {
        updateContentViewShadow()

        originalPoint = CGPoint(x: contentViewContainer.center.x - contentViewContainer.bounds.width / 2.0,
                                y: contentViewContainer.center.y - contentViewContainer.bounds.height / 2.0)
        menuViewContainer.transform = .identity
        if scaleBackgroundImageView {
            backgroundImageView?.transform = .identity
            backgroundImageView?.frame = view.bounds
        }
        menuViewContainer.frame = view.bounds
        view.window?.endEditing(true)
        sideMenuDelegateNotify = false
    }

    private func recognizerChanged(_ recognizer: UIPanGestureRecognizer) {
        var point = recognizer.translation(in: view)
        var delta: CGFloat = 0.0

        if visible {
            delta = originalPoint.x != 0 ? (point.x + originalPoint.x) / originalPoint.x : 0
        } else {
            delta = point.x / view.frame.size.width
        }
        delta = min(abs(delta), 1.6)

        var contentViewScale: CGFloat = scaleContentView ? 1 - ((1 - contentViewScaleValue) * delta) : 1

        var backgroundViewScale: CGFloat = backgroundTransformScale - (0.7 * delta)
        var menuViewScale: CGFloat = 1.5 - (0.5 * delta)

        if !bouncesHorizontally {
            contentViewScale = max(contentViewScale, contentViewScaleValue)
            backgroundViewScale = max(backgroundViewScale, 1.0)
            menuViewScale = max(menuViewScale, 1.0)
        }

        if fadeMenuView {
            menuViewContainer.alpha = delta
        }
        contentViewContainer.alpha = 1 - (1 - contentViewFadeOutAlpha) * delta

        if scaleBackgroundImageView {
            backgroundImageView?.transform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
        }

        if scaleMenuView {
            menuViewContainer.transform = CGAffineTransform(scaleX: menuViewScale, y: menuViewScale)
        }

        if scaleBackgroundImageView, backgroundViewScale < 1 {
            backgroundImageView?.transform = .identity
        }

        if !bouncesHorizontally, visible {
            if contentViewContainer.frame.origin.x > contentViewContainer.frame.size.width / 2.0 {
                point.x = min(0.0, point.x)
            }

            if contentViewContainer.frame.origin.x < -(contentViewContainer.frame.size.width / 2.0) {
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
        recognizer.setTranslation(point, in: view)

        if !sideMenuDelegateNotify {
            if point.x > 0 {
                if let leftMenuViewController = leftMenuViewController, !self.visible {
                    delegate?.sideMenu?(self, willShowMenuViewController: leftMenuViewController)
                }
            }
            if point.x < 0 {
                if let rightMenuViewController = rightMenuViewController, !self.visible {
                    delegate?.sideMenu?(self, willShowMenuViewController: rightMenuViewController)
                }
            }
            sideMenuDelegateNotify = true
        }

        if contentViewScale > 1 {
            let oppositeScale: CGFloat = (1 - (contentViewScale - 1))
            contentViewContainer.transform = CGAffineTransform(scaleX: oppositeScale, y: oppositeScale)
            contentViewContainer.transform = contentViewContainer.transform.translatedBy(x: point.x, y: 0)
        } else {
            contentViewContainer.transform = CGAffineTransform(scaleX: contentViewScale, y: contentViewScale)
            contentViewContainer.transform = contentViewContainer.transform.translatedBy(x: point.x, y: 0)
        }

        leftMenuViewController?.view.isHidden = contentViewContainer.frame.origin.x < 0
        rightMenuViewController?.view.isHidden = contentViewContainer.frame.origin.x > 0

        if leftMenuViewController == nil, contentViewContainer.frame.origin.x > 0 {
            contentViewContainer.transform = .identity
            contentViewContainer.frame = view.bounds
            visible = false
            leftMenuVisible = false
        } else if rightMenuViewController == nil, contentViewContainer.frame.origin.x < 0 {
            contentViewContainer.transform = .identity
            contentViewContainer.frame = view.bounds
            visible = false
            rightMenuVisible = false
        }

        updateContentViewAdditionalSafeAreaInsets()
        statusBarNeedsAppearanceUpdate()
    }

    private func recognizerEnded(_ recognizer: UIPanGestureRecognizer) {
        sideMenuDelegateNotify = false
        if panMinimumOpenThreshold > 0, (contentViewContainer.frame.origin.x < 0 && contentViewContainer.frame.origin.x > -CGFloat(panMinimumOpenThreshold)) ||
            (contentViewContainer.frame.origin.x > 0 && contentViewContainer.frame.origin.x < CGFloat(panMinimumOpenThreshold))
        {
            hideMenuViewController()
        } else if contentViewContainer.frame.origin.x == 0 {
            hideMenuViewControllerAnimated(false)
        } else {
            if recognizer.velocity(in: view).x > 0 {
                if contentViewContainer.frame.origin.x < 0 {
                    hideMenuViewController()
                } else {
                    if leftMenuViewController != nil {
                        showLeftMenuViewController()
                    }
                }
            } else {
                if contentViewContainer.frame.origin.x < 20 {
                    if rightMenuViewController != nil {
                        showRightMenuViewController()
                    }
                } else {
                    hideMenuViewController()
                }
            }
        }
    }

    // MARK: - Custom Setters

    public var backgroundImage: UIImage? {
        didSet(newValue) {
            backgroundImageView?.image = newValue
        }
    }

    public var leftMenuViewController: UIViewController? {
        get {
            _leftMenuViewController
        }
        set {
            guard _leftMenuViewController != nil else {
                _leftMenuViewController = newValue
                return
            }
            guard let oldViewController = newValue else { return }

            hideViewController(oldViewController)

            guard let newViewController = _leftMenuViewController else {
                _leftMenuViewController = nil
                return
            }

            _leftMenuViewController = newViewController

            addChild(newViewController)
            newViewController.view.frame = view.bounds
            newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            menuViewContainer.addSubview(newViewController.view)
            newViewController.didMove(toParent: self)

            addContentViewControllerMotionEffects()
            view.bringSubviewToFront(contentViewContainer)
        }
    }

    public var rightMenuViewController: UIViewController? {
        get {
            _rightMenuViewController
        }
        set {
            guard _rightMenuViewController != nil else {
                _rightMenuViewController = newValue
                return
            }
            guard let oldViewController = newValue else { return }

            hideViewController(oldViewController)

            guard let newViewController = _rightMenuViewController else {
                _rightMenuViewController = nil
                return
            }

            _rightMenuViewController = newViewController

            addChild(newViewController)
            newViewController.view.frame = view.bounds
            newViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            menuViewContainer.addSubview(newViewController.view)
            newViewController.didMove(toParent: self)

            addContentViewControllerMotionEffects()
            view.bringSubviewToFront(contentViewContainer)
        }
    }

    // MARK: - ViewController Rotation handler

    override open var shouldAutorotate: Bool {
        contentViewController?.shouldAutorotate ?? false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        contentViewController?.supportedInterfaceOrientations ?? .all
    }

    override open func willAnimateRotation(to _: UIInterfaceOrientation, duration _: TimeInterval) {
        if visible {
            menuViewContainer.bounds = view.bounds
            contentViewContainer.transform = .identity
            contentViewContainer.frame = view.bounds

            if scaleContentView {
                contentViewContainer.transform = CGAffineTransform(scaleX: contentViewScaleValue, y: contentViewScaleValue)
                updateContentViewAdditionalSafeAreaInsets()
            } else {
                contentViewContainer.transform = .identity
            }

            let center: CGPoint
            if leftMenuVisible {
                center = CGPoint(x: UIDevice.current.orientation.isLandscape ? contentViewInLandscapeOffsetCenterX + view.frame.width : contentViewInPortraitOffsetCenterX + view.frame.width, y: contentViewContainer.center.y)
            } else {
                center = CGPoint(x: UIDevice.current.orientation.isLandscape ? -contentViewInLandscapeOffsetCenterX : -contentViewInPortraitOffsetCenterX, y: contentViewContainer.center.y)
            }
            contentViewContainer.center = center
        }
        updateContentViewShadow()
    }

    // MARK: - Status Bar Appearance Management

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        var statusBarStyle = contentViewController?.preferredStatusBarStyle ?? .default

        if scaleContentView {
            if contentViewContainer.frame.origin.y > 10 {
                statusBarStyle = menuPreferredStatusBarStyle
            }
        } else {
            if contentViewContainer.frame.origin.x > 10 || contentViewContainer.frame.origin.x < -10 {
                statusBarStyle = menuPreferredStatusBarStyle
            }
        }
        return statusBarStyle
    }

    override open var prefersStatusBarHidden: Bool {
        var statusBarHidden = contentViewController?.prefersStatusBarHidden ?? false

        if scaleContentView {
            if contentViewContainer.frame.origin.y > 10 {
                statusBarHidden = menuPrefersStatusBarHidden
            }
        } else {
            if contentViewContainer.frame.origin.x > 10 || contentViewContainer.frame.origin.x < -10 {
                statusBarHidden = menuPrefersStatusBarHidden
            }
        }
        return statusBarHidden
    }

    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        var statusBarAnimation = contentViewController?.preferredStatusBarUpdateAnimation ?? .fade

        if scaleContentView {
            if contentViewContainer.frame.origin.y > 10 {
                statusBarAnimation = leftMenuViewController?.preferredStatusBarUpdateAnimation ?? statusBarAnimation
            }
        } else {
            if contentViewContainer.frame.origin.x > 10 || contentViewContainer.frame.origin.x < -10 {
                statusBarAnimation = leftMenuViewController?.preferredStatusBarUpdateAnimation ?? statusBarAnimation
            }
        }

        return statusBarAnimation
    }
}
