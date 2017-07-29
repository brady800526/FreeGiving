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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!

    let mapManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            print()
        }
        let currentLocation = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let mylocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        mapView.setRegion(region, animated: true)
        
//        print(currentLocation.coordinate.longitude)
//        print(currentLocation.coordinate.latitude)
        
        self.mapView.showsUserLocation = true
        self.mapView.showsScale = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // HandleLogout
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // HandleUpload
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(handleUpload))

        checkedIfUserLoggedIn()
        
        searchTextField.delegate = self
        
        mapManager.delegate = self
        
        mapManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapManager.requestWhenInUseAuthorization()
        
        mapManager.startUpdatingLocation()
        
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("Searching address")
        searchTextField.resignFirstResponder()
        CLGeocoder().geocodeAddressString(searchTextField.text!) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemark = placemarks?.first
                else {

                    print("placemarks doesn't exist")
                    
                    return
            }
            
//            let coordinate = placemark.location?.coordinate
//            print("get the coordinate")
//            
//            if !self.firstCoordinateSet {
//                self.firstCoordinate = coordinate!
//                self.firstCoordinateSet = true
//                print("Here1")
//            } else {
//                self.mapView.add(MKPolyline(coordinates: [self.firstCoordinate!], count: 2))
//                self.firstCoordinateSet = false
//                print("Here2")
//            }
            
        }
        return true
    }
 
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 1
        return renderer
    }
    
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

