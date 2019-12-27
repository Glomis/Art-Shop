//
//  ProductDetailVC.swift
//  Art Shop
//
//  Created by Tatyana on 27.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Kingfisher

class ProductDetailVC: UIViewController {

    // Outlets
    @IBOutlet weak var productImg: roundedImageView!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    
    //Variables
    var product: Product!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showCurrentProduct()
    }

    
    
    func showCurrentProduct() {
        productName.text = product.name
        productPrice.text = String(product.price)
        productDescription.text = product.productDiscription
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
        }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
      
        // Добавить функцию добавления
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func keepShoppingClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapAnywhere(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
