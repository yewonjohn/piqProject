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
    
//    var viewModelData = [CardsDataModel
//    ]
    
    var viewModelData = [BusinessModel(name: "Don Chicken", id: "123", rating: 4.5, reviewCount: 56, price: "$$", distance: 2330.5000, address: "193 Knickerbocker rd. Englewood, NJ, USA", isClosed: false, phone: "347-598-0607", categories: [Categories(alias: "chicken", title: "Fried Chicken"), Categories(alias: "chicen", title: "Korean")], url:"https://www.yelp.com/biz/oh-my-deer-montr%C3%A9al?adjust_creative=4QwbeG0sCgsCEshx-FWfWg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=4QwbeG0sCgsCEshx-FWfWg", img_url: "https://s3-media1.fl.yelpcdn.com/bphoto/hFO2kqbZtm9KRrDxTGqY-Q/o.jpg", isOpen: true)
    ]
    
    
      var stackContainer : StackContainerView!
    
      
      //MARK: - Init
      
      override func loadView() {
          view = UIView()
          view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
          stackContainer = StackContainerView()
          view.addSubview(stackContainer)
          configureStackContainer()
          stackContainer.translatesAutoresizingMaskIntoConstraints = false
          configureNavigationBarButtonItem()
        
        //API HERE
        
      }
    
    var locationManager = CLLocationManager()
    let backgroundImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackContainer.dataSource = self

        setBackground()
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           //print(currentLoc.coordinate.latitude)
           //print(currentLoc.coordinate.longitude)
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
