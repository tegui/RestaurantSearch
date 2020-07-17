//
//  RestaurantDetailViewController.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 10/13/19.
//  Copyright © 2019 Julian Amortegui. All rights reserved.
///** tegui.me **/

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {
    
    static let reuseIdentifier = String(describing: RestaurantDetailViewController.self)
    
    private enum Config {
        static let address              = "Address:"
        static let city                 = "City:"
        static let locality             = "Locality:"
        static let noAvailablePhone     = "Phone number not available"
        static let availablePhone       = "Phone number:"
        static let regionRadius: Double = 2000
    }
    
    var restaurant: Restaurant?
    
    @IBOutlet weak private var restaurantImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!
    @IBOutlet weak private var cityLabel: UILabel!
    @IBOutlet weak private var localtyLabel: UILabel!
    @IBOutlet weak private var phoneNumberLabel: UILabel!
    @IBOutlet weak private var mapView: MKMapView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Auxiliary Methods
    
    private func setupUI() {
        configureImage()
        configureTitle()
        configureLocation()
        configureContact()
        configureMap()
    }
    
    private func configureTitle() {
        guard let name = restaurant?.name else  { return }
        titleLabel.text = name
    }
    
    private func configureImage() {
        guard let thumb = restaurant?.featuredImage, let url = URL(string: thumb) else { return }
        
        CommonServices.downloadImage(from: url, completion: { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.restaurantImageView.image = image
                    self.restaurantImageView.contentMode = .scaleAspectFill
                }
            case .failure(_):
                break
            }
        })
    }
    
    private func configureLocation() {
        if let address = restaurant?.location?.address {
            addressLabel.text = "\(Config.address) \(address)"
        }
        
        if let city = restaurant?.location?.city {
            cityLabel.text = "\(Config.city) \(city)"
        }
        
        if let locality = restaurant?.location?.locality {
            localtyLabel.text = "\(Config.locality) \(locality)"
        }
    }
    
    private func configureContact() {
        guard let phone = restaurant?.phoneNumbers else {
            phoneNumberLabel.text = Config.noAvailablePhone
            return
        }
        
        phoneNumberLabel.text = "\(Config.availablePhone) \(phone)"
    }
    
    private func configureMap() {
        guard let location = LocationManager.currentLocation else {
            mapView.isHidden = true
            return
        }
        
        centerMapOnLocation(location: location)
        addPoint(on: restaurant?.location)
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = Config.regionRadius
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func addPoint(on location: Location?) {
        guard
            let latData = location?.latitude, let lat = Double(latData),
            let lonData = location?.longitude, let lon = Double(lonData) else { return }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = lat
        annotation.coordinate.longitude = lon
        
        mapView.addAnnotation(annotation)
        
        if let latitude = CLLocationDegrees(exactly: lat), let longitude = CLLocationDegrees(exactly: lon) {
            let newLocation = CLLocation(latitude: latitude, longitude: longitude)
            centerMapOnLocation(location: newLocation)
        }
    }
}
