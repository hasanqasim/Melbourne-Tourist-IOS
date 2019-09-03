//
//  AddSightViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 25/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import MapKit

class AddSightViewController: UIViewController {

    @IBOutlet weak var sightName: UITextField!
    @IBOutlet weak var sightDescription: UITextField!
    @IBOutlet weak var sightAddress: UITextField!
    @IBOutlet weak var iconSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: NewLocationDelegate?
    var newSightCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func viewSight(_ sender: Any) {
        showNewSightOnMap(address : sightAddress.text!)
        
    }
    @IBAction func addSight(_ sender: Any) {
        if sightName.text != "" && sightDescription.text != "" && sightAddress.text != ""{
            let nameRegex = "[a-zA-z ]+"
            let descriptionRegex = "[a-zA-z.!, ]+"
            let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegex)
            let descriptionTest = NSPredicate(format:"SELF MATCHES %@", descriptionRegex)
            let address = sightAddress.text!
            getCoordinates(address: address)
            
            if nameTest.evaluate(with: sightName.text) && descriptionTest.evaluate(with: sightDescription.text) && newSightCoordinates.latitude != 0 {
                let name = sightName.text!
                let description = sightName.text!
                let sight = SightAnnotation(title: name, subtitle: description, lat: newSightCoordinates.latitude, long: newSightCoordinates.longitude, image: "stkilda")
                delegate!.sightAnnotationAdded(annotation: sight)
                navigationController?.popViewController(animated: true)
                
            }
           
        }
        
        if sightName.text == "" {
            displayMessage(title: "Error", message: "Must provide a Name!")
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", "[a-zA-z ]+").evaluate(with: sightName.text) {
            displayMessage(title: "Error", message: "Must provide a Valid Name")
        }
        
        if sightDescription.text == "" {
            displayMessage(title: "Error", message: "Must provide a Description!")
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", "[a-zA-z.!, ]+").evaluate(with: sightDescription.text) {
            displayMessage(title: "Error", message: "Must provide a Valid Description")
        }
            
        if sightAddress.text == "" {
             displayMessage(title: "Error", message: "Must provide a Street Address!")
        }

       
    }
    
    func showNewSightOnMap(address : String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let sight = MKPointAnnotation()
                    sight.coordinate = CLLocationCoordinate2D(latitude: round(10000*location.coordinate.latitude)/10000, longitude: round(10000*location.coordinate.longitude)/10000)
                    self.mapView.addAnnotation(sight)
                    let zoomRegion = MKCoordinateRegion(center: sight.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    self.mapView.setRegion(self.mapView.regionThatFits(zoomRegion), animated: true)
                    return
                }
            } else {
                if address.count == 0 {
                    self.displayMessage(title: "ERROR", message: "Must provide a Street Address")
                } else {
                    self.displayMessage(title: "ERROR", message: "invalid Street Address")
                }
                
            }
        }
        
    }
    
    func getCoordinates(address : String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    self.newSightCoordinates.latitude = round(10000*placemark.location!.coordinate.latitude)/10000
                    self.newSightCoordinates.longitude = round(10000*placemark.location!.coordinate.longitude)/10000
                    return
                }
            } else {
                self.displayMessage(title: "ERROR", message: "invalid address")
                
            }
        }

    }
    
    
    
    func displayMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
