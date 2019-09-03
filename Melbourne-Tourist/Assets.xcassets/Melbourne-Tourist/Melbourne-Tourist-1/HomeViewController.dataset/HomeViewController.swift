//
//  HomeViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 23/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var sightList = [SightAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialLocation()
        loadSights()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewAllSightsSegue" {
            let destination = segue.destination as! AllSightsTableViewController
            destination.sights = sightList
        }
    }
    

  
    
    func loadInitialLocation() {
        let initialLocation = CLLocationCoordinate2D(latitude: -37.8180, longitude: 144.9691)
        let zoomRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    func loadSights() {
        let sightOne = SightAnnotation(title: "Old Treasury Building", subtitle: "Finest public building in Australia", lat: -37.8132, long: 144.9744)
        sightList.append(sightOne)
        let sightTwo = SightAnnotation(title: "Abbotsford Convent", subtitle: "Australia’s largest multi-arts precinct. ", lat: -37.8026, long: 145.0044)
        sightList.append(sightTwo)
        let sightThree = SightAnnotation(title: "St Kilda Pier", subtitle: "Providing panoramic views of the Melbourne skyline and Port Phillip Bay", lat: -37.8648, long: 144.9659)
        sightList.append(sightThree)
        let sightFour = SightAnnotation(title: "Parliament of Victoria", subtitle: "Victoria's Parliament House", lat: -35.3082, long: 149.1244)
        sightList.append(sightFour)
        let sightFive = SightAnnotation(title: "National Sports Museum at the MCG", subtitle: "National Sports Museum", lat: -37.8200, long: 144.9834)
        sightList.append(sightFive)
        let sightSix = SightAnnotation(title: "Brighton Bathing Boxes", subtitle: "a row of uniformly proportioned wooden structures lining the foreshore at Brighton Beach.", lat: -37.9177, long: 144.9866)
        sightList.append(sightSix)
        let sightSeven = SightAnnotation(title: "St Paul's Cathedral", subtitle: "Anglican Cathedral in Melbourne", lat: -37.8170, long: 144.9677)
        sightList.append(sightSeven)
        let sightEight = SightAnnotation(title: "St Patrick's Cathedral", subtitle: "Cathedral Church of Roman Catholics", lat: -37.8101, long: 144.9764)
        sightList.append(sightEight)
        let sightNine = SightAnnotation(title: "Royal Exhibition Building", subtitle: "World Heritage Site in Melbourne", lat: -37.8047, long: 144.9717)
        sightList.append(sightNine)
        let sightTen = SightAnnotation(title: "Melbourne Museum", subtitle: "Natural and Cultural History museum", lat: -37.8033, long: 144.9717)
        sightList.append(sightTen)
        let sightEleven = SightAnnotation(title: "Shrine of Remembrance", subtitle: "War Memorial in Melbourne", lat: -37.8305, long: 144.9734)
        sightList.append(sightEleven)
        
        mapView.addAnnotations([sightOne, sightTwo, sightThree, sightFour, sightFive, sightSix, sightSeven, sightEight, sightNine, sightTen, sightEleven])
    }
    
}
