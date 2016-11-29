//
//  AccessoryTableViewCell.swift
//  HomeKitDemo
//
//  Created by Vlad on 11/27/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit
import SnapKit

fileprivate struct Layout {
    static let xOffset: CGFloat   = 20.0
    static let topOffset: CGFloat = 5.0
}

class AccessoryTableViewCell: UITableViewCell {
    static var reuseIdentifier: String = "AccessoryCell"
    static var defaultHeight: CGFloat = 50.0

    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.0, weight: UIFontWeightMedium)
        return label
    }()
    var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0, weight: UIFontWeightRegular)
        label.textColor = .lightGray
        return label
    }()
    var stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: UIFontWeightMedium)
        label.textColor = .gray
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    func set(name: String, info: String, state: String) {
        nameLabel.text = name
        infoLabel.text = info
        stateLabel.text = state
        labels.forEach { $0.sizeToFit() }
    }

    fileprivate var labels: [UILabel] {
        return [nameLabel, infoLabel, stateLabel]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension AccessoryTableViewCell: Layoutable {
    func layout() {
        labels.forEach { addSubview($0) }
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Layout.xOffset)
            make.top.equalToSuperview().offset(Layout.topOffset)
        }
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(Layout.topOffset)
        }
        stateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Layout.xOffset)
            make.centerY.equalToSuperview()
        }
    }
}
