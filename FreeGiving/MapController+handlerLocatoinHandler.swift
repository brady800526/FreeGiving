
//  MapViewController+delegateHandler.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/30.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GooglePlaces

// Handle the behavior if status or update changed

extension MapController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        locationManager.startUpdatingLocation()

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let span = MKCoordinateSpanMake(0.05, 0.05)
            
            let region = MKCoordinateRegion(center: location.coordinate, span: span)

            mapView.setRegion(region, animated: true)
            
            locationManager.stopUpdatingLocation()
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        
    }

}
