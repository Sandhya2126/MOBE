//
//  OrderSummaryPage.swift
//  FoodTracker
//
//  Created by MacBook-Pro-4 on 04/03/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

class OrderSummaryPage: UIViewController {
    
    //OUTLETS:
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblTableNo: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
   
    //VARIABLES:
    var orders:[OrderSummary]?
    
    //METHODS:
    
    @IBAction func selectTable_Clicked(_ sender: UITapGestureRecognizer) {
        print("selectTable_Clicked")
        let objQuantity = QuanityTableLauncher()
        objQuantity.pageIndex = 2
        objQuantity.showQuantity(quantity: 30)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        orders = ordersForSummary
         print("orderes summary",orders)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        findTotalAmount()
    }
    
    @objc func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    
    func findTotalAmount(){
        if let orders = orders{
            var totalAmount = 0
            for order in orders{
                let itemPrice = order.price * order.itemCount
                totalAmount += itemPrice
            }
            
            lblTotalAmount.text = "Rs."+"\(totalAmount)"
        }
    }
    
    @IBAction func BtnConfirm_Clicked(_ sender: UIButton) {
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension OrderSummaryPage:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCell", for: indexPath)as! OrderSummaryCell
        if let order = orders?[indexPath.row]{
            cell.setUp(order: order)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width*0.3
        let height = collectionView.frame.height*0.4
        return CGSize(width: width, height: height)
    }
    
}
