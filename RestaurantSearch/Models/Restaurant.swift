//
//  Restaurant.swift
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

struct RestaurantData: Decodable {
    var restaurant: Restaurant?
}

struct Restaurant: Decodable {
    var id: String?
    var name: String?
    var url: String?
    var location: Location?
    var priceRange: Int?
    var currency: String?
    var thumb: String?
    var featuredImage: String?
    var photosUrl: String?
    var menuUrl: String?
    var eventsUrl: String?
    var deeplink: String?
    var cuisines: String?
    var allReviewsCount: Int?
    var photoCount: Int?
    var phoneNumbers: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case url = "url"
        case location = "location"
        case priceRange = "price_range"
        case currency = "currency"
        case thumb = "thumb"
        case featuredImage = "featured_image"
        case photosUrl = "photos_url"
        case menuUrl = "menu_url"
        case eventsUrl = "events_url"
        case deeplink = "deeplink"
        case cuisines = "cuisines"
        case allReviewsCount = "all_reviews_count"
        case photoCount = "photo_count"
        case phoneNumbers = "phone_numbers"
    }
}

struct Location: Decodable {
    var address: String?
    var locality: String?
    var city: String?
    var latitude: String?
    var longitude: String?
    var zipcode: String?
    var countryId: Int?
    
    enum CodingKeys: String, CodingKey {
        case address = "address"
        case locality = "locality"
        case city = "city"
        case latitude = "latitude"
        case longitude = "longitude"
        case zipcode = "zipcode"
        case countryId = "country_id"
    }
}

struct RestaurantsResult: Decodable {
    var resultsFound: Int?
    var resultsStart: Int?
    var resultsShown: Int?
    var restaurants: [RestaurantData]?
    
    enum CodingKeys: String, CodingKey {
        case resultsFound = "results_found"
        case resultsStart = "results_start"
        case resultsShown = "results_shown"
        case restaurants = "restaurants"
    }
}
