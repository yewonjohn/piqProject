//
//  ViewController.swift
//  piq
//
//  Created by John Kim on 6/19/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import IQKeyboardManager

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var animatingIcon: UIImageView!
    @IBOutlet weak var animatingIcon2: UIImageView!
    @IBOutlet weak var animatingIcon3: UIImageView!

    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHeight: NSLayoutConstraint!
    @IBOutlet weak var signInHeight: NSLayoutConstraint!
    
    
    
    // MARK: - Properties
    let userDefault = UserDefaults.standard
    let service = ServiceUtil()
    let auth = AuthManager()
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerHeight.constant = self.view.frame.height * 0.65
        emailHeight.constant = self.view.frame.height * 0.055
        passwordHeight.constant = self.view.frame.height * 0.055
        signInHeight.constant = self.view.frame.height * 0.055

        
//        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.70).isActive = true

        if userDefault.bool(forKey: "usersignedin") {
            self.performSegue(withIdentifier: "LoginToMain", sender: self)
        }
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()

        //
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        //making navigation bar transparent
        self.navigationController?.setup()
        
        service.animateIcon(icon: animatingIcon, parentView: animationContainerView, imageArray: AuthPage.animationIcons, imageIndex: 0, iconId: 1)
        service.animateIcon(icon: animatingIcon2, parentView: animationContainerView, imageArray: AuthPage.animationIcons2, imageIndex: 0, iconId: 2)
        service.animateIcon(icon: animatingIcon3, parentView: animationContainerView, imageArray: AuthPage.animationIcons3, imageIndex: 0, iconId: 3)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        service.backgroundTrigger()
    }

    // MARK: - IBActions & Objc Functions
    @IBAction func loginUser(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            auth.login(viewController: self, email: email, password: password)
        }
    }
    
    @IBAction func goToRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "loginToRegister", sender: self)
    }

}
//    //MARK: -- Keyboard Management
//extension LoginViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

