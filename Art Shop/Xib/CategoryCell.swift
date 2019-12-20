//
//  CategoryCell.swift
//  Art Shop
//
//  Created by Tatyana on 20.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImg.layer.cornerRadius = 7
    }

    func configureCell(category: Category) {
        categoryLbl.text = category.name
        if let url = URL(string: category.imgUrl) {
            categoryImg.kf.setImage(with: url)
        }
    }
    
}
