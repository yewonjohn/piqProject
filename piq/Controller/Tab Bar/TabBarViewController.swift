//
//  TabBarViewController.swift
//  piq
//
//  Created by John Kim on 8/2/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController{
    
    //MARK:- UI Properties
    
    let tutorialView = UIView()
    let leftSwipeLabel = UILabel()
    let rightSwipeLabel = UILabel()

    //MARK:- Properties
    let defaults = UserDefaults.standard
    let service = ServiceUtil()
    let restaurantVC = RestaurantViewController()
    
    //RestaurantVC properties to pass
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = [String]()
    var dollarSign : String?
    var distance : Double?

    //MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        restaurantVC.delegate = self

        delegate = self

        //passing info
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
    
        vc.categoriesArr = categoriesArr
        vc.categoriesTitles = categoriesTitles
        vc.dollarSign = dollarSign
        vc.distance = distance
        
        if(!defaults.bool(forKey: "tutorialTriggered")){
            configureTutorialView()
            configureleftSwipeLabel()
            defaults.set(true, forKey: "tutorialTriggered")
        }
    }
    
    //MARK: - Layout Configurations

    private func configureTutorialView(){
        view.addSubview(tutorialView)
        tutorialView.translatesAutoresizingMaskIntoConstraints = false
        tutorialView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tutorialView.alpha = 0.7
        tutorialView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tutorialView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tutorialView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tutorialView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissTutorial))
        tutorialView.isUserInteractionEnabled = true
        tutorialView.addGestureRecognizer(singleTap)

    }
    
    private func configureleftSwipeLabel(){
        view.addSubview(leftSwipeLabel)
        leftSwipeLabel.text = "swipe right to favorite!"
        leftSwipeLabel.textAlignment = .left
        leftSwipeLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.3764705882, blue: 0.2588235294, alpha: 1)
        leftSwipeLabel.font = UIFont(name: "Montserrat-Medium", size: 25)
        leftSwipeLabel.translatesAutoresizingMaskIntoConstraints = false
        leftSwipeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        leftSwipeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    @objc func dismissTutorial() {
        tutorialView.isHidden = true
        leftSwipeLabel.isHidden = true
    }
    
    
    // MARK: - IBActions & Objc Functions (Segues)
    
    //'Cancel' button segue
    @IBAction func unwindToCards(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
        vc.triggerShadowView()
    }
    //'Apply' button segue
    @IBAction func unwindWithInfo(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![0] as! RestaurantViewController
        
        vc.triggerShadowView()
        
        vc.categoriesArr = categoriesArr
        vc.categoriesTitles = categoriesTitles
        vc.dollarSign = dollarSign
        vc.distance = distance
        vc.getRestaurantCards()
    }
}
//MARK:- Tab Bar Delegate
extension TabBarViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
        }
        return true
    }
}

//extension TabBarViewController: RestaurantVCDelegate{
//    
//    func shadowViewTriggered() {
//        print("Trigger shadow inside Tab")
//        triggerShadowView()
//    }
//    
//}
