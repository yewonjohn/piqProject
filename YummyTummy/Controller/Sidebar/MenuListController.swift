//
//  MenuViewController.swift
//  YummyTummy
//
//  Created by John Kim on 7/8/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol MenuControllerDelegate{
    func didSelectMenuItem(named: String)
}

class MenuListController: UITableViewController{
    
    // MARK: - Properties
    public var delegate: MenuControllerDelegate?
    var menuItems: [String]
    
    // MARK: - View Controller Life Cycle
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
        tableView.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
    }
    // MARK: - Menu List Configuration

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        cell.imageView?.tintColor = #colorLiteral(red: 0.9098039216, green: 0.2901960784, blue: 0.3725490196, alpha: 1)

        if(menuItems[indexPath.row] == MenuList.home){
            cell.imageView?.image = UIImage(systemName: "star")
        }
        if(menuItems[indexPath.row] == MenuList.favorites){
            cell.imageView?.image = UIImage(systemName: "house")
        }
        if(menuItems[indexPath.row] == MenuList.logout){
            cell.imageView?.image = UIImage(systemName: "arrowshape.turn.up.left")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        delegate?.didSelectMenuItem(named: menuItems[indexPath.row])
    }
}
