//
//  AKSideMenu.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

@objc public protocol AKSideMenuDelegate {
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController)
    @objc optional func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController)
}

@IBDesignable open class AKSideMenu : UIViewController, UIGestureRecognizerDelegate {
    
    var visible: Bool = false
    var leftMenuVisible: Bool = false
    var rightMenuVisible: Bool = false
    var didNotifyDelegate: Bool = false
    var originalPoint: CGPoint = CGPoint.zero
    var contentButton: UIButton = UIButton()
    var backgroundImageView: UIImageView?
    var menuViewContainer: UIView = UIView()
    var contentViewContainer: UIView = UIView()
    
    @IBInspectable public let contentViewStoryboardID: String? = nil
    @IBInspectable public let leftMenuViewStoryboardID: String? = nil
    @IBInspectable public let rightMenuViewStoryboardID: String? = nil
    @IBInspectable public var panFromEdgeZoneWidth : CGFloat = 20.0
    @IBInspectable public var panGestureLeftEnabled : Bool = true
    @IBInspectable public var panGestureRightEnabled : Bool = true
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
    @IBInspectable public var contentViewFadeOutAlpha: CGFloat = 1.0
    @IBInspectable public var contentViewScaleValue: CGFloat = 0.7
    @IBInspectable public var contentViewInLandscapeOffsetCenterX : CGFloat = 30.0
    @IBInspectable public var contentViewInPortraitOffsetCenterX: CGFloat = 30.0
    @IBInspectable public var parallaxMenuMinimumRelativeValue: CGFloat = -15
    @IBInspectable public var parallaxMenuMaximumRelativeValue: CGFloat = 15
    @IBInspectable public var parallaxContentMinimumRelativeValue: CGFloat = -25
    @IBInspectable public var parallaxContentMaximumRelativeValue: CGFloat = 25
    @IBInspectable public var parallaxEnabled: Bool = true
    @IBInspectable public var bouncesHorizontally: Bool = true
    @IBInspectable public var menuPrefersStatusBarHidden: Bool = false
    
    public var delegate: AKSideMenuDelegate?
    public var animationDuration: TimeInterval =  0.35
    public var menuViewControllerTransformation: CGAffineTransform?
    public var panGestureEnabled: Bool = true
    public var panFromEdge: Bool = true
    public var panMinimumOpenThreshold: Float = 60.0
    public var menuPreferredStatusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
    public var contentViewController: UIViewController?    

    private var _leftMenuViewController: UIViewController?
    private var _rightMenuViewController: UIViewController?
    
    init() {
        super.init(nibName:nil, bundle:nil)
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    convenience public init(contentViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.leftMenuViewController = leftMenuViewController
        self.rightMenuViewController = rightMenuViewController
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        if (self.contentViewStoryboardID != nil) {
            self.contentViewController = self.storyboard!.instantiateViewController(withIdentifier: self.contentViewStoryboardID!)
        }
        if (self.leftMenuViewStoryboardID != nil) {
            self.leftMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: self.leftMenuViewStoryboardID!)
        }
        if (self.rightMenuViewStoryboardID != nil) {
            self.rightMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: self.rightMenuViewStoryboardID!)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        let imageView: UIImageView = UIImageView.init(frame: self.view.bounds)
        imageView.image = self.backgroundImage
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.backgroundImageView = imageView
        
        let button: UIButton = UIButton.init(frame: CGRect.null)
        button.addTarget(self, action: #selector(AKSideMenu.hideMenuViewController), for: UIControlEvents.touchUpInside)
        self.contentButton = button
        
        self.view.addSubview(self.backgroundImageView!)
        self.view.addSubview(self.menuViewContainer)
        self.view.addSubview(self.contentViewContainer)
        
        self.menuViewContainer.frame = self.view.bounds
        self.menuViewContainer.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        if (self.leftMenuViewController != nil) {
            self.addChildViewController(self.leftMenuViewController!)
            self.leftMenuViewController!.view.frame = self.view.bounds
            self.leftMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.menuViewContainer.addSubview(self.leftMenuViewController!.view)
            self.leftMenuViewController?.didMove(toParentViewController: self)
        }
        
        if (self.rightMenuViewController != nil) {
            self.addChildViewController(self.rightMenuViewController!)
            self.rightMenuViewController!.view.frame = self.view.bounds
            self.rightMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            self.menuViewContainer.addSubview(self.rightMenuViewController!.view)
            self.rightMenuViewController?.didMove(toParentViewController: self)
        }
        
        self.contentViewContainer.frame = self.view.bounds
        self.contentViewContainer.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        self.addChildViewController(self.contentViewController!)
        self.contentViewController!.view.frame = self.view.bounds
        self.contentViewContainer.addSubview(self.contentViewController!.view)
        self.contentViewController!.didMove(toParentViewController: self)
        
        if (self.fadeMenuView) {
            self.menuViewContainer.alpha = 0
        }
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView!.transform = self.backgroundTransformMakeScale()
        }
        
        self.addMenuViewControllerMotionEffects()
        
        if (self.panGestureEnabled) {
            self.view.isMultipleTouchEnabled = false
            let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(AKSideMenu.panGestureRecognized(_:)))
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
        self.presentMenuViewContainerWithMenuViewController(self.leftMenuViewController!)
        self.showLeftMenuViewController()
    }
    
    public func presentRightMenuViewController() {
        self.presentMenuViewContainerWithMenuViewController(self.rightMenuViewController!)
        self.showRightMenuViewController()
    }
    
    public func hideMenuViewController() {
        self.hideMenuViewControllerAnimated(true)
    }
    
    public func setContentViewController(_ contentViewController: UIViewController, animated: Bool) {
        if (self.contentViewController == contentViewController) {
            return
        }
        
        if (!animated) {
            self.contentViewController = contentViewController
        } else {
            self.addChildViewController(contentViewController)
            contentViewController.view.alpha = 0
            contentViewController.view.frame = self.contentViewContainer.bounds
            self.contentViewContainer.addSubview(contentViewController.view)
            
            UIView.animate(withDuration: self.animationDuration, animations: {
                contentViewController.view.alpha = 1
                }, completion: { (Bool) in
                    self.hideViewController(self.contentViewController!)
                    contentViewController.didMove(toParentViewController: self)
                    self.contentViewController = contentViewController
                    
                    self.statusBarNeedsAppearanceUpdate()
                    self.updateContentViewShadow()
                    
                    if (self.visible) {
                        self.addContentViewControllerMotionEffects()
                    }
            })
        }
    }
    
    // MARK: - Private
    
    func presentMenuViewContainerWithMenuViewController(_ menuViewController: UIViewController) {
        self.menuViewContainer.transform = CGAffineTransform.identity
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView!.transform = CGAffineTransform.identity
            self.backgroundImageView!.frame = self.view.bounds
        }
        
        self.menuViewContainer.frame = self.view.bounds
        
        if (self.scaleMenuView) {
            self.menuViewContainer.transform = self.menuViewControllerTransformation!
        }
        
        if (self.fadeMenuView) {
            self.menuViewContainer.alpha = 0
        }
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView!.transform = self.backgroundTransformMakeScale()
        }
        
        self.delegate?.sideMenu?(self , willShowMenuViewController: menuViewController)
    }
    
    func showLeftMenuViewController() {
        if (self.leftMenuViewController == nil) {
            return
        }
        self.leftMenuViewController?.beginAppearanceTransition(true, animated: true)
        self.leftMenuViewController!.view.isHidden = false
        self.rightMenuViewController!.view.isHidden = true
        self.view.window?.endEditing(true)
        self.addContentButton()
        self.updateContentViewShadow()
        self.resetContentViewScale()
        
        UIView.animate(withDuration: self.animationDuration, animations: {
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
            } else {
                self.contentViewContainer.transform = CGAffineTransform.identity
            }
            
            self.contentViewContainer.center = CGPoint(x: (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? self.contentViewInLandscapeOffsetCenterX + self.view.frame.width : self.contentViewInPortraitOffsetCenterX + self.view.frame.width), y: self.contentViewContainer.center.y)
            
            if (self.fadeMenuView) {
                self.menuViewContainer.alpha = 1.0
            }
            self.contentViewContainer.alpha = self.contentViewFadeOutAlpha
            self.menuViewContainer.transform = CGAffineTransform.identity
            if (self.scaleBackgroundImageView) {
                self.backgroundImageView!.transform = CGAffineTransform.identity
            }
        }) { (Bool) in
            self.addContentViewControllerMotionEffects()
            self.leftMenuViewController?.endAppearanceTransition()
            
            if (!self.visible) {
                self.delegate?.sideMenu?(self , didShowMenuViewController: self.leftMenuViewController!)
            }
            self.visible = true
            self.leftMenuVisible = true
        }
        self.statusBarNeedsAppearanceUpdate()
    }
    
    func showRightMenuViewController() {
        if (self.rightMenuViewController == nil) {
            return
        }
        self.rightMenuViewController?.beginAppearanceTransition(true, animated: true)
        self.leftMenuViewController!.view.isHidden = true
        self.rightMenuViewController!.view.isHidden = false
        self.view.window?.endEditing(true)
        self.addContentButton()
        self.updateContentViewShadow()
        self.resetContentViewScale()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: self.animationDuration, animations: {
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
            } else {
                self.contentViewContainer.transform = CGAffineTransform.identity
            }
            self.contentViewContainer.center = CGPoint(x: (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX), y: self.contentViewContainer.center.y)
            
            if (self.fadeMenuView) {
                self.menuViewContainer.alpha = 1.0
            }
            self.contentViewContainer.alpha = self.contentViewFadeOutAlpha
            self.menuViewContainer.transform = CGAffineTransform.identity
            if (self.scaleBackgroundImageView) {
                self.backgroundImageView!.transform = CGAffineTransform.identity
            }
        }) { (Bool) in
            self.rightMenuViewController?.endAppearanceTransition()
            
            if (!self.rightMenuVisible) {
                self.delegate?.sideMenu?(self , didShowMenuViewController:self.rightMenuViewController!)
            }
            self.visible = !(self.contentViewContainer.frame.size.width == self.view.bounds.size.width && self.contentViewContainer.frame.size.height == self.view.bounds.size.height && self.contentViewContainer.frame.origin.x == 0 && self.contentViewContainer.frame.origin.y == 0)
            self.rightMenuVisible = self.visible
            UIApplication.shared.endIgnoringInteractionEvents()
            self.addContentViewControllerMotionEffects()
        }
        self.statusBarNeedsAppearanceUpdate()
    }
    
    func hideViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func hideMenuViewControllerAnimated(_ animated: Bool) {
        let rightMenuVisible: Bool = self.rightMenuVisible
        let visibleMenuViewController: UIViewController = (rightMenuVisible ? self.rightMenuViewController! : self.leftMenuViewController!)
        visibleMenuViewController.beginAppearanceTransition(false, animated: animated)
        
        self.delegate?.sideMenu?(self , willHideMenuViewController: rightMenuVisible ? self.rightMenuViewController! : self.leftMenuViewController!)
        
        self.visible = false
        self.leftMenuVisible = false
        self.rightMenuVisible = false
        self.contentButton.removeFromSuperview()
        
        let animationBlock = { [weak self] in
            self!.contentViewContainer.transform = CGAffineTransform.identity
            self!.contentViewContainer.frame = self!.view.bounds
            if (self!.scaleMenuView) {
                self!.menuViewContainer.transform = self!.menuViewControllerTransformation!
            }
            if (self!.fadeMenuView) {
                self!.menuViewContainer.alpha = 0
            }
            self!.contentViewContainer.alpha = 1
            
            if (self!.scaleBackgroundImageView) {
                self!.backgroundImageView!.transform = self!.backgroundTransformMakeScale()
                
            }
            if (self!.parallaxEnabled) {
                for effect in self!.contentViewContainer.motionEffects {
                    self!.contentViewContainer.removeMotionEffect(effect)
                }
            }
        }
        
        let completionBlock = { [weak self] in
            visibleMenuViewController.endAppearanceTransition()
            self!.statusBarNeedsAppearanceUpdate()
            if (self!.visible == false) {
                self!.delegate?.sideMenu?(self!, didHideMenuViewController:rightMenuVisible ? self!.rightMenuViewController! : self!.leftMenuViewController!)
            }
        }
        
        if (animated) {
            UIApplication.shared.beginIgnoringInteractionEvents()
            UIView.animate(withDuration: self.animationDuration, animations: {
                animationBlock()
                }, completion: { (Bool) in
                    UIApplication.shared.endIgnoringInteractionEvents()
                    completionBlock()
            })
        } else {
            animationBlock()
            completionBlock()
        }
    }
    
    func addContentButton() {
        if (self.contentButton.superview != nil) {
            return
        }
        
        self.contentButton.autoresizingMask = UIViewAutoresizing()
        self.contentButton.frame = self.contentViewContainer.bounds
        self.contentButton.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
        self.contentViewContainer.addSubview(self.contentButton)
    }
    
    func statusBarNeedsAppearanceUpdate() {
        if (self.responds(to: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate))) {
            UIView.animate(withDuration: 0.3, animations: {
                self.perform(#selector(UIViewController.setNeedsStatusBarAppearanceUpdate))
            })
        }
    }
    
    func updateContentViewShadow() {
        if (self.contentViewShadowEnabled) {
            let layer: CALayer = self.contentViewContainer.layer
            let path: UIBezierPath = UIBezierPath.init(rect: layer.bounds)
            layer.shadowPath = path.cgPath
            layer.shadowColor = self.contentViewShadowColor!.cgColor
            layer.shadowOffset = self.contentViewShadowOffset
            layer.shadowOpacity = self.contentViewShadowOpacity
            layer.shadowRadius = self.contentViewShadowRadius
        }
    }
    
    func resetContentViewScale() {
        let t: CGAffineTransform = self.contentViewContainer.transform
        let scale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let frame: CGRect = self.contentViewContainer.frame
        self.contentViewContainer.transform = CGAffineTransform.identity
        self.contentViewContainer.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.contentViewContainer.frame = frame
    }
    
    func backgroundTransformMakeScale() -> CGAffineTransform {
        return CGAffineTransform(scaleX: self.backgroundTransformScale, y: self.backgroundTransformScale);
    }
    
    // MARK: - iOS 7 Motion Effects (Private)
    
    func addMenuViewControllerMotionEffects() {
        if (self.parallaxEnabled) {
            for effect in self.menuViewContainer.motionEffects {
                self.menuViewContainer.removeMotionEffect(effect)
            }
            let interpolationHorizontal: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
            interpolationHorizontal.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue
            interpolationHorizontal.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue
            
            let interpolationVertical: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
            interpolationVertical.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue
            interpolationVertical.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue
            
            self.menuViewContainer.addMotionEffect(interpolationHorizontal)
            self.menuViewContainer.addMotionEffect(interpolationVertical)
        }
    }
    
    func addContentViewControllerMotionEffects() {
        if (self.parallaxEnabled) {
            for effect in self.contentViewContainer.motionEffects {
                self.contentViewContainer.removeMotionEffect(effect)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                let interpolationHorizontal: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: UIInterpolatingMotionEffectType.tiltAlongHorizontalAxis)
                interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                
                let interpolationVertical: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: UIInterpolatingMotionEffectType.tiltAlongVerticalAxis)
                interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                
                self.contentViewContainer.addMotionEffect(interpolationHorizontal)
                self.contentViewContainer.addMotionEffect(interpolationVertical)
            })
        }
    }
    
    // MARK: - <UIGestureRecognizerDelegate>
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (self.interactivePopGestureRecognizerEnabled && self.contentViewController! is UINavigationController) {
            let navigationController: UINavigationController = (self.contentViewController as! UINavigationController)
            if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer!.isEnabled) {
                return false
            }
        }
        
        if (self.panFromEdge && gestureRecognizer is UIPanGestureRecognizer && !self.visible) {
            let point: CGPoint = touch.location(in: gestureRecognizer.view)
            if((self.panGestureLeftEnabled && point.x < self.panFromEdgeZoneWidth) || (self.panGestureRightEnabled && point.x > self.view.frame.size.width - self.panFromEdgeZoneWidth)) {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    
    // MARK: - Pan gesture recognizer (Private)
    
    func panGestureRecognized(_ recognizer: UIPanGestureRecognizer) {
        
        self.delegate?.sideMenu?(self, didRecognizePanGesture:recognizer);
        
        if (!self.panGestureEnabled) {
            return
        }
        
        var point: CGPoint = recognizer.translation(in: self.view)
        
        if (recognizer.state == UIGestureRecognizerState.began) {
            self.updateContentViewShadow()
            
            self.originalPoint = CGPoint(x: self.contentViewContainer.center.x - self.contentViewContainer.bounds.width / 2.0,
                                             y: self.contentViewContainer.center.y - self.contentViewContainer.bounds.height / 2.0)
            self.menuViewContainer.transform = CGAffineTransform.identity
            if (self.scaleBackgroundImageView) {
                self.backgroundImageView!.transform = CGAffineTransform.identity
                self.backgroundImageView!.frame = self.view.bounds
            }
            self.menuViewContainer.frame = self.view.bounds
            self.addContentButton()
            self.view.window?.endEditing(true)
            self.didNotifyDelegate = false
        }
        
        if (recognizer.state == UIGestureRecognizerState.changed) {
            var delta: CGFloat = 0
            if (self.visible) {
                delta = self.originalPoint.x != 0 ? (point.x + self.originalPoint.x) / self.originalPoint.x : 0
            } else {
                delta = point.x / self.view.frame.size.width
            }
            delta = min(fabs(delta), 1.6)
            
            var contentViewScale: CGFloat = self.scaleContentView ? 1 - ((1 - self.contentViewScaleValue) * delta) : 1
            
            var backgroundViewScale: CGFloat = self.backgroundTransformScale - (0.7 * delta)
            var menuViewScale: CGFloat = 1.5 - (0.5 * delta)
            
            if (!self.bouncesHorizontally) {
                contentViewScale = max(contentViewScale, self.contentViewScaleValue)
                backgroundViewScale = max(backgroundViewScale, 1.0)
                menuViewScale = max(menuViewScale, 1.0)
            }
            
            if (self.fadeMenuView) {
                self.menuViewContainer.alpha = delta
            }
            self.contentViewContainer.alpha = 1 - (1 - self.contentViewFadeOutAlpha) * delta
            
            if (self.scaleBackgroundImageView) {
                self.backgroundImageView!.transform = CGAffineTransform(scaleX: backgroundViewScale, y: backgroundViewScale)
            }
            
            if (self.scaleMenuView) {
                self.menuViewContainer.transform = CGAffineTransform(scaleX: menuViewScale, y: menuViewScale)
            }
            
            if (self.scaleBackgroundImageView) {
                if (backgroundViewScale < 1) {
                    self.backgroundImageView!.transform = CGAffineTransform.identity
                }
            }
            
            if (!self.bouncesHorizontally && self.visible) {
                if (self.contentViewContainer.frame.origin.x > self.contentViewContainer.frame.size.width / 2.0) {
                    point.x = min(0.0, point.x)
                }
                
                if (self.contentViewContainer.frame.origin.x < -(self.contentViewContainer.frame.size.width / 2.0)) {
                    point.x = max(0.0, point.x)
                }
            }
            
            // Limit size
            //
            if (point.x < 0) {
                point.x = max(point.x, -UIScreen.main.bounds.size.height)
            } else {
                point.x = min(point.x, UIScreen.main.bounds.size.height)
            }
            recognizer.setTranslation(point, in: self.view)
            
            if (!self.didNotifyDelegate) {
                if (point.x > 0) {
                    if (!self.visible) {
                        self.delegate?.sideMenu?(self, willShowMenuViewController:self.leftMenuViewController!)
                    }
                }
                if (point.x < 0) {
                    if (!self.visible) {
                        self.delegate?.sideMenu?(self, willShowMenuViewController:self.rightMenuViewController!)
                    }
                }
                self.didNotifyDelegate = true
            }
            
            if (contentViewScale > 1) {
                let oppositeScale: CGFloat = (1 - (contentViewScale - 1))
                self.contentViewContainer.transform = CGAffineTransform(scaleX: oppositeScale, y: oppositeScale)
                self.contentViewContainer.transform = self.contentViewContainer.transform.translatedBy(x: point.x, y: 0)
            } else {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: contentViewScale, y: contentViewScale)
                self.contentViewContainer.transform = self.contentViewContainer.transform.translatedBy(x: point.x, y: 0)
            }
            
            self.leftMenuViewController!.view.isHidden = self.contentViewContainer.frame.origin.x < 0
            self.rightMenuViewController!.view.isHidden = self.contentViewContainer.frame.origin.x > 0
            
            if (self.leftMenuViewController == nil && self.contentViewContainer.frame.origin.x > 0) {
                self.contentViewContainer.transform = CGAffineTransform.identity
                self.contentViewContainer.frame = self.view.bounds
                self.visible = false
                self.leftMenuVisible = false
            } else  if (self.rightMenuViewController == nil && self.contentViewContainer.frame.origin.x < 0) {
                self.contentViewContainer.transform = CGAffineTransform.identity
                self.contentViewContainer.frame = self.view.bounds
                self.visible = false
                self.rightMenuVisible = false
            }
            
            self.statusBarNeedsAppearanceUpdate()
        }
        
        if (recognizer.state == UIGestureRecognizerState.ended) {
            self.didNotifyDelegate = false
            if (self.panMinimumOpenThreshold > 0 && ((self.contentViewContainer.frame.origin.x < 0 && self.contentViewContainer.frame.origin.x > -(CGFloat(self.panMinimumOpenThreshold))) ||
                (self.contentViewContainer.frame.origin.x > 0 && self.contentViewContainer.frame.origin.x < CGFloat(self.panMinimumOpenThreshold)))) {
                self.hideMenuViewController()
            }
            else if (self.contentViewContainer.frame.origin.x == 0) {
                self.hideMenuViewControllerAnimated(false)
            }
            else {
                if (recognizer.velocity(in: self.view).x > 0) {
                    if (self.contentViewContainer.frame.origin.x < 0) {
                        self.hideMenuViewController()
                    } else {
                        if (self.leftMenuViewController != nil) {
                            self.showLeftMenuViewController()
                        }
                    }
                } else {
                    if (self.contentViewContainer.frame.origin.x < 20) {
                        if (self.rightMenuViewController != nil) {
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
            if (self.backgroundImageView != nil) {
                self.backgroundImageView!.image = newValue
            }
        }
    }
    
    public var leftMenuViewController: UIViewController? {
        get {
            return self._leftMenuViewController
        }
        set {
            if (self._leftMenuViewController == nil) {
                self._leftMenuViewController = newValue
                return
            }
            self.hideViewController(self._leftMenuViewController!)
            self._leftMenuViewController = newValue
            
            self.addChildViewController(self._leftMenuViewController!)
            self._leftMenuViewController!.view.frame = self.view.bounds
            self._leftMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
            self.menuViewContainer.addSubview(self._leftMenuViewController!.view)
            self._leftMenuViewController!.didMove(toParentViewController: self)
            
            self.addContentViewControllerMotionEffects()
            self.view.bringSubview(toFront: self.contentViewContainer)
        }
    }
    
    public var rightMenuViewController: UIViewController? {
        get {
            return self._rightMenuViewController
        }
        set {
            if (self._rightMenuViewController == nil) {
                self._rightMenuViewController = newValue
                return
            }
            self.hideViewController(self._rightMenuViewController!)
            self._rightMenuViewController = newValue
            
            self.addChildViewController(self._rightMenuViewController!)
            self._rightMenuViewController!.view.frame = self.view.bounds
            self._rightMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
            self.menuViewContainer.addSubview(self._rightMenuViewController!.view)
            self._rightMenuViewController!.didMove(toParentViewController: self)
            
            self.addContentViewControllerMotionEffects()
            self.view.bringSubview(toFront: self.contentViewContainer)
        }
    }
    
    // MARK: - View Controller Rotation handler
    
    override open var shouldAutorotate: Bool {
        get {
            return self.contentViewController!.shouldAutorotate
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return self.contentViewController!.supportedInterfaceOrientations
        }
    }
    
    override open func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if (self.visible) {
            self.menuViewContainer.bounds = self.view.bounds
            self.contentViewContainer.transform = CGAffineTransform.identity
            self.contentViewContainer.frame = self.view.bounds
            
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransform(scaleX: self.contentViewScaleValue, y: self.contentViewScaleValue)
            } else {
                self.contentViewContainer.transform = CGAffineTransform.identity
            }
            
            let center: CGPoint
            if (self.leftMenuVisible) {
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
        get {
            var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
            
            statusBarStyle = self.visible ? self.menuPreferredStatusBarStyle : self.contentViewController!.preferredStatusBarStyle
            if (self.contentViewContainer.frame.origin.y > 10) {
                statusBarStyle = self.menuPreferredStatusBarStyle
            } else {
                statusBarStyle = self.contentViewController!.preferredStatusBarStyle
            }
            return statusBarStyle
        }
    }
    
    override open var prefersStatusBarHidden: Bool {
        get {
            var statusBarHidden: Bool = false
            
            statusBarHidden = self.visible ? self.menuPrefersStatusBarHidden : self.contentViewController!.prefersStatusBarHidden
            if (self.contentViewContainer.frame.origin.y > 10) {
                statusBarHidden = self.menuPrefersStatusBarHidden
            } else {
                statusBarHidden = self.contentViewController!.prefersStatusBarHidden
            }
            return statusBarHidden
        }  
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            var statusBarAnimation: UIStatusBarAnimation = UIStatusBarAnimation.none
            
            statusBarAnimation = self.visible ? self.leftMenuViewController!.preferredStatusBarUpdateAnimation : self.contentViewController!.preferredStatusBarUpdateAnimation
            if (self.contentViewContainer.frame.origin.y > 10) {
                statusBarAnimation = self.leftMenuViewController!.preferredStatusBarUpdateAnimation
            } else {
                statusBarAnimation = self.contentViewController!.preferredStatusBarUpdateAnimation
            }
            
            return statusBarAnimation
        }
    }
    
}
