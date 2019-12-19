//
//  Category.swift
//  Art Shop
//
//  Created by Tatyana on 19.12.2019.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive:Bool = true
    var timeStamp:Timestamp
}
