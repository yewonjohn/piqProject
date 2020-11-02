//
//  CategoryModel.swift
//  piq
//
//  Created by John Kim on 6/24/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation

//Model to get categories from json file
struct CategoryModel: Codable{
    
    let alias : String?
    let countryBlacklist : [String]?
    let countryWhitelist : [String]?
    let parents : [String]?
    let title : String?
    
}
