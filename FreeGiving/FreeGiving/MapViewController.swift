//
//  ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()
    
    var resultSearchController: UISearchController?
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

//        print(currentLocation.coordinate.longitude)
//        print(currentLocation.coordinate.latitude)
        
//        self.mapView.showsUserLocation = true
//        self.mapView.showsScale = true
//        
//    }

    override func viewDidLoad() {

        super.viewDidLoad()
        
        // HandleLogout
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // HandleUpload
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(handleUpload))

        checkedIfUserLoggedIn()
        
        setMapViewBehavior()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "searchPage") as! LoactionSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
//        let location = "New York, NY, USA"
//        let geocoder:CLGeocoder = CLGeocoder()
//        geocoder.geocodeAddressString(location) { (placemarks, error) in
//            if (placemarks?.count)! > 0 {
//                let topResult:CLPlacemark = placemarks![0];
//                let placemark: MKPlacemark = MKPlacemark(placemark: topResult);
//                var region: MKCoordinateRegion = self.mapView.region;
//                region.center = (placemark.location?.coordinate)!;
//                region.span.longitudeDelta /= 8.0;
//                region.span.latitudeDelta /= 8.0;
//                self.mapView.setRegion(region, animated: true);
//                self.mapView.addAnnotation(placemark);
//                
//            }
//        }
        
        

        
//        
//        let bsuCSClassPin = BSUAnnotation(title: "Title", subtitle: "Subtitle", coordinate: CLLocationCoordinate2D(latitude: 52.52007, longitude: 13.404954))
//        
//        cameraSetup()
//        
//        mapView.addAnnotation(bsuC SClassPin)
        
    }
    
    // Set the mapView behavioe when viewdidload

    func setMapViewBehavior() {
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
//        locationManager.startUpdatingLocation()
        
    }
    
    
    
    // CheckIfUserLoggin before by checking uuid, if not send the user to login page

    func checkedIfUserLoggedIn() {

        if Auth.auth().currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)

            handleLogout()
            
        } else {
            
            let ref = Database.database().reference()
            
            let uid = Auth.auth().currentUser?.uid
            
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:Any] {
                    
                    self.navigationItem.title = dictionary["name"] as? String
                    
                }
                
            }, withCancel: nil)
            
        }
    }
    
// 
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor.blue
//        renderer.lineWidth = 1
//        return renderer
//    }
    
//    private func cameraSetup() {
//        
//        mapView.camera.altitude = 1400
//        mapView.camera.pitch = 50
//        mapView.camera.heading = 180
//        
//    }
//
//    
//    @IBAction func compassBtn(_ sender: UIButton) {
//        mapView.showsCompass = !mapView.showsCompass
//        
//        if mapView.showsTraffic == true {
//            sender.setTitle("Hide Compass ", for: UIControlState.normal)
//        } else {
//            sender.setTitle("Show Compass", for: UIControlState.normal)
//        }
//    }
}

extension MapViewController : CLLocationManagerDelegate {

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

