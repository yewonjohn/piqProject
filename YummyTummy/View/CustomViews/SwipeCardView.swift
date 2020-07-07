//
//  ViewController.swift
//  YummyTummy
//
//  Created by John Kim on 6/19/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import Kingfisher

protocol SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView)
}

class SwipeCardView : UIView {
    
    //MARK: - Properties
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
    var label = UILabel()
    var moreButton = UIButton()
    
    var delegate : SwipeCardsDelegate?
    
    var divisor : CGFloat = 0
    let baseView = UIView()
    
    
    
    var dataSource : BusinessModel? {
        didSet {
            swipeView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            label.text = dataSource?.text
            guard let image = dataSource?.img_url else { return }
            imageView.image = UIImage(named: image)
            titleLabel.text = dataSource?.name
            ratingsCountView.text = "\(dataSource?.reviewCount ?? 0) Reviews"
            dollarSignsView.text = "\(dataSource?.price ?? "$") •"
            phoneView.text = dataSource?.phone
            let url = URL(string: dataSource?.img_url ?? "")
            imageView.kf.setImage(with: url)
        }
    }
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureShadowView()
        configureSwipeView()
        configureLabelView()
        configureImageContainerView()
        configureImageView()
        configureTitleView()
        configureRatingsView()
        configureRatingsCountView()
        configureDollarSignsView()
        configureCategoriesView()
        configureisOpenView()
        configurePhoneView()
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
        //        imageView.contentMode = .scaleAspectFit
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
        ratingsView.image = UIImage(named: "regular_4_half")
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
        categoriesView.translatesAutoresizingMaskIntoConstraints = false
        categoriesView.topAnchor.constraint(equalTo: ratingsView.bottomAnchor, constant: 4).isActive = true
        categoriesView.leftAnchor.constraint(equalTo: dollarSignsView.rightAnchor, constant: 4).isActive = true
    }
    
    func configureisOpenView() {
        swipeView.addSubview(isOpenView)
        isOpenView.textColor = .red
        isOpenView.textAlignment = .left
        isOpenView.font = UIFont.boldSystemFont(ofSize: 18)
        isOpenView.text = "Closed now •"
        isOpenView.translatesAutoresizingMaskIntoConstraints = false
        isOpenView.topAnchor.constraint(equalTo: dollarSignsView.bottomAnchor, constant: 10).isActive = true
        isOpenView.leftAnchor.constraint(equalTo: swipeView.leftAnchor, constant: 10).isActive = true
    }
    
    func configurePhoneView() {
        swipeView.addSubview(phoneView)
        phoneView.textColor = .black
        phoneView.textAlignment = .left
        phoneView.font = UIFont.systemFont(ofSize: 18)
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        phoneView.topAnchor.constraint(equalTo: dollarSignsView.bottomAnchor, constant: 10).isActive = true
        phoneView.leftAnchor.constraint(equalTo: isOpenView.rightAnchor, constant: 4).isActive = true
    }
    
    func configureLabelView() {
        swipeView.addSubview(label)
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: swipeView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: swipeView.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: swipeView.bottomAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 85).isActive = true
    }
    
    func configureButton() {
        label.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "plus-tab")?.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(image, for: .normal)
        moreButton.tintColor = UIColor.red
        
        moreButton.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -15).isActive = true
        moreButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
        let card = sender.view as! SwipeCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
        
        let distanceFromCenter = ((UIScreen.main.bounds.width / 2) - card.center.x)
        divisor = ((UIScreen.main.bounds.width / 2) / 0.61)
        
        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }else if card.center.x < -65 {
                delegate?.swipeDidEnd(on: card)
                UIView.animate(withDuration: 0.2) {
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
