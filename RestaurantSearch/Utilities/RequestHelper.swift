//
//  RequestHelper.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import Foundation

// This helper is useful to handle the request responses
// BasicResponse is retrieving to the service the specific required data as
// Success enum value + Data
// or
// Failure enum value + Failure reason (Based on RequestError enum)

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
}

enum RequestError: Error {
    case unableToMakeRequest
    case requestFailed
    case invalidResponse
    case emptyResponse
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct BasicRequest {
    
    static var headers: [String: String] { ["user-key": ZomatoApi.apiKey, "Accept": "application/json"] }
    
    static func basicResponse(with data: Data?, response: URLResponse?, error: Error?) -> Result<Data, RequestError> {
        if error != nil {
            return .failure(RequestError.requestFailed)
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return .failure(.requestFailed)
        }
        
        guard statusCode >= 100 && statusCode < 400 else {
            return .failure(.requestFailed)
        }
        
        guard let data = data else {
            return .failure(.emptyResponse)
        }
        
        return .success(data)
    }
}
