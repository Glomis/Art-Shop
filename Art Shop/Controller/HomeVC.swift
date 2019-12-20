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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let category = Category.init(name: "Fuck YEAH!", id: "fwefwe", imgUrl: "https://images.unsplash.com/photo-1576790359694-14504775f70d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60", isActive: true, timeStamp: Timestamp())
        categories.append(category)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
        
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 50) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
