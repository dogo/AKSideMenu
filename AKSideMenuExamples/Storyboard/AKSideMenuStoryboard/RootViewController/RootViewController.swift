//
//  RootViewController.swift
//  AKSideMenuStoryboard
//
//  Created by Diogo Autilio on 6/9/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import AKSideMenu
import Foundation
import UIKit

final class RootViewController: AKSideMenu, AKSideMenuDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = .zero
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true

        self.backgroundImage = UIImage(named: "Stars")
        self.delegate = self

        if let storyboard = self.storyboard {
            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
            self.rightMenuViewController = storyboard.instantiateViewController(withIdentifier: "rightMenuViewController")
        }
    }

    // MARK: - <AKSideMenuDelegate>

    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        debugPrint("willShowMenuViewController")
    }

    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        debugPrint("didShowMenuViewController")
    }

    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        debugPrint("willHideMenuViewController")
    }

    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        debugPrint("didHideMenuViewController")
    }
}
