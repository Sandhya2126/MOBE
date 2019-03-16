//
//  NetworkProtocol.swift
//  Mobe
//
//  Created by user on 24/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import Foundation

protocol NetWorkProtocol {
    func sendJSON(data: Data)
}

class NetworkHandler{
    
    var networkDelegate: NetWorkProtocol?
    
    func fetchJSON(url: String){
        
        
        
        guard let Url = URL(string: url) else{ return }
         CustomLoader.activity.startLoader()
        URLSession.shared.dataTask(with: Url) { (data, response, error) in
            
            guard let data = data else { return }
            
            self.networkDelegate?.sendJSON(data: data)
            
            }.resume()
    }
    
    
}
