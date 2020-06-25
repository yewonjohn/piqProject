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

class RestaurantManager{
//    latitude: Double,
//    longitude: Double,
//    location: String,
//    category: String,
//    sortBy: String,
//    term: String,
//    categories: String,
//    price: Int,


    func getLocalRestaurants(){
        var businesses: [Businesses]? = []
        let url = "https://api.yelp.com/v3/businesses/search"
        let requestParams: Parameters = ["term": "cafe", "location": "Montreal, QC"]

        let apiKey = "XoLZTUzyXFYVkxV7QjDpxU0gkHSdGbUNmGPtMtIQcOdPzpQDF5iGA5kCBGkX7QFYrd8He5_OSg_mrLFeKfvOyd3_bZ8A7gHsyiwu0DUvDTAlpag_ctqd7j9B7DDtXnYx"
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(apiKey)"]

        
        AF.request(url, method: .get, parameters: requestParams, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { (responseObject) in
            switch responseObject.result {
            case .success:
                print("Success!")
                let json: JSON = JSON(responseObject.data)
                
                let businessArray = json["businesses"].arrayValue
                
                for business in businessArray {
                    let categories = business["categories"].arrayValue
                    for category in categories{
                        var cat = Categories()
                        cat.alias = category["alias"].stringValue
                        cat.title = category["title"].stringValue
                        
                        let business1 = Businesses(name: json["name"].stringValue,
                                                  id: json["id"].stringValue,
                                                  rating: json["rating"].floatValue,
                                                  reviewCount: json["review_count"].intValue,
                                                  price: json["price"].stringValue,
                                                  distance: json["distance"].doubleValue,
                                                  address: json["location"]["address1"].stringValue,
                                                  zipcode: json["location"]["zip_code"].stringValue,
                                                  city: json["location"]["city"].stringValue,
                                                  country: json["location"]["country"].stringValue,
                                                  state: json["location"]["state"].stringValue,
                                                  isClosed: json["is_closed"].boolValue,
                                                  phone: json["phone"].stringValue,
                                                  categories: cat,
                                                  url: json["url"].stringValue,
                                                  img_url: json["image_url"].stringValue)
                        
                        print(business1.categories)
                    }
                }

                
                
            case let .failure(error):
                print(error)
            }
        }
        
    }
    
    
    
}
