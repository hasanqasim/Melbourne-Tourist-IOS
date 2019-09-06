//
//  SightDetailViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 25/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class SightDetailViewController: UIViewController {
    
    var sight: SightAnnotation?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var subtitleTextView: UITextView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var locationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.text = sight?.title
        //checks for UUID, if image name has UUID then calls loadImageData that concatenates filepath with file name to get image
        if let image = sight?.imageName {
            if image.count != 36 {
                imageView.image =  UIImage(named: image)
            } else {
                imageView.image = loadImageData(fileName: image)
                
            }
        }
        if let subtitle = sight?.subtitle {
            subtitleTextView.text = "\(subtitle)"
        }
        // given lat and long coordinates converts into a user friendly address to display as location on the detail view controller
        reverseGeocode()
        //displays a placemark icon on the detail view screen
        iconImageView.image =  UIImage(named: "place-marker")
    }
    
    //this function converts lat and long to an address and dislays on detail view. Code taken from apple documentation  https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
    func reverseGeocode() {
        let geocoder = CLGeocoder()
        let currentSight  = CLLocation(latitude: sight!.coordinate.latitude, longitude: sight!.coordinate.longitude)
        geocoder.reverseGeocodeLocation(currentSight) { (placemarks, error) in
            if error == nil {
                
                let firstSight = placemarks?[0]
                if let currentSight = firstSight {
                    var address = ""
                    if let subThoroughfare = currentSight.subThoroughfare {
                        address += "\(subThoroughfare) "
                    }
                    if let thoroughfare = currentSight.thoroughfare {
                        address += "\(thoroughfare) "
                    }
                    if let subLocality = currentSight.subLocality {
                        address += " \(subLocality) "
                    }
                    if let subAdministrativeArea = currentSight.subAdministrativeArea {
                        address += "\(subAdministrativeArea) "
                    }
                    if let administrativeArea = currentSight.administrativeArea {
                        address += "\(administrativeArea)  "
                    }
                    self.locationTextView.text = address
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSightSegue" {
            let destination = segue.destination as! EditSightViewController
            destination.sightForEditing = sight
        }
    }
    
}
