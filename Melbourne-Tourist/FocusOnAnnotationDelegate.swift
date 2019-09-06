//
//  FocusOnAnnotationDelegate.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 5/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import Foundation
import MapKit
//focus on takes an annotation and focus on it in the mapview
protocol FocusOnAnnotationDelegate: AnyObject {
    func focusOn(annotation: MKAnnotation)
}
