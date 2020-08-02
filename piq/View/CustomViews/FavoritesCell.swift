//
//  FavoritesCell.swift
//  Next-flix
//
//  Created by John Kim on 6/15/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import SwipeCellKit

class FavoritesCell: SwipeTableViewCell {

    @IBOutlet weak var favoritesImage: UIImageView!
    @IBOutlet weak var favoritesTitle: UILabel!
    @IBOutlet weak var favoritesRatings: UIImageView!
    @IBOutlet weak var favoritesRatingCount: UILabel!
    @IBOutlet weak var favoritesPrice: UILabel!
    @IBOutlet weak var favoritesCategories: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
}
