//
//  RegisterVC.swift
//  Art Shop
//
//  Created by Tatyana on 14.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTF.addTarget(self, action: #selector(textFieldDidChanched(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(textFieldDidChanched(_:)), for: UIControl.Event.editingChanged)
    }
    
    
    // MARK: Работа с TextField
    @objc func textFieldDidChanched(_ textField: UITextField) {
        guard let passwordTxt = passwordTF.text else { return }
        
        // Проверка совпадения пародей
        if textField == confirmPasswordTF {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        } else {
            if passwordTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                confirmPasswordTF.text = ""
            }
        }
        // При совпадении паролей иконки становятся Зелеными
        if passwordTF.text == confirmPasswordTF.text {
            passCheckImg.image = UIImage(named: "green_check")
            confirmPassCheckImg.image = UIImage(named: "green_check")
        } else {
            passCheckImg.image = UIImage(named: "red_check")
            confirmPassCheckImg.image = UIImage(named: "red_check")
        }
    }
    
    
    @IBAction func registerBtnClicked(_ sender: UIButton) {
        
        guard let name = nameTF.text , !name.isEmpty,
            let email = emailTF.text , !email.isEmpty ,
            let password = passwordTF.text, !password.isEmpty else {
                simpleAlert(error: "Error", massage: "Please fill out all fields.")
                return
        }
        
        guard let confirmPass = confirmPasswordTF.text, confirmPass == password else {
            simpleAlert(error: "Error", massage: "Passwords do not match.")
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                self.handleFireAuthError(error: error)
                debugPrint(error)
                return
            }
            self.activityIndicator.stopAnimating()
            print("USER CREATED!!!")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
