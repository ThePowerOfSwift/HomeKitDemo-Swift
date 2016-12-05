//
//  AccessoryViewController.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/27/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import HomeKit
import SnapKit

class AccessoryViewController: UIViewController {
    var accessory: HMAccessory!

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ghostWhite
//        setupViews()
        accessory.services.forEach { stackView.addArrangedSubview(ServiceView(service: $0)) }
         layout()
    }
}

// MARK: Setup
extension AccessoryViewController {
    fileprivate func setupViews() {
        for service in accessory.services {
            let serviceView = ServiceView(service: service)
            stackView.addArrangedSubview(serviceView)
        }
    }
}

//MARK: Layout
extension AccessoryViewController: Layoutable {
    func layout() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.0)
            make.top.equalTo(topGuide.snp.bottom).offset(10.0)
            make.right.equalToSuperview().offset(-10.0)
        }
    }
}

