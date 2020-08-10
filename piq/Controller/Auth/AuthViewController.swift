//
//  IntialPageViewController.swift
//  piq
//
//  Created by John Kim on 8/3/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

class AuthViewController: UIViewController{
    @IBOutlet weak var containerView: UIView!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = true
        
        if userDefault.bool(forKey: "usersignedin") {
            self.performSegue(withIdentifier: "AuthToHome", sender: self)
        }
        
    }
}
