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
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    
    //MARK: - Properties
    var accountSettingsLabel = [String]()
    var accountSettingsImages = [UIImage]()
    let userDefault = UserDefaults.standard
    let auth = AuthManager()
    let currentUser = Auth.auth().currentUser

    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        
        accountSettingsLabel = ["Search History", "Password", "Rate Us", "App Feedback", "Logout"]
        accountSettingsImages = [#imageLiteral(resourceName: "History"),#imageLiteral(resourceName: "Lock"),#imageLiteral(resourceName: "Thumbs Up"),#imageLiteral(resourceName: "Comment"),#imageLiteral(resourceName: "Sign Out")]
        
        if((currentUser) == nil){
            accountSettingsLabel[4] = "Login"
            accountSettingsImages[4] = #imageLiteral(resourceName: "Login")
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        tableView.layer.cornerRadius = 30
        
        tableViewHeight.constant = view.frame.height * 0.4
        
        //setting two different colors on one label
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#828282")]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#E86042")]
        let attributedString1 = NSMutableAttributedString(string:"Hello, ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:auth.getDisplayName() ?? "Stranger", attributes:attrs2)
        attributedString1.append(attributedString2)
        fullNameLabel.attributedText = attributedString1
    }
}
//MARK: -- TableView DataSource and Delegate
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettingsLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        //strikethrough labels not yet implemented
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: accountSettingsLabel[indexPath.row])
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        if(indexPath.row != 4){
            cell.settingsImageView.image = accountSettingsImages[indexPath.row]
            cell.settingsLabel.attributedText = attributeString
        }else {
            cell.settingsImageView.image = accountSettingsImages[indexPath.row]
            cell.settingsLabel.text = accountSettingsLabel[indexPath.row]
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (view.frame.height * 0.4)/5
    }
    
    //Takes user to yelp page of selected favorite item.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //deselects after selecting
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 4){
            if((currentUser) != nil){
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
            } else{
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}


