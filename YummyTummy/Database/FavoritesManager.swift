//
//  FavoritesManager.swift
//  YummyTummy
//
//  Created by John Kim on 7/10/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import Firebase

//DEFINE PROTOCOL FOR DELEGATE FRAMEWORK
protocol FavoritesManagerDelegate {
    func didFetchFavorites(favorites: [FavoritesModel])
    func didFailWithError(error: Error)
    func didFailAddingFavorites(error: Error)
}

class FavoritesManager{
    
    let db = Firestore.firestore()
    var delegate: FavoritesManagerDelegate?
    
    func addToFavorites(user:String?, id: String?, name: String?, ratings: Float?, reviewCount: Int?, price: String?, distance: Double?, phone: String?, isClosed: Bool?, url: String?, img_url: String?, categories: String?){
        
        db.collection("favorites").addDocument(data: ["user":user,
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
                                                      "categories":categories
        ]) { (error) in
            if let e = error{
                self.delegate?.didFailAddingFavorites(error: e)
            } else{
                print("succesfully saved favorites")
            }
        }
        
    }
    
    func loadFavorites(){
        
        var favoritesArr = [FavoritesModel]()
        
        db.collection("favorites").getDocuments{ (QuerySnapshot, Error) in
            if let e = Error{
                self.delegate?.didFailWithError(error: e)
            }
            else {
                if let snapshotDocuments = QuerySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        
                        print("we in here?")
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
                print(favoritesArr)
                self.delegate?.didFetchFavorites(favorites: favoritesArr)
            }
            
        }
    }
    
    
}
