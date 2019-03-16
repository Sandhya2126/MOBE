//
//  OrderSummaryCell.swift
//  FoodTracker
//
//  Created by MacBook-Pro-4 on 04/03/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit



class OrderSummaryCell: UICollectionViewCell {
    @IBOutlet weak var lblItemName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var lblCount: UILabel!
    
    
    
    func setUp(order: OrderSummary){
        
        lblItemName.text = order.itemName
        lblPrice.text = "\(order.price)"
        lblCount.text = "x "+"\(order.itemCount)"
        let total = order.price * order.itemCount
        lblTotal.text = "\(total)"
        
    }
    
}


