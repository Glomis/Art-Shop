//
//  AddEditCategoryVC.swift
//  Art Shop Admin
//
//  Created by Tatyana on 09.01.2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var categoryNameTF: UITextField!
    @IBOutlet weak var categoryImg: roundedImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func imageTaped(_ sender: Any) {
        lounchImgPicker()
    }
    
    @IBAction func addCategoryCLicked(_ sender: Any) {
        
    }

}

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
