//
//  BarLoactions.swift
//  Mobe
//
//  Created by user on 03/03/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import UIKit



class BarLoaction: UIViewController {
    
    var userInfo:UserLogin?
    var latitude : String = ""
    var longitutde : String = ""
    var locationData:[Any] = []
    var queryDone:Bool?
    var arrayOfOutletNames = [String]()
    var arrayOfOutletAddress = [String]()
    var postLoactionDictionary = [String:Any]()
    var outletId = ""
    //showSecondPage
    @IBOutlet weak var showBarLoactionCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let barLocationURL = "https://evening-chamber-14219.herokuapp.com/outlet"
        let networkCall = NetworkHandler()
        networkCall.networkDelegate = self
        networkCall.fetchJSON(url: barLocationURL)
        showBarLoactionCollectionView.delegate = self
        showBarLoactionCollectionView.dataSource = self
        showBarLoactionCollectionView.reloadData()
        
       // setupNavigation(navigationItem: navigationItem)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OUTLETS", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
       // navigationController?.navigationBar.barTintColor = UIColor.darkGray
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecondPage" {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.outletId = outletId
                destinationVC.userInfo = userInfo
            }
        }
    }
}

extension BarLoaction: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("location234")
        guard let queryDone = queryDone else{ return 0}
        if queryDone{
            print("locationCount",locationData.count)
            return locationData.count
        }
        else{
            print("locationCount12",locationData.count)
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as! GetBarLocations
        guard let queryDone = queryDone else{ return cell}
        if queryDone{
            cell.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 4.0)
            cell.lblLocation.text = (locationData[indexPath.item] as! [String:Any])["OUTLET_NAME"] as? String
           
            
            
            
        }
        else{
            return cell
        }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // latitude = ((locationData[indexPath.item] as! [String:Any])["LAT"] as! String
        // longitutde = (locationData[indexPath.item] as! [String:Any])["LONG"] as! String
        outletId =  (locationData[indexPath.item] as! [String:Any])["_id"] as! String
        print("outlet id ",outletId)
        performSegue(withIdentifier: "showSecondPage", sender: self)
    }
    
    
}
extension BarLoaction: NetWorkProtocol{
    func sendJSON(data: Data) {
        let data = data
        
        do{
            print(data)
            locationData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            print("NO OF COUNT",locationData,locationData.count)
            
            self.queryDone = true
            DispatchQueue.main.async {
                self.showBarLoactionCollectionView.reloadData()
                 CustomLoader.activity.stopLoader()
                //self.tableView.reloadData()
            }
            
            
        } catch let jsonErr {
            print("error serialising json :",jsonErr)
        }
        
    }
}



