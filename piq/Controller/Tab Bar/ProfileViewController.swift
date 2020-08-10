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
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var accountSettingsLabel = [String]()
    var accountSettingsImages = [UIImage]()
    let userDefault = UserDefaults.standard
    let auth = AuthManager()

    override func viewDidLoad() {
        
        accountSettingsLabel = ["Search History", "Password", "Rate Us", "App Feedback", "Logout"]
        accountSettingsImages = [#imageLiteral(resourceName: "fa-solid_history"),#imageLiteral(resourceName: "Vector"),#imageLiteral(resourceName: "Vector-1"),#imageLiteral(resourceName: "Vector-2"),#imageLiteral(resourceName: "Vector-3")]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        tableView.layer.cornerRadius = 30
        
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#828282")]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-SemiBold", size: 24), NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#E86042")]

        let attributedString1 = NSMutableAttributedString(string:"Hello, ", attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:auth.getDisplayName() ?? "Stranger", attributes:attrs2)

        attributedString1.append(attributedString2)
        self.fullNameLabel.attributedText = attributedString1
    }

    
//    override func viewWillAppear(_ animated: Bool) {
//        tableView.reloadData()
//        self.tableViewHeight.constant = self.tableView.contentSize.height
//    }
    
//    override func viewDidLayoutSubviews() {
//        tableView.frame.size = tableView.contentSize
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountSettingsLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        
        cell.settingsImageView.image = accountSettingsImages[indexPath.row]
        cell.settingsLabel.text = accountSettingsLabel[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69    }
    
    //Takes user to yelp page of selected favorite item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //deselects after selecting
        tableView.deselectRow(at: indexPath, animated: true)

        if(indexPath.row == 4){
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

//MARK:- hexColor Function
extension ProfileViewController{
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
