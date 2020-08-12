//
//  ViewController.swift
//  piq
//
//  Created by John Kim on 6/19/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

//MARK: - Defining Delegate
protocol RestaurantCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> RestaurantCardView
    func emptyView() -> Void
    func swipeStarted() -> Bool
}

class StackContainerView: UIView, RestaurantCardsDelegate {

    //MARK: - Properties
    var numberOfCardsToShow: Int = 0
    var lastCardCounter = 0
    var cardsToBeVisible: Int = 3
    var cardViews : [RestaurantCardView] = []
    var remainingcards: Int = 0
    var swipeStarted = true
    
    let horizontalInset: CGFloat = 10.0
    let verticalInset: CGFloat = 10.0
    
    var visibleCards: [RestaurantCardView] {
        return subviews as? [RestaurantCardView] ?? []
    }
    var dataSource: RestaurantCardsDataSource? {
        didSet {
            reloadData()
        }
    }
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadData() {
        swipeStarted = true
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingcards = numberOfCardsToShow
        lastCardCounter = numberOfCardsToShow
        
        for i in 0..<min(numberOfCardsToShow,cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i )
            
        }
    }

    //MARK: - Configurations

    private func addCardView(cardView: RestaurantCardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingcards -= 1
    }
    
    func addCardFrame(index: Int, cardView: RestaurantCardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
        
    func swipeDidEnd(on view: RestaurantCardView) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()
        if remainingcards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingcards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                cardView.center = self.center
                  self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }
        //keeping track of last card
        lastCardCounter -= 1
        if(lastCardCounter == 0){
            dataSource?.emptyView()
        }
        
        //triggering reset button to show here
        if(swipeStarted){
            swipeStarted = datasource.swipeStarted()
        }
    }
}

