//
//  AddSightViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 25/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import MapKit

class AddSightViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var sightName: UITextField!
    @IBOutlet weak var sightDescription: UITextField!
    @IBOutlet weak var sightAddress: UITextField!
    @IBOutlet weak var iconSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addSightBtn: UIButton!
    @IBOutlet weak var viewSightBtn: UIButton!
    var imageName = ""
    weak var databaseController: DatabaseProtocol?
    var newSightCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var focusOnAnnotationDelegate: FocusOnAnnotationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        addSightBtn.backgroundColor = UIColor(red: 0.7, green: 0.2, blue: 0.31, alpha: 1.0)
        viewSightBtn.backgroundColor = UIColor(red: 0.7, green: 0.2, blue: 0.31, alpha: 1.0)
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.allowsEditing = false
        // we tell this view controller that we want our clas to be its delegate
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //extract image from dictionary that is passed as a parameter
        guard let image = info[.originalImage] as? UIImage else {
            displayMessage(title: "Error", message: "Cannot save until a photo has been taken!")
            return
        }
        
        //Generate a unique filename for the image we import using UUID.
        imageName = UUID().uuidString
        
        //convert image to JPEG, then write that JPEG to disk
        let jpegData = image.jpegData(compressionQuality: 0.8)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        
        if let pathComponent = url.appendingPathComponent("\(imageName)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: jpegData, attributes: nil)
        }
        
        //dismiss the view controller
        dismiss(animated: true)
        displayMessage(title: "Success", message: "Image Capture Successful!")
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
        if sightName.text!.count != 0 && sightDescription.text!.count != 0 && sightAddress.text!.count != 0 && imageName != ""{
            let nameRegex = "^[a-zA-Z]+( [a-zA-Z]+)*$"
            let descriptionRegex = "^[a-zA-Z0-9]+[.!,‘’']?[a-z]?( [a-zA-Z0-9]+[.!,‘’']?[a-z]?)*$"
            let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegex)
            let descriptionTest = NSPredicate(format:"SELF MATCHES %@", descriptionRegex)
            let address = sightAddress.text!
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if error == nil {
                    if let placemark = placemarks?[0] {
                        self.newSightCoordinates.latitude = round(10000*placemark.location!.coordinate.latitude)/10000
                        self.newSightCoordinates.longitude = round(10000*placemark.location!.coordinate.longitude)/10000
                        if nameTest.evaluate(with: self.sightName.text) && descriptionTest.evaluate(with: self.sightDescription.text) && self.newSightCoordinates.latitude != 0 {
                            let name = self.sightName.text!
                            let description = self.sightDescription.text!
                            let iconType = self.iconSegmentedControl.titleForSegment(at: self.iconSegmentedControl.selectedSegmentIndex)!
                            let sight = self.databaseController!.addSightAnnotation(title: name, subtitle: description, latitude: self.newSightCoordinates.latitude, longitude: self.newSightCoordinates.longitude, iconType: iconType, imageName: self.imageName)
                            self.navigationController?.popViewController(animated: true)
                            self.focusOnAnnotationDelegate?.focusOn(annotation: sight)
                            return
                        }
                    }
                } else {
                    self.displayMessage(title: "ERROR", message: "Invalid Street Address")
                }
            }
        }
        
        if sightName.text!.isEmpty {
            displayMessage(title: "Error", message: "Must provide a Name!")
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", "^[a-zA-Z]+( [a-zA-Z]+)*$").evaluate(with: sightName.text) {
            displayMessage(title: "Error", message: "Must provide a Valid Name. Name cannot have digits or punctuations!")
        }
        
        if sightDescription.text!.isEmpty {
            displayMessage(title: "Error", message: "Must provide a Description!")
        }
        
        if !NSPredicate(format:"SELF MATCHES %@", "^[a-zA-Z0-9]+[.!,‘’']?[a-z]?( [a-zA-Z0-9]+[.,!‘’']?[a-z]?)*$").evaluate(with: sightDescription.text) {
            displayMessage(title: "Error", message: "Must provide a Valid Description")
        }
            
        if sightAddress.text!.isEmpty {
             displayMessage(title: "Error", message: "Must provide a Street Address!")
        }
        
        if imageName == "" {
            displayMessage(title: "Error", message: "Must provide an Image")
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
                    self.mapView.removeAnnotation(sight)
                    self.mapView.addAnnotation(sight)
                    let zoomRegion = MKCoordinateRegion(center: sight.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
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
    /*
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
    */
    
    
    func displayMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
