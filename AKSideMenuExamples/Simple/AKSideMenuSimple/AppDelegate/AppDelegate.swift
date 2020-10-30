//
//  AppDelegate.swift
//  AKSideMenu
//
//  Created by Diogo Autilio on 6/3/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit
import AKSideMenu

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = buildController()
        self.window?.makeKeyAndVisible()
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
        sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
        sideMenuViewController.contentViewShadowOpacity = 0.6
        sideMenuViewController.contentViewShadowRadius = 12
        sideMenuViewController.contentViewShadowEnabled = true
        return sideMenuViewController
    }
}

extension AppDelegate: AKSideMenuDelegate {

    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        debugPrint("willShowMenuViewController", menuViewController)
    }

    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        debugPrint("didShowMenuViewController", menuViewController)
    }

    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        debugPrint("willHideMenuViewController ", menuViewController)
    }

    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        debugPrint("didHideMenuViewController", menuViewController)
    }
}
