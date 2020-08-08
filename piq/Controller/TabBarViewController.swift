//
//  TabBarViewController.swift
//  piq
//
//  Created by John Kim on 8/2/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController{
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitle = String()
    var dollarSign : String?
    var distance : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        //passing info
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
        
        vc.categoriesArr = categoriesArr
        vc.categoriesTitle = categoriesTitle
        vc.dollarSign = dollarSign
        vc.distance = distance
        
    }
    
    //MARK: - Segues
    //cancel button segue
    @IBAction func unwindToCards(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
        
        vc.triggerShadowView()
        
    }
    //apply button segue
    @IBAction func unwindWithInfo(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
        
        vc.triggerShadowView()
        
        vc.categoriesArr = categoriesArr
        vc.categoriesTitle = categoriesTitle
        vc.dollarSign = dollarSign
        vc.distance = distance
        vc.getCards()
    }
}

extension TabBarViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            if(viewController == self.viewControllers?[1]){
                UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCurlUp], completion: nil)

            }
            else{
                UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCurlDown], completion: nil)
            }
        }
        
        return true
    }
}
