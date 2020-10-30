//
//  SecondView.swift
//  AKSideMenuSimple
//
//  Created by Diogo Autilio on 29/10/20.
//  Copyright © 2020 AnyKey Entertainment. All rights reserved.
//

import Foundation
import UIKit

final class SecondView: UIView {

    // MARK: - Properties

    var didTouchButton: (() -> Void)?

    lazy var button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Push View Controller", for: .normal)
        button.addTarget(self, action: #selector(didButtonTouched), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc
    private func didButtonTouched() {
        didTouchButton?()
    }
}

extension SecondView {

    // MARK: - ViewCode

    func setupViewHierarchy() {
        addSubview(button)
    }

    func setupConstraints() {
        if #available(iOS 11.0, *) {
            button.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        } else {
            button.topAnchor.constraint(equalTo: topAnchor, constant: 44).isActive = true
        }
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
    }

    func configureViews() {
        backgroundColor = UIColor(red: 255 / 255.0, green: 202 / 255.0, blue: 101 / 255.0, alpha: 1.0)
    }
}
