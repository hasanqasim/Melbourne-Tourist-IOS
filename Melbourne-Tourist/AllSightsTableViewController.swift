//
//  AllSightsTableViewController.swift
//  Melbourne-Tourist
//
//  Created by Muhammad Hasan on 23/8/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit

class AllSightsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    //var homeViewController: HomeViewController?
    var allSights = [SightAnnotation]()
    var filteredSights = [SightAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filteredSights = allSights
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Sights"
        navigationItem.searchController = searchController
        definesPresentationContext = true // ensure that the search bar does not remain on the screen if the user navigates to another view controller while the UISearchController is active.
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


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredSights.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sightCell", for: indexPath)
        let sight = filteredSights[indexPath.row]
        
        cell.textLabel!.text = sight.title
        cell.detailTextLabel!.text = sight.subtitle

        return cell
    }
    
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //navigationController?.pushViewController(homeViewController, animated: true)
        //let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        //let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //_ = homeViewController.view
        HomeViewController().focusOn(annotation: self.sights[indexPath.row])
    }
     */
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            allSights.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }/*
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
         */
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "focusOnSightSegue" {
            let controller = segue.destination as! HomeViewController
            //controller.delegate = self
            let selectionIndexPath = tableView.indexPathsForSelectedRows?.first
            //controller.focusOn(annotation: self.sights[selectionIndexPath!.row])
            controller.annotation = self.filteredSights[selectionIndexPath!.row]
        }
    }
    
    
    

}
