//
//  ViewController.swift
//  piq
//
//  Created by John Kim on 6/19/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import IQKeyboardManager
import FirebaseAuth
import SwiftyJSON
import CoreLocation


class SearchPageViewController: UIViewController{
    
    // MARK: - Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var findFoodButton: FoodButton!
    @IBOutlet weak var piqLabel: UILabel!

    //outlets for all dollarSign buttons
    @IBOutlet weak var costStackView: UIStackView!
    @IBOutlet weak var costButton1: UIButton!
    @IBOutlet weak var costButton2: UIButton!
    @IBOutlet weak var costButton3: UIButton!
    @IBOutlet weak var costButton4: UIButton!
    @IBOutlet weak var costButtonAll: UIButton!

    //outlets for all distance buttons
    @IBOutlet weak var distanceStackView: UIStackView!
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var carButton: UIButton!
    @IBOutlet weak var farButton: UIButton!
    @IBOutlet weak var anyButton: UIButton!

    //constraints
    @IBOutlet weak var costRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var costLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var distanceRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var distanceLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionHeight: NSLayoutConstraint!
    
    
    // MARK: - Properties
    let backgroundImageView = UIImageView()
    var locationManager = CLLocationManager()
    let userDefault = UserDefaults.standard
    let service = ServiceUtil()
    var isFirstTimeOpening = true

    var categoriesArr = [CategoryModel]()
    var categoriesTitles = SearchPage.categoriesLabels
    var categoriesImages = SearchPage.categoriesUIImages
    var categoriesIndexArr = [Int]()
    var categoriesTitlesParam = [String]()
    var dollarSignsParam = String()
    var distanceParam = Double()
    let favoritesVC = FavoritesViewController()
    var sidePresented = false
    
    //translation var for dismiss gesture
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    // MARK: - View Controller Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutConfig()
        fetchCategories()
        collectionViewConfig()
        
    }
    
    override func viewWillLayoutSubviews() {
        if isFirstTimeOpening {
              isFirstTimeOpening = false
              //Asking for location permission if not already
              locationManager.requestWhenInUseAuthorization()
              
            //sets views differently depending where this VC is called
              switch sidePresented {
              case true:
                sidePresentedConfig()
              default:
                  findFoodButton.setTitle("Find my meal!", for: .normal)
                  cancelButton.isHidden = true

              }
        }
    }
    // MARK:- UI Configurations
    
    func collectionViewConfig(){
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        categoryCollectionView.allowsSelection = true
        categoryCollectionView.allowsMultipleSelection = true
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    }
    func layoutConfig(){
        costStackView.heightAnchor.constraint(equalTo: costStackView.widthAnchor, multiplier: 0.13).isActive = true
        distanceStackView.heightAnchor.constraint(equalTo: distanceStackView.widthAnchor, multiplier: 0.13).isActive = true
        categoryTitleTopConstraint.constant = self.view.frame.height * 0.2
        categoryCollectionHeight.constant = self.view.frame.height * 0.2
        
        dollarSignsParam = "0"
        //Sets background
        ServiceUtil().setBackground(view,backgroundImageView)
    }
    func fetchCategories(){
        //Fetching categories data from json file
        guard let jsonCategories = readLocalFile(forName: "categories") else { return }
        parse(jsonData: jsonCategories)
    }
    
    func sidePresentedConfig(){
        findFoodButton.setTitle("Apply", for: .normal)
        cancelButton.isHidden = false
        piqLabel.isHidden = true
        
        //set constraints
        costLeftConstraint.constant = 25
        costRightConstraint.constant = 25
        distanceLeftConstraint.constant = 25
        distanceRightConstraint.constant = 25
        
        let gesturePan = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(gesturePan)
    }
    
    
    // MARK: - User Interactions
    @IBAction func costButtonClicked(_ sender: UIButton) {
        switch sender {
        case costButton1:
            costButton1.setBackgroundImage(#imageLiteral(resourceName: "buttonLeft"), for: .normal)
            costButton1.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dollarSignsParam = "1"
            service.deselectButtons(button1: costButton1, button2: costButton2, button3: costButton3, button4: costButton4, buttonAll: costButtonAll, index: 1)
        case costButton2:
            costButton2.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddle"), for: .normal)
            costButton2.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dollarSignsParam = "2"
            service.deselectButtons(button1: costButton1, button2: costButton2, button3: costButton3, button4: costButton4, buttonAll: costButtonAll, index: 2)
        case costButton3:
            costButton3.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddle"), for: .normal)
            costButton3.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dollarSignsParam = "3"
            service.deselectButtons(button1: costButton1, button2: costButton2, button3: costButton3, button4: costButton4, buttonAll: costButtonAll, index: 3)
        case costButton4:
            costButton4.setBackgroundImage(#imageLiteral(resourceName: "buttonMiddle"), for: .normal)
            costButton4.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dollarSignsParam = "4"
            service.deselectButtons(button1: costButton1, button2: costButton2, button3: costButton3, button4: costButton4, buttonAll: costButtonAll, index: 4)
        case costButtonAll:
            costButtonAll.setBackgroundImage(#imageLiteral(resourceName: "buttonRight"), for: .normal)
            costButtonAll.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            dollarSignsParam = "0"
            service.deselectButtons(button1: costButton1, button2: costButton2, button3: costButton3, button4: costButton4, buttonAll: costButtonAll, index: 5)
        default:
            dollarSignsParam = "0"
        }
    }
    
    @IBAction func distanceButtonSelected(_ sender: UIButton) {
        switch sender {
        case walkButton:
            walkButton.setBackgroundImage(#imageLiteral(resourceName: "walk_selected"), for: .normal)
            distanceLabel.text = "0.5 mi"
            distanceParam = 0.5
            service.deselectDistButtons(buttonDist1: walkButton, buttonDist2: bikeButton, buttonDist3: carButton, buttonDist4: farButton, buttonDistAll: anyButton, index: 1)
        case bikeButton:
            bikeButton.setBackgroundImage(#imageLiteral(resourceName: "bike_selected"), for: .normal)
            distanceLabel.text = "1.0 mi"
            distanceParam = 1.0
            service.deselectDistButtons(buttonDist1: walkButton, buttonDist2: bikeButton, buttonDist3: carButton, buttonDist4: farButton, buttonDistAll: anyButton, index: 2)
        case carButton:
            carButton.setBackgroundImage(#imageLiteral(resourceName: "car_selected"), for: .normal)
            distanceLabel.text = "1.5 mi"
            distanceParam = 1.5
            service.deselectDistButtons(buttonDist1: walkButton, buttonDist2: bikeButton, buttonDist3: carButton, buttonDist4: farButton, buttonDistAll: anyButton, index: 3)
        case farButton:
            farButton.setBackgroundImage(#imageLiteral(resourceName: "far_selected"), for: .normal)
            distanceLabel.text = "2.0 mi"
            distanceParam = 2.0
            service.deselectDistButtons(buttonDist1: walkButton, buttonDist2: bikeButton, buttonDist3: carButton, buttonDist4: farButton, buttonDistAll: anyButton, index: 4)
        case anyButton:
            distanceLabel.text = "∞"
            anyButton.setBackgroundImage(#imageLiteral(resourceName: "buttonRight"), for: .normal)
            anyButton.titleLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            distanceParam = 0.0
            service.deselectDistButtons(buttonDist1: walkButton, buttonDist2: bikeButton, buttonDist3: carButton, buttonDist4: farButton, buttonDistAll: anyButton, index: 5)
        default:
            distanceParam = 0.0
        }
    }
    
    //Segues
    @IBAction func goSearch(_ sender: UIButton) {
        switch sidePresented {
        case true:
            self.performSegue(withIdentifier: "unwindWithInfo", sender: self)
        default:
            self.performSegue(withIdentifier: "HomeToCards", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToCards" {
            setCategoriesTitles()
            let controller = segue.destination as! TabBarViewController
            controller.categoriesArr = categoriesArr
            controller.categoriesTitles = categoriesTitlesParam
            controller.dollarSign = dollarSignsParam
            controller.distance = distanceParam
            controller.selectedIndex = 1
        }
        if segue.identifier == "unwindWithInfo" {
            setCategoriesTitles()
            let controller = segue.destination as! TabBarViewController
            controller.categoriesArr = categoriesArr
            controller.categoriesTitles = categoriesTitlesParam
            controller.dollarSign = dollarSignsParam
            controller.distance = distanceParam
        }
    }
    @IBAction func dismissView(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToCards", sender: self)
        //setting shadowView in RestaurantVC to hidden
    }
}



//MARK: -- 	Search Configuration
extension SearchPageViewController{

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

//MARK: - Categories Collection Delegates (Config)
extension SearchPageViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            categoriesIndexArr.append(indexPath.row)
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(categoriesIndexArr.contains(indexPath.row)){
            if let index = categoriesIndexArr.firstIndex(of: indexPath.row) {
                categoriesIndexArr.remove(at: index)
            }
        }
    }
    //not a delegate function
    func setCategoriesTitles(){
        if(categoriesIndexArr.contains(0) || categoriesIndexArr.isEmpty){
            categoriesTitlesParam = [""]
        } else{
            for index in 0...categoriesIndexArr.count-1 {
                let tempIndex = categoriesIndexArr[index]
                categoriesTitlesParam.append(categoriesTitles[tempIndex])
            }
        }
    }
}

//MARK: - Categories Collection Delegate (Data Source)
extension SearchPageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        cell.layer.cornerRadius = 15
        cell.layer.masksToBounds = true
        cell.dataImage = categoriesImages[indexPath.row]
        cell.dataTitle = categoriesTitles[indexPath.row]
        return cell
    }
}

//MARK: - Categories Collection Delegate (Framing)
extension SearchPageViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.height * 0.6, height: collectionView.frame.height * 0.9)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
    }
}

//MARK: - Handlers
extension SearchPageViewController{
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: view)
            
            if(viewTranslation.x > 0){
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: self.viewTranslation.x, y: 0)
            })
            }
        case .ended:
            if viewTranslation.x < 55 {
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                self.performSegue(withIdentifier: "unwindToCards", sender: self)
            }
        default:
            break
        }
    }
}
