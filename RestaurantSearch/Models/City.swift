//
//  City.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import Foundation

// Use Codable only if you need to perform the complete protocol
// for Encodable & Decodable
// that means, if you need to process model information from Data -> Decodable
// and convert local data to send as external data -> Encodable

struct City: Decodable {
    var id: Int
    var name: String
    var countryId: Int?
    var countryName: String?
    var countryFlagUrl: String?
    var stateId: Int?
    var stateName: String?
    var stateCode: String?
    var customLocation: CustomLocation?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case countryId = "country_id"
        case countryName = "country_name"
        case countryFlagUrl = "country_flag_url"
        case stateId = "state_id"
        case stateName = "state_name"
        case stateCode = "state_code"
        case customLocation = "customLocation"
    }
    
    init(id: Int? = nil, name: String? = nil, countryId: Int? = nil, countryName: String? = nil, countryFlagUrl: String? = nil, stateId: Int? = nil, stateName: String? = nil, stateCode: String? = nil, customLocation: CustomLocation? = nil) {
        self.id = id ?? 0
        self.name = name ?? ""
        self.countryId = countryId
        self.countryName = countryName
        self.countryFlagUrl = countryFlagUrl
        self.stateId = stateId
        self.stateName = stateName
        self.stateCode = stateCode
        self.customLocation = customLocation
    }
}

struct CustomLocation: Decodable {
    var longitude: Double
    var latitude: Double
}

struct Cities: Decodable {
    var locationSuggestions: [City] = []
    
    enum CodingKeys: String, CodingKey {
        case locationSuggestions = "location_suggestions"
    }
}
