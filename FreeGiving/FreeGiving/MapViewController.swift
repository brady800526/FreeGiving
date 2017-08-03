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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()

    var resultSearchController: UISearchController?

    var selectedPin: MKPlacemark?
    
    var posts = [Post]()

    @IBOutlet weak var searchBarView: UIView!

    override func viewDidLoad() {

        super.viewDidLoad()

        // HandleLogout

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        // HandleUpload

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(handleUpload))

        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: "Message", style: .plain, target: self, action: #selector(handleChat)))
        
        checkedIfUserLoggedIn()

        setLocationManagerBehavior()

        setLocationSearchTable()
        
        fetchAnnotations()

    }
    
    func fetchAnnotations() {
        
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post()
                post.setValuesForKeys(dictionary)
                
                guard
                let available = post.available,
                let availableBool = Bool(available),
                let latitude = post.latitude,
                let latitudeDouble = Double(latitude),
                let longtitude = post.longtitude,
                let longtitudeDouble = Double(longtitude),
                let description = post.productDescription,
                let imageURL = post.productImageURL,
                let name = post.productName,
                let time = post.productOnShelfTime,
                let timeStamp = post.timeStamp,
                let user = post.user
                    else {
                        print("format invalide")
                        return
                }

                print(availableBool, latitudeDouble, longtitudeDouble, description, imageURL, name, time, timeStamp, user)
                
                let anno = MKPointAnnotation()
                anno.coordinate = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longtitudeDouble)
                anno.title = name
                self.mapView.addAnnotation(anno)
                
            }
            
        })

        
    }
    
    func handleChat() {
        
        let newMessageConctroller = FriendTableViewController()
        navigationController?.pushViewController(newMessageConctroller, animated: true)
        
    }

    // CheckIfUserLoggin before by checking uuid, if not send the user to login page

    func checkedIfUserLoggedIn() {

        if Auth.auth().currentUser?.uid == nil {

            perform(#selector(handleLogout), with: nil, afterDelay: 0)

        } else {

            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        
        let ref = Database.database().reference()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // FIXME: Can't get the username since search bar override this title
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any] {
                
                self.navigationItem.title = dictionary["name"] as? String
                
            }
            
        }, withCancel: nil)

        
    }

    // Set the mapView behavior when viewdidload

    func setLocationManagerBehavior() {

        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.requestWhenInUseAuthorization()

        locationManager.requestLocation()

//        locationManager.startUpdatingLocation()

    }

    // Set the location search table

    func setLocationSearchTable() {

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "searchPage") as! LoactionSearchTableViewController

        resultSearchController = UISearchController(searchResultsController: locationSearchTable)

        resultSearchController?.searchResultsUpdater = locationSearchTable

        locationSearchTable.mapView = mapView

        locationSearchTable.handleMapSearchDelegate = self

        let searchBar = resultSearchController!.searchBar

        searchBar.sizeToFit()

        searchBar.placeholder = "Search for places"

        searchBarView.addSubview((resultSearchController?.searchBar)!)

//        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false

        resultSearchController?.dimsBackgroundDuringPresentation = true

        definesPresentationContext = true
    }

    // Set the mapview behavior

    func setMapViewBehavior() {

        // FIXME: Mapview doesn't conform to following behavior

        self.mapView.showsUserLocation = true

        self.mapView.showsScale = true

        self.mapView.showsCompass = true

    }

//    private func cameraSetup() {
//        
//        mapView.camera.altitude = 1400
//        mapView.camera.pitch = 50
//        mapView.camera.heading = 180
//        
//    }

}
