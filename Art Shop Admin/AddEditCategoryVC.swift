//
//  AddEditCategoryVC.swift
//  Art Shop Admin
//
//  Created by Tatyana on 09.01.2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {
    
    @IBOutlet weak var categoryNameTF: UITextField!
    @IBOutlet weak var categoryImg: roundedImageView!
    @IBOutlet weak var addBtn: UIButton!
    
    var categoryToEdit: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if categoryToEdit == nil {
            print("Oh My Shit")
        }
        categoryNameTF.delegate = self
        
        if let category = categoryToEdit {
            addBtn.setTitle("Save Changes", for: .normal)
            categoryNameTF.text = category.name
        
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    
    
    func uploadImage() {
        guard let image = categoryImg.image,
            let categoryName = categoryNameTF.text, !categoryName.isEmpty else {
                simpleAlert(error: "Error", massage: "Must add Category image and name.")
                return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
             
            if let error = error {
                debugPrint("Что-то не так")
                self.handleFireAuthError(error: error)
                return
            }
    
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    debugPrint("Или тут что-то не так")
                    self.handleFireAuthError(error: error)
                    return
                }
                guard let url = url else { return }
                self.uploadDocument(url: url.absoluteString)
            }
        }
    }
    
    func uploadDocument(url:String) {
        var docRef: DocumentReference!
        var category = Category.init(name: categoryNameTF.text!,
                                     id: "",
                                     imgUrl: url,
                                     timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            // Редактируем существующую Категорию
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
            // Создаем новую Катеорию
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
        
        let data = Category.categoryToModel(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                debugPrint("Крайне не то")
                self.handleFireAuthError(error: error)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    @IBAction func imageTaped(_ sender: UITapGestureRecognizer) {
        lounchImgPicker()
    }
    
    
    @IBAction func addCategoryCLicked(_ sender: Any) {
        uploadImage()
    }
}

// MARK: Работа с изображением
extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func lounchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }

    
}
// MARK: Работа с клавиатурой
extension AddEditCategoryVC: UITextFieldDelegate {
    
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        categoryNameTF.resignFirstResponder()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)
        return true
    }
}
