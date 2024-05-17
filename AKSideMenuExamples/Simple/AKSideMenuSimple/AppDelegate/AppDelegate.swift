//
//  AppDelegate.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import AKSideMenu
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = buildController()
        window?.makeKeyAndVisible()
        return true
    }

    private func buildController() -> UIViewController {
        // Create content and menu controllers
        let navigationController = UINavigationController(rootViewController: FirstViewController())
        let leftMenuViewController = LeftMenuViewController()
        let rightMenuViewController = RightMenuViewController()

        // Create sideMenuController
        let sideMenuViewController = AKSideMenu(contentViewController: navigationController,
                                                leftMenuViewController: leftMenuViewController,
                                                rightMenuViewController: rightMenuViewController)

        // Configure sideMenuController
        sideMenuViewController.backgroundImage = UIImage(named: "Stars")
        sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
        sideMenuViewController.delegate = self
        sideMenuViewController.contentViewShadowColor = .black
        sideMenuViewController.contentViewShadowOffset = .zero
        sideMenuViewController.contentViewShadowOpacity = 0.6
        sideMenuViewController.contentViewShadowRadius = 12
        sideMenuViewController.contentViewShadowEnabled = true
        return sideMenuViewController
    }
}

extension AppDelegate: AKSideMenuDelegate {
    public func sideMenu(_: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        debugPrint("willShowMenuViewController", menuViewController)
    }

    public func sideMenu(_: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        debugPrint("didShowMenuViewController", menuViewController)
    }

    public func sideMenu(_: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        debugPrint("willHideMenuViewController ", menuViewController)
    }

    public func sideMenu(_: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        debugPrint("didHideMenuViewController", menuViewController)
    }
}
