
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
    var available: String?
    var latitude: String?
    var longtitude: String?
    var productDescription: String?
    var productImageURL: String?
    var productName: String?
    var productOnShelfTime: String?
    var timeStamp: NSNumber?
    var user: String?
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

}
