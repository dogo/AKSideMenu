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
            guard var iterator = self.parent else { return nil }
            guard let strClass = String(describing: type(of: iterator)).components(separatedBy: ".").last else { return nil }

            while strClass != nibName {
                if iterator is AKSideMenu {
                    return iterator as? AKSideMenu
                } else if iterator.parent != nil && iterator.parent != iterator {
                    iterator = iterator.parent!
                }
            }
            return nil
        }
        set(newValue) {
            self.sideMenuViewController = newValue
        }
    }

    // MARK: - Public
    // MARK: - IBAction Helper methods

    @IBAction public func presentLeftMenuViewController(_ sender: AnyObject) {
        self.sideMenuViewController?.presentLeftMenuViewController()
    }

    @IBAction public func presentRightMenuViewController(_ sender: AnyObject) {
        self.sideMenuViewController?.presentRightMenuViewController()
    }
}
