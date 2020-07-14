//
//  FavoritesViewController.swift
//  YummyTummy
//
//  Created by John Kim on 7/9/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UITableViewController{
    
    let favoritesManager = FavoritesManager()
    var favoritesArray = [FavoritesModel]()
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        
        //making navigation bar transparent
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.clear
                
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

        
        //setting fetched cell text
        if(favoritesArray[indexPath.row].userEmail == Auth.auth().currentUser?.email){
            cell.favoritesTitle.text = favoritesArray[indexPath.row].name
            cell.favoritesPrice.text = favoritesArray[indexPath.row].price
            cell.favoritesRatingCount.text = String(favoritesArray[indexPath.row].reviewCount!)
            cell.favoritesCategories.text = favoritesArray[indexPath.row].categories
            
            switch favoritesArray[indexPath.row].rating {
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
        
        //SEGUE - sets current video to local var, and triggers segue
//        let vid = videoArray[indexPath.row]
//        vidToPass = vid
//        performSegue(withIdentifier: "ComingSegue", sender: self)
    }

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
