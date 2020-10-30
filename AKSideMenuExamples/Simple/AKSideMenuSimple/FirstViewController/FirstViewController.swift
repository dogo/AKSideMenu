//
//  FirstViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/6/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import AKSideMenu
import UIKit

final class FirstViewController: UIViewController {

    // MARK: - Life Cycle

    override func loadView() {
        view = FirstView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "First Controller"
        addNavigationButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("FirstViewController will appear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("FirstViewController will disappear")
    }

    // MARK: - Private Methods

    private func addNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(presentLeftMenuViewController(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(presentRightMenuViewController(_:)))
    }
}
