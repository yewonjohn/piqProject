//
//  FavoritesViewController.swift
//  piq
//
//  Created by John Kim on 7/9/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import SwipeCellKit
import NVActivityIndicatorView

class FavoritesViewController: UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingAnimation: NVActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Properties
    
    private let favoriteManager = FavoritesManager()
    private var favoritesArray : [FavoritesModel]?
    private var filteredFavorites: [FavoritesModel]?
    private let backgroundImageView = UIImageView()
    private let currentUser = Auth.auth().currentUser
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        searchBar.delegate = self
        tableViewConfig()
        ServiceUtil().setBackground(view,backgroundImageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logInToViewAlert()
    }
    
    //MARK:-- UI Layout Config
    
    private func tableViewConfig(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: FavoritesCell.identifier, bundle: nil), forCellReuseIdentifier: FavoritesCell.identifier)
        
    }
    private func logInToViewAlert(){
        //check if user is logged in, if not, trigger alert
        if((currentUser) != nil){
            favoriteManager.delegate = self
            favoriteManager.loadFavorites()
        }else{
            let alert = UIAlertController(title: "Favorites", message: "Please Login to access favorites!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: { action in}))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
}
//MARK: -- TableView DataSource and Delegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFavorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set current cell with "Coming Cell" at the current index
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.identifier, for: indexPath) as! FavoritesCell
        //this delegate is for swipeCell Pod
        cell.delegate = self
        
        let currentFavorite = filteredFavorites?[indexPath.row]
        //setting fetched cell text
        if(currentFavorite?.userEmail == Auth.auth().currentUser?.email){
            cell.favoritesTitle.text = currentFavorite?.name
            cell.favoritesPrice.text = currentFavorite?.price
            let ratingCount = currentFavorite?.reviewCount.value ?? 0
            cell.favoritesRatingCount.text = String(ratingCount)
            cell.favoritesCategories.text = currentFavorite?.categories
                
            switch currentFavorite?.rating.value {
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
                let url = URL(string: currentFavorite?.img_url ?? "")
                cell.favoritesImage.kf.setImage(with: url)
            }
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120    }
    
    //Takes user to yelp page of selected favorite item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //deselects after selecting
        tableView.deselectRow(at: indexPath, animated: true)

        guard let url = URL(string: (filteredFavorites?[indexPath.row].url!) as! String) else { return }
        UIApplication.shared.open(url)
    }
}


//MARK: -- Favorites Manager Delegate
extension FavoritesViewController: FavoritesManagerDelegate{
    func isLoading() {
        loadingAnimation.startAnimating()
        }
    
    func didFetchFavorites(favorites: [FavoritesModel]?) {
        favoritesArray = favorites
        filteredFavorites = favoritesArray
        DispatchQueue.main.async {
            self.loadingAnimation.stopAnimating()
            self.tableView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        print("something went wrong fetching favorites :(, \(error)")
    }
    func didFailAddingFavorites(error: Error) {
        print("something went wrong is saving favorites :(, \(error)")
    }
    
}

//MARK: -- Cell Swipe Delegates
extension FavoritesViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let favArr = self.favoritesArray {
                self.favoritesArray?.remove(at: indexPath.row)
                self.favoriteManager.deleteFavorite(itemToDelete: favArr[indexPath.row])
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash_icon")
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

extension FavoritesViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("something")
        if(searchText == "" || searchText == nil){
            filteredFavorites = favoritesArray
            tableView.reloadData()
        }else{
                            
            filteredFavorites = []

            let filter = searchText.lowercased()
            if let favoritesArray = favoritesArray{
                for favorite in favoritesArray{
                    if let name = favorite.name?.lowercased(){
                        if(name.contains(filter)){
                            filteredFavorites?.append(favorite)
                        }
                    }
                }
            }

            tableView.reloadSections([0], with: .automatic)

        }


    }
}
