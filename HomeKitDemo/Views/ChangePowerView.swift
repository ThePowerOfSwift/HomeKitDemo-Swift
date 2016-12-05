//
//  ChangePowerView.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/29/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import SnapKit
import HomeKit

class ChangePowerView: BaseCharacteristicView {
    var switchControl = UISwitch()
    var characteristic: HMCharacteristic!

    convenience init(title: String, with characteristic: HMCharacteristic) {
        self.init(title: title)
        self.characteristic = characteristic
        switchControl.isOn = characteristic.value as! Bool
        switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }

    override func layout() {
        super.layout()
        addSubview(switchControl)
        switchControl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.0)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
    }

    @objc fileprivate func switchValueChanged(_ switcher: UISwitch) {
        characteristic.writeValue(switcher.isOn) { error in
            guard error == nil else { return print("Cannot update value. Error: \(error?.localizedDescription)") }
        }
    }

}
