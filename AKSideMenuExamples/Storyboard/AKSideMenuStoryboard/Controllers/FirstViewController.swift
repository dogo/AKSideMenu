//
//  FirstViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/6/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

public class FirstViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("FirstViewController will appear")
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("FirstViewController will disappear")
    }
}
