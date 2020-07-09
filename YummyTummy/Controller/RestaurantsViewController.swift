//
//  RegisterViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantsViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModelData = [BusinessModel]()
    var stackContainer : StackContainerView!
    
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
        configureNavigationBarButtonItem()
        
    }
    
    var locationManager = CLLocationManager()
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            
            //calling API for all the Cards Data
            RestaurantManager().getLocalRestaurants(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude) { (businessModelArray) in
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
        stackContainer.heightAnchor.constraint(equalToConstant: 600).isActive = true
    }
    //SETS RESET NAVIGATIONAL BUTTON
    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
    }
    
    func setBackground(){
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.image = UIImage(named: "tacosImg")
        backgroundImageView.alpha = 0.5
        view.sendSubviewToBack(backgroundImageView)
    }
}
//MARK: - DataSource for StackContainerView

extension RestaurantsViewController : SwipeCardsDataSource {
    
    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }
    
}
