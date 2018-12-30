//
//  AddClassViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/14/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

/* Add Class View Controller
 *
 * Sub Page of the Schedule Page. Allows a user to add a new class to his schedule.
 */
class AddClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: Outlets
    
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var daysField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: Properties
    
    let subjectPicker = UIPickerView()
    let coursePicker = UIPickerView()
    let timePicker = UIPickerView()
    let daysPicker = UIPickerView()
    let startTime = ["07:00", "07:15", "07:30", "07:45", "08:00", "08:15", "08:30", "08:45", "09:00", "09:15", "09:30", "09:45", "10:00", "10:15", "10:30", "10:45", "11:00", "11:15", "11:30", "11:45", "12:00", "12:15", "12:30", "12:45", "13:00", "13:15", "13:30", "13:45", "14:00", "14:15", "14:30", "14:45", "15:00", "15:15", "15:30", "15:45", "16:00", "16:15", "16:30", "16:45", "17:00", "17:15", "17:30", "17:45", "18:00", "18:15", "18:30", "18:45", "19:00", "19:15", "19:30", "19:45", "20:00", "20:15", "20:30", "20:45"]
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Monday-Wednesday", "Tuesday-Thursday", "Monday-Wednesday-Friday"]
    var subject = [String]()
    var classes = [String]()
    var inputComplete = false
    
    //MARK: PickerView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timePicker {
            return startTime.count
        }
        else if pickerView == daysPicker {
            return days.count
        }
        else if pickerView == subjectPicker {
            return subject.count
        }
        else {
            return classes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == timePicker {
            return startTime[row]
        }
        else if pickerView == daysPicker {
            return days[row]
        }
        else if pickerView == subjectPicker {
            return subject[row]
        }
        else {
            return classes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timePicker {
            timeField.text = startTime[row]
            self.view.endEditing(true)
        }
        else if pickerView == subjectPicker {
            subjectField.text = subject[row]
            courseField.text = ""
            timeField.text = ""
            daysField.text = ""
            loadClasses(subject: subject[row])
            self.view.endEditing(true)
        }
        else if pickerView == coursePicker {
            courseField.text = classes[row]
            self.view.endEditing(true)
        }
        else {
            daysField.text = days[row]
            self.view.endEditing(true)
        }
    }
    
    //MARK: Action
    
    /* Adds Class to user schedule when clicked */
    @IBAction func addClass(_ sender: Any) {
        //Verify all fields are filled in, display alert if they are not
        if ((subjectField.text?.isEmpty)! || (courseField.text?.isEmpty)! || (timeField.text?.isEmpty)! || (daysField.text?.isEmpty)!) {
            let alertController = UIAlertController(title: "One or More Fields Are Empty", message: "Please Try Again", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else {
            //Get the user id of logged in user from Firebase
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            //Get the course info and separate string into 2 parts, course number and course name
            let course = courseField.text!
            let courseArr = course.components(separatedBy: ": ")
            //Add new course to Firebase for logged in user
            ref.child("users").child(userID!).child("classes").child(courseArr[1]).setValue(["courseNumber": courseArr[0], "days": self.daysField.text!, "time": self.timeField.text!])
            inputComplete = true 
        }
    }
    
    //MARK: Navigation
    
    //Verify all fields were filled in before taking the segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if inputComplete {return true}
        else {return false}
    }
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set initial properties
        self.navigationItem.title = "Add Class"
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        //Assign text fields as pickerviews
        subjectField.inputView = subjectPicker
        courseField.inputView = coursePicker
        timeField.inputView = timePicker
        daysField.inputView = daysPicker
        //Set delegates
        subjectPicker.delegate = self
        coursePicker.delegate = self
        timePicker.delegate = self
        daysPicker.delegate = self
        //Load class subjects
        loadSubjects()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: Private Methods
    
    /* Loads the subjects of the classes to display in the picker view */
    private func loadSubjects() {
        subject = []
        let data = Database.database().reference().child("classes")
        data.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.subject.append(key)
            }
        })
    }
    
    /* Loads the classes for each subject to display in the picker view */
    private func loadClasses(subject: String) {
        classes = []
        let data = Database.database().reference().child("classes/\(subject)")
        data.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                let className = "\(key): \(value!)"
                self.classes.append(className)
            }
        })
    }
}
