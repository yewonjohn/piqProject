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
    var isClosed: Bool?
    var phone: String? {
        didSet{
//            let phoneArr = Array(arrayLiteral: phone)
//            self.phone = "\(phoneArr[0])\(phoneArr[1]) (\(phoneArr[3])\(phoneArr[4])\(phoneArr[5]))-\(phoneArr[6])\(phoneArr[7])\(phoneArr[8])-\(phoneArr[9])\(phoneArr[10])\(phoneArr[11])"
        }
    }
    var categories: [Categories]
    var url: String?
    var img_url: String?
}

struct Categories{
    var alias: String?
    var title: String?
}

