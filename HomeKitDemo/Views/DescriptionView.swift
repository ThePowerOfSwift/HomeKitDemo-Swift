//
//  DescriptionView.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/29/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import SnapKit

class DescriptionView: BaseCharacteristicView {
    var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: UIFontWeightRegular)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()

    convenience init(title: String, value: String) {
        self.init(title: title)
        valueLabel.text = value
        valueLabel.sizeToFit()
    }

    override func layout() {
        super.layout()
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10.0)
            make.bottom.equalTo(nameLabel.snp.bottom)
        }
    }
}
