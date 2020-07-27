//
//  FavoritesViewController.swift
//  YummyTummy
//
//  Created by John Kim on 7/9/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import SwipeCellKit

class FavoritesViewController: UITableViewController, SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.favoritesManager.deleteFavorite(itemToDelete: self.favoritesArray[indexPath.row])
            DispatchQueue.main.async {
//                tableView.reloadData()
                print(self.favoritesArray)
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    
    let favoritesManager = FavoritesManager()
    var favoritesArray = [FavoritesModel]()
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        
        tableView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellReuseIdentifier: "FavoritesCell")
        
        favoritesManager.delegate = self
        favoritesManager.loadFavorites()
        
        view.backgroundColor = #colorLiteral(red: 0.8941176471, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesManager.loadFavorites()
    }
    
    
    //MARK - Tableview DataSource Methods
    //DEFINES HOW MANY CELLS TO CREATE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120    }
    
    //Runs every time a cell is loaded
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set current cell with "Coming Cell" at the current index
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        cell.delegate = self
        
        
        //setting fetched cell text
        if(favoritesArray[indexPath.row].userEmail == Auth.auth().currentUser?.email){
            cell.favoritesTitle.text = favoritesArray[indexPath.row].name
            cell.favoritesPrice.text = favoritesArray[indexPath.row].price
            cell.favoritesRatingCount.text = String(favoritesArray[indexPath.row].reviewCount.value!)
            cell.favoritesCategories.text = favoritesArray[indexPath.row].categories
            
            switch favoritesArray[indexPath.row].rating.value {
            case 0.0:
                cell.favoritesRatings.image = UIImage(named: "regular_0")
            case 0.5:
                cell.favoritesRatings.image = UIImage(named: "regular_0_half")
            case 1.0:
                cell.favoritesRatings.image = UIImage(named: "regular_1")
            case 1.5:
                cell.favoritesRatings.image = UIImage(named: "regular_1_half")
            case 2.0:
                cell.favoritesRatings.image = UIImage(named: "regular_2")
            case 2.5:
                cell.favoritesRatings.image = UIImage(named: "regular_2_half")
            case 3.0:
                cell.favoritesRatings.image = UIImage(named: "regular_3")
            case 3.5:
                cell.favoritesRatings.image = UIImage(named: "regular_3_half")
            case 4.0:
                cell.favoritesRatings.image = UIImage(named: "regular_4")
            case 4.5:
                cell.favoritesRatings.image = UIImage(named: "regular_4_half")
            case 5.0:
                cell.favoritesRatings.image = UIImage(named: "regular_5")
            default:
                cell.favoritesRatings.image = UIImage(named: "regular_0")
            }
            //setting image using kingfisher
            let url = URL(string: favoritesArray[indexPath.row].img_url!)
            cell.favoritesImage.kf.setImage(with: url)
            //returning updated cell
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //deselects after selecting
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = URL(string: (favoritesArray[indexPath.row].url!)) else { return }
        UIApplication.shared.open(url)
        
    }
    //defines swipe
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
//    {
//        // 1
//        let deleteAction = UITableViewRowAction(style: .default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
//            // 2
//            let deleteMenu = UIAlertController(title: nil, message: "Delete?", preferredStyle: .actionSheet)
//
//            let deleteAction = UIAlertAction(title: "Yes delete", style: .default, handler: {
//                // deleting from realm and cloud
//                (alert: UIAlertAction!) in self.favoritesManager.deleteFavorite(itemToDelete: self.favoritesArray[indexPath.row])
//                // deleting from instance variable - already taken care of by realm i think..
//                //                self.favoritesArray.remove(at: indexPath.row)
//                DispatchQueue.main.async {
//                    //                    self.favoritesManager.loadFavorites()
//                    tableView.reloadData()
//                    print("reloaded data here")
//                }
//
//            })
//            let cancelAction = UIAlertAction(title: "Nevermind I like", style: .cancel, handler: nil)
//
//            deleteMenu.addAction(deleteAction)
//            deleteMenu.addAction(cancelAction)
//
//            self.present(deleteMenu, animated: true, completion: nil)
//        })
//        return [deleteAction]
//    }
    
}
extension FavoritesViewController: FavoritesManagerDelegate{
    
    func didFetchFavorites(favorites: [FavoritesModel]) {
        favoritesArray = favorites
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("reloaded data here")
        }
    }
    
    func didFailWithError(error: Error) {
        print("something went wrong fetching favorites :(, \(error)")
    }
    
    func didFailAddingFavorites(error: Error) {
        print("something went wrong is saving favorites :(, \(error)")
    }
    
    
}

extension FavoritesViewController{
    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
}
