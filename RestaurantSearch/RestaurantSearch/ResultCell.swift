//
//  ResultCell.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import UIKit

class ResultCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ResultCell.self)
    
    @IBOutlet weak private var resultName: UILabel!
    @IBOutlet weak private var thumbImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCellContent(with restaurant: RestaurantData) {
        guard let name = restaurant.restaurant?.name else { return }
        
        resultName.text = name
        configureThumbImage(restaurant)
    }
    
    private func configureThumbImage(_ restaurant: RestaurantData) {
        guard let thumbUrl = restaurant.restaurant?.thumb, let url = URL(string: thumbUrl) else { return }
        
        CommonServices.downloadImage(from: url, completion: { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.thumbImageView.image = image
                }
            case .failure(_):
                break
            }
        })
    }
}
