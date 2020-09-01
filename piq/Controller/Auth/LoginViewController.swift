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
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var animationContainer: UIView!
    @IBOutlet weak var animationIcon: UIImageView!
    @IBOutlet weak var animationIcon2: UIImageView!
    @IBOutlet weak var animationIcon3: UIImageView!

    //constraints
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var introLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    @IBOutlet weak var passwordHeight: NSLayoutConstraint!
    @IBOutlet weak var signInHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var icon2Width: NSLayoutConstraint!
    @IBOutlet weak var icon2Height: NSLayoutConstraint!
    @IBOutlet weak var icon3Height: NSLayoutConstraint!
    @IBOutlet weak var icon3Width: NSLayoutConstraint!
    
    
    // MARK: - Properties
    let userDefault = UserDefaults.standard
    let service = ServiceUtil()
    let auth = AuthManager()
    var backgroundView = UIImageView()
    var isFirstTimeOpening = true

    
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

        iconHeight.constant = self.view.frame.height * 0.1339
        iconWidth.constant = self.view.frame.height * 0.1339
        icon2Width.constant = self.view.frame.height * 0.1339
        icon2Height.constant = self.view.frame.height * 0.1339
        icon3Height.constant = self.view.frame.height * 0.1339
        icon3Width.constant = self.view.frame.height * 0.1339

        
        if userDefault.bool(forKey: "usersignedin") {
            self.performSegue(withIdentifier: "LoginToMain", sender: self)
        }
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.setup()

        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        service.setAuthBackground(view, backgroundView)
        
    }
    override func viewDidLayoutSubviews() {
        
        if isFirstTimeOpening {
              isFirstTimeOpening = false
              service.animateIcon(icon: animationIcon, parentView: animationContainer, imageArray: AuthPage.animationIcons, imageIndex: 0, iconId: 1, firstTimeCalled: true)
              service.animateIcon(icon: animationIcon2, parentView: animationContainer, imageArray: AuthPage.animationIcons2, imageIndex: 0, iconId: 2, firstTimeCalled: true)
              service.animateIcon(icon: animationIcon3, parentView: animationContainer, imageArray: AuthPage.animationIcons3, imageIndex: 0, iconId: 3, firstTimeCalled: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        service.backgroundTrigger()
    }

    // MARK: - User Interactions
    @IBAction func loginUser(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            auth.login(viewController: self, email: email, password: password)
        }
    }
    
    @IBAction func goToRegister(_ sender: Any) {
        self.performSegue(withIdentifier: "loginToRegister", sender: self)
    }

}
