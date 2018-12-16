//
//  CreateGroupViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/15/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Properties
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var groupNameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var locationDetailsField: UITextField!
    @IBOutlet weak var classField: UITextField!
    
    let locationPicker = UIPickerView()
    let classPicker = UIPickerView()
    
    let userID = Auth.auth().currentUser?.uid
    
    var classes = [String]()
    var inputComplete = false 
    
    //let locationData = ["Malcom A. Love Library", "East Commons Bldg", "Manchester Hall", "Engineering Bldg"]
    let locationData = [ ["Malcom A. Love Library", 32.775216, -117.071124], ["East Commons Bldg", 32.775996, -117.070164] ]
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        
        locationField.inputView = locationPicker
        classField.inputView = classPicker
        
        locationPicker.delegate = self
        classPicker.delegate = self
        
        loadClasses()
    }
    
    //MARK: Action
    
    @IBAction func createGroup(_ sender: Any) {
        if ((groupNameField.text?.isEmpty)! || (locationField.text?.isEmpty)! || (locationDetailsField.text?.isEmpty)! || (classField.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "One or More Fields Are Empty", message: "Please Try Again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else {
            let uuid = UUID().uuidString
            let loc = locationField.text!
            var lat = 0.0
            var long = 0.0
            
            for (_,location) in locationData.enumerated() {
                let name = location[0] as? String
                if(name == loc){
                    lat = location[1] as! Double
                    long = location[2] as! Double
                }
            }
            
            let newGroup = Group(groupName: groupNameField.text!, groupID: uuid, location: locationField.text!, locationLat: lat, locationLong: long, locationDetails: locationDetailsField.text!, course: classField.text!)
            let ref = Database.database().reference()
            ref.child("groups").child(newGroup.groupID).setValue(["groupName": newGroup.groupName, "course": newGroup.course ,"location": newGroup.location, "latitude": lat, "longitude": long,"locationDetails": newGroup.locationDetails])
            
            inputComplete = true
        }
    }
    
    
    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if inputComplete {
            return true
        }
        else {
            return false
        }
    }
    
    
    //MARK: Private Functions
    
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
