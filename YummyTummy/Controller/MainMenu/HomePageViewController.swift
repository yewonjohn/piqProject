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
import SwiftyJSON
import SearchTextField

class HomePageViewController: UIViewController, MenuControllerDelegate{
    
    let backgroundImageView = UIImageView()
    var sideMenu: SideMenuNavigationController?
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = [String]()
    var dollarSignsParam = String()
    let favoritesVC = FavoritesViewController()
    
    
    
    @IBOutlet weak var searchCategory: SearchTextField!
    @IBOutlet weak var dollarSign: UILabel!
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
            switch currentValue {
            case 0:
                    self.dollarSign.text = "No Preference"
                    dollarSignsParam = "0"
            case 1:
                    self.dollarSign.text = "$"
                    dollarSignsParam = "1"
            case 2:
                    self.dollarSign.text = "$$"
                    dollarSignsParam = "2"
            case 3:
                    self.dollarSign.text = "$$$"
                    dollarSignsParam = "3"
            case 4:
                    self.dollarSign.text = "$$$$"
                    dollarSignsParam = "4"
            default:
                    self.dollarSign.text = "No Preference"
                    dollarSignsParam = "0"
            }
    }
    @IBAction func goToCards(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToCards", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCards" {
            let controller = segue.destination as! BusinessViewController
            controller.categoriesArr = categoriesArr
            controller.categoriesTitle = searchCategory.text ?? ""
            controller.dollarSign = dollarSignsParam
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()
        
        //json for categories
        guard let jsonCategories = readLocalFile(forName: "categories") else { return }
        parse(jsonData: jsonCategories)
        configureCategories(categories: categoriesArr)
        
        let menu = MenuListController(with: ["","Home","Favorites","Logout"])
        menu.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        
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
        if(named != ""){
            sideMenu?.dismiss(animated: true, completion: nil)
        }
        title = named
        
        if named == "Home"{
            favoritesVC.view.isHidden = true
            searchCategory.isHidden = false
            
        }
        else if named == "Favorites"{
            favoritesVC.view.isHidden = false
            searchCategory.isHidden = true
            searchCategory.endEditing(true)
        }
        else if named == "Logout"{
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                _ = navigationController?.popViewController(animated: true)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //            appDelegate.window! = UIWindow(frame: UIScreen.main.bounds)
            //            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //
            //            let view = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            //            appDelegate.window!.rootViewController = view
        }
    }
    
}

//MARK -- 	Search options
extension HomePageViewController{
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode([CategoryModel].self, from: jsonData)
            
            categoriesArr = decodedData
            
        } catch {
            print("decode error \(error)")
        }
    }
    
    private func configureCategories(categories: [CategoryModel]){
        for category in categories{
            if let parent = category.parents{
                if (parent.contains("food") || parent.contains("bars") || parent.contains("restaurants")){
                    if let title = category.title{
                        if let blacklist = category.countryBlacklist{
                            if !(blacklist.contains("US")){
                                categoriesTitles.append(title)
                            }
                        } else{
                            categoriesTitles.append(title)
                        }
                    }
                }else{continue}
            }
        }
        
        searchCategory.filterStrings(categoriesTitles)
        searchCategory.startVisible = true
        
    }
    
}





extension HomePageViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePageViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
