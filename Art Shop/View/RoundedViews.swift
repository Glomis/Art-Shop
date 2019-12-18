//
//  RoundedViews.swift
//  Art Shop
//
//  Created by Tatyana on 16.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class roundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7
    }
}

class roundedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7
        layer.shadowColor = #colorLiteral(red: 0.1764705882, green: 0.3019607843, blue: 0.4862745098, alpha: 1)
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class roundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7
    }
}
