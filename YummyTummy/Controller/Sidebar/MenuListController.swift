//
//  MenuViewController.swift
//  YummyTummy
//
//  Created by John Kim on 7/8/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

protocol MenuControllerDelegate{
    func didSelectMenuItem(named: String)
}

class MenuListController: UITableViewController{
    
    public var delegate: MenuControllerDelegate?
    var menuItems: [String]
    
    init(with menuItems: [String]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.8287023902, blue: 0.3496767282, alpha: 0.5)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.8287023902, blue: 0.3496767282, alpha: 0.5)
        cell.imageView?.tintColor = #colorLiteral(red: 0.9098039216, green: 0.3137254902, blue: 0.3568627451, alpha: 1)

        if(menuItems[indexPath.row] == "Favorites"){
            cell.imageView?.image = UIImage(systemName: "star")
        }
        if(menuItems[indexPath.row] == "Home"){
            cell.imageView?.image = UIImage(systemName: "house")
        }
        if(menuItems[indexPath.row] == "Logout"){
            cell.imageView?.image = UIImage(systemName: "arrowshape.turn.up.left")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        delegate?.didSelectMenuItem(named: menuItems[indexPath.row])
    }
    
}
