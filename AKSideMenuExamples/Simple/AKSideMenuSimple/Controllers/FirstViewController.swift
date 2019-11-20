//
//  FirstViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/6/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

open class FirstViewController: UIViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = "First Controller"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(presentLeftMenuViewController(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Right",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(presentRightMenuViewController(_:)))

        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.image = UIImage(named: "Balloon")
        self.view.addSubview(imageView)
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("FirstViewController will appear")
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("FirstViewController will disappear")
    }
}
