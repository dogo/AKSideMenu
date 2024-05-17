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
        guard var iterator = parent else { return nil }
        guard let strClass = String(describing: type(of: iterator)).components(separatedBy: ".").last else { return nil }

        while strClass != nibName {
            if iterator is AKSideMenu {
                return iterator as? AKSideMenu
            } else if let parent = iterator.parent, parent != iterator {
                iterator = parent
            } else {
                break
            }
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
