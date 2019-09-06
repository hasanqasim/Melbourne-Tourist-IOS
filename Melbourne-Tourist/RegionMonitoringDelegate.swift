//
//  RegionMonitoringDelegate.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 6/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import Foundation
import MapKit

protocol RegionMonitoringDelegate: AnyObject {
    func regionToBeRemoved (annotation: SightAnnotation)
}
