//
//  EventCell.swift
//  piq
//
//  Created by John Kim on 11/1/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventContainer: UIView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var eventTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventImageHeight: NSLayoutConstraint!
    //MARK:- Properties
    static let identifier = "EventCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configLayout()
    }
    
    //MARK:- UI Layout
    
    func configLayout(){
        eventContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: eventImageHeight.constant/2).isActive = true
        eventContainer.layer.cornerRadius = 15
        layer.cornerRadius = 15
        clipsToBounds = true
            
        
        
    }
    

}
