//
//  CitiesRepositoy.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import Foundation

typealias RestaurantResponse = (Result<RestaurantsResult?, RequestError>) -> ()

struct RestaurantRepository {
    
    private enum Config {
        static let lat = "lat"
        static let lon = "lon"
        static let count = "count"
    }
    
    private static var searchPath: String {
        return "\(ZomatoApi.apiIdentifier)\(ZomatoApi.apiVersion)\(ZomatoApi.search)"
    }
    
    static func obtainRestaurants(with info: [String: String], completion: @escaping RestaurantResponse) {
        guard let url = URLForDictionary(dictionary: info) else {
            completion(.failure(.unableToMakeRequest))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = BasicRequest.headers
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            switch BasicRequest.basicResponse(with: data, response: response, error: error) {
            case .success(let data):
                let decoder = JSONDecoder()
            
                guard
                    let searchResults = try? decoder.decode(RestaurantsResult.self, from: data) else {
                        completion(.failure(.invalidResponse))
                        return
                }
                
                completion(.success(searchResults))
            case .failure(let error):
                completion(.failure(error))
            }
        }).resume()
    }
    
    private static func URLForDictionary(dictionary: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = ZomatoApi.scheme
        urlComponents.host = ZomatoApi.host
        urlComponents.path = RestaurantRepository.searchPath
        
        var items = [URLQueryItem]()
        for (key, value) in dictionary {
            items.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = items
        
        return urlComponents.url
    }
}
