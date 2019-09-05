//
//  SightAnnotation+CoreDataClass.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 6/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

@objc(SightAnnotation)
public class SightAnnotation: NSManagedObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

}
