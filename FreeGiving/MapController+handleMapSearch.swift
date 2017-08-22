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
        mapView.setRegion(region, animated: true)
        self.dismiss(animated: true, completion: nil) // dismiss after select place

    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {

        print("ERROR AUTO COMPLETE \(error)")

    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
}
