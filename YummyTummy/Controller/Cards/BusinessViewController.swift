//
//  RegisterViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessViewController: UIViewController {
    
    //MARK: - Properties
    
    let emptyLabel = UILabel()
    
    var viewModelData = [BusinessModel]()
    var stackContainer : StackContainerView!
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitle = String()
    var dollarSign : String?
    
    //MARK: - Init
    
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
    
    var locationManager = CLLocationManager()
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //sets label for no more cards
        setLastLabel()
        emptyLabel.isHidden = true
        
        //set background
        Background().setAuthBackground(view,backgroundImageView)
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
        
        //asking for location
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        //if location is granted..
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            
            //calling API for all the Cards Data using location
            print(currentLoc.coordinate.latitude)
            RestaurantManager().getLocalRestaurants(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, category: categoryAlias, dollarSigns: dollarSign) { (businessModelArray) in
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset Cards", style: .plain, target: self, action: #selector(resetTapped))
    }
    //SETS CARDS ARE EMPTY LABEL
    func setLastLabel(){
        self.view?.addSubview(emptyLabel)
        emptyLabel.textColor = .black
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.systemFont(ofSize: 18)
        emptyLabel.text = "No more cards!"
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: self.view!.centerYAnchor).isActive = true
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
        emptyLabel.isHidden = true

    }
    
}
//MARK: - DataSource for StackContainerView

extension BusinessViewController : BusinessCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> BusinessCardView {
        let card = BusinessCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> Void {
        emptyLabel.isHidden = false
    }
    
}
