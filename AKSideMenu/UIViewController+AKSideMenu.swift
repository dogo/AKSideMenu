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

    public var sideMenuViewController: AKSideMenu? {
        get {
            var iter: UIViewController = self.parent!
            let strClass = String(describing: type(of: iter)).components(separatedBy: ".").last!
            while strClass != nibName {
                if iter is AKSideMenu {
                    return iter as? AKSideMenu
                } else if iter.parent != nil && iter.parent != iter {
                    iter = iter.parent!
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

    @IBAction public func presentLeftMenuViewController(_ sender: AnyObject) {
        self.sideMenuViewController!.presentLeftMenuViewController()
    }

    @IBAction public func presentRightMenuViewController(_ sender: AnyObject) {
        self.sideMenuViewController!.presentRightMenuViewController()
    }
}
