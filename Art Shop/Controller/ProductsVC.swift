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
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCollection()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }
    
    
    func fetchCollection() {
        let collectionRef = Firestore.firestore().collection("Products")
        
        listener = collectionRef.whereField("category", isEqualTo: category.id).addSnapshotListener { (snap, error) in
            guard let documents = snap?.documents else { return }
            
            self.products.removeAll()
            for document in documents {
                let data = document.data()
                let newProduct = Product.init(data: data)
                self.products.append(newProduct)
            }
            self.tableView.reloadData()
        }
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
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let vc = ProductDetailVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        present(vc, animated: true, completion: nil)
    }
        
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
