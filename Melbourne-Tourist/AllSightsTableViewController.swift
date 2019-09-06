//
//  AllSightsTableViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 23/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit

//most of the code in this view controller is from tutorials. Image resizing code snippet is from stackoverflow.
class AllSightsTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    
    //var homeViewController: HomeViewController?
    var allSights = [SightAnnotation]()
    var filteredSights = [SightAnnotation]()
    weak var databaseController: DatabaseProtocol?
    //delegate to pass annotation to focus on mapview once a selection is made in table view
    var focusOnDelegate: FocusOnAnnotationDelegate?
    //delegate to pass annotation fo which geofencing has to be removed
    var regionMonitoringDelegate: RegionMonitoringDelegate?
    //boolean used in sorting tableview
    var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

        filteredSights = allSights
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sights"
        navigationItem.searchController = searchController
        definesPresentationContext = true // ensure that the search bar does not remain on the screen if the user navigates to another view controller while the UISearchController is active.
    }
    
    //sorts table view in both ascending and descending
    @IBAction func sortButton(_ sender: Any) {
        if !flag {
            filteredSights.sort(by: { $0.title! < $1.title! })
            flag = true
            tableView.reloadData()
        } else {
            filteredSights.sort(by: { $0.title! > $1.title! })
            flag = false
            tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredSights = allSights.filter({(sight: SightAnnotation) -> Bool in
                return sight.title!.lowercased().contains(searchText)
            })
        } else {
            filteredSights = allSights
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSights.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sightCell", for: indexPath)
        let sight = filteredSights[indexPath.row]
        
        cell.textLabel!.text = sight.title
        cell.detailTextLabel!.text = sight.subtitle
        let cellViewImage: UIImage
        let imageName = sight.imageName!
        // if image name has UUID then fetches filepath
        if imageName.count != 36 {
            cellViewImage =  UIImage(named: imageName)!
        } else {
            cellViewImage = loadImageData(fileName: imageName)!
            }
        //fixes image size for display in table view cell. Code taken from stackoverflow
        let size = CGSize(width: 100, height: 50)
        UIGraphicsBeginImageContext(size)
        cellViewImage.draw(in: CGRect(x:0, y:0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        cell.imageView?.image = resizedImage

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        focusOnDelegate?.focusOn(annotation: filteredSights[indexPath.row])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onSightListChange(change: DatabaseChange, sights: [SightAnnotation]) {
        allSights = sights
        updateSearchResults(for: navigationItem.searchController!)
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            regionMonitoringDelegate?.geofenceToBeRemoved(annotation: filteredSights[indexPath.row])
            databaseController?.deleteSightAnnotation(sight: filteredSights[indexPath.row])
        }
 
    }
}
//made this a global function to be used by multiple view controllers
func loadImageData(fileName: String) -> UIImage? {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    var image: UIImage?
    if let pathComponent = url.appendingPathComponent(fileName) {
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        let fileData = fileManager.contents(atPath: filePath)
        image = UIImage(data: fileData!)
    }
    return image
}
