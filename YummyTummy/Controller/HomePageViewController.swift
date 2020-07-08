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
import SideMenu

class HomePageViewController: UIViewController {
    let backgroundImageView = UIImageView()
    
    var menu: SideMenuNavigationController?

    @IBAction func goToCards(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MainToCards", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
//        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //hides back button from this view
        self.navigationItem.setHidesBackButton(true, animated: false)

        
        
        Background().setAuthBackground(view,backgroundImageView)
        
        
        
    }
    @IBAction func didTapMenu(){
        present(menu!,animated: true)
    }
}

class MenuListController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.9204136133, green: 0.9190739989, blue: 0.9415156245, alpha: 1)

    }
    var items = ["Home","Favorites"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.9204136133, green: 0.9190739989, blue: 0.9415156245, alpha: 1)
        cell.imageView?.tintColor = #colorLiteral(red: 0.6624035239, green: 0, blue: 0.08404419571, alpha: 1)

        if(items[indexPath.row] == "Favorites"){
            cell.imageView?.image = UIImage(systemName: "star")
        }
        if(items[indexPath.row] == "Home"){
            cell.imageView?.image = UIImage(systemName: "house")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(items[indexPath.row] == "Favorites"){
            self.performSegue(withIdentifier: "MainToFavorites", sender: self)
        }
    }
    
}
