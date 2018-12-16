//
//  ScheduleTableViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/14/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

class ScheduleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    var classes = [Classes]()
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTableViewCell", for: indexPath) as? ScheduleTableViewCell else {
            fatalError("The dequed cell is not an instance of ScheduleTableViewCell")
        }
        let classInfo = classes[indexPath.row]
        cell.classTitleLabel.text = classInfo.className
        cell.classIdLabel.text = "\(classInfo.classID)  \(classInfo.days)"
        cell.timeLabel.text = classInfo.time
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let classInfo = classes[indexPath.row]
            let courseName = classInfo.className
            Database.database().reference().child("users").child(userID!).child("classes").child(courseName).removeValue()
            self.classes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        loadClasses()
    }

    //MARK: Action
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        loadClasses()
    }

    
    //MARK: Private Methods
    private func loadClasses() {
        classes = []
        let data = Database.database().reference().child("users").child(userID!).child("classes")
        data.observeSingleEvent(of: .value) { snapshot in
            for courses in snapshot.children {
                let snap = courses as! DataSnapshot
                let courseName = snap.key
                let courseChildren = data.child(courseName)
                courseChildren.observeSingleEvent(of: .value) { childSnap in
                    
                    var courseID = ""
                    var courseTime = ""
                    var courseDays = ""
    
                    for courseData in childSnap.children {
                        let csnap = courseData as! DataSnapshot
                        let category = csnap.key
                        let catInfo = csnap.value
                        if(category == "courseNumber") {
                            courseID = catInfo as! String
                        }
                        else if (category == "days") {
                            courseDays = catInfo as! String
                        }
                        else if (category == "time") {
                            courseTime = catInfo as! String
                        }
                    }
                    let entry = Classes(className: courseName, classID: courseID, days: courseDays, time: courseTime)
                    self.classes.append(entry)
                    self.classes = self.classes.sorted(by: {$0.time < $1.time})
                    self.tableView.reloadData()
                }
            }
        }
    }
}
