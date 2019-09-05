//
//  CoreDataController.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 6/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, NSFetchedResultsControllerDelegate, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    var allSightsFetchedResultsController: NSFetchedResultsController<SightAnnotation>?
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "MelbouneTourist")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        super.init()
        if fetchAllSights().count == 0 {
            createDefaultEntries()
        }
    }
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func addSightAnnotation(title: String, subtitle: String, latitude: Double, longitude: Double, iconType: String, imageName: String) -> SightAnnotation {
        let sight = NSEntityDescription.insertNewObject(forEntityName: "SightAnnotation", into: persistentContainer.viewContext) as! SightAnnotation
        sight.title = title
        sight.subtitle = subtitle
        sight.latitude = latitude
        sight.longitude = longitude
        sight.iconType = iconType
        sight.imageName = imageName
        saveContext()
        return sight
    }
    
    func deleteSightAnnotation(sight: SightAnnotation) {
        persistentContainer.viewContext.delete(sight)
        saveContext()
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        listener.onSightListChange(change: .update, sights: fetchAllSights())
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allSightsFetchedResultsController {
            listeners.invoke { (listener) in
                listener.onSightListChange(change: .update, sights: fetchAllSights())
            }
        }
    }
    
    func fetchAllSights() -> [SightAnnotation] {
        if allSightsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<SightAnnotation> = SightAnnotation.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allSightsFetchedResultsController = NSFetchedResultsController<SightAnnotation>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allSightsFetchedResultsController?.delegate = self
            
            do {
                try allSightsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        var sights = [SightAnnotation]()
        if allSightsFetchedResultsController?.fetchedObjects != nil {
            sights = (allSightsFetchedResultsController?.fetchedObjects)!
        }
        return sights
    }
    
    func createDefaultEntries() {
        let _ = addSightAnnotation(title: "Old Treasury Building", subtitle: "Finest public building in Australia", latitude: -37.8132, longitude: 144.9744, iconType: "Building", imageName: "oldtreasury")
        let _ = addSightAnnotation(title: "Abbotsford Convent", subtitle: "Australia’s largest multi-arts precinct. ", latitude: -37.8026, longitude: 145.0044, iconType: "Museum", imageName: "abbotsford")
        let _ = addSightAnnotation(title: "St Kilda Pier", subtitle: "Providing panoramic views of the Melbourne skyline and Port Phillip Bay", latitude: -37.8679, longitude: 144.9740, iconType: "Other", imageName: "stkilda")
        let _ = addSightAnnotation(title: "Parliament of Victoria", subtitle: "Victoria's Parliament House", latitude: -35.3082, longitude: 149.1244, iconType: "Building", imageName: "parliament")
        let _ = addSightAnnotation(title: "National Sports Museum", subtitle: "National Sports Museum at the MCG", latitude: -37.8200, longitude: 144.9834, iconType: "Museum", imageName: "mcg")
        let _ = addSightAnnotation(title: "Brighton Bathing Boxes", subtitle: "a row of uniformly proportioned wooden structures lining the foreshore at Brighton Beach.", latitude: -37.9177, longitude: 144.9866, iconType: "Other", imageName: "brighton")
        let _ = addSightAnnotation(title: "Rippon Lea Estate", subtitle: "An authentic Victorian mansion amidst 14 acres of breathtaking gardens.", latitude: -37.879150, longitude: 144.997780, iconType: "Park", imageName: "ripponlea")
        let _ = addSightAnnotation(title: "St Patrick's Cathedral", subtitle: "Cathedral Church of Roman Catholics", latitude: -37.8101, longitude: 144.9764, iconType: "Church", imageName: "stpat")
        let _ = addSightAnnotation(title: "Royal Exhibition Building", subtitle: "World Heritage Site in Melbourne", latitude: -37.8047, longitude: 144.9717, iconType: "Building", imageName: "royalexhibition")
        let _ = addSightAnnotation(title: "Melbourne Tram Museum", subtitle: "Melbourne Tram Museum preserves and shares the rich tramway history of Melbourne", latitude: -37.827130, longitude: 145.024280, iconType: "Museum", imageName: "tram")
        let _ = addSightAnnotation(title: "Shrine of Remembrance", subtitle: "War Memorial in Melbourne", latitude: -37.8305, longitude: 144.9734, iconType: "Museum", imageName: "shrine")
        let _ = addSightAnnotation(title: "Como House & Garden", subtitle: "One of Melbourne's most glamorous stately homes", latitude: -37.8379, longitude: 145.0037, iconType: "Park", imageName: "como")
        let _ = addSightAnnotation(title: "Old Melbourne Gaol", subtitle: "Shrouded in secrets, wander the same cells and halls as some of history’s most notorious criminals", latitude: -37.8078, longitude: 144.9653, iconType: "Museum", imageName: "gaol")
        let _ = addSightAnnotation(title: "Flinders Street Station", subtitle: "Melbourne's iconic railway station", latitude: -37.8183, longitude: 144.9671, iconType: "Other", imageName: "flinders")
        let _ = addSightAnnotation(title: "Athenaeum Theatre", subtitle: "Heritage-listed building housing the Athenaeum Theatre", latitude: -37.8150, longitude: 144.9674, iconType: "Museum", imageName: "theatre")
    }

}
