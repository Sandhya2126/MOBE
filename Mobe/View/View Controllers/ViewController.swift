//
//  ViewController.swift
//  Mobe
//
//  Created by MacBook-Pro-4 on 11/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit

var orderData = [String:Any]()
var ordersForSummary = [OrderSummary]()

class ViewController: UIViewController {
    
    @IBOutlet weak var notificationView: UIView!
    //OUTLETS:-
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblNotiDes1: UILabel!
    @IBOutlet weak var lblNotiDes2: UILabel!
   
    var outletId = ""
    //VARIABLES:
    //var drinkTypes = [DrinksData]()
    //var drinkProducts = [DrinkProducts]()
    var drinkTypes = [Any]()
    var drinkProducts = [String:Any]()
    var queryDoneForTypes:Bool?
    var queryDoneForProducts:Bool?
    var selectedProduct:String?
    var selectedPrice:Int?
    
    let objQuantity = QuanityTableLauncher()
   
    var userInfo:UserLogin?
    
    //Timer:
    
    var refreshTimer: Timer!
    
    //Notification from quantity launcher
    
    let getQuantityNotification = Notification.Name.init(QuantityForProductListNotiKey)
    
    //METHODS:
    
    func getUserData(userData: UserLogin){
        userInfo = userData
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          print("outlet id ",outletId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateQuanity(notification:)), name: getQuantityNotification, object: nil)
        
        DispatchQueue.main.async {
            self.setUPNavigationBar()
        }
        
       
        refreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        
        let url = "https://evening-chamber-14219.herokuapp.com/commonData/"+outletId
        print("urllllll",url)
        let networkCall = NetworkHandler()
        networkCall.networkDelegate = self
        networkCall.fetchJSON(url: url)
        
        //let menu = MenuLauncher()
        //menu.addMenu()
        
    }
    
    @objc func updateQuanity(notification: Notification){
       // performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
        
        if let userInfo = notification.userInfo{
           let quantity = userInfo["quantity"]
            let orderSummary = OrderSummary(itemName: selectedProduct ?? "no value", price: selectedPrice ?? 0, itemCount: quantity as! Int)
            ordersForSummary.append(orderSummary)
        }
       
        performSegue(withIdentifier: "showMixer", sender: (Any).self)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refresh(){
        tableView.reloadData()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
       refreshTimer.invalidate()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.layoutSubviews()
        //tableView.beginUpdates()
        //tableView.endUpdates()
    }
    
    func setUPNavigationBar(){
        
        var rightBarBtns = [UIBarButtonItem]()
        var LeftBarBtns = [UIBarButtonItem]()
        let imgLoactionMap:UIImageView =  UIImageView(frame: CGRect(x: 2, y: 3, width: 30, height: 30))//x:5
        let x = 10
        let btnLoactionMap :UIButton =  UIButton(frame: CGRect(x:0, y:0 ,width:3*x,height:5*x))
        btnLoactionMap.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        btnLoactionMap.addSubview(imgLoactionMap)
        imgLoactionMap.image = UIImage.init(named: "map icon")?.withRenderingMode(.alwaysOriginal)
        
        // image placed on btnMenu
        let menuImage:UIImageView = UIImageView(frame: CGRect(x:5, y: 0, width: 30, height: 30))
        
        // background button(on button there is image(menuImage)
        let btnMenu = UIButton(frame: CGRect(x:0, y:0 ,width:4*x,height:5*x))
        menuImage.image = UIImage.init(named: "menu icon")?.withRenderingMode(.alwaysOriginal)
        btnMenu.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        
        btnMenu.addSubview(menuImage)
        let rightbarbtn2 = UIBarButtonItem(customView: btnLoactionMap)
        rightBarBtns.append(rightbarbtn2)
        
        let Leftbutton = UIBarButtonItem(customView: btnMenu)
        LeftBarBtns.append(Leftbutton)
        navigationItem.setLeftBarButtonItems(LeftBarBtns, animated: true)
        navigationItem.setRightBarButtonItems(rightBarBtns, animated: true)
       
        //set up left bar button - menu
        
     /*   let image = UIImage.init(named: "menu icon")?.withRenderingMode(.alwaysOriginal)
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showMenu))
        self.title = "MOBE"
       
        //set up right bar button - map
        
         let imageMap = UIImage.init(named: "map icon")?.withRenderingMode(.alwaysOriginal)
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageMap, style: .plain, target: self, action: #selector(showMap))*/
        
        //title of the app should be made dynamic
       // navigationController?.navigationItem.title = "MOBE"
        
       // let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
       // navigationController?.navigationBar.titleTextAttributes = textAttributes
        
       // navigationController?.navigationBar.barTintColor = UIColor.darkGray
    }
    let menu = MenuLauncher()
    @objc func showMenu(){
        
        menu.userInfo = userInfo
            menu.addMenu()
    }
    
    @objc func showMap(){
        //show google map
        performSegue(withIdentifier: "showGoogleMap", sender: self)
    }
   
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)as! tableCell
        guard let queryDone = queryDoneForTypes else{ return cell}
        if queryDone{
            cell.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 4.0)
            cell.headerView.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 3.0)
            let drinkType = drinkTypes[indexPath.row] as! [String:Any]
            cell.registerCollectionView(dataSource: self, delegate: self)
            cell.setUpViews(dataSource: drinkType, index: indexPath.row)
            
            
        }
        else{
            return cell
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let queryDone = queryDoneForTypes else{ return 0}
        if queryDone{
           return drinkTypes.count
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            print("Landscape Left")
            return tableView.frame.height
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight{
            print("Landscape Right")
            return tableView.frame.height
        }
        else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown{
            print("Portrait Upside Down")
            return tableView.frame.height/3
        }
        else {
//            UIDevice.current.orientation == UIDeviceOrientation.portrait {
            print("Portrait")
            return tableView.frame.height/3
        }
        
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! collectionCell
        
        cell.setUp()
        cell.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 4.0)
        let drinkType = drinkTypes[collectionView.tag] as! [String:Any]
        let drinkProducts = drinkType["products"] as! [Any]
        let drinkProduct = drinkProducts[indexPath.item] as! [String:Any]
        cell.setUpData(drinkProducts: drinkProduct)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let drinkProducts = (drinkTypes[collectionView.tag] as! [String: Any])["products"] as! [Any]
       
        return drinkProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        objQuantity.pageIndex = 0
        objQuantity.showQuantity(quantity: 30)
        
        //filling the order data
        let drinkProducts = (drinkTypes[collectionView.tag] as! [String: Any])["products"] as! [Any]
        orderData["PROD_ID"] = (drinkProducts[indexPath.item] as! [String:Any])["_id"]
        
        
        print("selectedQuantity ",objQuantity.selectedQuantity)
        
        let cell = collectionView.cellForItem(at: indexPath)as! collectionCell
        print("luckyPrice ",cell.random)
        orderData["PRICE"] = cell.random
        
        print("orderData ",orderData)
        
        //filling selected product info . this will be used to fill order summary
        
        selectedProduct = (drinkProducts[indexPath.item] as! [String:Any])["NAME"] as? String
        selectedPrice = cell.random
        
    }

}

extension ViewController: NetWorkProtocol{
    func sendJSON(data: Data) {
        
        
         let data = data
        
        do{
            
            let drinksData:[String:Any] = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            
            print(drinksData)
            
            self.drinkTypes = drinksData["types"] as! [Any]
            
            
            
            //self.drinkTypes = try JSONDecoder().decode([DrinksData].self, from: data)
            self.queryDoneForTypes = true
            DispatchQueue.main.async {
                
                let notificationData = drinksData["notification"] as? [Any]
                guard let notification = notificationData?[0] as? [String:Any] else{return}
                self.lblNotiDes1.text = notification["NOTIF_DESC"] as? String
                self.lblNotiDes2.text = notification["NOTIF_DESC2"] as? String
                self.tableView.reloadData()
                 CustomLoader.activity.stopLoader()
            }
            
            
            
        } catch let jsonErr {
            print("error serialising json :",jsonErr)
        }
        
    }
    
    
}
