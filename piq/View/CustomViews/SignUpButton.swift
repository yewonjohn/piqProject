//
//  ViewController.swift
//  piq
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
        titleLabel?.font    = UIFont(name: "Montserrat-SemiBold", size: 18)
        layer.cornerRadius  = frame.size.height/2
        backgroundColor     = #colorLiteral(red: 0.8972918391, green: 0.8919581175, blue: 0.9013919234, alpha: 1)
        layer.borderWidth = 2
        layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)

    }
}
