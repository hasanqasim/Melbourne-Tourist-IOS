//
//  RegionMonitoringDelegate.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 6/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import Foundation
import MapKit

//geofence to be removed takes a sight annotation and removes its associated geofence
protocol RegionMonitoringDelegate: AnyObject {
    func geofenceToBeRemoved (annotation: SightAnnotation)
}
