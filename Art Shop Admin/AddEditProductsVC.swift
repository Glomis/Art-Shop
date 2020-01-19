//
//  AddEditProductsVC.swift
//  Art Shop Admin
//
//  Created by Tatyana on 16.01.2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var productNameTF: UITextField!
    @IBOutlet weak var productPriceTF: UITextField!
    @IBOutlet weak var productImageView: roundedImageView!
    @IBOutlet weak var productDescriptionView: UITextView!
    @IBOutlet weak var activitiIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: roundedButton!
    
    
    //variables
    var selectedCetegory: Category!
    var productToEdit: Product?
    
    var name = ""
    var price = 0.0
    var descriptionTxt = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = productToEdit {
            productNameTF.text = product.name
            productDescriptionView.text = product.productDiscription
            productPriceTF.text = String(product.price)
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: product.imgUrl) {
                productImageView.contentMode = .scaleAspectFill
                productImageView.kf.setImage(with: url)
            }
        }
    }
    
    
    
    
    func uploadImageThenDocument() {
        guard let image = productImageView.image,
            let name = productNameTF.text, !name.isEmpty,
            let priceString = productPriceTF.text, !priceString.isEmpty,
            let price = Double(priceString),
            let productDescription = productDescriptionView.text,
            !productDescription.isEmpty else {
                simpleAlert(error: "Missing Fields", massage: "Please fill out all required fields.")
                return
        }
        
        self.name = name
        self.price = price
        self.descriptionTxt = productDescription
        
        
        activitiIndicator.startAnimating()
        
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to download image.")
                    return
                }
                
                guard let url = url else { return }
                self.uploadDocument(url: url.absoluteString)
            }
            self.activitiIndicator.stopAnimating()
        }
    }
    
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var product = Product.init(name: name,
                                   id: "",
                                   category: selectedCetegory.id,
                                   price: price,
                                   productDescription: descriptionTxt,
                                   imgUrl: url)
        
        if let productToEdit = productToEdit {
            // We are editing a product
            docRef = Firestore.firestore().collection("Products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            // We are adding a new product
            docRef = Firestore.firestore().collection("Products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to uplouad Firestore document.")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        simpleAlert(error: "Error", massage: msg)
        activitiIndicator.stopAnimating()
    }
    
    
    
    
    @IBAction func productImgTapped(_ sender: UITapGestureRecognizer) {
        lounchImgPicker()
    }
    
    
    @IBAction func addProductPresed(_ sender: UIButton) {
        uploadImageThenDocument()
    }
    
}

//MARK: Работа с изображением
extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func lounchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = image
        productImageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
