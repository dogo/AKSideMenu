//
//  RightMenuViewController.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit

public class RightMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        let tableView: UITableView = UITableView.init(frame: CGRect(x: 0, y: (self.view.frame.size.height - 54 * 2) / 2.0, width: self.view.frame.size.width, height: 54 * 2), style: UITableViewStyle.plain)
        tableView.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = nil
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = false
        tableView.scrollsToTop = false

        self.tableView = tableView
        self.view.addSubview(self.tableView!)
    }

    // MARK: - <UITableViewDelegate>

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "firstViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()

        case 1:
            self.sideMenuViewController!.setContentViewController(UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "secondViewController")), animated: true)
            self.sideMenuViewController!.hideMenuViewController()

        default:
            break
        }
    }

    // MARK: - <UITableViewDataSource>

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel?.font = UIFont.init(name: "HelveticaNeue", size: 21)
            cell!.textLabel?.textColor = UIColor.white
            cell!.textLabel?.highlightedTextColor = UIColor.lightGray
            cell!.selectedBackgroundView = UIView.init()
        }

        var titles: [String] = ["Test 1", "Test 2"]
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.textLabel?.textAlignment = NSTextAlignment.right

        return cell!
    }
}
