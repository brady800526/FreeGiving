//
//  test2ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/27.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ImageUploadViewController: UIViewController {

    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productOnShelfTime: UITextField!
    @IBOutlet weak var productLocation: UITextField!
    @IBOutlet weak var productDescription: UITextField!

    var resultSearchController: UISearchController?
    let mapView = MKMapView()
    var selectedPin: MKPlacemark?
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var latitude: String?
    var longtitude: String?

    override func viewDidLoad() {

        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleDismiss))

        // Tap the button to upload the data to firebase
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "upload", style: .plain, target: self, action: #selector(handleUploadProduct))

        // User can tap the imageView to select the photo
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUploadImageView)))

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // Tap outside the screen to dismiss the keyboard
        view.addGestureRecognizer(tap)

//        setLocationSearchTable()
        
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func setLocationSearchTable() {

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "searchPage") as! LoactionSearchTableViewController

        resultSearchController = UISearchController(searchResultsController: locationSearchTable)

        resultSearchController?.searchResultsUpdater = locationSearchTable

        locationSearchTable.mapView = mapView

        locationSearchTable.handleMapSearchDelegate = self

        let searchBar = resultSearchController!.searchBar

        searchBar.sizeToFit()

        searchBar.placeholder = "Search for places"

        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false

        resultSearchController?.dimsBackgroundDuringPresentation = true

        definesPresentationContext = true
    }

}

// Return the item selected on the list we would pin the place on the map

extension ImageUploadViewController: HandleMapSearch {

    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)

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
