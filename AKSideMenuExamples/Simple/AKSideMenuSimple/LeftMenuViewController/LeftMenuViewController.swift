//
//  LeftMenuViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import AKSideMenu
import UIKit

final class LeftMenuViewController: UIViewController {

    // MARK: - Properties

    let leftMenuView = LeftMenuView()

    // MARK: - Life Cycle

    override func loadView() {
        view = leftMenuView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        leftMenuView.didTouchIndex = { [weak self] index in
            self?.handleTouch(at: index)
        }
    }

    // MARK: - Actions

    private func handleTouch(at index: Int) {
        switch index {
        case 0:
            let contentViewController = UINavigationController(rootViewController: FirstViewController())
            sideMenuViewController?.setContentViewController(contentViewController, animated: true)
            sideMenuViewController?.hideMenuViewController()
        case 1:
            let contentViewController = UINavigationController(rootViewController: SecondViewController())
            sideMenuViewController?.setContentViewController(contentViewController, animated: true)
            sideMenuViewController?.hideMenuViewController()
        default:
            break
        }
    }
}
