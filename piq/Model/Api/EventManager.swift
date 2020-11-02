//
//  EventManager.swift
//  piq
//
//  Created by John Kim on 11/1/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation

class EventManager {
    
    static let apiKey = "XoLZTUzyXFYVkxV7QjDpxU0gkHSdGbUNmGPtMtIQcOdPzpQDF5iGA5kCBGkX7QFYrd8He5_OSg_mrLFeKfvOyd3_bZ8A7gHsyiwu0DUvDTAlpag_ctqd7j9B7DDtXnYx"
    
    func getEvents(completion: @escaping ((_ events: [EventModel]) -> Void)){
        
        let session = URLSession.shared
        //        var url = URL(string: "https://api.yelp.com/v3/events")!
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.yelp.com"
        urlComponent.path = "/v3/events"
        urlComponent.queryItems = [
            URLQueryItem(name: "location", value: "New York"),
            URLQueryItem(name: "limit", value: "50")
        ]
        guard let url = urlComponent.url else {return}
        var request = URLRequest(url: url)
        request.setValue("Bearer XoLZTUzyXFYVkxV7QjDpxU0gkHSdGbUNmGPtMtIQcOdPzpQDF5iGA5kCBGkX7QFYrd8He5_OSg_mrLFeKfvOyd3_bZ8A7gHsyiwu0DUvDTAlpag_ctqd7j9B7DDtXnYx", forHTTPHeaderField: "Authorization")
        
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            print(response)
            if(error != nil){
                print(error?.localizedDescription)
            }
            else{
                do{
                    let json = try JSONDecoder().decode(EventResponse.self, from: data! )
//                    print(json)
                    
                    completion(json.events ?? [])
                }catch{
                    print(error)
                }
            }
            
        })
        task.resume()
    }
    
    
    
}
