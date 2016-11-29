//
//  SliderView.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/29/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import SnapKit
import HomeKit

class SliderView: BaseCharacteristicView {
    let sliderView = UISlider()
    var characteristic: HMCharacteristic!

    convenience init(title: String, with characteristic: HMCharacteristic) {
        self.init(title: title)
        self.characteristic = characteristic
        sliderView.value = Float(characteristic.value as! Int / 100)
//        sliderView.isContinuous = true
        sliderView.addTarget(self, action: #selector(sliderDoneChanging(_:)), for: .touchUpInside)
    }

    override func layout() {
        super.layout()
        addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.0)
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.width.equalTo(150.0)
        }
    }

    @objc fileprivate func sliderDoneChanging(_ slider: UISlider) {
        characteristic.writeValue(Int(slider.value * 100)) { error in
            guard error == nil else { return print("Cannot update value. Error: \(error?.localizedDescription)") }
        }
    }
}
