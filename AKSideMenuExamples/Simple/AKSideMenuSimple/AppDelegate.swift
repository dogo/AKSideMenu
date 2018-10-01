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
class AppDelegate: UIResponder, UIApplicationDelegate, AKSideMenuDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Create content and menu controllers
        let navigationController = UINavigationController(rootViewController: FirstViewController())
        let leftMenuViewController = LeftMenuViewController()
        let rightMenuViewController = RightMenuViewController()

        // Create side menu controller
        let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)

        sideMenuViewController.backgroundImage = UIImage(named: "Stars")!
        sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
        sideMenuViewController.delegate = self
        sideMenuViewController.contentViewShadowColor = .black
        sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
        sideMenuViewController.contentViewShadowOpacity = 0.6
        sideMenuViewController.contentViewShadowRadius = 12
        sideMenuViewController.contentViewShadowEnabled = true
        self.window?.rootViewController = sideMenuViewController

        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: - <AKSideMenuDelegate>

    open func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        print("willShowMenuViewController")
    }

    open func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }

    open func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }

    open func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
}
