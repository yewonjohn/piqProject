//
//  RegisterViewController.swift
//  piq
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import CoreLocation
import NVActivityIndicatorView

class RestaurantViewController: UIViewController {
    
    // MARK: - Properties
    let piqTitle = UILabel()
    let filterButton = UIButton()
    let emptyCardsLabel = UILabel()
    let signOutButton = UIButton()
    let resetButton = UIButton()

    let shadowView = UIView()
    let loadingView = NVActivityIndicatorView(frame: .zero)
    
    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?

    let userDefault = UserDefaults.standard

    var viewModelData = [RestaurantModel]()
    var stackContainer : StackContainerView!
    
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = [String]()
    var dollarSign : String?
    var distance : Double?
    var finalDist : Int?
    
    var locationManager = CLLocationManager()
    let backgroundImageView = UIImageView()
    let service = ServiceUtil()
    let homePage = SearchPageViewController()
    let restaurantAPI = RestaurantManager()

    // MARK: - View Controller Life Cycle

    override func loadView() {

        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        configureResetNavigationBarButtonItem()
        restaurantAPI.delegate = self

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creates views for this page
        setLastLabel()
        emptyCardsLabel.isHidden = true
        setPiqTitle()
        setFilterButton()
        setResetButton()
        setShadowView()
        setLoadingView()

        //set background
        ServiceUtil().setAuthBackground(view,backgroundImageView)

        getCards()
    }
    
    func getCards(){
        
        //make sure empty label and reset button is hidden when new search
        resetButton.isHidden = true
        emptyCardsLabel.isHidden = true
        
        //get category title alias
        var categoryAlias: String? = nil
        for category in categoriesArr{
            if let catTitle = category.title, let catAlias = category.alias{
                if (categoriesTitles.contains(catTitle)){
                    if(categoryAlias == nil){
                        categoryAlias = catAlias
                    }else {
                        categoryAlias! += ","+catAlias
                    }
                }
            }
        }
        if(dollarSign == "0" || dollarSign == ""){
            dollarSign = nil
        }
        if(distance == 0.0 || distance == nil){
            finalDist = nil
        } else{
            if let dist = distance{
                finalDist = Int(dist * 1609)
            }
        }
        
        var currentLoc: CLLocation!

        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            
            //Calling API for all the Cards Data using current location
            restaurantAPI.getLocalRestaurants(distance: finalDist, latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, category: categoryAlias, dollarSigns: dollarSign) { (businessModelArray) in
                self.viewModelData = businessModelArray
                self.stackContainer.dataSource = self
                //stop loading animation
                self.loadingView.stopAnimating()
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("triggered")
        getCards()
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
      func setShadowView(){

        self.view.addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .black
        shadowView.alpha = 0.7
        shadowView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        shadowView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        shadowView.isHidden = true
    }
    func triggerShadowView(){
        service.animateShadowView(view: shadowView)
    }

    func setLoadingView(){
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        loadingView.type = .pacman
        loadingView.color = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
    }

    
    // MARK: - IBActions & Objc Functions
    
    @objc func resetTapped() {
        stackContainer.reloadData()
        emptyCardsLabel.isHidden = true
        service.animateResetButton(button: resetButton)
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
//MARK:-- Custom Transition (Delegate)
extension RestaurantViewController: UIViewControllerTransitioningDelegate{
    
    @objc public func buttonAction(){
        
        triggerShadowView()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as! SearchPageViewController
        
        presentTransition = RightToLeftTransition()
        dismissTransition = LeftToRightTransition()
        
        pvc.modalPresentationStyle = .custom
        pvc.transitioningDelegate = self
        pvc.view.layer.cornerRadius = 30
        pvc.view.clipsToBounds = true
        //boolean value to let HomePageVC know where it's being presented from
        pvc.sidePresented = true
        
        self.present(pvc, animated: true, completion: nil)
        }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}
//MARK:-- Custom Transition (Right to Left Transition)
class RightToLeftTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.25

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        container.addSubview(toView)

        toView.frame = CGRect(x: toView.bounds.width, y: 0, width: (toView.bounds.width) - 65, height: (toView.bounds.height) as! CGFloat)
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            toView.frame.origin = CGPoint(x: 65, y: 0)
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
//MARK:-- Custom Transition (Left to Right Transition)
class LeftToRightTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval = 0.25

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!

        container.addSubview(fromView)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            fromView.frame.origin = CGPoint(x: fromView.frame.width, y: 0)
        }, completion: { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

//MARK:- Restaurant Manager Delegate (IS LOADING)
extension RestaurantViewController: RestaurantManagerDelegate{
    func isLoading() {
        loadingView.startAnimating()
    }
}
