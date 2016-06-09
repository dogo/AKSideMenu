//
//  SecondViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

public class SecondViewController : UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func pushViewController(sender :AnyObject) {
        let viewController = UIViewController.init()
        viewController.title = "Pushed Controller"
        viewController.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("SecondViewController will appear")
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("SecondViewController will disappear")
    }
}