//
//  ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/17.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap {

    @IBOutlet weak var googleMapContainer: UIView!

    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    var googleMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        
        self.googleMapView = GMSMapView(frame: self.googleMapContainer.frame)
        self.view.addSubview(self.googleMapView)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        
    }
    
    @IBAction func search(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        
        DispatchQueue.global().async {
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.googleMapView
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error) in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            
            print(123)
            
            for result in results! {
                self.resultsArray.append(result.attributedFullText.string)
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
            
        }
        
    }
    
}
