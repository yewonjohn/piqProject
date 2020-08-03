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
    let piqTitle = UILabel()
    let filterButton = UIButton()
    let emptyCardsLabel = UILabel()
    let filterView = UIView()
    
    
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
        
        //creates views for this page
        setLastLabel()
        emptyCardsLabel.isHidden = true
        setPiqTitle()
        setButton()
        setFilterView()


        //set background
        ServiceUtil().setAuthBackground(view,backgroundImageView)
        
        //get category title alias
        var categoryAlias: String?
        for category in categoriesArr{
            if(category.title == categoriesTitle){
                categoryAlias = category.alias
            }
        }
        if(categoryAlias == ""){
            categoryAlias = nil
        }
        if(dollarSign == "0" || dollarSign == ""){
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
    //Sets title
    func setPiqTitle(){
        self.view?.addSubview(piqTitle)
        piqTitle.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        piqTitle.textAlignment = .center
        piqTitle.font = UIFont(name: "Montserrat-SemiBold", size: 36)
        piqTitle.text = "piq"
        piqTitle.translatesAutoresizingMaskIntoConstraints = false
        piqTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 44).isActive = true
        piqTitle.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
//        piqTitle.leftAnchor.constraint(equalTo: self.view!.leftAnchor, constant: 100).isActive = true
    }
    func setButton(){
        self.view?.addSubview(filterButton)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55).isActive = true
        filterButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        filterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        filterButton.isUserInteractionEnabled = true

    }
    func setFilterView(){
        self.view?.addSubview(filterView)
        filterView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        filterView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        filterView.leftAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        filterView.widthAnchor.constraint(equalToConstant: 360).isActive = true
    }
    
    // MARK: - IBActions & Objc Functions
    
    @objc func buttonAction(){
        print("Button tapped")
        UIView.animate(withDuration: 0.5, animations: {
            self.filterView.frame.origin.x -= self.filterView.frame.width
        })
    }
    
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
