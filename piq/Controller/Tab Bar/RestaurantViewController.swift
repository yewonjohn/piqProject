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
import Firebase


class RestaurantViewController: UIViewController {
    
    // MARK: - Properties
    let piqTitle = UILabel()
    let filterButton = UIButton()
    let emptyCardsLabel = UILabel()
    let signOutButton = UIButton()
    let resetButton = UIButton()
    let resetLabel = UILabel()
    let loadingView = NVActivityIndicatorView(frame: .zero)
    let backgroundImageView = UIImageView()
    let piqdLabel = UILabel()
    let shadowView = UIView()

    var presentTransition: UIViewControllerAnimatedTransitioning?
    var dismissTransition: UIViewControllerAnimatedTransitioning?

    var stackContainer : StackContainerView!
    
    var restaurantModelData = [RestaurantModel]()
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = [String]()
    var dollarSign : String?
    var distance : Double?
    var finalDist : Int?
    
    var locationManager = CLLocationManager()
    var favoritesManager = FavoritesManager()

    let service = ServiceUtil()
    let homePage = SearchPageViewController()
    let restaurantAPI = RestaurantManager()
    var isFirstTimeOpening = true
    let userDefault = UserDefaults.standard
    let currentUser = Auth.auth().currentUser

    // MARK: - View Controller Life Cycle

    override func loadView() {
        view = UIView()
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        stackContainer.translatesAutoresizingMaskIntoConstraints = false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //creates views for this page
        setCardsEmpterLabel()
        emptyCardsLabel.isHidden = true
        setPiqTitle()
        setFilterButton()
        setResetButton()
        setResetLabel()
        setLoadingView()
        configurePiqdLabel()
        presentDarkLayer(darkLayer: shadowView)
        //set background
        ServiceUtil().setBackground(view,backgroundImageView)

        getRestaurantCards()
        restaurantAPI.delegate = self
    }
    
    override func viewDidLayoutSubviews() {

        super.viewDidLayoutSubviews()
        if isFirstTimeOpening{
            isFirstTimeOpening = false
            //calling this here because we're using view.frame for dynamic heigh/width
            configureStackContainer()
        }
    }
    
    //MARK: - Layout Configurations
    func triggerShadowView(){
        service.animateShadowView(view: shadowView)
    }
    
    //SETS CONTAINER CONSTRAINTS
    private func configureStackContainer() {
        stackContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        stackContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.83).isActive = true
        stackContainer.heightAnchor.constraint(equalToConstant: view.frame.height * 0.58).isActive = true
    }
    //SETS CARDS ARE EMPTY LABEL
    private func setCardsEmpterLabel(){
        self.view?.addSubview(emptyCardsLabel)
        emptyCardsLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        emptyCardsLabel.textAlignment = .center
        emptyCardsLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        emptyCardsLabel.text = RestaurantVC.emptyCardsText
        emptyCardsLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyCardsLabel.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
        emptyCardsLabel.centerYAnchor.constraint(equalTo: self.view!.centerYAnchor).isActive = true
    }

    private func setPiqTitle(){
        self.view?.addSubview(piqTitle)
        piqTitle.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        piqTitle.textAlignment = .center
        piqTitle.font = UIFont(name: "Montserrat-SemiBold", size: 36)
        piqTitle.text = "piq"
        piqTitle.translatesAutoresizingMaskIntoConstraints = false
        piqTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        piqTitle.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
    }
    
    private func setFilterButton(){
        self.view?.addSubview(filterButton)
        filterButton.setImage(#imageLiteral(resourceName: "filterIcon"), for: .normal)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        filterButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        filterButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        filterButton.isUserInteractionEnabled = true

    }
    private func setResetButton(){
        self.view.addSubview(resetButton)
        let symbol = UIImage(systemName: "arrow.2.circlepath")
        resetButton.setImage(symbol, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .regular, scale: .default)
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
        view.sendSubviewToBack(resetButton)

    }
    
    private func setResetLabel(){
        self.view.addSubview(resetLabel)
        resetLabel.text = "reset"
        resetLabel.font = UIFont(name: "Montserrat-SemiBold", size: 9)
        resetLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        resetLabel.textAlignment = .center
        resetLabel.translatesAutoresizingMaskIntoConstraints = false
        resetLabel.centerXAnchor.constraint(equalTo: resetButton.centerXAnchor, constant: 0).isActive = true
        resetLabel.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 0).isActive = true
        resetLabel.isHidden = true
        view.sendSubviewToBack(resetLabel)

    }

    private func setLoadingView(){
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        loadingView.type = .pacman
        loadingView.color = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
    }
    //favorited label popup
    private func configurePiqdLabel() {
        view.addSubview(piqdLabel)
        piqdLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        piqdLabel.text = "piq'd!"
        piqdLabel.textAlignment = .center
        piqdLabel.font = UIFont(name: "Montserrat-Medium", size: 90)
        piqdLabel.translatesAutoresizingMaskIntoConstraints = false
        piqdLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        piqdLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        piqdLabel.isHidden = true
    }
    

    
    // MARK: - User Interactionßß
    
    @objc func resetTapped() {
        stackContainer.reloadData()
        emptyCardsLabel.isHidden = true
        service.animateResetButton(button: resetButton)
        service.animateResetLabel(label: resetLabel)
    }
}
//MARK: - DataSource/Delegate for StackContainerView (Delegate)
extension RestaurantViewController : RestaurantCardsDataSource {
    
    //Adds to favorites when cards swiped right.
    func swipedRight(data: RestaurantModel, userEmail: String, categoriesTitles: String) {
        if(currentUser != nil){
            favoritesManager.addToFavorites(user: userEmail, id: data.id, name: data.name, ratings: data.rating, reviewCount: data.reviewCount, price: data.price, distance: data.distance, phone: data.phone, isClosed: data.isClosed, url: data.url, img_url: data.img_url, categories: categoriesTitles)
            service.animatePiqd(label: piqdLabel)
        }
    }
    //provides total number of cards to StackContainerView
    func numberOfCardsToShow() -> Int {
        if(restaurantModelData.count == 0){
            emptyCardsLabel.isHidden = false
        }
        return restaurantModelData.count
    }
    //creates one card obj and sends to StackContainerView
    func card(at index: Int) -> RestaurantCardView {
        let card = RestaurantCardView()
        //setting delegate for TabBarView here
        if let tabBar = self.tabBarController as? TabBarViewController{
            //setting two delegates here, because these two objects are listening to each other.
            card.tutorialDelegate = tabBar
        }
        
        card.dataSource = restaurantModelData[index]
        return card
    }
    //triggers when last card is swiped
    func emptyView() -> Void {			
        emptyCardsLabel.isHidden = false
    }
    //triggers when swiping starts
    func swipeStarted() -> Bool {
        service.animateResetButton(button: resetButton)
        service.animateResetLabel(label: resetLabel)
        return false
    }
    //tracking FRONT card for dismissing tutorial
    func currentFrontCard(card: RestaurantCardView) {
        if let tabBar = self.tabBarController as? TabBarViewController{
            tabBar.tabDelegate = card
        }
    }
}
//MARK:-- Custom Transition (Delegate)
extension RestaurantViewController: UIViewControllerTransitioningDelegate{
    
    @objc public func buttonAction(){
        //triggers shadowView
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
    let duration: TimeInterval = 0.15

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
    let duration: TimeInterval = 0.15

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

//MARK:- Restaurant Manager Delegate (LOADING ICON)
extension RestaurantViewController: RestaurantManagerDelegate{
    func isLoading() {
        loadingView.startAnimating()
    }
}

//MARK:- Restaurant API Call
extension RestaurantViewController{
    
    func getRestaurantCards(){
        //make sure empty label and reset button is hidden when new search is initialized
        resetButton.isHidden = true
        resetLabel.isHidden = true
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
            restaurantAPI.getLocalRestaurants(distance: finalDist, latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, category: categoryAlias, dollarSigns: dollarSign) { (restaurantModelArray) in
                self.restaurantModelData = restaurantModelArray
                self.stackContainer.dataSource = self
                //stop loading animation here
                self.loadingView.stopAnimating()
            }
        }
    }
    //making sure data refreshes once user clicks 'allow' to location
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getRestaurantCards()
    }
}
