//
//  RegisterViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import IQKeyboardManager
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dynamic keyboard
        IQKeyboardManager.shared().isEnabled = true
        //set background
        Background().setAuthBackground(view,backgroundImageView)
        
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    @IBAction func register(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    let alert = UIAlertController(title: "uh oh", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok sorry", style: .default, handler: { action in }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "RegisterToMain", sender: self)
                }
            }
        }
    }
}
