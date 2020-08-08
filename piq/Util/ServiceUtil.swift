//
//  Background.swift
//  YummyTummy
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

class ServiceUtil{
    
    func setAuthBackground(_ view: UIView,_ backgroundImageView: UIImageView){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        backgroundImageView.image = UIImage(named: "tacosImg")
        backgroundImageView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9529411765, alpha: 1)
        //        backgroundImageView.alpha = 0.5
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
    func animateButton(button: UIButton){
        button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        button.transform = CGAffineTransform.identity
                        button.tintColor = #colorLiteral(red: 0.6624035239, green: 0, blue: 0.08404419571, alpha: 1)
                        //                                    button.layer.borderWidth = 1
                        //                                    button.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        },
                       completion: { _ in }
        )
    }
    func animateResetButton(button: UIButton){
        if(button.isHidden == false){
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            button.transform = button.transform.rotated(by: 360)
                            button.alpha = 0
                            
            },
                           completion: { _ in
                            button.isHidden = true
            }
            )
        }else{
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            button.transform = button.transform.rotated(by: 360)
                            button.isHidden = false
                            button.alpha = 1
            },
                           completion: { _ in }
            )
        }
    }
    
    func animateShadowView(view: UIView){
        if(view.isHidden == false){
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           animations: {
                            view.alpha = 0
                            
            },
                           completion: { _ in
                            view.isHidden = true
            }
            )
        }else{
            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           animations: {
                            view.isHidden = false
                            view.alpha = 0.7
            },
                           completion: { _ in }
            )
        }
    }
    
}
