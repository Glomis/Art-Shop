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
    var favorite: Bool
}
