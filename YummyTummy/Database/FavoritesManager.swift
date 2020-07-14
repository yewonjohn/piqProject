//
//  FavoritesManager.swift
//  YummyTummy
//
//  Created by John Kim on 7/10/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

//DEFINE PROTOCOL FOR DELEGATE FRAMEWORK
protocol FavoritesManagerDelegate {
    func didFetchFavorites(favorites: [FavoritesModel])
    func didFailWithError(error: Error)
    func didFailAddingFavorites(error: Error)
}

class FavoritesManager{

    let db = Firestore.firestore()
    var delegate: FavoritesManagerDelegate?
    
    var timeStamp = NSDate().timeIntervalSince1970
    
    func addToFavorites(user:String?, id: String?, name: String?, ratings: Float?, reviewCount: Int?, price: String?, distance: Double?, phone: String?, isClosed: Bool?, url: String?, img_url: String?, categories: String?){
        
        // CHECK IF CURRENT USER HAS THIS BUSINESS FAVORITED ALREADY
        let docRef = db.collection("favorites")
        var counter = 0
        
        docRef.getDocuments{ (snapshot, error) in
            if let snapshot = snapshot{
                for doc in snapshot.documents{
                    let data = doc.data()
                    if (data["user"] as? String == user && data["business_id"] as? String == id){
                        counter += 1
                    }
                }
                if(counter == 0){
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
                }
            }else {
                print("nothing saved in favorites at all\(error)")
            }
        }
        
        

    }
    func loadFavorites(){
        
        var favoritesArr = [FavoritesModel]()
        let currentUser = Auth.auth().currentUser?.email
        
        db.collection("favorites")
            .whereField("user", isEqualTo: currentUser)
            .order(by: "date_added")
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
                            
                            let newFavorite = FavoritesModel(userEmail: businessUserEmail, name: businessName, id: businessId, rating: businessRatings, reviewCount: businessReviewCount, price: businessPrice, distance: businessDistance, isClosed: businessIsClosed, phone: businessPhone, categories: businessCategories, url: businessUrl, img_url: businessImg_url)
                            
                            favoritesArr.append(newFavorite)
                        }
                    }
                    self.delegate?.didFetchFavorites(favorites: favoritesArr)
                }
                
        }
    }
    
    func deleteFavorite(itemToDelete: FavoritesModel) {
        
        db.collection("favorites").document(itemToDelete.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
}
