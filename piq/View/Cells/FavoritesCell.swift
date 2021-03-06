//
//  FavoritesCell.swift
//  piq
//
//  Created by John Kim on 6/15/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import SwipeCellKit

class FavoritesCell: SwipeTableViewCell {
    
    static let identifier = "FavoritesCell"

    @IBOutlet weak var contentVIew: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favoritesImage: UIImageView!
    @IBOutlet weak var favoritesTitle: UILabel!
    @IBOutlet weak var favoritesRatings: UIImageView!
    @IBOutlet weak var favoritesRatingCount: UILabel!
    @IBOutlet weak var favoritesPrice: UILabel!
    @IBOutlet weak var favoritesCategories: UILabel!
    
    @IBOutlet weak var categoriesWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favoritesImage.layer.cornerRadius = 4
        favoritesImage.clipsToBounds = true
        
        favoritesTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 4).isActive = true
//        favoritesCategories.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 4).isActive = true
        
        categoriesWidth.constant = containerView.frame.width * 0.55
        print(containerView.frame.width * 0.55)
    }
    
}
