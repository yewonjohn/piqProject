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
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var passwordValidateTextField: AuthTextField!
    
    // MARK: - Properties
    let backgroundImageView = UIImageView()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()

        //set background
        ServiceUtil().setAuthBackground(view,backgroundImageView)
        
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    // MARK: - IBActions & Objc Functions
    @IBAction func register(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let passwordValidate = passwordValidateTextField.text{
            if(password == passwordValidate){
                
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error{
                        let alert = UIAlertController(title: "uh oh", message: e.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok sorry", style: .default, handler: { action in }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.performSegue(withIdentifier: "RegisterToMain", sender: self)
                    }
                }
            }else {
                let alert = UIAlertController(title: "uh oh", message: "password doesn't match!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok sorry", style: .default, handler: { action in}))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}

    //MARK: -- Keyboard Management
extension RegisterViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
