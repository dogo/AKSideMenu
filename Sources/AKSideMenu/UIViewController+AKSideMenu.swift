//
//  UIViewController+AKSideMenu.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

// MARK: - UIViewController+AKSideMenu

public extension UIViewController {
    var sideMenuViewController: AKSideMenu? {
        var iterator = parent

        while let viewController = iterator {
            if let sideMenuViewController = viewController as? AKSideMenu {
                return sideMenuViewController
            }
            iterator = viewController.parent
        }

        return nil
    }

    // MARK: - Public

    // MARK: - IBAction Helper methods

    @IBAction func presentLeftMenuViewController(_: AnyObject) {
        sideMenuViewController?.presentLeftMenuViewController()
    }

    @IBAction func presentRightMenuViewController(_: AnyObject) {
        sideMenuViewController?.presentRightMenuViewController()
    }
}
