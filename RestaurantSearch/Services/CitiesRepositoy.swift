//
//  CitiesRepositoy.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import Foundation

typealias CitiesResponse = (Result<City?, RequestError>) -> ()

struct CitiesRepository {
    
    private enum Config {
        static let lat          = "lat"
        static let lon          = "lon"
        static let count        = "count"
        static let countValue   = "10"
        
        static let defaultLongitude = -73.935242
        static let defaultLatitude  = 40.730610
    }
    
    private static var citiesPath: String {
        return "\(ZomatoApi.apiIdentifier)\(ZomatoApi.apiVersion)\(ZomatoApi.citiesIdentifier)"
    }
    
    static func obtainCurrentCity(from latitude: Double, andLongitude longitude: Double, completion: @escaping CitiesResponse) {
        guard let url = URLForCoordinates(latitude, longitude) else {
            completion(.failure(.unableToMakeRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = BasicRequest.headers
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            switch BasicRequest.basicResponse(with: data, response: response, error: error) {
            case .success(let data):
                
                guard let cities = try? JSONDecoder().decode(Cities.self, from: data) else {
                        completion(.failure(.invalidResponse))
                        return
                }
                
                let currentCities = cities.locationSuggestions
                if currentCities.isEmpty {
                    fetchDefaultCity(completion: completion)
                    return
                }
                
                var currentCity = currentCities.first
                currentCity?.customLocation = CustomLocation(longitude: longitude, latitude: latitude)
                
                completion(.success(currentCity))
            case .failure(let error):
                completion(.failure(error))
            }
        }).resume()
    }
    
    private static func URLForCoordinates(_ latitude: Double, _ longitude: Double) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = ZomatoApi.scheme
        urlComponents.host = ZomatoApi.host
        urlComponents.path = CitiesRepository.citiesPath
        
        
        urlComponents.queryItems = [
            URLQueryItem(name: Config.lat, value: "\(latitude)"),
            URLQueryItem(name: Config.lon, value: "\(longitude)"),
            URLQueryItem(name: Config.count, value: Config.countValue)
        ]
        
        return urlComponents.url
    }
    
    private static func fetchDefaultCity(completion: @escaping CitiesResponse) {
        obtainCurrentCity(from: Config.defaultLatitude, andLongitude: Config.defaultLongitude, completion: completion)
    }
}
