//
//  ViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/19/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

class SignUpButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        backgroundColor = .clear
        titleLabel?.font    = UIFont(name: Fonts.avenirNextCondensedDemiBold, size: 18)
        layer.cornerRadius  = frame.size.height/2
        tintColor = #colorLiteral(red: 0.9098039216, green: 0.3137254902, blue: 0.3568627451, alpha: 1)

    }
}
