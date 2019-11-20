//
//  SecondViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

public class SecondViewController: UIViewController {

    @IBAction func pushViewController(_ sender: Any) {
        let viewController = UIViewController()
        viewController.title = "Pushed Controller"
        viewController.view.backgroundColor = .white
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SecondViewController will appear")
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SecondViewController will disappear")
    }
}
