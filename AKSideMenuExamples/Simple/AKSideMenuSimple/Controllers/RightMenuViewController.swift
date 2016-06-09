//
//  LeftMenuViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

public class LeftMenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    
    init() {
        super.init(nibName:nil, bundle:nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    
        let tableView: UITableView = UITableView.init(frame: CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0, self.view.frame.size.width, 54 * 5), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin , UIViewAutoresizing.FlexibleBottomMargin , UIViewAutoresizing.FlexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.bounces = false
        
        self.tableView = tableView
        self.view.addSubview(self.tableView!)
    }
    
    // MARK: - <UITableViewDelegate>
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.row) {
            case 0:
                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: FirstViewController.init()), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                break
            case 1:
                self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: SecondViewController.init()), animated: true)
                self.sideMenuViewController!.hideMenuViewController()
                break
        default:
            break
        }
    }
    
    // MARK: - <UITableViewDataSource>
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return 5
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"
    
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
    
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.font = UIFont.init(name: "HelveticaNeue", size: 21)
            cell!.textLabel?.textColor = UIColor.whiteColor()
            cell!.textLabel?.highlightedTextColor = UIColor.lightGrayColor()
            cell!.selectedBackgroundView = UIView.init()
        }
    
        var titles:[String] = ["Home", "Calendar", "Profile", "Settings", "Log Out"]
        var images:[String] = ["IconHome", "IconCalendar", "IconProfile", "IconSettings", "IconEmpty"]
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.imageView?.image = UIImage.init(named: images[indexPath.row])
    
        return cell!
    }
}
