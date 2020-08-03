//
//  CategoryCell.swift
//  piq
//
//  Created by John Kim on 8/2/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell{
    
    var dataTitle: String?{
        didSet{
            guard let dataTitle = dataTitle else{ return }
            categoryTitle.text = dataTitle
            if(dataTitle == "Breakfast & Brunch"){
                categoryTitle.text = "Breakfast"
            }
            if(dataTitle == "American (New)"){
                categoryTitle.text = "American"
            }
        }
    }
    var dataImage: UIImage?{
        didSet{
            guard let dataImage = dataImage else {return}
            categoryImage.image = dataImage
        }
    }

    
    fileprivate let categoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "breakfast")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    fileprivate let categoryTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.text = "Breakfast"
        label.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        label.textAlignment = .center

        
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        let deselectedView = UIView(frame: bounds)
        deselectedView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.backgroundView = deselectedView

        let selectedView = UIView(frame: bounds)
        selectedView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        selectedView.layer.borderWidth = 4
        selectedView.layer.borderColor = #colorLiteral(red: 0.8666666667, green: 0.5647058824, blue: 0.4980392157, alpha: 1)
        selectedView.layer.cornerRadius = 15
        self.selectedBackgroundView = selectedView
        
//        let topView = UIView()
//        contentView.addSubview(topView)
//        topView.translatesAutoresizingMaskIntoConstraints = false
//        topView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        topView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        topView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        topView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        topView.layer.cornerRadius = 15
//        topView.clipsToBounds = true

//        self.contentView.layer.cornerRadius = 12.0
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.clear.cgColor
//        self.contentView.layer.masksToBounds = true
        
        contentView.addSubview(categoryImage)

        categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        categoryImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        categoryImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        categoryImage.widthAnchor.constraint(equalToConstant: 90).isActive = true

        contentView.addSubview(categoryTitle)
        categoryTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        categoryTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
