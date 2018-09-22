//
//  SecondViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

public class SecondViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pushViewController(_ sender: Any) {
        let viewController = UIViewController()
        viewController.title = "Pushed Controller"
        viewController.view.backgroundColor = .white
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SecondViewController will appear")
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SecondViewController will disappear")
    }
}
