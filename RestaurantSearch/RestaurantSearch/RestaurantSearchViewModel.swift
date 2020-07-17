//
//  CuisineSearchViewModel.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import Foundation

// This app requires geo location usage to obtain
// the current city and find the nearest cucines or restaurants
// Only availabe for U.S searching
// If you are in another country, please use simulator for custom
// geo-location input

class RestaurantSearchViewModel {
    
    private enum Config {
        static let latitudeKey  = "lat"
        static let longitudeKey = "lon"
    }
    
    var delegate: RestaurantSearchDelegate?
    
    private var currentCity: City?
    private var locationManager: LocationManager?
    private var resultsSource = [RestaurantData]()
    
    var searchResults: [RestaurantData] { resultsSource }
    
    //MARK: - Class Methods
    
    func configureLocationManager() {
        delegate?.enableActivityIndicator(currentCity == nil)
        locationManager = LocationManager(with: self)
    }
    
//    IMPORTANT STUFF:
//    Use DispatchQueue.main.async {...} to notify the main thread
//    for UI operations when a request or a different thread
//    proccess anything
//    If you forget to do this, so it's a potential crash
//    if a different thread tries to access to UI layer (main)
    
    func fetchNearRestaurants(with keyword: String? = nil) {
        guard let currentLocation = currentCity?.customLocation else { return }
        
        var queries = [
            Config.latitudeKey: "\(currentLocation.latitude)",
            Config.longitudeKey: "\(currentLocation.longitude)"]
        
        if let q = keyword { queries["q"] = q }
        
        obtainRestaurants(with: queries)
    }
    
    private func obtainCurrentCity(from city: City) {
        guard let currentLocation = city.customLocation else { return }
        
        CitiesRepository.obtainCurrentCity(from: currentLocation.latitude, andLongitude: currentLocation.longitude) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let city):
                    guard let city = city else { return /* Show any error message */ }
                    self.currentCity = city
                    
                    self.delegate?.updateCurrentCity(with: city)
                    self.delegate?.enableActivityIndicator(false)
                case .failure(_):
                    // Show any error message
                    self.delegate?.enableActivityIndicator(false)
                }
            }
        }
    }
    
    private func obtainRestaurants(with queries: [String: String]) {
        RestaurantRepository.obtainRestaurants(with: queries) { result in
            DispatchQueue.main.async {
                self.delegate?.enableActivityIndicator(false)
            }
            
            switch result {
            case .success(let restaurants):
                guard
                    let restaurants = restaurants,
                    let results = restaurants.restaurants else { return }
                
                self.fillResults(with: results)
            case .failure( _ ):
                break
            }
        }
    }
    
    private func fillResults(with results: [RestaurantData]) {
        resultsSource = results
        DispatchQueue.main.async {
            self.delegate?.updateResultsData()
        }
    }
}

extension RestaurantSearchViewModel: LocationManagerDelegate {
    func didUpdateLocation(with city: City) {
        obtainCurrentCity(from: city)
    }
}
