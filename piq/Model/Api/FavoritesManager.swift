//
//  FavoritesManager.swift
//  piq
//
//  Created by John Kim on 7/10/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import RealmSwift

protocol FavoritesManagerDelegate {
    func didFetchFavorites(favorites: [FavoritesModel]?)
    //    func didFetchFavoritesLocally(favorites: Results<FavoritesModel>)
    func didFailWithError(error: Error)
    func didFailAddingFavorites(error: Error)
    func isLoading()
}

//network calls to firebase (database) for favorites objects
class FavoritesManager{
    //MARK: - Properties
    
    let db = Firestore.firestore()
    var delegate: FavoritesManagerDelegate?
    
    let realm = try! Realm()
    var timeStamp = NSDate().timeIntervalSince1970
    let currentUser = Auth.auth().currentUser?.email
    
    
    //MARK: - Functions (ADD)
    func addToFavorites(user:String?, id: String?, name: String?, ratings: Float?, reviewCount: Int?, price: String?, distance: Double?, phone: String?, isClosed: Bool?, url: String?, img_url: String?, categories: String?){
        
        timeStamp = NSDate().timeIntervalSince1970
        // CHECK IF CURRENT USER HAS THIS FAVORITED ALREADY
        let docRef = db.collection("favorites")
        var exists = false
        
        docRef.getDocuments{ (snapshot, error) in
            if let snapshot = snapshot{
                for doc in snapshot.documents{
                    let data = doc.data()
                    if (data["user"] as? String == user && data["business_id"] as? String == id){
                        exists = true
                    }
                }
                if(exists == false){
                    //saving to cloud
                    self.db.collection("favorites").document(id!).setData([
                        "user":user,
                        "business_id":id,
                        "name":name,
                        "ratings":ratings,
                        "reviewCount":reviewCount,
                        "price":price,
                        "distance":distance,
                        "phone":phone,
                        "isClosed":isClosed,
                        "url":url,
                        "img_url":img_url,
                        "categories":categories,
                        "date_added":self.timeStamp
                    ]){ (error) in
                        if let e = error{
                            self.delegate?.didFailAddingFavorites(error: e)
                        } else{
                            print("succesfully saved favorites")
                        }
                    }
                    //saving to realm (not really using this yet)
                    let favorite = FavoritesModel()
                    favorite.userEmail = user
                    favorite.name = name
                    favorite.id = id
                    favorite.rating.value = ratings
                    favorite.reviewCount.value = reviewCount
                    favorite.price = price
                    favorite.distance.value = distance
                    favorite.phone = phone
                    favorite.isClosed.value = isClosed
                    favorite.url = url
                    favorite.img_url = img_url
                    favorite.categories = categories
                    favorite.date_added = Date(timeIntervalSince1970: self.timeStamp)
                    
                    do{
                        try self.realm.write{
                            self.realm.add((favorite))
                        }
                    }catch {
                        print("Error saving favorite \(error)")
                    }
                    
                }
            }else {
                print("nothing saved in favorites at all\(error)")
            }
        }
        
    }
        func loadFavorites(){
            
            delegate?.isLoading()
    
            var favoritesArr = [FavoritesModel]()
            let currentUser = Auth.auth().currentUser?.email
    
            db.collection("favorites")
                .whereField("user", isEqualTo: currentUser)
                .order(by: "date_added", descending: false)
                .getDocuments{ (QuerySnapshot, Error) in
                    if let e = Error{
                        self.delegate?.didFailWithError(error: e)
                    }
                    else {
                        if let snapshotDocuments = QuerySnapshot?.documents{
                            for doc in snapshotDocuments{
                                let data = doc.data()
    
                                let businessName = data["name"] as? String
                                let businessId = data["business_id"] as? String
                                let businessRatings = data["ratings"] as? Float
                                let businessReviewCount = data["reviewCount"] as? Int
                                let businessCategories = data["categories"] as? String
                                let businessDistance = data["distance"] as? Double
                                let businessPrice = data["price"] as? String
                                let businessUrl = data["url"] as? String
                                let businessImg_url = data["img_url"] as? String
                                let businessPhone = data["phone"] as? String
                                let businessIsClosed = data["isClosed"] as? Bool
                                let businessUserEmail = data["user"] as? String
    
                                let newFavorite = FavoritesModel()
                                newFavorite.userEmail = businessUserEmail
                                newFavorite.name = businessName
                                newFavorite.id = businessId
                                newFavorite.rating.value = businessRatings
                                newFavorite.reviewCount.value = businessReviewCount
                                newFavorite.price = businessPrice
                                newFavorite.distance.value = businessDistance
                                newFavorite.isClosed.value = businessIsClosed
                                newFavorite.phone = businessPhone
                                newFavorite.categories = businessCategories
                                newFavorite.url = businessUrl
                                newFavorite.img_url = businessImg_url
    
                                favoritesArr.append(newFavorite)
                            }
                        }
                        self.delegate?.didFetchFavorites(favorites: favoritesArr)
                    }
            }
        }
    //MARK: - Functions (GET)
//    func loadFavoritesLocally(){
//        if let user = currentUser{
//            favorites = realm.objects(FavoritesModel.self).filter("userEmail = '\(user)'")
//            self.delegate?.didFetchFavorites(favorites: favorites)
//        }
//    }
    //MARK: - Functions (DELETE)
    func deleteFavorite(itemToDelete: FavoritesModel) {
        //deleting from cloud
        db.collection("favorites").document(itemToDelete.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        //deleting locally 
        do{
            let object = realm.objects(FavoritesModel.self).filter("id = %@", itemToDelete.id).first
            try realm.write{
                if let obj = object {
                    realm.delete(obj)
                }
            }
        }catch {
            print("error deleting local data \(error)")
        }
    }
    
    //MARK: - Functions (Sync)
//    func sync(){
//        var favoritesArr = [FavoritesModel]()
//        let currentUser = Auth.auth().currentUser?.email
//
//        db.collection("favorites")
//            .whereField("user", isEqualTo: currentUser)
//            .order(by: "date_added")
//            .getDocuments{ (QuerySnapshot, Error) in
//                if let e = Error{
//                    self.delegate?.didFailWithError(error: e)
//                }
//                else {
//                    if let snapshotDocuments = QuerySnapshot?.documents{
//                        for doc in snapshotDocuments{
//                            //commenting something here
//                        }
//                    }
//                }
//        }
//    }
}

