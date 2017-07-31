//
//  LoactionSearchTableViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/29.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark)
    
}

class LoactionSearchTableViewController: UITableViewController {

    var matchingItems: [MKMapItem]?
    var mapView: MKMapView?
    var handleMapSearchDelegate:HandleMapSearch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let matchingItems = matchingItems else { return 0 }
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems?[indexPath.row].placemark
        cell.textLabel?.text = selectedItem?.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem!)
        return cell
    }

    func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension LoactionSearchTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text
            else { return }

        let request = MKLocalSearchRequest()

        request.naturalLanguageQuery = searchBarText

        request.region = mapView.region

        let search = MKLocalSearch(request: request)

        search.start { response, _ in

            guard let response = response else {
                return
            }

            self.matchingItems = response.mapItems

            self.tableView.reloadData()
        }
        
    }

}

extension LoactionSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedItem = matchingItems?[indexPath.row].placemark

        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem!)

        dismiss(animated: true, completion: nil)
    }
    
}
