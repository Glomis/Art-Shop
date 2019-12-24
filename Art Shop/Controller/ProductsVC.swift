//
//  ProductsVC.swift
//  Art Shop
//
//  Created by Tatyana on 22.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    var category: Category!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product.init(name: "Wow", id: "dqwf", category: "Nature", price: 22.22, productDiscription: "", imgUrl: "https://images.unsplash.com/photo-1573743338941-39db12ef9b64?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1051&q=80", timeStamp: Timestamp(), stock: 0, favorite: false)
        
        let productOne = Product(name: "Amaizing", id: "egww", category: "Nature", price: 24.33, productDiscription: "Bla Bla One", imgUrl: "https://images.unsplash.com/photo-1572295727871-7638149ea3d7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80", timeStamp: Timestamp(), stock: 0, favorite: false)
        
        products.append(product)
        products.append(productOne)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }
    

}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
