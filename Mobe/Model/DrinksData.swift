//
//  DrinksData.swift
//  Mobe
//
//  Created by MacBook-Pro-4 on 22/02/19.
//  Copyright © 2019 MacBook-Pro-4. All rights reserved.
//

import Foundation


struct DrinksData: Decodable{
    var _id : String
    var NAME: String
    var IMAGE_PATH: String = "https://evening-chamber-14219.herokuapp.com/"
    var products : [DrinkProducts]
}
