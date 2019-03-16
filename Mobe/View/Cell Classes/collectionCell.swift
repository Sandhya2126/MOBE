//
//  collectionCell.swift
//  Mobe
//
//  Created by MacBook-Pro-4 on 11/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit

class collectionCell: UICollectionViewCell {
    @IBOutlet weak var upArrow: UILabel!
    
    @IBOutlet weak var viewRandomPrice: UIView!
    @IBOutlet weak var lblMaxPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var downArrow: UILabel!
    @IBOutlet weak var lblMinPrice: UILabel!
    
    @IBOutlet weak var arrowRandom: UILabel!
    @IBOutlet weak var lblLuckyPrice: UILabel!
    var maxPrice = 0
    var minPrice = 0
    var random = 0
    
    func setUp(){
        upArrow.rotateArrowUp()
        downArrow.rotateArrowDown()
    }
    
    func findRandomNumber(){
        let middileValue = (maxPrice+minPrice)/2
        random = Int.random(in: minPrice...maxPrice)
        if random > middileValue{
           // lblLuckyPrice.textColor = UIColor.green
            lblLuckyPrice.text = "\(random)"
            viewRandomPrice.backgroundColor = .green
            arrowRandom.textColor = UIColor.white
            arrowRandom.rotateArrowUp()
        }
        else{
           // lblLuckyPrice.textColor = UIColor.red
             viewRandomPrice.backgroundColor = .red
            lblLuckyPrice.text = "\(random)"
            arrowRandom.rotateArrowDown()
            arrowRandom.textColor = UIColor.white
        }
        
    }
    
    func setUpData(drinkProducts: [String:Any]){
        
        lblProductName.text = drinkProducts["NAME"] as? String
        maxPrice = drinkProducts["MAX_PRICE"] as! Int
        minPrice = drinkProducts["MIN_PRICE"] as! Int
        lblMaxPrice.text = "\(maxPrice)"
       
        lblMinPrice.text = "\(minPrice)"
        findRandomNumber()
        
    }
    
   
    
}
