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
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var locationTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = sight?.title
        if let image = sight?.imageName {
            if image.count != 36 {
                imageView.image =  UIImage(named: image)
            } else {
                imageView.image = loadImageData(fileName: image)
                
            }
        }
        if let subtitle = sight?.subtitle {
            textView.text = "\(subtitle)"
        }
        
        reverseGeocode()
        iconImageView.image =  UIImage(named: "place-marker")
    }
    
    func reverseGeocode() {
        let geocoder = CLGeocoder()
        let currentSight  = CLLocation(latitude: sight!.coordinate.latitude, longitude: sight!.coordinate.longitude)
        geocoder.reverseGeocodeLocation(currentSight) { (placemarks, error) in
            if error == nil {
                
                let firstSight = placemarks?[0]
                if let currentSight = firstSight {
                    /*
                    if let name = currentSight.name {
                        address += "name: \(name)  "
                    }
                    */
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
                    /*
                    if let locality = currentSight.locality {
                        address += "locality: \(locality)  "
                    }
                    */
                   
                    
                    self.locationTextView.text = address
                }
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
       
    }
    */

}
