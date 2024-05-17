//
//  SecondViewController.swift
//  AKSideMenuStoryboard
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import Foundation
import UIKit

final class SecondViewController: UIViewController {
    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("SecondViewController will appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("SecondViewController will disappear")
    }

    // MARK: - Actions

    @IBAction private func pushViewController(_: Any) {
        let viewController = UIViewController()
        viewController.title = "Pushed Controller"
        viewController.view.backgroundColor = .white
        navigationController?.pushViewController(viewController, animated: true)
    }
}
