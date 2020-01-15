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
    
    // Outlets
    @IBOutlet weak var loginBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Variables
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        setCategoriesListener()
        
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginBtn.title = "Logout"
        } else {
            loginBtn.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    
    // Отображение главного экрана
    fileprivate func presentHomeVC() {
        let storyBoard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "loginVC")
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    
    //MARK: Работа с категориями Firestore
    func setCategoriesListener() {
        listener = Firestore.firestore().collection("categories").addSnapshotListener({ (snap, error) in
           
            if let error = error {
                debugPrint(error)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.doocumentAdded(change: change, category: category)
                case .modified:
                    self.documentModified(change: change, category: category)
                case .removed:
                    self.documentRemoved(change: change)
                }
            })
        })
    }
    
    func doocumentAdded(change: DocumentChange, category: Category) {
        
        let newIndex = Int(change.newIndex)
        
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func documentModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            
            let index = Int(change.newIndex)
            
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0),
                                    to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func documentRemoved(change: DocumentChange) {
        
        let oldIndex = Int(change.oldIndex)
        
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
 
    //MARK: Действия
    
    // Кнопка Логин
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
    
    // Кнопка Магазин
    @IBAction func shopClicked(_ sender: Any) {
        
    }
    
    // Кнопка Избранное
    @IBAction func favoriteClicked(_ sender: Any) {
        
    }
    
}


//MARK: Работа c Collection Delegate
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
