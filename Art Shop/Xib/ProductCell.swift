//
//  ProductCell.swift
//  Art Shop
//
//  Created by Tatyana on 22.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImg: roundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteImg: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

   
    func configureCell(product: Product) {
        productTitle.text = product.name
        
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
        }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
        
    }
    
}
