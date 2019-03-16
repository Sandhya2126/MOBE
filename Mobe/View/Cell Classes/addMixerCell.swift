//
//  addMixerCell.swift
//  Mobe
//
//  Created by user on 01/03/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit

class addMixerCell: UICollectionViewCell {
    
    var mixerList = [Int]()
    
    @IBOutlet weak var btnCancelQunatity: UIButton!
    @IBOutlet weak var lblNoOfQunatity: UILabel!
    @IBOutlet weak var lblMixerPrice: UILabel!
    @IBOutlet weak var lblMixerName: UILabel!
    
    
    
    
    func setUpData(mixerList: [String:Any]){
        
        let priceList = mixerList["PRICE"] as! Int
        lblMixerPrice.text = String(priceList)
        lblMixerName.text = mixerList["NAME"] as? String
        
    }
    
    func updateMixerList(){
        
    }
}
