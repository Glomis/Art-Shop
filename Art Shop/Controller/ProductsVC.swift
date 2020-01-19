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
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category!
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        
        fetchCollection()
    }
    
    
    func fetchCollection() {
        listener = Firestore.firestore().collection("Products").whereField("category", isEqualTo: category.id).order(by: "timeStamp", descending: true).addSnapshotListener { (snap, error) in
            
            if let error = error {
                debugPrint(error, "ВСЁ ПРОПАААААЛО!!!")
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                    
                case .added:
                    self.docimentAdded(change: change, product: product)
                case .modified:
                    self.documentModifiried(change: change, product: product)
                case .removed:
                    self.documentRemoved(change: change)
                }
            })
        }
    }
    
    func docimentAdded(change: DocumentChange, product: Product) {
        
        let newIndex = Int(change.newIndex)
        
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .automatic)
    }
    
    func documentModifiried(change: DocumentChange, product: Product) {
        
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        } else {
            let newIndex = Int(change.newIndex)
            let oldIndex = Int(change.oldIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func documentRemoved(change: DocumentChange) {
        
        let oldIndex = Int(change.oldIndex)
        
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .automatic)
    }
}




//MARK: Table View Delegate

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
