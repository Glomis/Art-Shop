//
//  ViewController.swift
//  Art Shop
//
//  Created by Max on 12.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    self.handleFireAuthError(error: error)
                    debugPrint(error)
                }
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginBtn.title = "Logout"
        } else { 
            loginBtn.title = "Login"
        }
    }
    
    
    fileprivate func presentHomeVC() {
        let storyBoard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            presentHomeVC()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        self.handleFireAuthError(error: error)
                        debugPrint(error)
                    }
                    self.presentHomeVC()
                }
            } catch {
                self.handleFireAuthError(error: error)
                debugPrint(error)
            }
        }
    }
    
    
    
}

