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

class HomePageViewController: UIViewController, MenuControllerDelegate{
    
    let backgroundImageView = UIImageView()
    var sideMenu: SideMenuNavigationController?
    
    let favoritesVC = FavoritesViewController()

    @IBAction func goToCards(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToCards", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menu = MenuListController(with: ["Home","Favorites"])
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
//        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //hides back button from this view
        self.navigationItem.setHidesBackButton(true, animated: false)

        
        
        Background().setAuthBackground(view,backgroundImageView)
        addChildVCs()
    }
    @IBAction func didTapMenu(){
        present(sideMenu!,animated: true)
    }
    
    func addChildVCs(){
        addChild(favoritesVC)
        view.addSubview(favoritesVC.view)
        favoritesVC.view.frame = view.bounds
        
        favoritesVC.didMove(toParent: self)
        favoritesVC.view.isHidden = true
    }
    
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: nil)
        
        title = named
        
        if named == "Home"{
            favoritesVC.view.isHidden = true
            
        }
        else if named == "Favorites"{
            favoritesVC.view.isHidden = false
        }
    }
}

    
    
    
    



