//
//  LocationManager.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/9/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit

class LocationManager{
    static let shared = LocationManager()
    private init(){}
    
    static let locationManager = CLLocationManager()
    
    
    
    func requestAuthorizationStatus(){
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            LocationManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.locationManager.startUpdatingLocation()
        case .notDetermined:
            LocationManager.locationManager.requestWhenInUseAuthorization()
        default:
            print("default")
            break;
        }
    }
    
    func getLocation() -> CLLocationCoordinate2D?{
        let l = LocationManager.locationManager.location?.coordinate
        return l
    }

}


