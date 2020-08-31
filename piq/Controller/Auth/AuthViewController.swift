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
    //MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Properties
    let userDefault = UserDefaults.standard
    
    @IBAction func skipForNow(_ sender: UIButton) {
        self.performSegue(withIdentifier: "AuthToHome", sender: self)
    }
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.navigationController?.setup()
        
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        if userDefault.bool(forKey: "usersignedin") {
            self.performSegue(withIdentifier: "AuthToHome", sender: self)
        }
        
    }
}
