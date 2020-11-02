//
//  SettingsCell.swift
//  piq
//
//  Created by John Kim on 8/9/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static let identifier = "SettingsCell"
    
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
