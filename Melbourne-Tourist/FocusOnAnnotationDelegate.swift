//
//  FocusOnAnnotationDelegate.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 5/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import Foundation
import MapKit

protocol FocusOnAnnotationDelegate: AnyObject {
    func focusOn(annotation: MKAnnotation)
}
