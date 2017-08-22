//
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
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }

    // Set the mapView behavior when viewdidload

    func setLocationManagerBehavior() {

        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.requestWhenInUseAuthorization()

        locationManager.requestLocation()

    }

    // Set the location search table

    func setLocationSearchTable() {

        let searchBar = UISearchBar()
        
        searchBar.delegate = self

        searchBar.sizeToFit()

        searchBar.placeholder = "Search for places"

        navigationItem.titleView = searchBar
        
        searchBar.showsCancelButton = false

        definesPresentationContext = true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let autoCompleteController = GMSAutocompleteViewController()
        
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
        return true
        
    }

}
