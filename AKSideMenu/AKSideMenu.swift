//
//  AKSideMenu.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

@objc protocol AKSideMenuDelegate {
    optional func sideMenu(sideMenu: AKSideMenu, didRecognizePanGesture recognizer: UIPanGestureRecognizer)
    optional func sideMenu(sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController)
    optional func sideMenu(sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController)
    optional func sideMenu(sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController)
    optional func sideMenu(sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController)
}

@IBDesignable public class AKSideMenu : UIViewController, UIGestureRecognizerDelegate {
    
    var visible: Bool = false
    var leftMenuVisible: Bool = false
    var rightMenuVisible: Bool = false
    var didNotifyDelegate: Bool = false
    var originalPoint: CGPoint = CGPointZero
    var contentButton: UIButton = UIButton()
    var backgroundImageView: UIImageView?
    var menuViewContainer: UIView = UIView()
    var contentViewContainer: UIView = UIView()
    var delegate: AKSideMenuDelegate?
    
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
    @IBInspectable public var contentViewShadowOffset: CGSize = CGSizeZero
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
    
    public var animationDuration: NSTimeInterval =  0.35
    public var menuViewControllerTransformation: CGAffineTransform?
    public var panGestureEnabled: Bool = true
    public var panFromEdge: Bool = true
    public var panMinimumOpenThreshold: Float = 60.0
    public var menuPreferredStatusBarStyle: UIStatusBarStyle = UIStatusBarStyle.Default
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
    
    convenience init(contentViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.init()
        self.contentViewController = contentViewController
        self.leftMenuViewController = leftMenuViewController
        self.rightMenuViewController = rightMenuViewController
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        if (self.contentViewStoryboardID != nil) {
            self.contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier(self.contentViewStoryboardID!)
        }
        if (self.leftMenuViewStoryboardID != nil) {
            self.leftMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier(self.leftMenuViewStoryboardID!)
        }
        if (self.rightMenuViewStoryboardID != nil) {
            self.rightMenuViewController = self.storyboard!.instantiateViewControllerWithIdentifier(self.rightMenuViewStoryboardID!)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        let imageView: UIImageView = UIImageView.init(frame: self.view.bounds)
        imageView.image = self.backgroundImage
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        self.backgroundImageView = imageView
        
        let button: UIButton = UIButton.init(frame: CGRectNull)
        button.addTarget(self, action: #selector(AKSideMenu.hideMenuViewController), forControlEvents: UIControlEvents.TouchUpInside)
        self.contentButton = button
        
        self.view.addSubview(self.backgroundImageView!)
        self.view.addSubview(self.menuViewContainer)
        self.view.addSubview(self.contentViewContainer)
        
        self.menuViewContainer.frame = self.view.bounds
        self.menuViewContainer.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        if (self.leftMenuViewController != nil) {
            self.addChildViewController(self.leftMenuViewController!)
            self.leftMenuViewController!.view.frame = self.view.bounds
            self.leftMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.menuViewContainer.addSubview(self.leftMenuViewController!.view)
            self.leftMenuViewController?.didMoveToParentViewController(self)
        }
        
        if (self.rightMenuViewController != nil) {
            self.addChildViewController(self.rightMenuViewController!)
            self.rightMenuViewController!.view.frame = self.view.bounds
            self.rightMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            self.menuViewContainer.addSubview(self.rightMenuViewController!.view)
            self.rightMenuViewController?.didMoveToParentViewController(self)
        }
        
        self.contentViewContainer.frame = self.view.bounds
        self.contentViewContainer.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        self.addChildViewController(self.contentViewController!)
        self.contentViewController!.view.frame = self.view.bounds
        self.contentViewContainer.addSubview(self.contentViewController!.view)
        self.contentViewController!.didMoveToParentViewController(self)
        
        if (self.fadeMenuView) {
            self.menuViewContainer.alpha = 0
        }
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView!.transform = self.backgroundTransformMakeScale()
        }
        
        self.addMenuViewControllerMotionEffects()
        
        if (self.panGestureEnabled) {
            self.view.multipleTouchEnabled = false
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
        
        self.menuViewControllerTransformation = CGAffineTransformMakeScale(1.5, 1.5)
        
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
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeZero
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
    
    public func setContentViewController(contentViewController: UIViewController, animated: Bool) {
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
            
            UIView.animateWithDuration(self.animationDuration, animations: {
                contentViewController.view.alpha = 1
                }, completion: { (Bool) in
                    self.hideViewController(self.contentViewController!)
                    contentViewController.didMoveToParentViewController(self)
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
    
    func presentMenuViewContainerWithMenuViewController(menuViewController: UIViewController) {
        self.menuViewContainer.transform = CGAffineTransformIdentity
        
        if (self.scaleBackgroundImageView) {
            self.backgroundImageView!.transform = CGAffineTransformIdentity
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
        self.leftMenuViewController!.view.hidden = false
        self.rightMenuViewController!.view.hidden = true
        self.view.window?.endEditing(true)
        self.addContentButton()
        self.updateContentViewShadow()
        self.resetContentViewScale()
        
        UIView.animateWithDuration(self.animationDuration, animations: {
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue)
            } else {
                self.contentViewContainer.transform = CGAffineTransformIdentity
            }
            
            self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetWidth(self.view.frame) : self.contentViewInPortraitOffsetCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y)
            
            if (self.fadeMenuView) {
                self.menuViewContainer.alpha = 1.0
            }
            self.contentViewContainer.alpha = self.contentViewFadeOutAlpha
            self.menuViewContainer.transform = CGAffineTransformIdentity
            if (self.scaleBackgroundImageView) {
                self.backgroundImageView!.transform = CGAffineTransformIdentity
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
        self.leftMenuViewController!.view.hidden = true
        self.rightMenuViewController!.view.hidden = false
        self.view.window?.endEditing(true)
        self.addContentButton()
        self.updateContentViewShadow()
        self.resetContentViewScale()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        UIView.animateWithDuration(self.animationDuration, animations: {
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue)
            } else {
                self.contentViewContainer.transform = CGAffineTransformIdentity
            }
            self.contentViewContainer.center = CGPointMake((UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX), self.contentViewContainer.center.y)
            
            if (self.fadeMenuView) {
                self.menuViewContainer.alpha = 1.0
            }
            self.contentViewContainer.alpha = self.contentViewFadeOutAlpha
            self.menuViewContainer.transform = CGAffineTransformIdentity
            if (self.scaleBackgroundImageView) {
                self.backgroundImageView!.transform = CGAffineTransformIdentity
            }
        }) { (Bool) in
            self.rightMenuViewController?.endAppearanceTransition()
            
            if (!self.rightMenuVisible) {
                self.delegate?.sideMenu?(self , didShowMenuViewController:self.rightMenuViewController!)
            }
            self.visible = !(self.contentViewContainer.frame.size.width == self.view.bounds.size.width && self.contentViewContainer.frame.size.height == self.view.bounds.size.height && self.contentViewContainer.frame.origin.x == 0 && self.contentViewContainer.frame.origin.y == 0)
            self.rightMenuVisible = self.visible
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.addContentViewControllerMotionEffects()
        }
        self.statusBarNeedsAppearanceUpdate()
    }
    
    func hideViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func hideMenuViewControllerAnimated(animated: Bool) {
        let rightMenuVisible: Bool = self.rightMenuVisible
        let visibleMenuViewController: UIViewController = (rightMenuVisible ? self.rightMenuViewController! : self.leftMenuViewController!)
        visibleMenuViewController.beginAppearanceTransition(false, animated: animated)
        
        self.delegate?.sideMenu?(self , willHideMenuViewController: rightMenuVisible ? self.rightMenuViewController! : self.leftMenuViewController!)
        
        self.visible = false
        self.leftMenuVisible = false
        self.rightMenuVisible = false
        self.contentButton.removeFromSuperview()
        
        let animationBlock = { [weak self] in
            self!.contentViewContainer.transform = CGAffineTransformIdentity
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
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            UIView.animateWithDuration(self.animationDuration, animations: {
                animationBlock()
                }, completion: { (Bool) in
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
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
        
        self.contentButton.autoresizingMask = UIViewAutoresizing.None
        self.contentButton.frame = self.contentViewContainer.bounds
        self.contentButton.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
        self.contentViewContainer.addSubview(self.contentButton)
    }
    
    func statusBarNeedsAppearanceUpdate() {
        if (self.respondsToSelector(#selector(UIViewController.setNeedsStatusBarAppearanceUpdate))) {
            UIView.animateWithDuration(0.3, animations: {
                self.performSelector(#selector(UIViewController.setNeedsStatusBarAppearanceUpdate))
            })
        }
    }
    
    func updateContentViewShadow() {
        if (self.contentViewShadowEnabled) {
            let layer: CALayer = self.contentViewContainer.layer
            let path: UIBezierPath = UIBezierPath.init(rect: layer.bounds)
            layer.shadowPath = path.CGPath
            layer.shadowColor = self.contentViewShadowColor!.CGColor
            layer.shadowOffset = self.contentViewShadowOffset
            layer.shadowOpacity = self.contentViewShadowOpacity
            layer.shadowRadius = self.contentViewShadowRadius
        }
    }
    
    func resetContentViewScale() {
        let t: CGAffineTransform = self.contentViewContainer.transform
        let scale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let frame: CGRect = self.contentViewContainer.frame
        self.contentViewContainer.transform = CGAffineTransformIdentity
        self.contentViewContainer.transform = CGAffineTransformMakeScale(scale, scale)
        self.contentViewContainer.frame = frame
    }
    
    func backgroundTransformMakeScale() -> CGAffineTransform {
        return CGAffineTransformMakeScale(self.backgroundTransformScale, self.backgroundTransformScale);
    }
    
    // MARK: - iOS 7 Motion Effects (Private)
    
    func addMenuViewControllerMotionEffects() {
        if (self.parallaxEnabled) {
            for effect in self.menuViewContainer.motionEffects {
                self.menuViewContainer.removeMotionEffect(effect)
            }
            let interpolationHorizontal: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
            interpolationHorizontal.minimumRelativeValue = self.parallaxMenuMinimumRelativeValue
            interpolationHorizontal.maximumRelativeValue = self.parallaxMenuMaximumRelativeValue
            
            let interpolationVertical: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
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
            
            UIView.animateWithDuration(0.2, animations: {
                let interpolationHorizontal: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
                interpolationHorizontal.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationHorizontal.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                
                let interpolationVertical: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect.init(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
                interpolationVertical.minimumRelativeValue = self.parallaxContentMinimumRelativeValue
                interpolationVertical.maximumRelativeValue = self.parallaxContentMaximumRelativeValue
                
                self.contentViewContainer.addMotionEffect(interpolationHorizontal)
                self.contentViewContainer.addMotionEffect(interpolationVertical)
            })
        }
    }
    
    // MARK: - <UIGestureRecognizerDelegate>
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (self.interactivePopGestureRecognizerEnabled && self.contentViewController!.isKindOfClass(UINavigationController)) {
            let navigationController: UINavigationController = (self.contentViewController as! UINavigationController)
            if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer!.enabled) {
                return false
            }
        }
        
        if (self.panFromEdge && gestureRecognizer.isKindOfClass(UIPanGestureRecognizer) && !self.visible) {
            let point: CGPoint = touch.locationInView(gestureRecognizer.view)
            if((self.panGestureLeftEnabled && point.x < self.panFromEdgeZoneWidth) || (self.panGestureRightEnabled && point.x > self.view.frame.size.width - self.panFromEdgeZoneWidth)) {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    
    // MARK: - Pan gesture recognizer (Private)
    
    func panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        
        self.delegate?.sideMenu?(self, didRecognizePanGesture:recognizer);
        
        if (!self.panGestureEnabled) {
            return
        }
        
        var point: CGPoint = recognizer.translationInView(self.view)
        
        if (recognizer.state == UIGestureRecognizerState.Began) {
            self.updateContentViewShadow()
            
            self.originalPoint = CGPointMake(self.contentViewContainer.center.x - CGRectGetWidth(self.contentViewContainer.bounds) / 2.0,
                                             self.contentViewContainer.center.y - CGRectGetHeight(self.contentViewContainer.bounds) / 2.0)
            self.menuViewContainer.transform = CGAffineTransformIdentity
            if (self.scaleBackgroundImageView) {
                self.backgroundImageView!.transform = CGAffineTransformIdentity
                self.backgroundImageView!.frame = self.view.bounds
            }
            self.menuViewContainer.frame = self.view.bounds
            self.addContentButton()
            self.view.window?.endEditing(true)
            self.didNotifyDelegate = false
        }
        
        if (recognizer.state == UIGestureRecognizerState.Changed) {
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
                self.backgroundImageView!.transform = CGAffineTransformMakeScale(backgroundViewScale, backgroundViewScale)
            }
            
            if (self.scaleMenuView) {
                self.menuViewContainer.transform = CGAffineTransformMakeScale(menuViewScale, menuViewScale)
            }
            
            if (self.scaleBackgroundImageView) {
                if (backgroundViewScale < 1) {
                    self.backgroundImageView!.transform = CGAffineTransformIdentity
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
                point.x = max(point.x, -UIScreen.mainScreen().bounds.size.height)
            } else {
                point.x = min(point.x, UIScreen.mainScreen().bounds.size.height)
            }
            recognizer.setTranslation(point, inView: self.view)
            
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
                self.contentViewContainer.transform = CGAffineTransformMakeScale(oppositeScale, oppositeScale)
                self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0)
            } else {
                self.contentViewContainer.transform = CGAffineTransformMakeScale(contentViewScale, contentViewScale)
                self.contentViewContainer.transform = CGAffineTransformTranslate(self.contentViewContainer.transform, point.x, 0)
            }
            
            self.leftMenuViewController!.view.hidden = self.contentViewContainer.frame.origin.x < 0
            self.rightMenuViewController!.view.hidden = self.contentViewContainer.frame.origin.x > 0
            
            if (self.leftMenuViewController == nil && self.contentViewContainer.frame.origin.x > 0) {
                self.contentViewContainer.transform = CGAffineTransformIdentity
                self.contentViewContainer.frame = self.view.bounds
                self.visible = false
                self.leftMenuVisible = false
            } else  if (self.rightMenuViewController == nil && self.contentViewContainer.frame.origin.x < 0) {
                self.contentViewContainer.transform = CGAffineTransformIdentity
                self.contentViewContainer.frame = self.view.bounds
                self.visible = false
                self.rightMenuVisible = false
            }
            
            self.statusBarNeedsAppearanceUpdate()
        }
        
        if (recognizer.state == UIGestureRecognizerState.Ended) {
            self.didNotifyDelegate = false
            if (self.panMinimumOpenThreshold > 0 && ((self.contentViewContainer.frame.origin.x < 0 && self.contentViewContainer.frame.origin.x > -(CGFloat(self.panMinimumOpenThreshold))) ||
                (self.contentViewContainer.frame.origin.x > 0 && self.contentViewContainer.frame.origin.x < CGFloat(self.panMinimumOpenThreshold)))) {
                self.hideMenuViewController()
            }
            else if (self.contentViewContainer.frame.origin.x == 0) {
                self.hideMenuViewControllerAnimated(false)
            }
            else {
                if (recognizer.velocityInView(self.view).x > 0) {
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
            self._leftMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
            self.menuViewContainer.addSubview(self._leftMenuViewController!.view)
            self._leftMenuViewController!.didMoveToParentViewController(self)
            
            self.addContentViewControllerMotionEffects()
            self.view.bringSubviewToFront(self.contentViewContainer)
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
            self._rightMenuViewController!.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleHeight]
            self.menuViewContainer.addSubview(self._rightMenuViewController!.view)
            self._rightMenuViewController!.didMoveToParentViewController(self)
            
            self.addContentViewControllerMotionEffects()
            self.view.bringSubviewToFront(self.contentViewContainer)
        }
    }
    
    // MARK: - View Controller Rotation handler
    
    public override func shouldAutorotate() -> Bool {
        return self.contentViewController!.shouldAutorotate()
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.contentViewController!.supportedInterfaceOrientations()
    }
    
    public override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (self.visible) {
            self.menuViewContainer.bounds = self.view.bounds
            self.contentViewContainer.transform = CGAffineTransformIdentity
            self.contentViewContainer.frame = self.view.bounds
            
            if (self.scaleContentView) {
                self.contentViewContainer.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue)
            } else {
                self.contentViewContainer.transform = CGAffineTransformIdentity
            }
            
            let center: CGPoint
            if (self.leftMenuVisible) {
                center = CGPointMake((UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? self.contentViewInLandscapeOffsetCenterX + CGRectGetWidth(self.view.frame) : self.contentViewInPortraitOffsetCenterX + CGRectGetWidth(self.view.frame)), self.contentViewContainer.center.y)
            } else {
                center = CGPointMake((UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) ? -self.contentViewInLandscapeOffsetCenterX : -self.contentViewInPortraitOffsetCenterX), self.contentViewContainer.center.y)
            }
            self.contentViewContainer.center = center
        }
        self.updateContentViewShadow()
    }
    
    // MARK: - Status Bar Appearance Management
    
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.Default
        
        statusBarStyle = self.visible ? self.menuPreferredStatusBarStyle : self.contentViewController!.preferredStatusBarStyle()
        if (self.contentViewContainer.frame.origin.y > 10) {
            statusBarStyle = self.menuPreferredStatusBarStyle
        } else {
            statusBarStyle = self.contentViewController!.preferredStatusBarStyle()
        }
        return statusBarStyle
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        var statusBarHidden: Bool = false
        
        statusBarHidden = self.visible ? self.menuPrefersStatusBarHidden : self.contentViewController!.prefersStatusBarHidden()
        if (self.contentViewContainer.frame.origin.y > 10) {
            statusBarHidden = self.menuPrefersStatusBarHidden
        } else {
            statusBarHidden = self.contentViewController!.prefersStatusBarHidden()
        }
        return statusBarHidden
    }
    
    override public func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        var statusBarAnimation: UIStatusBarAnimation = UIStatusBarAnimation.None
        
        statusBarAnimation = self.visible ? self.leftMenuViewController!.preferredStatusBarUpdateAnimation() : self.contentViewController!.preferredStatusBarUpdateAnimation()
        if (self.contentViewContainer.frame.origin.y > 10) {
            statusBarAnimation = self.leftMenuViewController!.preferredStatusBarUpdateAnimation()
        } else {
            statusBarAnimation = self.contentViewController!.preferredStatusBarUpdateAnimation()
        }
        return statusBarAnimation
    }
    
}