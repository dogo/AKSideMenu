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
        self.title = "Second Controller"
        self.view.backgroundColor = UIColor.init(red: 255/255.0, green: 202/255.0, blue: 101/255.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Left", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.presentLeftMenuViewController(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Right", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.presentRightMenuViewController(_:)))
        
        let button: UIButton = UIButton.init(type: UIButtonType.RoundedRect)
        button.frame = CGRectMake(0, 84, self.view.frame.size.width, 44)
        button.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        button.setTitle("Push View Controller", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(SecondViewController.pushViewController(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
            
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