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
    
        var counter = 0
    
    func animateIcon(icon: UIImageView, parentView: UIView, imageArray: [UIImage?]){
        
        if(counter == imageArray.count){
            counter = 0
        }
        icon.image = imageArray[counter]
        counter = counter + 2
        
        var customTransform = icon.transform
        customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
        customTransform = customTransform.translatedBy(x: 75, y: 245)
        customTransform = customTransform.rotated(by: .pi/8)
        
        UIView.animate(withDuration: 0.6, delay: 1, animations: {

            icon.transform = customTransform

        }, completion: { _ in
            
            customTransform = customTransform.translatedBy(x: 375, y: 50)
            customTransform = customTransform.scaledBy(x: 2, y: 2)
            customTransform = customTransform.rotated(by: -.pi/10)

            UIView.animate(withDuration: 0.6, delay: 1, animations: {
                icon.transform = customTransform
                
            }, completion: { _ in
                
                customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
                customTransform = customTransform.rotated(by: -.pi/3)
                UIView.animate(withDuration: 0.6, delay: 1, animations: {
                    icon.transform = customTransform.translatedBy(x: 300, y: 0)
                    
                }, completion: { _ in
                    icon.transform = .identity
                    self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray)
                })
                
            })
        })
    }
    
    var counter2 = 1
//    var firstRun = true
    func animateSecondIcon(icon: UIImageView, parentView: UIView, imageArray: [UIImage?]){
        
//        var delayNum : Double
//
//        if(firstRun){
//            delayNum = 2.0
//            firstRun = false
//        }else{
//            delayNum = 1.0
//        }
//
        if(counter == imageArray.count){
            counter2 = 1
        }
        icon.image = imageArray[counter]
        counter2 = counter2 + 2
        
        var customTransform = icon.transform
        customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
        customTransform = customTransform.translatedBy(x: 75, y: 245)
        customTransform = customTransform.rotated(by: .pi/8)
        
        UIView.animate(withDuration: 0.6, delay: 2.5, animations: {

            icon.transform = customTransform

        }, completion: { _ in
            
            customTransform = customTransform.translatedBy(x: 375, y: 50)
            customTransform = customTransform.scaledBy(x: 2, y: 2)
            customTransform = customTransform.rotated(by: -.pi/10)

            UIView.animate(withDuration: 0.6, delay: 1, animations: {
                icon.transform = customTransform
                
            }, completion: { _ in
                
                customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
                customTransform = customTransform.rotated(by: -.pi/3)
                UIView.animate(withDuration: 0.6, delay: 1, animations: {
                    icon.transform = customTransform.translatedBy(x: 300, y: 0)
                    
                }, completion: { _ in
                    icon.transform = .identity
                    self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray)
                })
                
            })
        })
    }
    
        func animateThirdIcon(icon: UIImageView, parentView: UIView, imageArray: [UIImage?]){
            
    //        var delayNum : Double
    //
    //        if(firstRun){
    //            delayNum = 2.0
    //            firstRun = false
    //        }else{
    //            delayNum = 1.0
    //        }
    //
            if(counter == imageArray.count){
                counter2 = 1
            }
            icon.image = imageArray[counter]
            counter2 = counter2 + 2
            
            var customTransform = icon.transform
            customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
            customTransform = customTransform.translatedBy(x: 75, y: 245)
            customTransform = customTransform.rotated(by: .pi/8)
            
            UIView.animate(withDuration: 0.6, delay: 4.15, animations: {

                icon.transform = customTransform

            }, completion: { _ in
                
                customTransform = customTransform.translatedBy(x: 375, y: 50)
                customTransform = customTransform.scaledBy(x: 2, y: 2)
                customTransform = customTransform.rotated(by: -.pi/10)

                UIView.animate(withDuration: 0.6, delay: 1, animations: {
                    icon.transform = customTransform
                    
                }, completion: { _ in
                    
                    customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
                    customTransform = customTransform.rotated(by: -.pi/3)
                    UIView.animate(withDuration: 0.6, delay: 1, animations: {
                        icon.transform = customTransform.translatedBy(x: 300, y: 0)
                        
                    }, completion: { _ in
                        icon.transform = .identity
                        self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray)
                    })
                    
                })
            })
        }
    
    
    func deselectButtons(button1: UIButton, button2:UIButton, button3:UIButton, button4:UIButton, buttonAll: UIButton, index: Int){
        if(index == 1){
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
        }
        else if(index == 2){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
        }
        else if(index == 3){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
        }
        else if(index == 4){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
        }
        else if(index == 5){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
        }
    }
    
    func deselectDistButtons(button1: UIButton, button2:UIButton, button3:UIButton, button4:UIButton, buttonAll: UIButton, index: Int){
        if(index == 1){
            button2.setBackgroundImage(#imageLiteral(resourceName: "bike_un"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "drive_un"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "far_un"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "any_un"), for: .normal)
            print("1")
        }
        else if(index == 2){
            button1.setBackgroundImage(#imageLiteral(resourceName: "walk_un"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "bike_un"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "drive_un"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "far_un"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "any_un"), for: .normal)
        }
        else if(index == 3){
            button1.setBackgroundImage(#imageLiteral(resourceName: "walk_un"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "bike_un"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "far_un"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "any_un"), for: .normal)
        }
        else if(index == 4){
            button1.setBackgroundImage(#imageLiteral(resourceName: "walk_un"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "bike_un"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "drive_un"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "any_un"), for: .normal)
        }
        else if(index == 5){
            button1.setBackgroundImage(#imageLiteral(resourceName: "walk_un"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "bike_un"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "drive_un"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "far_un"), for: .normal)
        }
    }
}
