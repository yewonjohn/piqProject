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
    
//    let favorites = ["BonChon",]
    
    override func viewDidLoad() {
        Background().setAuthBackground(view,backgroundImageView)
        
        tableView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellReuseIdentifier: "FavoritesCell")

    }
    
    //MARK - Tableview DataSource Methods
    //DEFINES HOW MANY CELLS TO CREATE
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
//    }
    
    
}
