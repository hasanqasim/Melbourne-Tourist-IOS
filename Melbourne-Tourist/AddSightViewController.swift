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
    //variable for the image that the user takes from camera or photo gallery
    var imageName = ""
    weak var databaseController: DatabaseProtocol?
    //coordinate variable used to store coordinates of the location address string that user inputs
    var newSightCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    //delegate used to focus on sight annotation on mapview after user successfully adds it
    var focusOnAnnotationDelegate: FocusOnAnnotationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        //modify button background color. Code taken from stackoverflow.
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
    
    //Save image ame as UUID. Code inspiration from hacking with swifts tutorial on ImagePickerController tutorial: https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller
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
    

    @IBAction func viewSight(_ sender: Any) {
        //add screen has a mapview for users to check if the address string they entered matches with location on map. method uses geocoding to convert address string to coordinates. Code taken from apple developer documentation: https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
        showNewSightOnMap(address : sightAddress.text!)
    }
    // method extensively validates users input, adds new sight and persists it to application. Regex validation done using helper code from medium and stackoverflow: https://medium.com/@vinayganeshh/regex-and-smart-punctuation-in-ios-f36deb3503e https://stackoverflow.com/questions/15472764/regular-expression-to-allow-spaces-between-words
    // method also does geocoding using code from apple documentation - same link as above
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
    
    //method to show users address on map for verification. Uses geocoding to convert address to coordinates
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
   
    func displayMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
