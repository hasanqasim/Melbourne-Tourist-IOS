//
//  HomeViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 23/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate, NewLocationDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var sightList = [SightAnnotation]()
    var annotation: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialLocation()
        loadSights()
        
        if let annotation = annotation {
            focusOn(annotation: annotation)
        }

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAllSightsSegue" {
            let destination = segue.destination as! AllSightsTableViewController
            destination.allSights = sightList
        }
        
        if segue.identifier == "sightDetailViewSegue" {
            let destination = segue.destination as! SightDetailViewController
            destination.sight = sender as? SightAnnotation
            
        }
        
        if segue.identifier == "addNewSightSegue" {
            let controller = segue.destination as! AddSightViewController
            controller.delegate = self
        }
    }
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true) // Selects the specified annotation and displays a callout view for it
        // A rectangular geographic region centered around a specefic latitude and longitude
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        // Changes the current visible region
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true) // adjusts aspect ratio of the specified region to ensure that it fits map view's frame
       
    }
    
    func loadInitialLocation() {
        let initialLocation = CLLocationCoordinate2D(latitude: -37.8180, longitude: 144.9691)
        let zoomRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    func loadSights() {
        let sightOne = SightAnnotation(title: "Old Treasury Building", subtitle: "Finest public building in Australia", lat: -37.8132, long: 144.9744, image: "oldtreasury")
        sightList.append(sightOne)
        let sightTwo = SightAnnotation(title: "Abbotsford Convent", subtitle: "Australia’s largest multi-arts precinct. ", lat: -37.8026, long: 145.0044, image: "abbotsford")
        sightList.append(sightTwo)
        let sightThree = SightAnnotation(title: "St Kilda Pier", subtitle: "Providing panoramic views of the Melbourne skyline and Port Phillip Bay", lat: -37.8679, long: 144.9740, image: "stkilda")
        sightList.append(sightThree)
        let sightFour = SightAnnotation(title: "Parliament of Victoria", subtitle: "Victoria's Parliament House", lat: -35.3082, long: 149.1244, image: "parliament")
        sightList.append(sightFour)
        let sightFive = SightAnnotation(title: "National Sports Museum", subtitle: "National Sports Museum at the MCG", lat: -37.8200, long: 144.9834, image: "mcg")
        sightList.append(sightFive)
        let sightSix = SightAnnotation(title: "Brighton Bathing Boxes", subtitle: "a row of uniformly proportioned wooden structures lining the foreshore at Brighton Beach.", lat: -37.9177, long: 144.9866, image: "brighton")
        sightList.append(sightSix)
        let sightSeven = SightAnnotation(title: "Rippon Lea Estate", subtitle: "An authentic Victorian mansion amidst 14 acres of breathtaking gardens.", lat: -37.879150, long: 144.997780, image: "ripponlea")
        sightList.append(sightSeven)
        let sightEight = SightAnnotation(title: "St Patrick's Cathedral", subtitle: "Cathedral Church of Roman Catholics", lat: -37.8101, long: 144.9764, image: "stpat")
        sightList.append(sightEight)
        let sightNine = SightAnnotation(title: "Royal Exhibition Building", subtitle: "World Heritage Site in Melbourne", lat: -37.8047, long: 144.9717, image: "royalexhibition")
        sightList.append(sightNine)
        let sightTen = SightAnnotation(title: "Melbourne Tram Museum", subtitle: "Melbourne Tram Museum preserves and shares the rich tramway history of Melbourne", lat: -37.827130, long: 145.024280, image: "tram")
        sightList.append(sightTen)
        let sightEleven = SightAnnotation(title: "Shrine of Remembrance", subtitle: "War Memorial in Melbourne", lat: -37.8305, long: 144.9734, image: "shrine")
        sightList.append(sightEleven)
        let sightTwelve = SightAnnotation(title: "Como House & Garden", subtitle: "One of Melbourne's most glamorous stately homes", lat: -37.8379, long: 145.0037, image: "como")
        sightList.append(sightTwelve)
        let sightThirteen = SightAnnotation(title: "Old Melbourne Gaol", subtitle: "Shrouded in secrets, wander the same cells and halls as some of history’s most notorious criminals", lat: -37.8078, long: 144.9653, image: "gaol")
        sightList.append(sightThirteen)
        let sightFourteen = SightAnnotation(title: "Flinders Street Station", subtitle: "Melbourne's iconic railway station", lat: -37.8183, long: 144.9671, image: "flinders")
        sightList.append(sightFourteen)
        let sightFifteen = SightAnnotation(title: "Athenaeum Theatre", subtitle: "Heritage-listed building housing the Athenaeum Theatre", lat: -37.8150, long: 144.9674, image: "theatre")
        sightList.append(sightFifteen)
        
        mapView.addAnnotations([sightOne, sightTwo, sightThree, sightFour, sightFive, sightSix, sightSeven, sightEight, sightNine, sightTen, sightEleven, sightTwelve, sightThirteen, sightFourteen, sightFifteen])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is SightAnnotation else {
            return nil
        }
        
        let identifier = "SightAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let sight = view.annotation as? SightAnnotation else {
            return
        }
        
        performSegue(withIdentifier: "sightDetailViewSegue", sender: sight)
        view.isSelected = false
        
    }
    
    func sightAnnotationAdded(annotation: SightAnnotation) {
        sightList.append(annotation)
        mapView.addAnnotation(annotation)
    }
    
}
