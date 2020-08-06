//
//  RegisterViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth

class RestaurantViewController: UIViewController {
    
    // MARK: - Properties
    let piqTitle = UILabel()
    let filterButton = UIButton()
    let emptyCardsLabel = UILabel()
    let signOutButton = UIButton()
    let resetButton = UIButton()
    
    let userDefault = UserDefaults.standard

    var viewModelData = [BusinessModel]()
    var stackContainer : StackContainerView!
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitle = String()
    var dollarSign : String?
    var distance : Int?
    
    var locationManager = CLLocationManager()
    let backgroundImageView = UIImageView()
    let service = ServiceUtil()
    
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
        setFilterButton()
        setSignOut()
        setResetButton()

        //set background
        ServiceUtil().setAuthBackground(view,backgroundImageView)
        getCards()
    }
    
    func getCards(){
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
        emptyCardsLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        emptyCardsLabel.textAlignment = .center
        emptyCardsLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
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
        piqTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55).isActive = true
        piqTitle.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
//        piqTitle.leftAnchor.constraint(equalTo: self.view!.leftAnchor, constant: 100).isActive = true
    }
    func setFilterButton(){
        self.view?.addSubview(filterButton)
        filterButton.setImage(#imageLiteral(resourceName: "filterIcon"), for: .normal)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 55).isActive = true
        filterButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        filterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        filterButton.isUserInteractionEnabled = true

    }
    func setSignOut(){
        self.view.addSubview(signOutButton)
        let symbol = UIImage(systemName: "escape")
        signOutButton.setImage(symbol, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .regular, scale: .default)
        signOutButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        
        signOutButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        signOutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 71).isActive = true
        signOutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
        signOutButton.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        signOutButton.isUserInteractionEnabled = true
    }
    func setResetButton(){
        self.view.addSubview(resetButton)
        let symbol = UIImage(systemName: "arrow.2.circlepath")
        resetButton.setImage(symbol, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .light, scale: .default)
        resetButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        
        resetButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        resetButton.alpha = 0
        resetButton.isHidden = true
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        resetButton.isUserInteractionEnabled = true
    }
    

    
    // MARK: - IBActions & Objc Functions
    
    @objc func resetTapped() {
        stackContainer.reloadData()
        emptyCardsLabel.isHidden = true
        service.animateResetButton(button: resetButton)
    }
    @objc func logoutUser() {
        
        let alert = UIAlertController(title: "Logout?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Yes, logout", style: .default, handler: { action in
              switch action.style{
              case .default:
                    do { try Auth.auth().signOut() }
                    catch { print("already logged out") }
                    self.userDefault.set(false, forKey: "usersignedin")
                    self.userDefault.synchronize()
                    self.navigationController?.popToRootViewController(animated: true)

              case .cancel:
                print("cancel")
              case .destructive:
                print("destruct")
            }}))
        self.present(alert, animated: true, completion: nil)
        
        

    }
}
//MARK: - DataSource for StackContainerView (Delegate)

extension RestaurantViewController : RestaurantCardsDataSource {

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
    
    func swipeStarted() -> Bool {
        service.animateResetButton(button: resetButton)
        return false
    }
}

extension RestaurantViewController: UIViewControllerTransitioningDelegate{
    
    @objc public func buttonAction(){        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var pvc = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
        
        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
        pvc.transitioningDelegate = self
        pvc.view.layer.cornerRadius = 30
        pvc.view.clipsToBounds = true
        pvc.sidePresented = true

        self.present(pvc, animated: true, completion: nil)
        
        }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
             return SetSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
class SetSizePresentationController : UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
             return CGRect(x: (containerView?.bounds.width)! - 350, y: 0, width: (containerView?.bounds.width)! - 65, height: (containerView?.bounds.height)!)
        }
    }

}

