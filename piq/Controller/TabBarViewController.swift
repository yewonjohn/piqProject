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

        
        //Making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Hides back button from this view
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
}
