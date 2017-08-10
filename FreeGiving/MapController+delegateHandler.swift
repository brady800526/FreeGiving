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
}

// Return the item selected on the list we would pin the place on the map

extension MapController: HandleMapSearch {

    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
//        mapView.removeAnnotations(mapView.annotations)

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

// Display the annotationView and the following handling

extension MapController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
            // 1
            if view.annotation is MKUserLocation
            {
                // Don't proceed with custom callout
                return
            }
            // 2
        guard let postsAnnotation = view.annotation as? Post else { return }
            let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
            let calloutView = views?[0] as! CustomCalloutView
            calloutView.starbucksName.text = postsAnnotation.productName
            calloutView.starbucksAddress.text = postsAnnotation.productOnShelfTime
            calloutView.starbucksPhone.text = postsAnnotation.productDescription
            
            //
            let button = UIButton(frame: calloutView.starbucksPhone.frame)
//            button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
            calloutView.addSubview(button)
        
        do {
            // MAKR: - change the photo to your's photo
            
            guard let photoURL = postsAnnotation.productImageURL as? String else { return }
            
            let url = URL(string: photoURL)
            
            let data = try Data(contentsOf: url!)
            
                calloutView.starbucksImage.image = UIImage(data: data)
            
            self.mapView.reloadInputViews()
            
        } catch {
            
            print(error)
            
        }
            // 3
            calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
            view.addSubview(calloutView)
            mapView.setCenter((view.annotation?.coordinate)!, animated: true)
        
    }
    

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }

}
