//
//  DatabaseProtocol.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 6/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

protocol DatabaseListener: AnyObject {
    func onSightListChange(change: DatabaseChange, sights: [SightAnnotation])
}

protocol DatabaseProtocol: AnyObject {
    func addSightAnnotation(title: String, subtitle: String, latitude: Double, longitude: Double, iconType: String, imageName: String) -> SightAnnotation
    func deleteSightAnnotation(sight: SightAnnotation)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}

