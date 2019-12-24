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
    var selectedCategory: Category!
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func fetchDocument() {
        let docRef = Firestore.firestore().collection("categories").document("8EayF4mb9WUGiNY32mmV")
        docRef.getDocument { (snap, error) in
            guard let data = snap?.data() else { return }
            
            let newCategory = Category.init(data: data)
            self.categories.append(newCategory)
            self.collectionView.reloadData()
        }
    }
    
    func fetchCollection() {
        let collectionRef = Firestore.firestore().collection("categories")
        
        listener = collectionRef.addSnapshotListener { (snap, error) in
            guard let documents = snap?.documents else { return }
            
            self.categories.removeAll()
            for document in documents {
                let data = document.data()
                let newCategory = Category.init(data: data)
                self.categories.append(newCategory)
            }
            self.collectionView.reloadData()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // fetchDocument()
        fetchCollection()
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginBtn.title = "Logout"
        } else { 
            loginBtn.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
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
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: "toProductsVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProductsVC" {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        }
    }
}
