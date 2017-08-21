//
//  File.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/3.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import MapKit

class Post: NSObject, MKAnnotation {

    var longtitude: Double?
    var latitude: Double?
    var productDescription: String?
    var productImageURL: String?
    var title: String?
    var timeStamp: NSNumber?
    var user: String?
    var key: String?
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    init(_ longtitude: Double, _ latitude: Double, _ description: String, _ URL: String, _ name: String, _ timestamp: NSNumber, _ user: String, _ key: String) {
        self.longtitude = longtitude
        self.latitude = latitude
        self.productDescription = description
        self.productImageURL = URL
        self.title = name
        self.timeStamp = timestamp
        self.user = user
        self.key = key
    }
}
