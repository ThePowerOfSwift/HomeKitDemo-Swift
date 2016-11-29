//
//  ServiceView.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/28/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import HomeKit
import SnapKit

fileprivate struct Layout {
    static let offset: CGFloat = 5.0
}

class ServiceView: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0.5
        return stackView
    }()

    convenience init(service: HMService) {
        self.init(frame: .zero)
        backgroundColor = .ghostWhite
        setupShadow()
        set(service)
        layout()
    }
    
    fileprivate func set(_ service: HMService) {
        setupServiceNameLabel(with: service.localizedDescription)
        for characteristic in service.characteristics {
            guard let metadata = characteristic.metadata else { return }
            guard let title = metadata.manufacturerDescription else { return }
            var view: BaseCharacteristicView?
            if metadata.format == HMCharacteristicMetadataFormatBool {
                if let _ = characteristic.value as? Bool {
                    view = ChangePowerView(title: title, with: characteristic)
                }
            } else if metadata.format == HMCharacteristicMetadataFormatString {
                if let value = characteristic.value as? String {
                    view = DescriptionView(title: title, value: value)
                }
            } else if metadata.format == HMCharacteristicMetadataFormatInt {
                if let _ = characteristic.value as? Int {
                    view = SliderView(title: title, with: characteristic)
                }
            }
            if let v = view {
                stackView.addArrangedSubview(v)
                v.snp.makeConstraints { make in
                    make.height.equalTo(40.0)
                }
            }
//            characteristic.enableNotification(true) { error in
//                guard error == nil else {
//                    print("Something went wrong when enabling notification for a chracteristic. \(error?.localizedDescription)")
//                    return
//                }
//            }
        }
    }
}

// MARK: Setup
extension ServiceView {
    fileprivate func setupServiceNameLabel(with name: String) {
        let serviceNameLabel = UILabel()
        serviceNameLabel.text = name
        serviceNameLabel.textAlignment = .center
        serviceNameLabel.font = .systemFont(ofSize: 21.0, weight: UIFontWeightMedium)
        serviceNameLabel.backgroundColor = .smokeWhite
        stackView.addArrangedSubview(serviceNameLabel)
        serviceNameLabel.snp.makeConstraints { make in
            make.height.equalTo(40.0)
        }
    }

    fileprivate func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.5
    }
}

//MARK: Layout
extension ServiceView: Layoutable {
    func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

