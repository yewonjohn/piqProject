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
    
    //MARK:- Properties
    var gradientView = GradientImageView(colors:  [#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)], gradientDirection: .downUp)
    static let identifier = "EventCell"
    
    //MARK:- Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configLayout()
        gradientConfig()
    }
    
    //MARK:- UI Layout
    
    func configLayout(){
//        eventContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: eventImageHeight.constant/2).isActive = true
        
        eventContainer.layer.cornerRadius = 15
        layer.cornerRadius = 15
        clipsToBounds = true
        
        eventImage.contentMode = .scaleAspectFill
        eventImage.clipsToBounds = true

        eventContainer.clipsToBounds = true
        
    }
    func gradientConfig(){
        eventImage.addSubview(gradientView)
        gradientView.contentMode = .scaleAspectFill
        gradientView.alpha = 0.5
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.centerXAnchor.constraint(equalTo: eventImage.centerXAnchor).isActive = true
        gradientView.centerYAnchor.constraint(equalTo: eventImage.centerYAnchor).isActive = true
        gradientView.widthAnchor.constraint(equalTo: self.eventImage.widthAnchor, multiplier: 1.0).isActive = true
        gradientView.heightAnchor.constraint(equalTo: self.eventImage.heightAnchor, multiplier: 1.0).isActive = true
    }
    

}
