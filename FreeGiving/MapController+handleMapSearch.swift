//
//  File.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/10.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

// Return the item selected on the list we would pin the place on the map

import MapKit

extension MapController: HandleMapSearch {

    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()

        annotation.coordinate = placemark.coordinate

        annotation.title = placemark.name

        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }

        mapView.addAnnotation(annotation)

        let span = MKCoordinateSpanMake(0.05, 0.05)

        let region = MKCoordinateRegionMake(placemark.coordinate, span)

        mapView.setRegion(region, animated: true)
    }
}
