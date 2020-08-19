//
//  ViewController.swift
//  piq
//
//  Created by John Kim on 6/19/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseFirestore
import Firebase


protocol RestaurantCardsDelegate {
    func swipeDidEnd(on view: RestaurantCardView)
    func swipedRight(data : RestaurantModel, userEmail : String, categoriesTitles : String)
}
class RestaurantCardView : UIView {

    //MARK: - UI Properties
    private var shadowView : UIView!
    private var swipeView : UIView!
    private var imageContainView: UIView!
    private var imageView: UIImageView!
    private var titleLabel = UILabel()
    private var ratingsView: UIImageView!
    private var ratingsCountView = UILabel()
    private var dollarSignsView = UILabel()
    private var categoriesView = UILabel()
    private var distanceView = UILabel()
    private var phoneView = UILabel()
    private var addressView = UILabel()
    private var favoriteButton = UIButton()
    private var yelpImgView: UIImageView!
    private var arrowButton = UIButton()

    //MARK: - Properties
    private let favoritesManager = FavoritesManager()
    private let service = ServiceUtil()
    var delegate : RestaurantCardsDelegate?
    
    private var categoryTitles = ""
    private var divisor : CGFloat = 0
    private let baseView = UIView()
    
    
    var dataSource : RestaurantModel? {
        didSet {
            //reformatting phoneNumber
            var phoneNumber = dataSource?.phone
            phoneNumber = phoneNumber?.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
                        
            //setting UIViews text with data
            swipeView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            guard let image = dataSource?.img_url else { return }
            imageView.image = UIImage(named: image)
            titleLabel.text = dataSource?.name
            ratingsCountView.text = "\(dataSource?.reviewCount ?? 0) Reviews"
            dollarSignsView.text = "\(dataSource?.price ?? "$") •"
            if dataSource?.price == ""{
                dollarSignsView.text = "? •"
            }
            phoneView.text = phoneNumber
            let url = URL(string: dataSource?.img_url ?? "")
            imageView.kf.setImage(with: url)
            
            var distInMiles = 0.0
            //SETTING STORE OPEN/CLOSED
            if let dist = dataSource?.distance{
                distInMiles = dist/1609
                distInMiles = Double(round(10*distInMiles)/10)
                distanceView.text = String(distInMiles)+" mi •"
            } else{
                distanceView.text = "? mi •"
            }
            if distInMiles >= 0 && distInMiles <= 1 {
                distanceView.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            } else if distInMiles > 1 && distInMiles <= 2 {
                distanceView.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            } else if distInMiles > 2 {
                distanceView.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            }
            
            
            //SETTING RATINGS BAR
            switch dataSource?.rating {
            case 0.0:
                ratingsView.image = UIImage(named: "regular_0")
            case 0.5:
                ratingsView.image = UIImage(named: "regular_0_half")
            case 1.0:
                ratingsView.image = UIImage(named: "regular_1")
            case 1.5:
                ratingsView.image = UIImage(named: "regular_1_half")
            case 2.0:
                ratingsView.image = UIImage(named: "regular_2")
            case 2.5:
                ratingsView.image = UIImage(named: "regular_2_half")
            case 3.0:
                ratingsView.image = UIImage(named: "regular_3")
            case 3.5:
                ratingsView.image = UIImage(named: "regular_3_half")
            case 4.0:
                ratingsView.image = UIImage(named: "regular_4")
            case 4.5:
                ratingsView.image = UIImage(named: "regular_4_half")
            case 5.0:
                ratingsView.image = UIImage(named: "regular_5")
            default:
                ratingsView.image = UIImage(named: "regular_0")
            }
            //SETTING CATEGORIES
            var counter = 0
            for category in dataSource!.categories {
                if(counter != (dataSource?.categories.count)!-1){
                    categoryTitles += category.title! + ", "
                } else {categoryTitles += category.title!}
                counter+=1
            }
            categoriesView.text = categoryTitles
            
        }
    }

    //MARK: - Interactions
    @objc private func goToURL() {
        guard let url = URL(string: (dataSource?.url)!) else { return }
        UIApplication.shared.open(url)
    }

    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureSwipeView()
        configureImageContainerView()
        configureImageView()
        configureTitleView()
        configureRatingsView()
        configureRatingsCountView()
        configureDollarSignsView()
        configureCategoriesView()
        configureDistanceView()
        configurePhoneView()
        configureArrow()
        addPanGestureOnCards()
        configureTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    
    private func configureShadowView() {
        shadowView = UIView()
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 4.0
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func configureSwipeView() {
        swipeView = UIView()
        swipeView.layer.cornerRadius = 25
        swipeView.clipsToBounds = true
        shadowView.addSubview(swipeView)
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        swipeView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        swipeView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        swipeView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }
    private func configureImageContainerView() {
        imageContainView = UIView()
        imageContainView.clipsToBounds = true
        swipeView.addSubview(imageContainView)
        imageContainView.translatesAutoresizingMaskIntoConstraints = false
        imageContainView.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor).isActive = true
        imageContainView.topAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
        imageContainView.widthAnchor.constraint(equalTo: self.swipeView.widthAnchor, multiplier: 1.0).isActive = true
        imageContainView.heightAnchor.constraint(equalTo: self.swipeView.heightAnchor, multiplier: 0.70).isActive = true

    }
    
    private func configureImageView() {
        imageView = UIImageView()
        imageContainView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageContainView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.imageContainView.widthAnchor, multiplier: 1.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.imageContainView.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    private func configureTitleView() {
        imageContainView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 25)
        titleLabel.numberOfLines = 0
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = .zero
        titleLabel.layer.shadowRadius = 10
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: imageContainView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: imageContainView.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: imageContainView.bottomAnchor, constant: -4).isActive = true
    }
    
    private func configureRatingsView() {
        ratingsView = UIImageView()
        ratingsView.image = UIImage(named: "regular_0")
        swipeView.addSubview(ratingsView)
        ratingsView.contentMode = .scaleAspectFit
        ratingsView.translatesAutoresizingMaskIntoConstraints = false
        ratingsView.topAnchor.constraint(equalTo: imageContainView.bottomAnchor).isActive = true
        ratingsView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 10).isActive = true
//        ratingsView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        ratingsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ratingsView.widthAnchor.constraint(equalTo: swipeView.widthAnchor, multiplier: 0.45).isActive = true
        ratingsView.heightAnchor.constraint(equalTo: swipeView.heightAnchor, multiplier: 0.10).isActive = true
    }
    
    private func configureRatingsCountView() {
        swipeView.addSubview(ratingsCountView)
        ratingsCountView.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
        ratingsCountView.textAlignment = .left
        ratingsCountView.font = UIFont(name: "Montserrat-Medium", size: 12)
        ratingsCountView.translatesAutoresizingMaskIntoConstraints = false
//        ratingsCountView.centerXAnchor.constraint(equalTo: ratingsView.centerXAnchor).isActive = true
//        ratingsCountView.topAnchor.constraint(equalTo: imageContainView.bottomAnchor, constant: 16).isActive = true
        ratingsCountView.leftAnchor.constraint(equalTo: ratingsView.rightAnchor, constant: 8).isActive = true
        ratingsCountView.centerYAnchor.constraint(equalTo: ratingsView.centerYAnchor, constant: 0).isActive = true

    }
    
    private func configureDollarSignsView() {
        swipeView.addSubview(dollarSignsView)
        dollarSignsView.textColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        dollarSignsView.textAlignment = .left
        dollarSignsView.font = UIFont(name: "Montserrat-Medium", size: 15)
        dollarSignsView.translatesAutoresizingMaskIntoConstraints = false
        dollarSignsView.topAnchor.constraint(equalTo: ratingsView.bottomAnchor, constant: 4).isActive = true
        dollarSignsView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 10).isActive = true
        dollarSignsView.adjustsFontSizeToFitWidth = true
        dollarSignsView.minimumScaleFactor = 0.2
    }
    
    private func configureCategoriesView() {
        swipeView.addSubview(categoriesView)
        categoriesView.textColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        categoriesView.textAlignment = .left
        categoriesView.font = UIFont(name: "Montserrat-Medium", size: 15)
        categoriesView.text = "Korean, American"
        categoriesView.numberOfLines = 0
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.topAnchor.constraint(equalTo: ratingsView.bottomAnchor, constant: 4).isActive = true
        categoriesView.leftAnchor.constraint(equalTo: dollarSignsView.rightAnchor, constant: 4).isActive = true
        categoriesView.rightAnchor.constraint(equalTo: swipeView.rightAnchor, constant: 4).isActive = true
        categoriesView.adjustsFontSizeToFitWidth = true
        categoriesView.minimumScaleFactor = 0.2
    }
    
    private func configureDistanceView() {
        swipeView.addSubview(distanceView)
        distanceView.textAlignment = .left
        distanceView.font = UIFont(name: "Montserrat-Medium", size: 15)
        distanceView.text = "distance •"
        distanceView.translatesAutoresizingMaskIntoConstraints = false
        distanceView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 10).isActive = true
        distanceView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 10).isActive = true
        distanceView.adjustsFontSizeToFitWidth = true
        distanceView.minimumScaleFactor = 0.2
        
    }
    
    private func configurePhoneView() {
        swipeView.addSubview(phoneView)
        phoneView.textColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        phoneView.textAlignment = .left
        phoneView.font = UIFont(name: "Montserrat-Medium", size: 15)
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        phoneView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 10).isActive = true
        phoneView.leftAnchor.constraint(equalTo: distanceView.rightAnchor, constant: 4).isActive = true
        phoneView.centerYAnchor.constraint(equalTo: distanceView.centerYAnchor, constant: 0).isActive = true
        phoneView.adjustsFontSizeToFitWidth = true
        phoneView.minimumScaleFactor = 0.2

    }

    private func configureArrow(){
        swipeView.addSubview(arrowButton)
        let symbol = UIImage(systemName: "chevron.compact.down")
        arrowButton.setImage(symbol, for: .normal)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .regular, scale: .large)
        arrowButton.setPreferredSymbolConfiguration(configuration, forImageIn: .normal)
        arrowButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        arrowButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        arrowButton.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: 5).isActive = true
        arrowButton.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor).isActive = true
        arrowButton.topAnchor.constraint(greaterThanOrEqualTo: phoneView.bottomAnchor, constant: 5).isActive = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(goToURL))
        arrowButton.isUserInteractionEnabled = true
        arrowButton.addGestureRecognizer(singleTap)

    }
    
    
    private func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    
    private func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    
    
    //MARK: - Gesture Handlers
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! RestaurantCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
//        let distanceFromCenter = ((UIScreen.main.bounds.width / 2) - card.center.x)
//        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
        
        switch sender.state {
        case .ended:
            //swiped right
            if point.x > 120 {
                var cardRightTransform = card.transform
                cardRightTransform = cardRightTransform.translatedBy(x: card.frame.width*2 , y: -20)
                UIView.animate(withDuration: 0.2, animations: {
                    card.transform = cardRightTransform
                }, completion: { _ in
                    self.delegate?.swipeDidEnd(on: card)
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                    if let dataSource = self.dataSource, let email = Auth.auth().currentUser?.email{
                        self.delegate?.swipedRight(data: dataSource, userEmail: email, categoriesTitles: self.categoryTitles)
                    }
                })
                return
            //swiped left
            }else if point.x < -120 {
                var cardLeftTransform = card.transform
                cardLeftTransform = cardLeftTransform.translatedBy(x: -card.frame.width*2 , y: -20)
                UIView.animate(withDuration: 0.2, animations: {
                    card.transform = cardLeftTransform
                }, completion: { _ in
                    self.delegate?.swipeDidEnd(on: card)
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                })
                return
            }
            //goes back to initial spot if
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer){
    }
    
}

