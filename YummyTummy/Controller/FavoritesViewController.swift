//
//  FavoritesViewController.swift
//  YummyTummy
//
//  Created by John Kim on 7/9/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController{
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        Background().setAuthBackground(view,backgroundImageView)
    }
}
