//
//  ViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/19/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import IQKeyboardManager
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    
    // MARK: - Properties
    let backgroundImageView = UIImageView()
    let userDefault = UserDefaults.standard
    
    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefault.bool(forKey: "usersignedin") {
            self.performSegue(withIdentifier: "LoginToMain", sender: self)
        }
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()

        Background().setAuthBackground(view,backgroundImageView)
    }
    // Navigation Bar Management
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - IBActions & Objc Functions
    @IBAction func goSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
    @IBAction func loginUser(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error{
                    let alert = UIAlertController(title: "uh oh", message: e.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok sorry", style: .default, handler: { action in}))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.userDefault.set(true, forKey: "usersignedin")
                    self.userDefault.synchronize()

                    self.performSegue(withIdentifier: "LoginToMain", sender: self)
                }
                // ...
            }
        }
    }
    
}
    //MARK: -- Keyboard Management
extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

