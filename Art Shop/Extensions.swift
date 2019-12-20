//
//  Extensions.swift
//  Art Shop
//
//  Created by Tatyana on 18.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    
    func handleFireAuthError(error: Error) {
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func simpleAlert(error: String, massage: String) {
        let alert = UIAlertController(title: error, message: massage, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

struct Identifires {
    static let categoryCell = "CategoryCell"
}
