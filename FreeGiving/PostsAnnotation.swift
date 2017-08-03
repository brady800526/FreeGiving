//
//  PostsAnnotation.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/3.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import MapKit

class PostsAnnotation: NSObject {
    var available: String?
    var latitude: String?
    var longtitude: String?
    var productDescription: String?
    var productImageURL: String?
    var productName: String?
    var productOnShelfTime: String?
    var timeStamp: String?
    var user: String?
    var coordinates: CLLocationCoordinate2D?

        init(latitude: Double, longtitude: Double) {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        }
}
