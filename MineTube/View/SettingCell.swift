//
//  SettingCell.swift
//  MineTube
//
//  Created by Chris Stev on 10/05/20.
//  Copyright © 2020 chrizstvan. All rights reserved.
//

import UIKit

//Setting Data

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            
            nameLabel.textColor = isHighlighted ? .white : .black
            iconImageView.tintColor = isHighlighted ? .white : .darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name.rawValue
            iconImageView.image = UIImage(named: setting?.imageName ?? "placeholder")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Setting"
        return label
    }()
    
    let iconImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "settings")
        image.contentMode = .scaleAspectFill
        image.tintColor = .darkGray
        return image
    }()
    
    override func setupView() {
        super.setupView()
        addSubview(nameLabel)
        addSubview(iconImageView)
        addConstrainWithFormat(format: "H:|-16-[v0(22)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstrainWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstrainWithFormat(format: "V:[v0(22)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
