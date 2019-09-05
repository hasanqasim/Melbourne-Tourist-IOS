//
//  SightAnnotation+CoreDataProperties.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 6/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//
//

import Foundation
import CoreData


extension SightAnnotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SightAnnotation> {
        return NSFetchRequest<SightAnnotation>(entityName: "SightAnnotation")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var iconType: String?
    @NSManaged public var imageName: String?

}
