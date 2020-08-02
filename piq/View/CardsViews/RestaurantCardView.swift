//
//  ViewController.swift
//  YummyTummy
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
}

class RestaurantCardView : UIView {
    
    let favoritesManager = FavoritesManager()
    let service = ServiceUtil()
    
    //MARK: - UI Properties
    var shadowView : UIView!
    var swipeView : UIView!
    var imageContainView: UIView!
    var imageView: UIImageView!
    var titleLabel = UILabel()
    var ratingsView: UIImageView!
    var ratingsCountView = UILabel()
    var dollarSignsView = UILabel()
    var categoriesView = UILabel()
    var isOpenView = UILabel()
    var phoneView = UILabel()
    var addressView = UILabel()
    var favoriteButton = UIButton()
    var yelpImgView: UIImageView!
    
    var categoryTitles = ""
    
    var delegate : RestaurantCardsDelegate?
    
    var divisor : CGFloat = 0
    let baseView = UIView()
    
    
    var dataSource : BusinessModel? {
        didSet {
            //reformatting phoneNumber
            var phoneNumber = dataSource?.phone
            phoneNumber = phoneNumber?.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
                        
            //setting UIViews text with data
            swipeView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
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
            
            //SETTING STORE OPEN/CLOSED
            if dataSource?.isClosed == true{
                isOpenView.text = "Closed now •"
                isOpenView.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                
            } else {
                isOpenView.text = "Open now •"
            isOpenView.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
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
            
            favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        }
    }

    //Action
    @objc func tapDetected() {
        guard let url = URL(string: (dataSource?.url)!) else { return }
        UIApplication.shared.open(url)
    }

    @objc func addToFavorites(){
        if let data = dataSource, let user = Auth.auth().currentUser?.email{
            favoritesManager.addToFavorites(user: user, id: data.id, name: data.name, ratings: data.rating, reviewCount: data.reviewCount, price: data.price, distance: data.distance, phone: data.phone, isClosed: data.isClosed, url: data.url, img_url: data.img_url, categories: categoryTitles)
            
            //animating button
            service.animateButton(button: favoriteButton)
        }
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
        configureisOpenView()
        configurePhoneView()
        configureYelpView()
        configureButton()
        addPanGestureOnCards()
        configureTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    
    func configureShadowView() {
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
    
    func configureSwipeView() {
        swipeView = UIView()
        swipeView.layer.cornerRadius = 15
        swipeView.clipsToBounds = true
        shadowView.addSubview(swipeView)
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive = true
        swipeView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive = true
        swipeView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive = true
        swipeView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive = true
    }
    func configureImageContainerView() {
        imageContainView = UIView()
        imageContainView.clipsToBounds = true
        swipeView.addSubview(imageContainView)
        imageContainView.translatesAutoresizingMaskIntoConstraints = false
        imageContainView.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor).isActive = true
        imageContainView.topAnchor.constraint(equalTo: swipeView.topAnchor).isActive = true
        imageContainView.widthAnchor.constraint(equalTo: self.swipeView.widthAnchor, multiplier: 1.0).isActive = true
        imageContainView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    func configureImageView() {
        imageView = UIImageView()
        imageContainView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageContainView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainView.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.imageContainView.widthAnchor, multiplier: 1.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.imageContainView.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    func configureTitleView() {
        imageContainView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: imageContainView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: imageContainView.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: imageContainView.bottomAnchor, constant: -4).isActive = true
    }
    
    func configureRatingsView() {
        ratingsView = UIImageView()
        ratingsView.image = UIImage(named: "regular_0")
        swipeView.addSubview(ratingsView)
        ratingsView.contentMode = .scaleAspectFit
        ratingsView.translatesAutoresizingMaskIntoConstraints = false
        ratingsView.topAnchor.constraint(equalTo: imageContainView.bottomAnchor).isActive = true
        ratingsView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 10).isActive = true
        ratingsView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        ratingsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureRatingsCountView() {
        swipeView.addSubview(ratingsCountView)
        ratingsCountView.textColor = .black
        ratingsCountView.textAlignment = .left
        ratingsCountView.font = UIFont.systemFont(ofSize: 16)
        ratingsCountView.translatesAutoresizingMaskIntoConstraints = false
        ratingsCountView.topAnchor.constraint(equalTo: imageContainView.bottomAnchor, constant: 16).isActive = true
        ratingsCountView.leftAnchor.constraint(equalTo: ratingsView.rightAnchor, constant: 8).isActive = true
    }
    
    func configureDollarSignsView() {
        swipeView.addSubview(dollarSignsView)
        dollarSignsView.textColor = .black
        dollarSignsView.textAlignment = .left
        dollarSignsView.font = UIFont.systemFont(ofSize: 18)
        dollarSignsView.translatesAutoresizingMaskIntoConstraints = false
        dollarSignsView.topAnchor.constraint(equalTo: ratingsView.bottomAnchor, constant: 4).isActive = true
        dollarSignsView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 10).isActive = true
    }
    
    func configureCategoriesView() {
        swipeView.addSubview(categoriesView)
        categoriesView.textColor = .black
        categoriesView.textAlignment = .left
        categoriesView.font = UIFont.systemFont(ofSize: 18)
        categoriesView.text = "Korean, American"
        categoriesView.numberOfLines = 0
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.topAnchor.constraint(equalTo: ratingsView.bottomAnchor, constant: 4).isActive = true
        categoriesView.leftAnchor.constraint(equalTo: dollarSignsView.rightAnchor, constant: 4).isActive = true
        categoriesView.rightAnchor.constraint(equalTo: swipeView.rightAnchor, constant: 2).isActive = true
    }
    
    func configureisOpenView() {
        swipeView.addSubview(isOpenView)
        isOpenView.textColor = .red
        isOpenView.textAlignment = .left
        isOpenView.font = UIFont.boldSystemFont(ofSize: 18)
        isOpenView.text = "Closed now •"
        isOpenView.translatesAutoresizingMaskIntoConstraints = false
        isOpenView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 10).isActive = true
        isOpenView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 10).isActive = true
    }
    
    func configurePhoneView() {
        swipeView.addSubview(phoneView)
        phoneView.textColor = .black
        phoneView.textAlignment = .left
        phoneView.font = UIFont.systemFont(ofSize: 18)
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        phoneView.topAnchor.constraint(equalTo: categoriesView.bottomAnchor, constant: 10).isActive = true
        phoneView.leftAnchor.constraint(equalTo: isOpenView.rightAnchor, constant: 4).isActive = true
    }
    func configureYelpView(){
        yelpImgView = UIImageView()
        yelpImgView.image = UIImage(named: "yelp_logo_1")
        swipeView.addSubview(yelpImgView)
        yelpImgView.contentMode = .scaleAspectFit
        yelpImgView.translatesAutoresizingMaskIntoConstraints = false
        yelpImgView.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -20).isActive = true
        yelpImgView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 15).isActive = true
        yelpImgView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        yelpImgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        yelpImgView.isUserInteractionEnabled = true
        yelpImgView.addGestureRecognizer(singleTap)
    }

    func configureButton() {
        swipeView.addSubview(favoriteButton)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "plus-tab")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        favoriteButton.layer.borderWidth = 1
//        favoriteButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        favoriteButton.layer.cornerRadius  = 7
        favoriteButton.rightAnchor.constraint(equalTo: swipeView.rightAnchor, constant: -30).isActive = true
        favoriteButton.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: -30).isActive = true
    }
    
    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! RestaurantCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        let distanceFromCenter = ((UIScreen.main.bounds.width / 2) - card.center.x)
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
        
        switch sender.state {
        case .ended:
            if (card.center.x) > 350 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 10.0) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }else if card.center.x < -35 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 10.0) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
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
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
    }
    
    
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
