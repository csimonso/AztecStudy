//
//  AddAssignmentViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase 

class AddAssignmentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var detailsField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let classPicker = UIPickerView()
    let userID = Auth.auth().currentUser?.uid
    var classes = [String]()
    var date = String()
    var inputComplete = false 
    
    
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
    
    @IBAction func enterAssignment(_ sender: Any) {
        if ((classField.text?.isEmpty)! || (detailsField.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "One or More Fields Are Empty", message: "Please Try Again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else {
            let uuid = UUID().uuidString
            let assignment = Assignment(course: classField.text!, dueDate: date, details: detailsField.text!, completed: false, assignmentID: uuid)
            let ref = Database.database().reference()
            ref.child("users").child(userID!).child("assignments").child("current").child(uuid).setValue(["course": assignment.course, "details": assignment.details , "dueDate": assignment.dueDate,"completed": assignment.completed, "ID": assignment.assignmentID])
            inputComplete = true
        }
 
    }
    
    //MARK: Action
    
    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        date = dateFormatter.string(from: datePicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Assignment"
        enterButton.layer.cornerRadius = 10
        enterButton.clipsToBounds = true
        
        classField.inputView = classPicker
        classPicker.delegate = self
        
        loadClasses()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        date = dateFormatter.string(from: datePicker.date)
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
    }}
