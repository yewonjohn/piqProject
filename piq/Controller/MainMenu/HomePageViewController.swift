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
    
    // MARK: - Outlets
    @IBOutlet weak var searchCategory: SearchTextField!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    

    // MARK: - Properties
    let backgroundImageView = UIImageView()
    var sideMenu: SideMenuNavigationController?
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = [String]()
    var dollarSignsParam = String()
    var distanceParam = Int()
    let favoritesVC = FavoritesViewController()
    
    let userDefault = UserDefaults.standard
    let menu = MenuListController(with: [MenuList.empty,MenuList.home,MenuList.favorites,MenuList.logout])
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()
        
        //Fetching categories data from json file
        guard let jsonCategories = readLocalFile(forName: "categories") else { return }
        parse(jsonData: jsonCategories)
        configureCategories(categories: categoriesArr)
        
        //Side Menu management
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        sideMenu?.presentationStyle = .menuSlideIn
    
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        //Making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Hides back button from this view
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //Sets background
        ServiceUtil().setAuthBackground(view,backgroundImageView)
        addFavoriteVC()
    }

    //MARK: - Segue
    @IBAction func goToCards(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToCards", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCards" {
            let controller = segue.destination as! RestaurantViewController
            controller.categoriesArr = categoriesArr
            controller.categoriesTitle = searchCategory.text ?? ""
            controller.dollarSign = dollarSignsParam
            controller.distance = distanceParam
        }
    }

    //MARK: - Layout Config
    func addFavoriteVC(){
        addChild(favoritesVC)
        view.addSubview(favoritesVC.view)
        favoritesVC.view.frame = view.bounds
        
        favoritesVC.didMove(toParent: self)
        favoritesVC.view.isHidden = true
    }
    
    //MARK: - Side Menu Config
    @IBAction func didTapMenu(){
        present(sideMenu!,animated: true)
    }
    func didSelectMenuItem(named: String) {
        if(named != ""){
            sideMenu?.dismiss(animated: true, completion: nil)
        }
        title = named
        
        if named == MenuList.home{
            favoritesVC.view.isHidden = true
            searchCategory.isHidden = false
        }
        else if named == MenuList.favorites{
            favoritesVC.view.isHidden = false
            searchCategory.isHidden = true
            searchCategory.endEditing(true)
        }
        else if named == MenuList.logout{
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                _ = navigationController?.popViewController(animated: true)
                self.userDefault.set(false, forKey: "usersignedin")
                self.userDefault.synchronize()
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
}

//MARK: -- 	Search Configuration
extension HomePageViewController{
    
    @IBAction func costSliderChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        switch currentValue {
        case 0:
            self.dollarLabel.text = "No preference"
            dollarSignsParam = "0"
        case 1:
            self.dollarLabel.text = "$"
            dollarSignsParam = "1"
        case 2:
            self.dollarLabel.text = "$$"
            dollarSignsParam = "2"
        case 3:
            self.dollarLabel.text = "$$$"
            dollarSignsParam = "3"
        case 4:
            self.dollarLabel.text = "$$$$"
            dollarSignsParam = "4"
        default:
            self.dollarLabel.text = "No preference"
            dollarSignsParam = "0"
        }
    }
    
    @IBAction func distanceSliderMoved(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        switch currentValue {
        case 0:
            self.distanceLabel.text = "0 mi"
            distanceParam = 0
        case 1:
            self.distanceLabel.text = "1 mi"
            distanceParam = 1
        case 2:
            self.distanceLabel.text = "2 mi"
            distanceParam = 2
        case 3:
            self.distanceLabel.text = "3 mi"
            distanceParam = 3
        case 4:
            self.distanceLabel.text = "4 mi"
            distanceParam = 4
        case 5:
            self.distanceLabel.text = "5 mi"
            distanceParam = 5
        case 6:
            self.distanceLabel.text = "6 mi"
            distanceParam = 6
        case 7:
            self.distanceLabel.text = "7 mi"
            distanceParam = 7
        case 8:
            self.distanceLabel.text = "8 mi"
            distanceParam = 8
        case 9:
            self.distanceLabel.text = "9 mi"
            distanceParam = 9
        case 10:
            self.distanceLabel.text = "10 mi"
            distanceParam = 10
        default:
            self.distanceLabel.text = "0 mi"
            distanceParam = 0
        }
    }
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
//MARK: - Keyboard Management
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
