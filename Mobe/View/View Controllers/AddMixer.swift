//
//  AddMixer.swift
//  Mobe
//
//  Created by user on 01/03/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit


class AddMixer: UIViewController,NetWorkProtocol {
    var formOrderFromMixerPage = [ordersForSummary]
    @IBOutlet weak var btnProceed: UIButton!
    var mixerName:String?
    var mixerPrice:Int?
    var mixerDataList = [Any]()
    var lastSelectedCellIndex:IndexPath?
    let objQuantity = QuanityTableLauncher()
    var mixerProducts = [String:Any]()
    let quantityNotification = Notification.Name.init(QuantityForMixerPageNotiKey)
    struct Info{
        var name: String = ""
        var price: Int = 0
       
        
        init(typeName:String,price: Int) {
            name = typeName
            self.price = price
          
        }
        var quantity: Int = 0
        init(quantity: Int) {
            self.quantity = quantity
        }
    }
    var itemPresent = [Bool]()
    var mixerData = [Int: Info]()
    
    var queryDoneFormixerList:Bool?
    func sendJSON(data: Data) {
        let data = data
        do{
            
            mixerDataList = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            print("mixerData",mixerDataList.count,mixerDataList)
            self.queryDoneFormixerList = true
            self.itemPresent = Array(repeating: false, count: mixerDataList.count)
            DispatchQueue.main.async {
                //self.mixerList = drinksData["mixerData"] as! [Any]
                self.mixerListCollectionView.reloadData()
                CustomLoader.activity.stopLoader()
            }
        } catch let jsonErr {
            print("error serialising json :",jsonErr)
        }
        
    }
    @IBAction func leftSkipBarButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "showOrderSummary", sender: self)
    }
   /* func notifySelectedIndex(indexpath:IndexPath){
        print("notification index",indexpath)
        let cell = mixerListCollectionView.cellForItem(at: indexpath) as! addMixerCell
        cell.lblNoOfQunatity.text = String(objQuantity.selectedQuantity)
        
    }*/
    
    
    @IBOutlet weak var mixerListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // NotificationCenter.default.addObserver(self, selector: #selector(someFuncitonName), name: Notification.Name.TimeOutUserInteraction, object: nil)
        btnProceed.addTarget(self, action: #selector(ProccedToOrderSummary), for: .touchUpInside)
        navigationItem.title = "Add Mixer"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuantity(notification:)), name: quantityNotification, object: nil)
       
        let url = "https://evening-chamber-14219.herokuapp.com/mixer/getAllMixer"
        let networkCall = NetworkHandler()
        networkCall.networkDelegate = self
        networkCall.fetchJSON(url: url)
        
        mixerListCollectionView.delegate = self
        mixerListCollectionView.dataSource = self
        // doSomething(timeInterval: 10)
        
        // Do any additional setup after loading the view.
    }
    @objc func someFuncitonName()
    {
        alert(message: "dead", title: "end timer")
    }
    @objc func ProccedToOrderSummary()
    {
     performSegue(withIdentifier: "showOrderSummary", sender: self)
        
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOrderSummary" {
            if let destinationVC = segue.destination as? OrderSummaryPage {
                destinationVC.orders =  ordersForSummary
            }
        }
    }*/
    //update cell data
    @objc func updateQuantity(notification: Notification){
        if let userInfo = notification.userInfo{
        let quantity = userInfo["quantity"] as! Int
            let cell = mixerListCollectionView.cellForItem(at: lastSelectedCellIndex!) as! addMixerCell
            cell.lblNoOfQunatity.text = "\(quantity)"
            cell.btnCancelQunatity.isHidden = false
            let orderSummary = OrderSummary(itemName:  mixerName ?? "no value", price: mixerPrice ?? 0, itemCount: quantity )
            ordersForSummary.append(orderSummary)
        }
        
    }
    
  
    
    @objc func refreshTheQunatityLabel(sender:UIButton){
        print("sender",sender.tag)
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = mixerListCollectionView.cellForItem(at: indexPath ) as! addMixerCell
        cell.lblNoOfQunatity.text = ""
        }
   
    
    
}

extension AddMixer:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mixerDataList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mixerCell", for: indexPath) as! addMixerCell
        cell.btnCancelQunatity.tag = indexPath.item
        cell.btnCancelQunatity.isUserInteractionEnabled = true
        cell.btnCancelQunatity.addTarget(self, action: #selector(refreshTheQunatityLabel), for: .touchUpInside)
        guard let queryDone = queryDoneFormixerList else{ return cell}
        
        if queryDone{
           
            
            mixerProducts = mixerDataList[indexPath.item] as! [String:Any]
            cell.setUpData(mixerList: mixerProducts)
         
            
            cell.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 4.0)
            
        }
        else{
            print("return cell")
            return cell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        lastSelectedCellIndex = indexPath
        objQuantity.pageIndex = 1
        mixerProducts = mixerDataList[indexPath.item] as! [String:Any]
        mixerName = mixerProducts["NAME"] as? String
        mixerPrice = mixerProducts["PRICE"] as? Int
        objQuantity.showQuantity(quantity: 30)
        
       
       /* if itemPresent[indexPath.item]{
           itemPresent[indexPath.item] = false
            mixerData.removeValue(forKey: indexPath.item)
        }
        else{
            itemPresent[indexPath.item] = true
            let info = Info(typeName: mixerName ?? "no value", price: mixerPrice ?? 0)
            mixerData[indexPath.item] = info
        }*/
        
        
        
        
       
       
        
        
           
    }
    
    
    
    
}
