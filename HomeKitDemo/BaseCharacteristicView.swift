//
//  BaseCharacteristicView.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/29/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import SnapKit

class BaseCharacteristicView: UIView {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: UIFontWeightMedium)
        return label
    }()

    convenience init(title: String) {
        self.init(frame: .zero)
        backgroundColor = .white
        layout()
        nameLabel.text = title
        nameLabel.sizeToFit()
    }
}

extension BaseCharacteristicView: Layoutable {
    func layout() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10.0)
            make.centerYWithinMargins.equalToSuperview()
        }
    }
}

