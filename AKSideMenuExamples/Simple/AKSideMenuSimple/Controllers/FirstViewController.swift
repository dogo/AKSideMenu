//
//  FirstViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/6/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

open class FirstViewController : UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = "First Controller"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Left", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.presentLeftMenuViewController(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Right", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.presentRightMenuViewController(_:)))
        
        let imageView: UIImageView = UIImageView.init(frame: self.view.bounds)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
        imageView.image = UIImage.init(named: "Balloon")
        self.view.addSubview(imageView)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("FirstViewController will appear")
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NSLog("FirstViewController will disappear")
    }
}
