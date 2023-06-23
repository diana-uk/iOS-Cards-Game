//
//  LocationManager.swift
//  MyWarGameApp
//
//  Created by Student15 on 14/06/2023.
//

import Foundation
import CoreLocation

class LocationManager: NSObject , ObservableObject, CLLocationManagerDelegate{
    
    private let locationManager = CLLocationManager()
    @Published var userLongitude: Double?
    
    override init(){
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else {return}
        userLongitude = location.coordinate.longitude
    }
}
