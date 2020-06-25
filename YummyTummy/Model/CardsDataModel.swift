//
//  CardsDataModel.swift
//  YummyTummy
//
//  Created by John Kim on 6/25/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
struct CardsDataModel {
    
    var bgColor: UIColor
    var text : String
    var image : String
      
    init(bgColor: UIColor, text: String, image: String) {
        self.bgColor = bgColor
        self.text = text
        self.image = image
    
    }
}
