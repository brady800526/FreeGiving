//
//  File.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/10.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

// Return the item selected on the list we would pin the place on the map

import MapKit
import GooglePlaces

extension MapController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let span = MKCoordinateSpanMake(0.05, 0.05)

        let region = MKCoordinateRegionMake(place.coordinate, span)
        
        self.mapView.setRegion(region, animated: true)

        self.navigationController?.popViewController(animated: false)
        
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {

        print("ERROR AUTO COMPLETE \(error)")

    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
}
