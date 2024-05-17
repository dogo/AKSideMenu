//
//  LeftMenuView.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 30/10/20.
//  Copyright © 2020 AnyKey Entertainment. All rights reserved.
//

import Foundation
import UIKit

final class LeftMenuView: UITableView {
    // MARK: - Properties

    var didTouchIndex: ((_ index: Int) -> Void)?

    // MARK: - Life Cycle

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        isOpaque = false
        backgroundColor = .clear
        backgroundView = nil
        separatorStyle = .none
        bounces = false
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentInset()
    }

    // MARK: - Private Methods

    private func updateContentInset() {
        let tableViewHeight = bounds.height
        let contentHeight = contentSize.height

        let centeringInset = (tableViewHeight - contentHeight) / 2.0
        let topInset = max(centeringInset, 0.0)

        contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
}

extension LeftMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didTouchIndex?(indexPath.row)
    }
}

extension LeftMenuView: UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        54
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = .clear
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
            cell?.textLabel?.textColor = .white
            cell?.textLabel?.highlightedTextColor = .lightGray
            cell?.selectedBackgroundView = UIView()
        }

        let titles = ["Home", "Calendar", "Profile", "Settings", "Log Out"]
        let images = ["IconHome", "IconCalendar", "IconProfile", "IconSettings", "IconEmpty"]
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.imageView?.image = UIImage(named: images[indexPath.row])

        return cell ?? UITableViewCell()
    }
}
