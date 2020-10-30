//
//  RightMenuViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import AKSideMenu
import UIKit

final class RightMenuViewController: UIViewController {

    // MARK: - Properties

    let rightMenuView = RightMenuView()

    // MARK: - Life Cycle

    override func loadView() {
        view = rightMenuView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        rightMenuView.didTouchIndex = { [weak self] index in
            self?.handleTouch(at: index)
        }
    }

    // MARK: - Actions

    private func handleTouch(at index: Int) {
        switch index {
        case 0:
            let contentViewController = UINavigationController(rootViewController: FirstViewController())
            self.sideMenuViewController?.setContentViewController(contentViewController, animated: true)
            self.sideMenuViewController?.hideMenuViewController()
        case 1:
            let contentViewController = UINavigationController(rootViewController: SecondViewController())
            sideMenuViewController?.setContentViewController(contentViewController, animated: true)
            sideMenuViewController?.hideMenuViewController()
        default:
            break
        }
    }
}
