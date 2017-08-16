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
import Floaty

class MapController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    let locationManager = CLLocationManager()

    var resultSearchController: UISearchController?

    var selectedPin: MKPlacemark?
    
    var posts = [Post]()
    
    var float = FloatyItem()
    
    var floaty = Floaty()

    override func viewDidLoad() {

        super.viewDidLoad()

        // HandleLogout

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(handleLogout))

        // HandleUpload
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        
        checkedIfUserLoggedIn()

        setLocationManagerBehavior()

        setLocationSearchTable()
        
        fetchAnnotations()
        
        
        
        float.titleColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
        
        float.title = "Record"
        
        float.size = 28
        
        float.handler = { item in
         
            self.handleUpload()
            
        }
        
        floaty.addItem(item: float)
        
        floaty.addItem(title: "Hello")
        
        self.mapView.addSubview(floaty)
        
    }
    
    func fetchAnnotations() {
        
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any],
                let available = dictionary["available"] as? String,
                let description = dictionary["productDescription"] as? String,
                let URL = dictionary["productImageURL"] as? String,
                let title = dictionary["title"] as? String,
                let latitude = dictionary["latitude"] as? String,
                let longtitude = dictionary["longitude"] as? String,
                let time = dictionary["productOnShelfTime"] as? String,
                let user = dictionary["user"] as? String,
                let timeStamp = dictionary["timeStamp"] as? NSNumber
                {
                    
                    
                    let post = Post(Bool(available)!, Double(latitude)!, Double(longtitude)!, description, URL, title, time, timeStamp, user, snapshot.key)

                    post.coordinate = CLLocationCoordinate2D(latitude: Double(latitude)!, longitude: Double(longtitude)!)

                    self.posts.append(post)
                    
                    self.mapView.addAnnotation(post)

            }
            
        })
        
    }

    // CheckIfUserLoggin before by checking uuid, if not send the user to login page

    func checkedIfUserLoggedIn() {

        if Auth.auth().currentUser?.uid == nil {

            perform(#selector(handleLogout), with: nil, afterDelay: 0)

        }
        
//        else {
//
//            fetchUserAndSetupNavBarTitle()
//
//        }
    }
    
//    func fetchUserAndSetupNavBarTitle() {
//        
//        let ref = Database.database().reference()
//        
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String:Any] {
//                
//                self.navigationItem.title = dictionary["name"] as? String
//                
//            }
//            
//        }, withCancel: nil)
//
//        
//    }

    // Set the mapview behavior

    func setMapViewBehavior() {

        // FIXME: Mapview doesn't conform to following behavior

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
    
    func handleLogout() {
        
        do {
            
            try Auth.auth().signOut()
            
        } catch let logoutError {
            
            print(logoutError)
            
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! LoginController
        
        vc.mapViewController = self
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func handleUpload() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadPage") as! UINavigationController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func handleSearch() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchPage") as! SearchItemController
        
        navigationController?.pushViewController(vc, animated: true)
    }

}
