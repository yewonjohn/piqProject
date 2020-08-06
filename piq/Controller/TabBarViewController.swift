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
        
        //passing info
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController

        vc.categoriesArr = categoriesArr
        vc.categoriesTitle = categoriesTitle
        vc.dollarSign = dollarSign
        vc.distance = distance
    }
    
    //MARK: - Segues
    @IBAction func unwindToCards(_ unwindSegue: UIStoryboardSegue) {
           // Use data from the view controller which initiated the unwind segue
       }
    
    @IBAction func unwindWithInfo(_ unwindSegue: UIStoryboardSegue) {
         //let sourceViewController = unwindSegue.source
         // Use data from the view controller which initiated the unwind segue
        print("unwindWIthInfo triggerd")
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController

        vc.categoriesArr = categoriesArr
        vc.categoriesTitle = categoriesTitle
        vc.dollarSign = dollarSign
        vc.distance = distance
        vc.getCards()
        
        
     }
}
