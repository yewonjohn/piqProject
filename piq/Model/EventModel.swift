//
//  EventModel.swift
//  piq
//
//  Created by John Kim on 11/1/20.
//  Copyright © 2020 John Yewon Kim. All rights reserved.
//

import Foundation

struct EventResponse : Decodable{
    var events: [EventModel]?
    
}

struct EventModel : Decodable{
    
    var attending_count : Int?
    var category: String?
    var cost: Double?
    var description: String?
    var event_site_url: String?
    var id: String?
    var image_url: String?
    var name: String?
    var tickets_url: String?
    var time_end: String?
    var time_start: String?
    var location: EventLocation?
    var business_id: String?
    
}

struct EventLocation : Decodable{
    var address1: String?
    var city: String?
    var zip_code : String?
    var country: String?
    var state: String?
    var display_address: [String]?
}
