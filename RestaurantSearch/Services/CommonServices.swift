//
//  CommonServices.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import UIKit

typealias ImageResponse = (Result<UIImage, RequestError>) -> ()

struct CommonServices {
    
    static func downloadImage(from url: URL, completion: @escaping ImageResponse) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            switch BasicRequest.basicResponse(with: data, response: response, error: error) {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                completion(.success(image))
            case .failure( let error ):
                completion(.failure(error))
            }
        }.resume()
    }
}
