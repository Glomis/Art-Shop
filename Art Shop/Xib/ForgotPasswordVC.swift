//
//  ForgotPasswordVC.swift
//  Art Shop
//
//  Created by Tatyana on 18.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func resetPassClicked(_ sender: Any) {
        
        guard let email = emailTF.text , !email.isEmpty else {
            simpleAlert(error: "Error", massage: "Pleasr enter your email.")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error)
                self.handleFireAuthError(error: error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
