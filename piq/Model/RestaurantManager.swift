//
//  RestaurantManager.swift
//  YummyTummy
//
//  Created by John Kim on 6/24/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation


class RestaurantManager{
    
    //MARK: - Functions (GET)
    func getLocalRestaurants(distance: Int?, latitude: Double, longitude: Double, category: String?, dollarSigns: String?, completion: @escaping ((_ businesses:[BusinessModel])->Void)){
        var businesses: [BusinessModel]? = []
        let url = "https://api.yelp.com/v3/businesses/search"
        
        //        let distanceWR = distance!
        var requestParams : [String: Any] = [:]
        //Calling API depending on headers
        print(distance)
        print(category)
        print(dollarSigns)
        
        //everything included
        if(distance != nil && category != nil && dollarSigns != nil){
            if let dist = distance, let price = dollarSigns, let cat = category{
                requestParams = ["limit": 50,"radius":dist,"latitude": latitude,"longitude": longitude,"categories": cat,"price": price]
                print("1")
            }
        }
        //distance
        else if(distance != nil && category == nil && dollarSigns == nil){
            if let dist = distance{
                requestParams = ["limit": 50,"radius":dist,"latitude": latitude,"longitude": longitude]
                print("2")
            }
        }
        //dollarSigns
        else if(distance == nil && category == nil && dollarSigns != nil){
            if let price = dollarSigns{
                requestParams = ["limit": 50,"latitude": latitude,"longitude": longitude,"price": price]
                print("3")
            }
        }
        //category
        else if(distance == nil && category != nil && dollarSigns == nil){
            if let cat = category{
                requestParams = ["limit": 50,"latitude": latitude,"longitude": longitude,"category":cat]
                print("4")
            }
        }
        //distance and dollarSigns
        else if(distance != nil && category == nil && dollarSigns != nil){
            if let price = dollarSigns, let dist = distance{
                requestParams = ["limit": 50,"radius":dist,"latitude": latitude,"longitude": longitude,"price": price]
                print("5")
            }
        }
        //distance and category
        else if(distance != nil && category != nil && dollarSigns == nil){
            if let cat = category, let dist = distance{
                requestParams = ["limit": 50,"radius":dist,"latitude": latitude,"longitude": longitude,"categories": cat]
                print("6")
            }
        }
        //category and dollarSigns
        else if(distance == nil && category != nil && dollarSigns != nil){
            if let price = dollarSigns, let cat = category{
                requestParams = ["limit": 50,"latitude": latitude,"longitude": longitude,"categories": cat,"price": price]
                print("7")
            }
        }
        //none
        else if(distance == nil && category != nil && dollarSigns != nil){
            requestParams = ["limit": 50,"latitude": latitude,"longitude": longitude]
            print("8")
        }



        
        //        if let cat = category{
        //            if(dollarSigns == nil && cat != ""){
        //                requestParams = ["limit": 40,"latitude": latitude, "longitude": longitude, "categories": cat]
        //            }
        //        }
        //        if let price = dollarSigns{
        //            if(category == nil && price != ""){
        //                requestParams = ["limit": 40, "latitude": latitude, "longitude": longitude, "price": price]
        //            }
        //        }
        //        if let price = dollarSigns, let cat = category {
        //            requestParams = ["limit": 40, "latitude": latitude, "longitude": longitude, "categories": cat,"price": price]
        //        }
        //        if ((category == nil || category! == "") && (dollarSigns == nil || dollarSigns! == "")){
        //            if let distanceWR = distance{
        //            requestParams = ["limit": 40, "radius":distanceWR, "latitude": latitude, "longitude": longitude]
        //            }
        //        }
        //
        
        let apiKey = "XoLZTUzyXFYVkxV7QjDpxU0gkHSdGbUNmGPtMtIQcOdPzpQDF5iGA5kCBGkX7QFYrd8He5_OSg_mrLFeKfvOyd3_bZ8A7gHsyiwu0DUvDTAlpag_ctqd7j9B7DDtXnYx"
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(apiKey)"]
        
        
        AF.request(url, method: .get, parameters: requestParams, encoding: URLEncoding.default, headers: headers).validate().responseJSON { (responseObject) in
            switch responseObject.result {
            case .success:
                print("Success!")
                let json: JSON = JSON(responseObject.data)
                let businessArray = json["businesses"].arrayValue
                
                for business in businessArray {
                    print(business)
                    var categoryArr = [Categories]()
                    
                    let categories = business["categories"].arrayValue
                    for category in categories{
                        var cat = Categories()
                        cat.alias = category["alias"].stringValue
                        cat.title = category["title"].stringValue
                        categoryArr.append(cat)
                    }
                    let businessUnit = BusinessModel(name: business["name"].stringValue,
                                                     id: business["id"].stringValue,
                                                     rating: business["rating"].floatValue,
                                                     reviewCount: business["review_count"].intValue,
                                                     price: business["price"].stringValue,
                                                     distance: business["distance"].doubleValue,
                                                     isClosed: business["is_closed"].boolValue,
                                                     phone: business["phone"].stringValue,
                                                     categories: categoryArr,
                                                     url: business["url"].stringValue,
                                                     img_url: business["image_url"].stringValue
                    )
                    
                    businesses?.append(businessUnit)
                }
                
            case let .failure(error):
                print(error)
            }
            //FIX THIS FORCE UNWRAP LATER
            completion(businesses!)
        }
    }
    
    
    
}
