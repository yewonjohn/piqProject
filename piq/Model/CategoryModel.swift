//
//  RootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on July 23, 2020

import Foundation

//Model to get categories from json file
struct CategoryModel: Codable{
    
    let alias : String?
    let countryBlacklist : [String]?
    let countryWhitelist : [String]?
    let parents : [String]?
    let title : String?
    
}
