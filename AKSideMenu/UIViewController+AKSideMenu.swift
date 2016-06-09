//
//  UIViewController+AKSideMenu.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

// MARK: - UIViewController+AKSideMenu

extension UIViewController {
    
    var sideMenuViewController: AKSideMenu? {
        get {
            var iter : UIViewController = self.parentViewController!
            while (iter != nibName) {
                if (iter.isKindOfClass(AKSideMenu)) {
                    return (iter as! AKSideMenu)
                } else if (iter.parentViewController != nil && iter.parentViewController != iter) {
                    iter = iter.parentViewController!
                }
            }
            return nil
        }
        set(newValue) {
            self.sideMenuViewController = newValue
        }
    }
    
    // MARK: - Public
    // MARK: - IB Action Helper methods
    
    @IBAction public func presentLeftMenuViewController(sender: AnyObject) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }
    
    @IBAction public func presentRightMenuViewController(sender: AnyObject) {
        self.sideMenuViewController!.presentRightMenuViewController()
    }
}