//
//  Constants.swift
//  piq
//
//  Created by John Kim on 6/23/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

struct Colors {
    static let tropicBlue = UIColor(red: 0, green: 192/255, blue: 255/255, alpha: 1)
}


struct Fonts {
    static let avenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
}

struct MenuList {
    static let home = "Home"
    static let favorites = "Favorites"
    static let logout = "Logout"
    static let empty = ""
}

struct MenuItems {
    static let reset = "Reset Cards"
}

struct RestaurantVC {
    static let emptyCardsText = "No more cards!"
}

struct SearchPage {
    static let categoriesLabels = ["All","Breakfast & Brunch","Burgers","Pizza","Mexican","Chinese","Seafood","Thai", "Sandwiches","Italian","Steakhouses","Korean","Japanese","Vietnamese","Vegetarian","Sushi Bars","American (New)"]
    
    static let categoriesUIImages = [UIImage(named: "all_food"), UIImage(named: "breakfast"), UIImage(named: "burger"), UIImage(named: "pizza"),UIImage(named: "taco"),UIImage(named: "chinese"),UIImage(named: "seafood"),UIImage(named: "thai"),UIImage(named: "sandwich"),UIImage(named: "spaghetti"),UIImage(named: "steak"),UIImage(named: "korean"),UIImage(named: "japanese"),UIImage(named: "vietnamese"),UIImage(named: "salad"),UIImage(named: "sushi"),UIImage(named: "american")]
}

struct AuthPage {
    static let animationIcons = [UIImage(named: "Beer"), UIImage(named: "Cafe"), UIImage(named: "Cinnamon Roll"), UIImage(named: "Cookies"), UIImage(named: "Cotton Candy"), UIImage(named: "Cupcake"),UIImage(named: "Dim Sum"), UIImage(named: "Pizza"), UIImage(named: "Rack of Lamb")]
    
    static let animationIcons2 = [UIImage(named: "Doughnut"), UIImage(named: "Food And Wine"), UIImage(named: "French Fries"), UIImage(named: "Hamburger"), UIImage(named: "Hot Dog"), UIImage(named: "Kebab"), UIImage(named: "Pancake"), UIImage(named: "Porridge"), UIImage(named: "Ice Cream Cone")]
    
    static let animationIcons3 = [UIImage(named: "Pizza"), UIImage(named: "Porridge"), UIImage(named: "Rack of Lamb"), UIImage(named: "Spaghetti"), UIImage(named: "Steak"), UIImage(named: "Sushi"), UIImage(named: "Taco"), UIImage(named: "Wrap"), UIImage(named: "Noodles")]
}


struct RestaturantCardPage{
    static let tutorialLeftKey = "tutorialLeftTriggered"
    static let tutorialRightKey = "tutorialRightTriggered"
    
}

struct ProfilePage{
    static let accountSettingsLabel = ["Search History", "Password", "Rate Us", "App Feedback", "Logout"]
    static let accountSettingsImages = [#imageLiteral(resourceName: "History"),#imageLiteral(resourceName: "Lock"),#imageLiteral(resourceName: "Thumbs Up"),#imageLiteral(resourceName: "Comment"),#imageLiteral(resourceName: "Sign Out")]
}
