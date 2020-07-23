//
//  FavoritesModel.swift
//  YummyTummy
//
//  Created by John Kim on 6/24/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import RealmSwift

class FavoritesModel: Object {
    
    @objc dynamic var userEmail: String?
    @objc dynamic var name : String?
    @objc dynamic var id: String?
    let rating = RealmOptional<Float>()
    let reviewCount = RealmOptional<Int>()
    @objc dynamic var price: String?
    let distance = RealmOptional<Double>()
    let isClosed = RealmOptional<Bool>()
    @objc dynamic var phone: String?
    @objc dynamic var categories: String?
    @objc dynamic var url: String?
    @objc dynamic var img_url: String?
    @objc dynamic var date_added: Date? = nil
    
}
