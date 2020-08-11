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
    
    
    //MARK:- Properties
    
    //RestaurantVC properties to pass
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = [String]()
    var dollarSign : String?
    var distance : Double?

    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        //passing info
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
    
        vc.categoriesArr = categoriesArr
        vc.categoriesTitles = categoriesTitles
        vc.dollarSign = dollarSign
        vc.distance = distance
    }
    
    //MARK: - Segues
    
    //'Cancel' button segue
    @IBAction func unwindToCards(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
        vc.triggerShadowView()
    }
    //'Apply' button segue
    @IBAction func unwindWithInfo(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
        
        vc.triggerShadowView()
        
        vc.categoriesArr = categoriesArr
        vc.categoriesTitles = categoriesTitles
        vc.dollarSign = dollarSign
        vc.distance = distance
        vc.getCards()
        
    }
}
//MARK:- Tab Bar Delegate
extension TabBarViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}
