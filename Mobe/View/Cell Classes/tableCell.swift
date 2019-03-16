//
//  tableCell.swift
//  Mobe
//
//  Created by MacBook-Pro-4 on 11/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit

class tableCell: UITableViewCell {

    @IBOutlet weak var imgDrinkType: CustomImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    
    
    @IBOutlet weak var lblDrinkType: UILabel!
    
    var drinkType:[String:Any]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpViews(dataSource: [String:Any],index: Int){
        self.drinkType = dataSource
        
        lblDrinkType.text = drinkType?["NAME"] as? String
        
        var imgUrlStr = "https://evening-chamber-14219.herokuapp.com"
        imgUrlStr.append((drinkType?["IMAGE_PATH"] as? String)!)
        imgDrinkType.loadImageFromUrl(urlStr: imgUrlStr)
        
        collectionView.tag = index
        
        
        collectionView.reloadData()
        
        
    }
    
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func registerCollectionView(dataSource: UICollectionViewDataSource,delegate:UICollectionViewDelegate){
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }

}
