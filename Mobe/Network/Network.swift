//
//  Network.swift
//  Mobe
//
//  Created by MacBook-Pro-4 on 16/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import Foundation

import AWSCognitoIdentityProvider

protocol sendJSONdelegate {
    func sendJSON(data: [String:Any])
}

class NetworkHandler{
    
    var url: String?
    init(url: String) {
        self.url = url
    }
    
    var JSONDelegate: sendJSONdelegate?
    
    func fetchJSON(){
        //fetch JSON data from AWS
        //call handler with data after the data is fetched
        
       // JSONDelegate.sendJSON(data: <#T##[String : Any]#>)
       // return data
    }
}


