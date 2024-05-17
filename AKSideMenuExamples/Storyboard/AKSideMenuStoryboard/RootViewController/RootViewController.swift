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
        menuPreferredStatusBarStyle = .lightContent
        contentViewShadowColor = .black
        contentViewShadowOffset = .zero
        contentViewShadowOpacity = 0.6
        contentViewShadowRadius = 12
        contentViewShadowEnabled = true

        backgroundImage = UIImage(named: "Stars")
        delegate = self

        if let storyboard = storyboard {
            contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
            leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
            rightMenuViewController = storyboard.instantiateViewController(withIdentifier: "rightMenuViewController")
        }
    }

    // MARK: - <AKSideMenuDelegate>

    func sideMenu(_: AKSideMenu, willShowMenuViewController _: UIViewController) {
        debugPrint("willShowMenuViewController")
    }

    func sideMenu(_: AKSideMenu, didShowMenuViewController _: UIViewController) {
        debugPrint("didShowMenuViewController")
    }

    func sideMenu(_: AKSideMenu, willHideMenuViewController _: UIViewController) {
        debugPrint("willHideMenuViewController")
    }

    func sideMenu(_: AKSideMenu, didHideMenuViewController _: UIViewController) {
        debugPrint("didHideMenuViewController")
    }
}
