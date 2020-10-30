//
//  SecondViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

final class SecondViewController: UIViewController {

    // MARK: - Properties

    let secondView = SecondView()

    // MARK: - Life Cycle

    override func loadView() {
        view = secondView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Second Controller"
        addNavigationButtons()

        secondView.didTouchButton = { [weak self] in
            self?.pushViewController()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("SecondViewController will appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("SecondViewController will disappear")
    }

    // MARK: - Private Methods

    private func addNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(presentLeftMenuViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(presentRightMenuViewController))
    }

    private func pushViewController() {
        let viewController = UIViewController()
        viewController.title = "Pushed Controller"
        viewController.view.backgroundColor = .white
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
