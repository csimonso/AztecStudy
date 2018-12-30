//
//  AddAssignmentViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase 

/* Add Assignment View Controller
 *
 * Allows the user to add a new assignment to their list of assignments as well as to Firebase.
 */
class AddAssignmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Outlets
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK: Properties
    
    let classPicker = UIPickerView()
    let userID = Auth.auth().currentUser?.uid
    var classes = [String]()
    var date = String()
    var inputComplete = false 
    
    //MARK: PickerView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        classField.text = classes[row]
        self.view.endEditing(true)
    }
    
    //MARK: Action
    
    /* Adds the assignment to users assignment list */
    @IBAction func enterAssignment(_ sender: Any) {
        //Verify all fields are filled out, display alert if not
        if ((classField.text?.isEmpty)! || (detailsField.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "One or More Fields Are Empty", message: "Please Try Again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else {
            //Assign a unique ID so no assignment is the same
            let uuid = UUID().uuidString
            let assignment = Assignment(course: classField.text!, dueDate: date, details: detailsField.text!, completed: false, assignmentID: uuid)
            let ref = Database.database().reference()
            //Add the assignment to Firebase for the specific user
            ref.child("users").child(userID!).child("assignments").child("current").child(uuid).setValue(["course": assignment.course, "details": assignment.details , "dueDate": assignment.dueDate,"completed": assignment.completed, "ID": assignment.assignmentID])
            //Inputs all filled in correctly
            inputComplete = true
        }
    }
    
    /* Called when the date changes in the Date Picker*/
    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        date = dateFormatter.string(from: datePicker.date)
    }
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set properties
        self.title = "Add Assignment"
        enterButton.layer.cornerRadius = 10
        enterButton.clipsToBounds = true
        //Set text field to picker view
        classField.inputView = classPicker
        //Set delegate
        classPicker.delegate = self
        //Load classes
        loadClasses()
        //Formate the date picker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        date = dateFormatter.string(from: datePicker.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    // MARK: - Navigation
    
    /* Takes the segue only if the data is fully filled in */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if inputComplete {
            return true
        }
        else {
            return false
        }
    }
    
    //MARK: Private Functions
    
    /* Loads the classes */
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
