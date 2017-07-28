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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let mapManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let mylocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        mapView.setRegion(region, animated: true)
        
        print(currentLocation.coordinate.longitude)
        print(currentLocation.coordinate.latitude)
        
        self.mapView.showsUserLocation = true
        self.mapView.showsScale = true
        self.mapView.showsTraffic = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(handleUpload))

        checkedIfUserLoggedIn()
        
        mapManager.delegate = self
        
        mapManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapManager.requestWhenInUseAuthorization()
        
        mapManager.startUpdatingLocation()
        
//        let berlin = MKCoordinateRegionMake(CLLocationCoordinate2DMake(52.52007, 13.404954), MKCoordinateSpanMake(0.1766154, 0.153035))
//        
//        mapView.setRegion(berlin, animated: true)
//        
//        let bsuCSClassPin = BSUAnnotation(title: "Title", subtitle: "Subtitle", coordinate: CLLocationCoordinate2D(latitude: 52.52007, longitude: 13.404954))
//        
//        cameraSetup()
//        
//        mapView.addAnnotation(bsuC SClassPin)
        
    }

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
 
    private func cameraSetup() {
        
        mapView.camera.altitude = 1400
        mapView.camera.pitch = 50
        mapView.camera.heading = 180
        
    }

    
    @IBAction func compassBtn(_ sender: UIButton) {
        mapView.showsCompass = !mapView.showsCompass
        
        if mapView.showsTraffic == true {
            sender.setTitle("Hide Compass ", for: UIControlState.normal)
        } else {
            sender.setTitle("Show Compass", for: UIControlState.normal)
        }
    }
}

