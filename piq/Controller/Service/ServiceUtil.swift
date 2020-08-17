//
//  Background.swift
//  piq
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

class ServiceUtil{
    
    func setBackground(_ view: UIView,_ backgroundImageView: UIImageView){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9529411765, alpha: 1)
        view.sendSubviewToBack(backgroundImageView)
    }
    func setAuthBackground(_ view: UIView,_ backgroundImageView: UIImageView){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.image = #imageLiteral(resourceName: "authBackground")
        backgroundImageView.contentMode = .scaleAspectFill
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
    
    func animateResetLabel(label: UILabel){
    if(label.isHidden == false){
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        label.alpha = 0
                        
        },
                       completion: { _ in
                        label.isHidden = true
        }
        )
    }else{
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        label.isHidden = false
                        label.alpha = 1
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
    //stops animation
    var inBackground = false
    func backgroundTrigger(){
        inBackground = true
    }
    
    func animateIcon(icon: UIImageView, parentView: UIView, imageArray: [UIImage?], imageIndex: Int, iconId: Int, firstTimeCalled: Bool = true) {
        let delayInBetween = 1.0
        var delayNumber = 1.0
        let animationDuration = 0.6

        switch iconId {
        case 2:
            delayNumber = (animationDuration + delayInBetween)

        case 3:
            delayNumber = (animationDuration + delayInBetween) * 2
            
        default:
            delayNumber = 1.0
        }
        
        if(imageIndex == imageArray.count){
              icon.image = imageArray[0]
        } else {
              icon.image = imageArray[imageIndex]
        }
                
        var customTransform = icon.transform
        customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
        customTransform = customTransform.translatedBy(x: parentView.frame.width * 0.1811, y: parentView.frame.height * 0.7346)
        customTransform = customTransform.rotated(by: .pi/8)
        
        if !firstTimeCalled {
            delayNumber = delayInBetween
        } else {
            if iconId == 1 {
                delayNumber = 0
            }
        }
        
        UIView.animate(withDuration: animationDuration, delay: delayNumber, animations: {

            icon.transform = customTransform

        }, completion: { _ in
            
            customTransform = customTransform.translatedBy(x: parentView.frame.width * 0.9057, y: parentView.frame.height * 0.1499)
            customTransform = customTransform.scaledBy(x: 2, y: 2)
            customTransform = customTransform.rotated(by: -.pi/10)

            UIView.animate(withDuration: animationDuration, delay: delayInBetween, animations: {
                icon.transform = customTransform
                
            }, completion: { _ in
                
                customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
                customTransform = customTransform.rotated(by: -.pi/3)
                UIView.animate(withDuration: animationDuration, delay: delayInBetween, animations: {
                    icon.transform = customTransform.translatedBy(x: parentView.frame.width * 0.7246, y: 0)
                    
                }, completion: { _ in
                    icon.transform = .identity
                    if(!self.inBackground){
                        if(imageIndex == imageArray.count){
                            self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: 0, iconId: iconId, firstTimeCalled: false)
                        } else {
                            self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: imageIndex+1, iconId: iconId, firstTimeCalled: false)
                        }
                    }
                })
                
            })
        })
    }
    
        
//    func animateIcon(icon: UIImageView, parentView: UIView, imageArray: [UIImage?], imageIndex: Int, iconId: Int){
//        var delayNumber = 1.0
////        print("something")
////        switch iconId {
////        case 1:
////            delayNumber = 1.0
////            print("case1")
////
////        case 2:
////            delayNumber = 2.5
////            print("case2")
////
////        case 3:
////            delayNumber = 4.15
////            print("case3")
////
////        default:
////            delayNumber = 1.0
////        }
//
//        if(imageIndex == imageArray.count){
//              icon.image = imageArray[0]
//        } else {
//              icon.image = imageArray[imageIndex]
//        }
//
//        var customTransform = icon.transform
//        customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
//        customTransform = customTransform.translatedBy(x: parentView.frame.width/5, y: parentView.frame.height/1.03469388)
//        print(parentView.frame.width)
//        print(parentView.frame.height)
//        customTransform = customTransform.rotated(by: .pi/8)
//
//        UIView.animate(withDuration: 0.6, delay: delayNumber, animations: {
//
//            icon.transform = customTransform
//
//        }, completion: { _ in
//
//            customTransform = customTransform.translatedBy(x: parentView.frame.width, y: parentView.frame.height/5.07)
//            customTransform = customTransform.scaledBy(x: 2, y: 2)
//            customTransform = customTransform.rotated(by: -.pi/10)
//
//            UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                icon.transform = customTransform
//
//            }, completion: { _ in
//
//                customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
//                customTransform = customTransform.rotated(by: -.pi/3)
//                UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                    icon.transform = customTransform.translatedBy(x: parentView.frame.width, y: 0)
//
//                }, completion: { _ in
//                    icon.transform = .identity
//                    if(!self.inBackground){
//                        if(imageIndex == imageArray.count){
//                             self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: 0, iconId: iconId)
//                        } else {
//                              self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: imageIndex+1, iconId: iconId)
//                        }
//                    }
//                })
//
//            })
//        })
//    }
//        func animateIcon2(icon: UIImageView, parentView: UIView, imageArray: [UIImage?], imageIndex: Int, iconId: Int){
//            var delayNumber = 2.5
//    //        print("something")
//    //        switch iconId {
//    //        case 1:
//    //            delayNumber = 1.0
//    //            print("case1")
//    //
//    //        case 2:
//    //            delayNumber = 2.5
//    //            print("case2")
//    //
//    //        case 3:
//    //            delayNumber = 4.15
//    //            print("case3")
//    //
//    //        default:
//    //            delayNumber = 1.0
//    //        }
//
//            if(imageIndex == imageArray.count){
//                  icon.image = imageArray[0]
//            } else {
//                  icon.image = imageArray[imageIndex]
//            }
//
//            var customTransform = icon.transform
//            customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
//            customTransform = customTransform.translatedBy(x: 75, y: 245)
//            customTransform = customTransform.rotated(by: .pi/8)
//
//            UIView.animate(withDuration: 0.6, delay: delayNumber, animations: {
//
//                icon.transform = customTransform
//
//            }, completion: { _ in
//
//                customTransform = customTransform.translatedBy(x: 375, y: 50)
//                customTransform = customTransform.scaledBy(x: 2, y: 2)
//                customTransform = customTransform.rotated(by: -.pi/10)
//
//                UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                    icon.transform = customTransform
//
//                }, completion: { _ in
//
//                    customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
//                    customTransform = customTransform.rotated(by: -.pi/3)
//                    UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                        icon.transform = customTransform.translatedBy(x: 300, y: 0)
//
//                    }, completion: { _ in
//                        icon.transform = .identity
//                        if(!self.inBackground){
//                            if(imageIndex == imageArray.count){
//                                 self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: 0, iconId: iconId)
//                            } else {
//                                  self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: imageIndex+1, iconId: iconId)
//                            }
//                        }
//                    })
//
//                })
//            })
//        }
//
//        func animateIcon3(icon: UIImageView, parentView: UIView, imageArray: [UIImage?], imageIndex: Int, iconId: Int){
//            var delayNumber = 4.15
//    //        print("something")
//    //        switch iconId {
//    //        case 1:
//    //            delayNumber = 1.0
//    //            print("case1")
//    //
//    //        case 2:
//    //            delayNumber = 2.5
//    //            print("case2")
//    //
//    //        case 3:
//    //            delayNumber = 4.15
//    //            print("case3")
//    //
//    //        default:
//    //            delayNumber = 1.0
//    //        }
//
//            if(imageIndex == imageArray.count){
//                  icon.image = imageArray[0]
//            } else {
//                  icon.image = imageArray[imageIndex]
//            }
//
//            var customTransform = icon.transform
//            customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
//            customTransform = customTransform.translatedBy(x: 75, y: 245)
//            customTransform = customTransform.rotated(by: .pi/8)
//
//            UIView.animate(withDuration: 0.6, delay: delayNumber, animations: {
//
//                icon.transform = customTransform
//
//            }, completion: { _ in
//
//                customTransform = customTransform.translatedBy(x: 375, y: 50)
//                customTransform = customTransform.scaledBy(x: 2, y: 2)
//                customTransform = customTransform.rotated(by: -.pi/10)
//
//                UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                    icon.transform = customTransform
//
//                }, completion: { _ in
//
//                    customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
//                    customTransform = customTransform.rotated(by: -.pi/3)
//                    UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                        icon.transform = customTransform.translatedBy(x: 300, y: 0)
//
//                    }, completion: { _ in
//                        icon.transform = .identity
//                        if(!self.inBackground){
//                            if(imageIndex == imageArray.count){
//                                 self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: 0, iconId: iconId)
//
//                            } else {
//                                  self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray, imageIndex: imageIndex+1, iconId: iconId)
//                            }
//                        }
//                    })
//
//                })
//            })
//        }
//
//    var counter2 = 0
//    func animateSecondIcon(icon: UIImageView, parentView: UIView, imageArray: [UIImage?]){
//
//        if(counter2 == imageArray.count-1){
//            counter2 = 0
//        }
//        icon.image = imageArray[counter2]
//        counter2 = counter2 + 1
//
//        var customTransform = icon.transform
//        customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
//        customTransform = customTransform.translatedBy(x: 75, y: 245)
//        customTransform = customTransform.rotated(by: .pi/8)
//
//        UIView.animate(withDuration: 0.6, delay: 2.5, animations: {
//
//            icon.transform = customTransform
//
//        }, completion: { _ in
//
//            customTransform = customTransform.translatedBy(x: 375, y: 50)
//            customTransform = customTransform.scaledBy(x: 2, y: 2)
//            customTransform = customTransform.rotated(by: -.pi/10)
//
//            UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                icon.transform = customTransform
//
//            }, completion: { _ in
//
//                customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
//                customTransform = customTransform.rotated(by: -.pi/3)
//                UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                    icon.transform = customTransform.translatedBy(x: 300, y: 0)
//
//                }, completion: { _ in
//                    icon.transform = .identity
//                    if(!self.inBackground){
//                    self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray)
//                    }
//                })
//
//            })
//        })
//    }
//        var counter3 = 0
//        func animateThirdIcon(icon: UIImageView, parentView: UIView, imageArray: [UIImage?]){
//
//            if(counter3 == imageArray.count-1){
//                counter3 = 0
//            }
//            icon.image = imageArray[counter3]
//            counter3 = counter3 + 1
//
//            var customTransform = icon.transform
//            customTransform = customTransform.scaledBy(x: 0.7, y: 0.7)
//            customTransform = customTransform.translatedBy(x: 75, y: 245)
//            customTransform = customTransform.rotated(by: .pi/8)
//
//            UIView.animate(withDuration: 0.6, delay: 4.15, animations: {
//
//                icon.transform = customTransform
//
//            }, completion: { _ in
//
//                customTransform = customTransform.translatedBy(x: 375, y: 50)
//                customTransform = customTransform.scaledBy(x: 2, y: 2)
//                customTransform = customTransform.rotated(by: -.pi/10)
//
//                UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                    icon.transform = customTransform
//
//                }, completion: { _ in
//
//                    customTransform = customTransform.scaledBy(x: 2.5, y: 2.5)
//                    customTransform = customTransform.rotated(by: -.pi/3)
//                    UIView.animate(withDuration: 0.6, delay: 1, animations: {
//                        icon.transform = customTransform.translatedBy(x: 300, y: 0)
//
//                    }, completion: { _ in
//                        icon.transform = .identity
//                        if(!self.inBackground){
//                        self.animateIcon(icon: icon, parentView: parentView, imageArray: imageArray)
//                        }
//                    })
//                })
//            })
//        }
//
//
    func deselectButtons(button1: UIButton, button2:UIButton, button3:UIButton, button4:UIButton, buttonAll: UIButton, index: Int){
        if(index == 1){
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)

            button2.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button3.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button4.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            buttonAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)

        }
        else if(index == 2){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)

            button1.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button3.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button4.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            buttonAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
        }
        else if(index == 3){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)

            button1.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button2.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button4.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            buttonAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
        }
        else if(index == 4){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            buttonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)

            button1.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button2.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button3.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            buttonAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
        }
        else if(index == 5){
            button1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeftWhite"), for: .normal)
            button2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)
            button4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddleWhite"), for: .normal)

            button1.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button2.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button3.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            button4.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
        }
    }

    func deselectDistButtons(buttonDist1: UIButton, buttonDist2:UIButton, buttonDist3:UIButton, buttonDist4:UIButton, buttonDistAll: UIButton, index: Int){
        if(index == 1){
            buttonDist2.setBackgroundImage(#imageLiteral(resourceName: "bike_unselected"), for: .normal)
            buttonDist3.setBackgroundImage(#imageLiteral(resourceName: "car_unselected"), for: .normal)
            buttonDist4.setBackgroundImage(#imageLiteral(resourceName: "far_unselected"), for: .normal)
            buttonDistAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
            buttonDistAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
            print("1")
        }
        else if(index == 2){
            buttonDist1.setBackgroundImage(#imageLiteral(resourceName: "walk_unselected"), for: .normal)
            buttonDist3.setBackgroundImage(#imageLiteral(resourceName: "car_unselected"), for: .normal)
            buttonDist4.setBackgroundImage(#imageLiteral(resourceName: "far_unselected"), for: .normal)
            buttonDistAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
            buttonDistAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
        }
        else if(index == 3){
            buttonDist1.setBackgroundImage(#imageLiteral(resourceName: "walk_unselected"), for: .normal)
            buttonDist2.setBackgroundImage(#imageLiteral(resourceName: "bike_unselected"), for: .normal)
            buttonDist4.setBackgroundImage(#imageLiteral(resourceName: "far_unselected"), for: .normal)
            buttonDistAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
            buttonDistAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
        }
        else if(index == 4){
            buttonDist1.setBackgroundImage(#imageLiteral(resourceName: "walk_unselected"), for: .normal)
            buttonDist2.setBackgroundImage(#imageLiteral(resourceName: "bike_unselected"), for: .normal)
            buttonDist3.setBackgroundImage(#imageLiteral(resourceName: "car_unselected"), for: .normal)
            buttonDistAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRightWhite"), for: .normal)
            buttonDistAll.setTitleColor(#colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1), for: .normal)
        }
        else if(index == 5){
            buttonDist1.setBackgroundImage(#imageLiteral(resourceName: "walk_unselected"), for: .normal)
            buttonDist2.setBackgroundImage(#imageLiteral(resourceName: "bike_unselected"), for: .normal)
            buttonDist3.setBackgroundImage(#imageLiteral(resourceName: "car_unselected"), for: .normal)
            buttonDist4.setBackgroundImage(#imageLiteral(resourceName: "far_unselected"), for: .normal)
        }
    }
}
