//
//  SightAnnotation.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 23/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import MapKit

class SightAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: String
    
    init(title: String, subtitle: String, lat: Double, long: Double, image: String) {
        self.title = title
        self.subtitle = subtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.image = image
    }

}
