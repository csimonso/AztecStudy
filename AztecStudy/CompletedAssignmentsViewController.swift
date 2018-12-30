//
//  CompletedAssignmentsViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

/* Completed Assignments View Controller
 *
 * Displays the completed assignments for the user.
 */
class CompletedAssignmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
 
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var assignments = [Assignment]()
    let userID = Auth.auth().currentUser?.uid

    //MARK: Table Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell", for: indexPath) as? AssignmentTableViewCell else {
            fatalError("The dequed cell is not an instance of ScheduleTableViewCell")
        }
        let assignmentInfo = assignments[indexPath.row]
        cell.classLabel.text = assignmentInfo.course
        cell.detailsLabel.text = assignmentInfo.details
        
        let dueDate = assignmentInfo.dueDate
        let dueDateArr = dueDate.components(separatedBy: "-")
        let month = getMonth(date: dueDateArr[1])
        let dueDateStr = "Due: \(month) \(dueDateArr[0]), \(dueDateArr[2])"
        cell.dueDateLabel.text = dueDateStr
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let assignmentInfo = assignments[indexPath.row]
            let assignmentID = assignmentInfo.assignmentID
            Database.database().reference().child("users").child(userID!).child("assignments").child("completed").child(assignmentID).removeValue()
            self.assignments.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //Load assignments
        loadAssignments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Private Methods
    
    /* Converts Numeric Month to String */
    private func getMonth(date: String) -> String {
        var month = ""
        switch date {
        case "01":
            month = "Jan"
        case "02":
            month = "Feb"
        case "03":
            month = "Mar"
        case "04":
            month = "Apr"
        case "05":
            month = "May"
        case "06":
            month = "Jun"
        case "07":
            month = "Jul"
        case "08":
            month = "Aug"
        case "09":
            month = "Sep"
        case "10":
            month = "Oct"
        case "11":
            month = "Nov"
        case "12":
            month = "Dec"
        default:
            month = ""
        }
        return month
    }
    
    /* Loads the user assignments */
    private func loadAssignments() {
        assignments = []
        let data = Database.database().reference().child("users").child(userID!).child("assignments").child("completed")
        data.observeSingleEvent(of: .value) { snapshot in
            //Loop through users completed assignments
            for assignment in snapshot.children {
                let snap = assignment as! DataSnapshot
                let assignmentID = snap.key
                let assignmentChildren = data.child(assignmentID)
                assignmentChildren.observeSingleEvent(of: .value) { childSnap in
                    //Local variables for each assignment details
                    var course = ""
                    var details = ""
                    var dueDate = ""
                    var completed = true
                    var id = ""
                    //Loops through the assignment details
                    for assignmentData in childSnap.children {
                        let csnap = assignmentData as! DataSnapshot
                        let category = csnap.key
                        let catInfo = csnap.value
                        if(category == "course") {
                            course = catInfo as! String
                        }
                        else if (category == "completed") {
                            completed = catInfo as! Bool
                        }
                        else if (category == "details") {
                            details = catInfo as! String
                        }
                        else if (category == "ID") {
                            id = catInfo as! String
                        }
                        else {
                            dueDate = catInfo as! String
                        }
                    }
                    //Create an assignment entry
                    let assignmentEntry = Assignment(course: course, dueDate: dueDate, details: details, completed: completed, assignmentID: id)
                    self.assignments.append(assignmentEntry)
                    //Sort assignments by date due
                    self.assignments = self.assignments.sorted(by: {$0.dueDate < $1.dueDate})
                    //Reload the data
                    self.tableView.reloadData()
                }
            }
        }
    }
 }
