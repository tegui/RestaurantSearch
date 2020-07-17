//
//  LocationHelper.swift
//  RestaurantSearch
//
//  Created by Julian Amortegui on 17/07/20.
//  Copyright © 2020 Julian Amortegui. All rights reserved.
//

import Foundation
import CoreLocation

// This class manages the location logic
// retrieving the longitude and latitude
// taked from the device
// Please be aware to add this into the Plist file
// Privacy - Location When In Use Usage Description

protocol LocationManagerDelegate {
    func didUpdateLocation(with city: City)
}

class LocationManager: NSObject {
    
    var delegate: LocationManagerDelegate?
    private var locationManager = CLLocationManager()
    
    static var currentLocation: CLLocation?
    
    convenience init(with delegate: LocationManagerDelegate) {
        self.init()
        
        self.delegate = delegate
        locationManager.delegate = self
        fetchCurrentLocation()
    }
    
    private func fetchCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .denied, .restricted:
            if !CLLocationManager.locationServicesEnabled() { return }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("Unknown error")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let customLocation = CustomLocation(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        let city = City(customLocation: customLocation)
        
        delegate?.didUpdateLocation(with: city)
        LocationManager.currentLocation = locationManager.location
    }
}
