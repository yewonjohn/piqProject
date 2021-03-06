//
//  Businesses.swift
//  piq
//
//  Created by John Kim on 6/24/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation

//Model to fetch from API
struct RestaurantModel{
    
    var name : String?
    var id: String?
    var rating: Float?
    var reviewCount: Int?
    var price: String?
    var distance: Double?
    var isClosed: Bool?
    var phone: String?
    var categories: [Categories]
    var url: String?
    var img_url: String?
    var addressCity: String?
    var addressStreet: String?
}

struct Categories{
    var alias: String?
    var title: String?
}

