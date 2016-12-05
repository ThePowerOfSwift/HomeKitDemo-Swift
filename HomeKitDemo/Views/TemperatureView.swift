//
//  TemperatureView.swift
//  HomeKitDemo
//
//  Created by Vlad on 12/3/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import HomeKit
import SnapKit

class TemperatureView: BaseCharacteristicView {
    var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    var characteristic: HMCharacteristic!

    convenience init(title: String, characteristic: HMCharacteristic) {
        self.init(title: title)
        self.characteristic = characteristic
        characteristic.service?.accessory?.delegate = self
        valueLabel.text = value
        valueLabel.sizeToFit()
        enableNotification()
    }

    fileprivate var value: String {
        guard let value = characteristic.value as? Float64 else { return "" }
        return "\(value)˚C"
    }

    fileprivate func enableNotification() {
        characteristic.enableNotification(true) { error in
            guard error == nil else {
                return print("Something went wrong when enabling notification for a chracteristic. \(error?.localizedDescription)")
            }
        }
    }

    override  func layout() {
        super.layout()
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.0)
            make.bottom.equalTo(nameLabel.snp.bottom)
        }
    }
}

extension TemperatureView: HMAccessoryDelegate {
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        self.valueLabel.text = value
    }
}
