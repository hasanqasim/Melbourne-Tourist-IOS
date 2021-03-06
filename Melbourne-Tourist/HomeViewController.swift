//
//  HomeViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 23/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import MapKit

//most of the code in this view controller is from tutorials, some of it is from mapkit tutorial on hacking with swift.
class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, DatabaseListener,FocusOnAnnotationDelegate, RegionMonitoringDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewAllSightsBtn: UIButton!
    
    var sightList = [SightAnnotation]()
    weak var databaseController: DatabaseProtocol?
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAllSightsBtn.backgroundColor = UIColor(red: 0.7, green: 0.2, blue: 0.31, alpha: 1.0)
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        loadInitialLocation()
       
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startMonitoringForGeofence() {
        for location in sightList {
            let geoLocation = CLCircularRegion(center: location.coordinate, radius: 300, identifier: location.title!)
            geoLocation.notifyOnEntry = true
            locationManager.startMonitoring(for: geoLocation)
        }
    }
    
    //delegate method that removes geofence for deleted sight location
    func geofenceToBeRemoved (annotation: SightAnnotation) {
        let region = CLCircularRegion(center: annotation.coordinate, radius: 300, identifier: annotation.title!)
        locationManager.stopMonitoring(for: region)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        mapView.addAnnotations(sightList)
        locationManager.startUpdatingLocation()
        startMonitoringForGeofence()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        locationManager.stopUpdatingLocation()
    }
    
    func onSightListChange(change: DatabaseChange, sights: [SightAnnotation]) {
        sightList = sights
    }
    
    //keeps a track of user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = location.coordinate
    }
    
    func loadInitialLocation() {
        let initialLocation = CLLocationCoordinate2D(latitude: -37.8180, longitude: 144.9691)
        let zoomRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    func focusOn(annotation: MKAnnotation) {
        // A rectangular geographic region centered around a specefic latitude and longitude
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        // Changes the current visible region
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true) // adjusts aspect ratio of the specified region to ensure that it fits map view's frame
    }
    
    //customise annotation view with callout. Code reference from hacking with swift mapkit project: https://www.hackingwithswift.com/read/16/2/up-and-running-with-mapkit
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is SightAnnotation else {
            return nil
        }
        
        let identifier = "SightAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
            let sightAnnotation = annotation as! SightAnnotation
            let pinImage = UIImage(named: sightAnnotation.iconType!)
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x:0, y:0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView!.image = resizedImage
        
        
        return annotationView
    }
    
    // creates a segue way from annotation callout to detail view screen. Code referenced from the same MapKit Hacking with swif mapkit tutorial
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let sight = view.annotation as? SightAnnotation else {
            return
        }
        
        performSegue(withIdentifier: "sightDetailViewSegue", sender: sight)
        view.isSelected = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAllSightsSegue" {
            let destination = segue.destination as! AllSightsTableViewController
            destination.allSights = sightList
            destination.focusOnDelegate = self
            destination.regionMonitoringDelegate = self
        }
        
        if segue.identifier == "sightDetailViewSegue" {
            let destination = segue.destination as! SightDetailViewController
            destination.sight = sender as? SightAnnotation
            
        }
        
        if segue.identifier == "addNewSightSegue" {
            let controller = segue.destination as! AddSightViewController
            controller.focusOnAnnotationDelegate = self
        }
    }
}
