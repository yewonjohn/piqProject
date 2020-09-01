//
//  TabBarViewController.swift
//  piq
//
//  Created by John Kim on 8/2/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarViewControllerDelegate: class {
    func didDismissTutorial()
}
class TabBarViewController: UITabBarController{
    
    //MARK:- UI Properties
    
    var tutorialOverlayView = UIView()
    let tutorialView = UIView()
    let tutorialContainerView = UIView()
    let tutorialIconView = UIImageView()
    let tutorialTitleLabel = UILabel()
    let tutorialDescLabel = UILabel()
    let tutorialArrowImage = UIImageView()

    //MARK:- Properties
    let service = ServiceUtil()
    weak var tabDelegate : TabBarViewControllerDelegate?
    
    //RestaurantVC properties to pass
    var categoriesArr = [CategoryModel]()
    var categoriesTitles = [String]()
    var dollarSign : String?
    var distance : Double?

    //MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad in TabBar")
        delegate = self

        //passing info
        let viewControllers = self.viewControllers
        let vc = viewControllers![1] as! RestaurantViewController
        vc.categoriesArr = categoriesArr
        vc.categoriesTitles = categoriesTitles
        vc.dollarSign = dollarSign
        vc.distance = distance
//        vc.getRestaurantCards()
        
        
        configureTutorialView()
        configureCircleOverlay()
        configureContainerView()
        configureIconView()
        configureTitleLabel()
        configureDescLabel()
        configureArrow()

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        //anything
//    }
    
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
        tutorialView.isHidden = true

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissTutorial))
        tutorialView.isUserInteractionEnabled = true
        tutorialView.addGestureRecognizer(singleTap)

    }
    
    private func configureCircleOverlay(){
        tutorialOverlayView = createOverlay(frame: view.frame,
                                            xOffset: view.frame.width - view.frame.width*0.16,
                                    yOffset: view.frame.height - view.frame.height*0.06,
                                    radius: view.frame.height*0.05)
        view.addSubview(tutorialOverlayView)
        tutorialOverlayView.isHidden = true

        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissTutorial))
        tutorialOverlayView.isUserInteractionEnabled = true
        tutorialOverlayView.addGestureRecognizer(singleTap)
    }
    
    private func configureContainerView(){
        view.addSubview(tutorialContainerView)
        tutorialContainerView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9529411765, alpha: 1)
        tutorialContainerView.translatesAutoresizingMaskIntoConstraints = false
        tutorialContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        tutorialContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tutorialContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3, constant: 0).isActive = true
        tutorialContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9, constant: 0).isActive = true
        tutorialContainerView.layer.cornerRadius = 15
        tutorialContainerView.clipsToBounds = true
        tutorialContainerView.isHidden = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(dismissTutorial))
        tutorialContainerView.isUserInteractionEnabled = true
        tutorialContainerView.addGestureRecognizer(singleTap)
    }
    
    private func configureIconView(){
        tutorialContainerView.addSubview(tutorialIconView)
        tutorialIconView.translatesAutoresizingMaskIntoConstraints = false
//        tutorialIconView.centerYAnchor.constraint(equalTo: tutorialContainerView.centerYAnchor, constant: -30).isActive = true
        tutorialIconView.topAnchor.constraint(equalTo: tutorialContainerView.topAnchor, constant: 20).isActive = true
        tutorialIconView.centerXAnchor.constraint(equalTo: tutorialContainerView.centerXAnchor).isActive = true
        tutorialIconView.heightAnchor.constraint(equalTo: tutorialContainerView.heightAnchor, multiplier: 0.4, constant: 0).isActive = true
        tutorialIconView.widthAnchor.constraint(equalTo: tutorialContainerView.heightAnchor, multiplier: 0.4, constant: 0).isActive = true
        tutorialIconView.image = #imageLiteral(resourceName: "favorite_heart")
        tutorialIconView.isHidden = true
    }
    
    private func configureTitleLabel(){
        tutorialContainerView.addSubview(tutorialTitleLabel)
        tutorialTitleLabel.text = "You want it? You got it."
        tutorialTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        tutorialTitleLabel.textColor = .black
        tutorialTitleLabel.numberOfLines = 0
        tutorialTitleLabel.textAlignment = .center
        tutorialTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tutorialTitleLabel.topAnchor.constraint(equalTo: tutorialIconView.bottomAnchor, constant: 10).isActive = true
        tutorialTitleLabel.centerXAnchor.constraint(equalTo: tutorialContainerView.centerXAnchor).isActive = true
        tutorialTitleLabel.widthAnchor.constraint(equalTo: tutorialContainerView.widthAnchor, multiplier: 0.9, constant: 0).isActive = true
        tutorialTitleLabel.isHidden = true
    }
    
    private func configureDescLabel(){
        tutorialContainerView.addSubview(tutorialDescLabel)
        tutorialDescLabel.text = "Everytime you swipe right, your piq is saved in your favorites menu. "
        tutorialDescLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        tutorialDescLabel.textColor = .black
        tutorialDescLabel.numberOfLines = 0
        tutorialDescLabel.textAlignment = .center
        tutorialDescLabel.translatesAutoresizingMaskIntoConstraints = false
        tutorialDescLabel.topAnchor.constraint(equalTo: tutorialTitleLabel.bottomAnchor, constant: 10).isActive = true
        tutorialDescLabel.centerXAnchor.constraint(equalTo: tutorialContainerView.centerXAnchor).isActive = true
        tutorialDescLabel.widthAnchor.constraint(equalTo: tutorialContainerView.widthAnchor, multiplier: 0.9, constant: 0).isActive = true
        tutorialDescLabel.isHidden = true
    }
    
    private func configureArrow(){
        view.addSubview(tutorialArrowImage)
        tutorialArrowImage.translatesAutoresizingMaskIntoConstraints = false
        tutorialArrowImage.image = #imageLiteral(resourceName: "Arrow")
        tutorialArrowImage.topAnchor.constraint(equalTo: tutorialContainerView.bottomAnchor, constant: 15).isActive = true
        tutorialArrowImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -17).isActive = true
        tutorialArrowImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35).isActive = true
        tutorialArrowImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.27).isActive = true
        tutorialArrowImage.isHidden = true
    }
    
    @objc func dismissTutorial() {
        tabDelegate?.didDismissTutorial()
        tutorialOverlayView.isHidden = true
        tutorialView.isHidden = true
        tutorialTitleLabel.isHidden = true
        tutorialContainerView.isHidden = true
        tutorialIconView.isHidden = true
        tutorialTitleLabel.isHidden = true
        tutorialDescLabel.isHidden = true
        tutorialArrowImage.isHidden = true
    }
    
    
    // MARK: - User Interactions (Segues)
    
    //'Cancel' button segue
    @IBAction func unwindToCards(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![1] as! RestaurantViewController
        vc.triggerShadowView()
    }
    //'Apply' button segue
    @IBAction func unwindWithInfo(_ unwindSegue: UIStoryboardSegue) {
        
        let viewControllers = self.viewControllers
        let vc = viewControllers![1] as! RestaurantViewController
        
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
//MARK:- RestaurantCard Delegate (Tutorial Triggers)
extension TabBarViewController: RestaurantCardTutorialDelegate{
    func swipingLeft() {
            tutorialView.isHidden = false
        
            tutorialIconView.image = #imageLiteral(resourceName: "skip_icon")
            tutorialTitleLabel.text = "In the mood for something else?"
            tutorialDescLabel.text = "Swipe left and your next meal could be the next thing you see."
            tutorialContainerView.isHidden = false
            tutorialIconView.isHidden = false
            tutorialTitleLabel.isHidden = false
            tutorialDescLabel.isHidden = false
    }
    
    func swipingRight() {
            tutorialOverlayView.isHidden = false
        
            tutorialIconView.image = #imageLiteral(resourceName: "favorite_heart")
            tutorialTitleLabel.text = "You want it? You got it."
            tutorialDescLabel.text = "Everytime you swipe right, your piq is saved in your favorites menu."
            tutorialContainerView.isHidden = false
            tutorialIconView.isHidden = false
            tutorialTitleLabel.isHidden = false
            tutorialDescLabel.isHidden = false
            tutorialArrowImage.isHidden = false
    }
}
