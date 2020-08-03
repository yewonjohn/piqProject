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

class HomePageViewController: UIViewController{
    
    
    // MARK: - Outlets
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    // MARK: - Properties
    let backgroundImageView = UIImageView()
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = HomePage.categoriesLabels
    var categoriesImages = HomePage.categoriesUIImages
    var titleParam = String()
    var dollarSignsParam = String()
    var distanceParam = Int()
    let favoritesVC = FavoritesViewController()
    
    let userDefault = UserDefaults.standard
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnabled = true
        self.hideKeyboardWhenTappedAround()
        
        //Fetching categories data from json file
        guard let jsonCategories = readLocalFile(forName: "categories") else { return }
        parse(jsonData: jsonCategories)
        
        //Sets background
        ServiceUtil().setAuthBackground(view,backgroundImageView)
        addFavoriteVC()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        categoryCollectionView.allowsSelection = true
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    //MARK: - Segue
    @IBAction func goToCards(_ sender: UIButton) {
        self.performSegue(withIdentifier: "HomeToCards", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCards" {
            let controller = segue.destination as! TabBarViewController
            controller.categoriesArr = categoriesArr
            controller.categoriesTitle = titleParam
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

//MARK: - Categories Collection Delegates
extension HomePageViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        titleParam = categoriesTitles[indexPath.row]
    }

}

//MARK: - Categories Collection Data Source
extension HomePageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        cell.dataImage = categoriesImages[indexPath.row]
        cell.dataTitle = categoriesTitles[indexPath.row]
        return cell
    }
}

//MARK: - Categories Collection Delegate Flow Layout
extension HomePageViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 123, height: 180)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
    }
}
