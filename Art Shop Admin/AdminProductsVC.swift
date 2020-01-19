//
//  AdminProductsVC.swift
//  Art Shop Admin
//
//  Created by Tatyana on 12.01.2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    // Variables
    var selectedProduct: Product?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Ways.segueToAddEditProduct {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.productToEdit = selectedProduct
                destination.selectedCetegory = category
            }
        } else if segue.identifier == Ways.segueToAddEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Ways.segueToAddEditProduct , sender: self)
      }
    
    
    @IBAction func addProductPresed(_ sender: Any) {
        performSegue(withIdentifier: Ways.segueToAddEditProduct, sender: self)
    }
    
    
    @IBAction func editCategoryPresed(_ sender: Any) {
        performSegue(withIdentifier: Ways.segueToAddEditCategory , sender: self)
    }
}
