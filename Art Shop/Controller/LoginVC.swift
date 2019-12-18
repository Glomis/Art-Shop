//
//  LoginVC.swift
//  Art Shop
//
//  Created by Tatyana on 14.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func forgotPassClicked(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func loginClicked(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty else {
                simpleAlert(error: "Error", massage: "Please fill out all fields.")
                return
        }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                self.handleFireAuthError(error: error)
                debugPrint(error)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            print("Login SUCCSESSFUL!")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func guestClicked(_ sender: Any) {
    }
    
    
}
