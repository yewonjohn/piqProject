//
//  RegisterViewController.swift
//  piq
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
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var greetingHeight: NSLayoutConstraint!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHeight: NSLayoutConstraint!
    @IBOutlet weak var validateHeight: NSLayoutConstraint!
    @IBOutlet weak var registerHeight: NSLayoutConstraint!
    
    
    
    // MARK: - Properties
    let auth = AuthManager()
    let service = ServiceUtil()
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerHeight.constant = self.view.frame.height * 0.65
        greetingHeight.constant = self.view.frame.height * 0.05
        nameHeight.constant = self.view.frame.height * 0.055
        emailHeight.constant = self.view.frame.height * 0.055
        passwordHeight.constant = self.view.frame.height * 0.055
        validateHeight.constant = self.view.frame.height * 0.055
        registerHeight.constant = self.view.frame.height * 0.055

        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()
        
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        //making navigation bar transparent
        self.navigationController?.setup()

        
        service.animateIcon(icon: animationIcon, parentView: animationContainer, imageArray: AuthPage.animationIcons, imageIndex: 0, iconId: 1)
        service.animateIcon(icon: animationIcon2, parentView: animationContainer, imageArray: AuthPage.animationIcons2, imageIndex: 0, iconId: 2)
        service.animateIcon(icon: animationIcon3, parentView: animationContainer, imageArray: AuthPage.animationIcons3, imageIndex: 0, iconId: 3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         service.backgroundTrigger()
     }
    // MARK: - IBActions & Objc Functions
    
    @IBAction func goToLogin(_ sender: Any) {
        	navigationController?.popViewController(animated: true)
    }
    
    @IBAction func register(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let passwordValidate = passwordValidateTextField.text{
            if(password == passwordValidate){
                auth.register(viewController: self, email: email, password: password, name: nameTextField.text ?? "")
            }else {
                let alert = UIAlertController(title: "uh oh", message: "password doesn't match!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok sorry", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

    //MARK: -- Keyboard Management
//extension RegisterViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
