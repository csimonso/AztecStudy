//
//  CreateGroupViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/15/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

/* Create Group View Controller
 *
 * Allows a user to create a study group.
 */
class CreateGroupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Outlets
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var locationDetailsField: UITextField!
    @IBOutlet weak var classField: UITextField!
    
    //MARK: Properties
    
    let locationPicker = UIPickerView()
    let classPicker = UIPickerView()
    let userID = Auth.auth().currentUser?.uid
    var classes = [String]()
    var inputComplete = false
    let locationData = [ ["Malcom A. Love Library", 32.775216, -117.071124], ["East Commons Bldg", 32.775996, -117.070164], ["Hardy Tower", 32.77724, -117.071923], ["Life Sciences North", 32.7777, -117.071604], ["Life Sciences South", 32.777226, -117.071365], ["Hepner Hall", 32.77645, -117.071904], ["Communications Bldg", 32.77645, -117.072771], ["Music Bldg", 32.774239, -117.072696], ["Dramatic Arts Bldg", 32.775056, -117.0725], ["Education Bldg", 32.775358, -117.069381], ["Physics Bldg", 32.776504, -117.070252], ["Art North Bldg", 32.778181, -117.072181], ["Arts & Letters Bldg", 32.777655, -117.07322], ["Engineering Bldg", 32.77756, -117.070546], ["West Commons Bldg", 32.776268, -117.073866], ["College of Business Bldg", 32.772003, -117.072697], ["Gateway Center", 32.772414, -117.072476], ["Manchester Hall", 32.774623, -117.070396], ["Adams Humanities Bldg", 32.773735, -117.071335], ["Industrial Technology Bldg", 32.776854, -117.070236], ["Physics-Astronomy Bldg", 32.776466, -117.070877], ["Bioscience Center", 32.777993, -117.071246] ]
    
    //MARK: PickerView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == locationPicker {
            return locationData.count
        }
        else {
            return classes.count 
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == locationPicker {
            let location = locationData[row][0]
            return (location as! String)
        }
        else {
            return classes[row]
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == locationPicker {
            locationField.text = (locationData[row][0] as! String)
            self.view.endEditing(true)
        }
        else {
            classField.text = classes[row]
            self.view.endEditing(true)
        }
    }
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Initial Properties
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        //Set text fields to picker view
        locationField.inputView = locationPicker
        classField.inputView = classPicker
        //Set delegates
        locationPicker.delegate = self
        classPicker.delegate = self
        //Load classes
        loadClasses()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: Action
    
    /* Creates a study group */
    @IBAction func createGroup(_ sender: Any) {
        //Verifies all fields are filled in, displays alert if not
        if ((groupNameField.text?.isEmpty)! || (locationField.text?.isEmpty)! || (locationDetailsField.text?.isEmpty)! || (classField.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "One or More Fields Are Empty", message: "Please Try Again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else {
            //Sets a unique ID to the group, this way no group is the same
            let uuid = UUID().uuidString
            let loc = locationField.text!
            var lat = 0.0
            var long = 0.0
            //Get the coordinates of the location that was selected
            for (_,location) in locationData.enumerated() {
                let name = location[0] as? String
                if(name == loc){
                    lat = location[1] as! Double
                    long = location[2] as! Double
                }
            }
            //Create a new entry for the group
            let newGroup = Group(groupName: groupNameField.text!, groupID: uuid, location: locationField.text!, locationLat: lat, locationLong: long, locationDetails: locationDetailsField.text!, course: classField.text!)
            //Create a Firebase reference
            let ref = Database.database().reference()
            //Add the group to Firebase
            ref.child("groups").child(newGroup.groupID).setValue(["groupName": newGroup.groupName, "course": newGroup.course ,"location": newGroup.location, "latitude": lat, "longitude": long,"locationDetails": newGroup.locationDetails])
            //All inputs completed
            inputComplete = true
        }
    }
    
    // MARK: - Navigation

    /* Verifies input is complete before taking segue */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if inputComplete {return true}
        else {return false}
    }
    
    //MARK: Private Functions
    
    /* Loads the users classes, can only create a study group for the classes the user is taking */
    private func loadClasses() {
        classes = []
        let data = Database.database().reference().child("users").child(userID!).child("classes")
        data.observeSingleEvent(of: .value, with: { (snapshot) in
            for classes in snapshot.children {
                let snap = classes as! DataSnapshot
                let className = snap.key
                self.classes.append(className)
            }
        })
    }
}
