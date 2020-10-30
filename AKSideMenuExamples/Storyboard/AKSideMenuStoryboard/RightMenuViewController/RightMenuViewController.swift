//
//  RightMenuViewController.swift
//  AKSideMenuStoryboard
//
//  Created by Diogo Autilio on 6/7/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import AKSideMenu
import Foundation
import UIKit

final class RightMenuViewController: UIViewController {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
    }

    // MARK: - Private Methods

    private func addTableView() {
        let tableView = UITableView(frame: CGRect(x: 0,
                                                  y: (view.frame.size.height - 54 * 2) / 2.0,
                                                  width: view.frame.size.width,
                                                  height: 54 * 2), style: .plain)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = false
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.scrollsToTop = false

        view.addSubview(tableView)
    }
}

extension RightMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            if let firstVC = storyboard?.instantiateViewController(withIdentifier: "firstViewController") {
                let contentViewController = UINavigationController(rootViewController: firstVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        case 1:
            if let secondVC = storyboard?.instantiateViewController(withIdentifier: "secondViewController") {
                let contentViewController = UINavigationController(rootViewController: secondVC)
                sideMenuViewController?.setContentViewController(contentViewController, animated: true)
                sideMenuViewController?.hideMenuViewController()
            }
        default:
            break
        }
    }
}

extension RightMenuViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "Cell"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = .clear
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
            cell?.textLabel?.textColor = .white
            cell?.textLabel?.highlightedTextColor = .lightGray
            cell?.selectedBackgroundView = UIView()
        }

        let titles = ["Test 1", "Test 2"]
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.textLabel?.textAlignment = .right

        return cell ?? UITableViewCell()
    }
}
