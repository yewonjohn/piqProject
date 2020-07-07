//
//  Businesses.swift
//  YummyTummy
//
//  Created by John Kim on 6/24/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation

struct BusinessModel{
    
    var name : String?
    var id: String?
    var rating: Float?
    var reviewCount: Int?
    var price: String?
    var distance: Double?
    var address: String?
    var isClosed: Bool?
    var phone: String?
    var categories: [Categories]
    var url: String?
    var img_url: String?
    var isOpen: Bool?
}

struct Categories{
    var alias: String?
    var title: String?
}

