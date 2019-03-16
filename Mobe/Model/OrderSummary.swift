//
//  OrderSummary.swift
//  Mobe
//
//  Created by MacBook-Pro-4 on 04/03/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import Foundation

struct OrderSummary{
    
    var itemName: String
    var price: Int
    var itemCount: Int
    
    
    init(itemName: String,price:Int,itemCount:Int) {
        self.itemName = itemName
        self.price = price
        self.itemCount = itemCount
        
    }
}
