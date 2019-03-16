//
//  OrderHistoryCell.swift
//  Namitha_try
//
//  Created by MacBook-Pro-4 on 05/03/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit

class OrderHistoryCell: UICollectionViewCell {
    
    //Outlets:
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var titleItems: UILabel!
    @IBOutlet weak var titleOrderedOn: UILabel!
    @IBOutlet weak var lblOrderedDate: UILabel!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var titleAmount: UILabel!
}
