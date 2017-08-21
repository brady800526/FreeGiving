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

class MapController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()

    var resultSearchController: UISearchController?

    var selectedPin: MKPlacemark?

    var posts = [Post]()

    var float = FloatyItem()

    var floaty = Floaty()

    @IBOutlet weak var messageLink: UIView!

    @IBOutlet weak var messageIcon: UIImageView!

    @IBOutlet weak var ownerLink: UIView!

    @IBOutlet weak var ownerIcon: UIImageView!

    @IBOutlet weak var logoutLink: UIView!

    @IBOutlet weak var logoutIcon: UIImageView!

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var slideMenuView: UIView!

    var menuShowing = false

    var postBeGiven = [String]()

    override func viewWillAppear(_ animated: Bool) {

        leadingConstraint.constant = self.view.bounds.width * -2/5 - 10

        self.mapView.backgroundColor = UIColor.black

        self.view.backgroundColor = UIColor.clear

        self.mapView.alpha = 1

        fetchPostsBeGiven()

    }

    override func viewDidLoad() {

        //        Crashlytics.sharedInstance().crash()

        super.viewDidLoad()

        slideMenuSetup()

        checkedIfUserLoggedIn()

        setLocationManagerBehavior()

        setLocationSearchTable()

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

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
        
    }


    func slideMenuSetup() {

        slideMenuView.layer.shadowOpacity = 1

        slideMenuView.layer.shadowRadius = 3

        // HandleMenu

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(handleMenu))

        leadingConstraint.constant = self.view.bounds.width * -2/5 - 10

        // HandleSearch

        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))

        // HandleLogout

        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(handleLogout))

        logoutLink.addGestureRecognizer(logoutGesture)

        logoutIcon.tintColor = UIColor.white
        // HandleMessage

        let messageGesture = UITapGestureRecognizer(target: self, action: #selector(handleMessage))

        messageLink.addGestureRecognizer(messageGesture)

        messageIcon.tintColor = UIColor.white

        // HandleOwner

        let ownerGesture = UITapGestureRecognizer(target: self, action: #selector(handleOwner))

        ownerLink.addGestureRecognizer(ownerGesture)

        ownerIcon.tintColor = UIColor.white

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

                    if !self.postBeGiven.contains(itemsnapshot.key) == true {

                        self.posts.append(post)

                        self.mapView.addAnnotation(post)

                    }

                }
            }
        })
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

    // CheckIfUserLoggin before by checking uuid, if not send the user to login page

    func checkedIfUserLoggedIn() {

        if Auth.auth().currentUser?.uid == nil {

            perform(#selector(handleLogout), with: nil, afterDelay: 0)

        }

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

    //    private func cameraSetup() {
    //
    //        mapView.camera.altitude = 1400
    //        mapView.camera.pitch = 50
    //        mapView.camera.heading = 180
    //
    //    }

    func handleMenu() {

        if menuShowing {
            leadingConstraint.constant = self.view.bounds.width * -2/5 - 10

            self.mapView.backgroundColor = UIColor.black

            self.view.backgroundColor = UIColor.clear

            self.mapView.alpha = 1

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })

        } else {

            leadingConstraint.constant = 0

            self.mapView.backgroundColor = UIColor.black

            self.view.backgroundColor = UIColor.clear

            self.mapView.alpha = 0.7

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }

        menuShowing = !menuShowing
    }

    func handleUpload() {

        // swiftlint:disable force_cast
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadPage") as! UINavigationController
        // swiftlint:enable force_cast

        self.present(vc, animated: true, completion: nil)
    }

    func handleSearch() {

        // swiftlint:disable force_cast
        let vc = SearchItemController(collectionViewLayout: UICollectionViewFlowLayout())
        // swiftlint:enable force_cast

        navigationController?.pushViewController(vc, animated: true)
    }

    func handleMessage() {

        // swiftlint:disable force_cast
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "messagePage") as! MessageController
        // swiftlint:enable force_cast

        navigationController?.pushViewController(vc, animated: true)
    }

    func handleOwner() {

        // swiftlint:disable force_cast
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ownerPage") as! OwnerController
        // swiftlint:enable force_cast

        navigationController?.pushViewController(vc, animated: true)
    }

    func handleLogout() {

        do {

            try Auth.auth().signOut()

        } catch let logoutError {

            print(logoutError)

        }

        // swiftlint:disable force_cast
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! LoginController
        // swiftlint:enable force_cast

        vc.mapViewController = self

        self.present(vc, animated: true, completion: nil)

    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        print(123)
        
        return true
        
    }

}
