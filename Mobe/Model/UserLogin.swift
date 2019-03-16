//
//  UserLogin.swift
//  Mobe
//
//  Created by MacBook-Pro-4 on 28/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import Foundation

struct UserLogin{
    let name: String
    let urlPath: URL
    let mailId: String
    
    init(name: String,urlPath:URL,mailId: String) {
        self.name = name
        self.urlPath = urlPath
        self.mailId = mailId
    }
}
