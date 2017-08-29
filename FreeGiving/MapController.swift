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
import Cluster
import GooglePlaces

class MapController: UIViewController, UISearchBarDelegate {

    let locationManager = CLLocationManager()

    let clusterManager = ClusterManager()

    var posts = [Post]()

    var float = FloatyItem()

    var floaty = Floaty()

    var postBeGiven = [String]()

    let mapView: MKMapView = {
        let mapview = MKMapView()
        mapview.translatesAutoresizingMaskIntoConstraints = false
        return mapview
    }()

    override func viewWillAppear(_ animated: Bool) {

        fetchPostsBeGiven()

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.view.addSubview(mapView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleLogout))

        mapView.delegate = self

        checkedIfUserLoggedIn()

        setLocationManagerBehavior()

        fetchPostsBeGiven()

        self.navigationController?.navigationBar.barTintColor = UIColor.orange

        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white

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

        self.mapView.addSubview(floaty)

        setupMapView()

    }

    func handleSearch() {

        let autoCompleteController = GMSAutocompleteViewController()

        autoCompleteController.delegate = self

        self.present(autoCompleteController, animated: true, completion: nil)

    }

    func setupMapView() {

        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent

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

    // CheckIfUserLoggin before by checking uuid, if not send the user to login page

    func checkedIfUserLoggedIn() {

        if Auth.auth().currentUser?.uid == nil {

            perform(#selector(handleLogout), with: nil, afterDelay: 0)

        } else {

            fetchUserAndSetupNavBarTitle()
        }

    }

    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(uid)
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

        // swiftlint:disable force_cast
        let vc = ImageUploadController()
        let nv = UINavigationController(rootViewController: vc)
        // swiftlint:enable force_cast

        vc.mapView = self.mapView

        self.present(nv, animated: true, completion: nil)
    }

    func handleLogout() {

        do {

            try Auth.auth().signOut()

        } catch let logoutError {

            print(logoutError)

        }

        // swiftlint:disable force_cast
        let vc = LoginController()
        // swiftlint:enable force_cast

        vc.mapViewController = self

        self.present(vc, animated: true, completion: nil)

    }

}
