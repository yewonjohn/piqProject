//
//  RegisterViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import IQKeyboardManager

class RegisterViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextField: AuthTextField!
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var passwordValidateTextField: AuthTextField!
    
    @IBOutlet weak var animationIcon: UIImageView!
    @IBOutlet weak var animationIcon2: UIImageView!
    @IBOutlet weak var animationIcon3: UIImageView!
    
    
    // MARK: - Properties
    let auth = AuthManager()
    let service = ServiceUtil()
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        service.animateIcon(icon: animationIcon, parentView: animationContainer, imageArray: AuthPage.animationIcons)
        service.animateSecondIcon(icon: animationIcon2, parentView: animationContainer, imageArray: AuthPage.animationIcons2)
        service.animateThirdIcon(icon: animationIcon3, parentView: animationContainer, imageArray: AuthPage.animationIcons3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         service.backgroundTrigger()
     }
    // MARK: - IBActions & Objc Functions
    
    @IBAction func goToLogin(_ sender: Any) {
    }
    
    @IBAction func register(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let passwordValidate = passwordValidateTextField.text{
            if(password == passwordValidate){
                auth.register(viewController: self, email: email, password: password, name: nameTextField.text ?? "")
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
