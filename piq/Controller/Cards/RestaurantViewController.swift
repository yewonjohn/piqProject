//
//  RegisterViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantViewController: UIViewController {
    
    // MARK: - Properties
    
    let emptyCardsLabel = UILabel()
    
    var viewModelData = [BusinessModel]()
    var stackContainer : StackContainerView!
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitle = String()
    var dollarSign : String?
    var distance : Int?
    
    var locationManager = CLLocationManager()
    let backgroundImageView = UIImageView()
    
    // MARK: - View Controller Life Cycle

    override func loadView() {
        //making navigation bar transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        configureResetNavigationBarButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets label for no more cards
        setLastLabel()
        emptyCardsLabel.isHidden = true
        
        //set background
        ServiceUtil().setAuthBackground(view,backgroundImageView)
        
        //get category title alias
        var categoryAlias: String?
        for category in categoriesArr{
            if(category.title == categoriesTitle){
                categoryAlias = category.alias
            }
        }
        if(dollarSign == "0"){
            dollarSign = nil
        }
        if(distance == 0){
            distance = nil
        } else{
            if let dist = distance{
                distance = dist * 1609
            }
        }
        
        //Asking for location permission
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!

        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            
            //Calling API for all the Cards Data using current location
            print(currentLoc.coordinate.latitude)
            RestaurantManager().getLocalRestaurants(distance: distance, latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, category: categoryAlias, dollarSigns: dollarSign) { (businessModelArray) in
                self.viewModelData = businessModelArray
                self.stackContainer.dataSource = self
            }
        }
    }
    
    //MARK: - Configurations
    //SETS CONTAINER CONSTRAINTS
    func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: 350).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    //SETS RESET NAVIGATIONAL BUTTON
    func configureResetNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: MenuItems.reset, style: .plain, target: self, action: #selector(resetTapped))
    }
    //SETS CARDS ARE EMPTY LABEL
    func setLastLabel(){
        self.view?.addSubview(emptyCardsLabel)
        emptyCardsLabel.textColor = .black
        emptyCardsLabel.textAlignment = .center
        emptyCardsLabel.font = UIFont.systemFont(ofSize: 18)
        emptyCardsLabel.text = RestaurantVC.emptyCardsText
        emptyCardsLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyCardsLabel.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
        emptyCardsLabel.centerYAnchor.constraint(equalTo: self.view!.centerYAnchor).isActive = true
    }
    
    // MARK: - IBActions & Objc Functions
    
    @objc func resetTapped() {
        stackContainer.reloadData()
        emptyCardsLabel.isHidden = true
    }
}
//MARK: - DataSource for StackContainerView (Delegate)

extension RestaurantViewController : BusinessCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> RestaurantCardView {
        let card = RestaurantCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> Void {
        emptyCardsLabel.isHidden = false
    }
}
