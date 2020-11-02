//
//  AuthManager.swift
//  piq
//
//  Created by John Kim on 8/8/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import FirebaseAuth

//Network calls to all Authentication related tasks
class AuthManager{
    
    let userDefault = UserDefaults.standard
    
    func login(viewController: UIViewController, email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if let e = error{
                let alert = UIAlertController(title: "uh oh", message: e.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok sorry", style: .default, handler: { action in}))
                viewController.present(alert, animated: true, completion: nil)
            } else {
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()

                viewController.performSegue(withIdentifier: "LoginToMain", sender: self)
            }
        }
    }
    
    func register(viewController: UIViewController, email: String, password: String, name: String){
        
        //registering using email + password
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error{
                let alert = UIAlertController(title: "uh oh", message: e.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok sorry", style: .default, handler: { action in }))
                viewController.present(alert, animated: true, completion: nil)
            } else {
                //saving name with change request
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { (error) in
                    print("error saving display name of current user \(error)")
                }
                self.userDefault.set(true, forKey: "usersignedin")
                self.userDefault.synchronize()
                
                viewController.performSegue(withIdentifier: "RegisterToMain", sender: self)
            }
        }
    }
    
    func getDisplayName() -> String?{
        let displayName = Auth.auth().currentUser?.displayName
        
        return displayName
    }
    
    
}
