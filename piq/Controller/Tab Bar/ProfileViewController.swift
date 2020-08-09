//
//  ProfileViewController.swift
//  piq
//
//  Created by John Kim on 8/8/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = "Sign Out"
        cell.textLabel?.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        
        return cell
    }
    
    //Takes user to yelp page of selected favorite item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //deselects after selecting
        tableView.deselectRow(at: indexPath, animated: true)

        if(indexPath.row == 0){
            let alert = UIAlertController(title: "Logout?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            alert.addAction(UIAlertAction(title: "Yes, logout", style: .destructive, handler: { action in
                  switch action.style{
                  case .default:
                    print("cancel")
                  case .cancel:
                    print("cancel")
                  case .destructive:
                    do { try Auth.auth().signOut() }
                    catch { print("already logged out") }
                    self.userDefault.set(false, forKey: "usersignedin")
                    self.userDefault.synchronize()
                    self.navigationController?.popToRootViewController(animated: true)
                }}))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
