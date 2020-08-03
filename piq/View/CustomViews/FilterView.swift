//
//  FilterView.swift
//  piq
//
//  Created by John Kim on 8/3/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

class FilterView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 123, y: 180, width: 123, height: 180))

        setCategoryTitle()
//        setCategoryCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let categoryTitle = UILabel()
//    let categoryCollection = UICollectionView()
    
    func setCategoryTitle(){
        self.addSubview(categoryTitle)
        categoryTitle.translatesAutoresizingMaskIntoConstraints = false
        categoryTitle.font = UIFont(name: "Montserrat-SemiBold", size: 25)
        categoryTitle.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        categoryTitle.topAnchor.constraint(equalTo: self.topAnchor,constant: 60).isActive = true
        categoryTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        categoryTitle.text = "Category"
    }
    
//    func setCategoryCollection(){
//        self.addSubview(categoryCollection)
//        categoryCollection.translatesAutoresizingMaskIntoConstraints = false
//        categoryCollection.topAnchor.constraint(equalTo: categoryTitle.bottomAnchor, constant: 5).isActive = true
//        categoryCollection.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        categoryCollection.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        categoryCollection.heightAnchor.constraint(equalToConstant: 188)
//    }
    
//
//    func setFilterView(){
//        self.view?.addSubview(filterView)
//        filterView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        filterView.translatesAutoresizingMaskIntoConstraints = false
//        filterView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//        filterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
//        filterView.leftAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
//        filterView.widthAnchor.constraint(equalToConstant: 360).isActive = true
//    }
    
    
}
