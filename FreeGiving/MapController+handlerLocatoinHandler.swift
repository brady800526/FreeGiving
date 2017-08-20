//
//  MapViewController+delegateHandler.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/30.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import MapKit

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

        // swiftlint:disable force_cast
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "locationSearchPage") as! LoactionSearchController
        // swiftlint:enable force_cast

        resultSearchController = UISearchController(searchResultsController: locationSearchTable)

        resultSearchController?.searchResultsUpdater = locationSearchTable

        locationSearchTable.mapView = mapView

        locationSearchTable.handleMapSearchDelegate = self

        let searchBar = resultSearchController!.searchBar

        searchBar.sizeToFit()

        searchBar.placeholder = "Search for places"

        navigationItem.titleView = resultSearchController?.searchBar

        searchBar.showsCancelButton = false

        resultSearchController?.hidesNavigationBarDuringPresentation = false

        resultSearchController?.dimsBackgroundDuringPresentation = true

        definesPresentationContext = true
    }

}
