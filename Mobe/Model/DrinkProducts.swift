//
//  DrinkProducts.swift
//  Mobe
//
//  Created by user on 23/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import Foundation

struct DrinkProducts: Decodable{
    var _id: String
    var NAME: String
    var TYPE_ID: String
    var MIN_PRICE: Int
    var MAX_PRICE: Int
    var createdAt: String
    var updatedAt: String
    var __v: Int
}
