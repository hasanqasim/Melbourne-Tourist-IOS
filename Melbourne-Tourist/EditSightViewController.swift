//
//  EditSightViewController.swift
//  Melbourne-Tourist
//
//  Created by Hasan Qasim on 6/9/19.
//  Copyright © 2019 Muhammad Hasan. All rights reserved.
//

import UIKit
import CoreData
// most of the code in this view controller is from other view controllers where references have been sighted.
class EditSightViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var sightForEditing: SightAnnotation?
    weak var databaseController: DatabaseProtocol?
    var imageName = ""

    @IBOutlet weak var sightDescription: UITextField!
    @IBOutlet weak var saveEditsBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveEditsBtn.backgroundColor = UIColor(red: 0.7, green: 0.2, blue: 0.31, alpha: 1.0)
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        let descriptionRegex = "^[a-zA-Z0-9]+[.!,‘’']?[a-z]?( [a-zA-Z0-9]+[.!,‘’']?[a-z]?)*$"
        let descriptionTest = NSPredicate(format:"SELF MATCHES %@", descriptionRegex)
        if descriptionTest.evaluate(with: self.sightDescription.text) {
            //makes changes to annotations subtitle property and persists it. Code understood and implemented from this tutorial here: https://cocoacasts.com/reading-and-updating-managed-objects-with-core-data
            sightForEditing!.setValue(sightDescription.text!, forKey: "subtitle")
            databaseController?.saveEditSightChanges()
            navigationController?.popToRootViewController(animated: true)
        } else {
            let ac = UIAlertController(title: "Error", message: "Description must be valid", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(ac, animated: true, completion: nil)
        }
    }
}
