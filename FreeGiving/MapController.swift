//
//  ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation
import Floaty
import Crashlytics
import GooglePlaces

class MapController: UIViewController, UISearchBarDelegate {

    let locationManager = CLLocationManager()

    var posts = [Post]()

    var float = FloatyItem()

    var floaty = Floaty()

    var postBeGiven = [String]()

    lazy var mapView: MKMapView = {
        let mapview = MKMapView()
        mapview.translatesAutoresizingMaskIntoConstraints = false
        mapview.delegate = self
        return mapview
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        checkedIfUserLoggedIn()
        
        setLocationManagerBehavior()

        view.addSubview(mapView)
        
        mapView.addSubview(floaty)
        
        setupMapView()
        
        setNavigationBarColor()
        
        setFloatButton()
        
        setMapViewBehavior()
        
        fetchPostsBeGiven()

    }

    func setupMapView() {
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setNavigationBarColor() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleUpload))
        
        navigationController?.navigationBar.barTintColor = UIColor.orange
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
    }
    
    func handleSearch() {
        
        let autoCompleteController = GMSAutocompleteViewController()
        
        autoCompleteController.delegate = self
        
        autoCompleteController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        autoCompleteController.secondaryTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        autoCompleteController.primaryTextColor = .lightGray;
        
        autoCompleteController.primaryTextHighlightColor = UIColor.gray
        
        autoCompleteController.tableCellSeparatorColor = .lightGray;
        
        autoCompleteController.tintColor = .lightGray;
        
        self.navigationController?.pushViewController(autoCompleteController, animated: true)
        
    }
    
    // CheckIfUserLoggin before by checking uuid, if not send the user to login page
    
    func checkedIfUserLoggedIn() {
        
        if Auth.auth().currentUser?.uid != nil {
            
            fetchUserAndSetupNavBarTitle()
            
        } else {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        }
        
    }
    
    // Set the mapView behavior when viewdidload
    
    func setLocationManagerBehavior() {
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }
    
    func setFloatButton() {
        
        float.title = "photo"
        
        float.titleLabel.font = UIFont(name: "Marker Felt", size: 18)
        
        float.imageSize = CGSize(width: 28, height: 28)
        
        float.imageOffset = CGPoint(x: -6, y: 0)
        
        float.icon = UIImage(named: "camera")
        
        float.tintColor = UIColor.white
        
        float.buttonColor = UIColor.clear
        
        float.handler = { item in
            
            self.handleUpload()
            
        }
        
        floaty.addItem(item: float)
        
    }

    func fetchPostsBeGiven() {

        Database.database().reference().child("givens").observe(.value, with: { (snapshot) in

            self.postBeGiven = [String]()

            guard let data = snapshot.value as? [String: Any] else { return }

            for postBeGiven in data {

                self.postBeGiven.append(postBeGiven.key)

            }

            self.fetchPostannotations()

        })

    }

    func fetchPostannotations() {

        Database.database().reference().child("posts").observe(.value, with: { (snapshot) in

            self.posts = [Post]()

            for annotation in self.mapView.annotations {

                self.mapView.removeAnnotation(annotation)

            }

            for item in snapshot.children {

                guard let itemsnapshot = item as? DataSnapshot else { return }

                if let dictionary = itemsnapshot.value as? [String: Any],
                    let description = dictionary["productDescription"] as? String,
                    let URL = dictionary["productImageURL"] as? String,
                    let title = dictionary["title"] as? String,
                    let latitude = dictionary["latitude"] as? String,
                    let longtitude = dictionary["longitude"] as? String,
                    let user = dictionary["user"] as? String,
                    let timeStamp = dictionary["timeStamp"] as? NSNumber {

                    let post = Post(Double(latitude)!, Double(longtitude)!, description, URL, title, timeStamp, user, itemsnapshot.key)

                    post.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longtitude)!)

                    if !self.postBeGiven.contains(itemsnapshot.key) == true && post.user != Auth.auth().currentUser?.uid {

                        self.posts.append(post)

                        self.mapView.addAnnotation(post)

                    }

                }
            }
        })
    }


    func fetchUserAndSetupNavBarTitle() {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: Any] {
                
                self.navigationItem.title = dictionary["name"] as? String
                
            }

        }, withCancel: nil)
    }

    // Set the mapview behavior

    func setMapViewBehavior() {

        self.mapView.showsUserLocation = true

        self.mapView.showsScale = true

        self.mapView.showsCompass = true

    }

    func showChatControllerForUser(user: User) {

        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())

        vc.user = user

        let nv = UINavigationController(rootViewController: vc)

        present(nv, animated: true)
    }

    func handleUpload() {

        let vc = ImageUploadController()

        vc.mapView = self.mapView

        navigationController?.pushViewController(vc, animated: false)

    }

    func handleLogout() {

        do {

            try Auth.auth().signOut()

        } catch let logoutError {

            print(logoutError)

        }

        let vc = LoginController()

        vc.mapViewController = self

        self.present(vc, animated: false, completion: nil)

    }

}
