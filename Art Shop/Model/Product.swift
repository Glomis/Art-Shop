//
//  Products.swift
//  Art Shop
//
//  Created by Tatyana on 22.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDiscription: String
    var imgUrl: String
    var timeStamp: Timestamp
    var stock: Int
    
    
    init(
        name: String,
        id: String,
        category: String,
        price:Double,
        productDescription: String,
        imgUrl: String,
        timeStamp: Timestamp = Timestamp(),
        stock: Int = 0
    ) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDiscription = productDescription
        self.imgUrl = imgUrl
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 99.99
        self.productDiscription = data["productDiscription"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    
    static func modelToData(product: Product) -> [String: Any] {
        
        let data: [String: Any] = [
            "name" : product.name,
            "id": product.id,
            "category": product.category,
            "price": product.price,
            "productDescription": product.productDiscription,
            "imgUrl": product.imgUrl,
            "timeStamp": product.timeStamp,
            "stock": product.stock
        ]
        
        return data
    }
}
