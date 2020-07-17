//
//  KeysUtilities.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import Foundation

// API key and API path should live into a plist file
// or secured system as keychain (if sensitive data came from a request)
// Those data lives here for tutorial goals
// Please, generate your own api key in zomato web
/** developers.zomato.com **/

enum ZomatoApi {
    static let apiKey           = "ADD_ZOMATO_API_KEY"
    static let scheme           = "https"
    static let host             = "developers.zomato.com"
    static let apiIdentifier    = "/api"
    static let apiVersion       = "/v2.1"
    static let citiesIdentifier = "/cities"
    static let search           = "/search"
}
