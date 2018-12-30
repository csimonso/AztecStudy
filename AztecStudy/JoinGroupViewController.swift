//
//  JoinGroupViewController.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/15/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import UIKit
import Firebase

/* Join Study Group View Controller
 *
 * Allows a user to join a already created study group
 */
class JoinGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    
    @IBOutlet var classButton: UIButton!
    @IBOutlet var classTableView: UITableView!
    @IBOutlet var groupTableView: UITableView!
    @IBOutlet var classTableHeight: NSLayoutConstraint!
    @IBOutlet var groupTableHeight: NSLayoutConstraint!
    
    //MARK: Properties
    
    var classes = [String]()
    var groups = [Group]()
    let userID = Auth.auth().currentUser?.uid
    
    //MARK: Table Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == classTableView {
            return classes.count
        }
        else {
            return groups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == classTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
            cell.textLabel?.text = classes[indexPath.row]
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
            cell.textLabel?.text = groups[indexPath.row].groupName
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            return cell 
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == classTableView {
            classButton.setTitle(classes[indexPath.row], for: .normal)
            animate(toogle: false)
            loadGroups(selectedCourse: classes[indexPath.row])
        }
    }
    
    //MARK: Initial Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set delegates
        self.classTableView.delegate = self
        self.classTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        //For dropdown effect
        classTableView.isHidden = true
        //Set initial properties
        classButton.layer.cornerRadius = 5
        classButton.clipsToBounds = true
        //Load the classes
        loadClasses()
    }
  
    //MARK: Tab View Methods
    
    override func viewDidAppear(_ animated: Bool) {
        classTableView.frame = CGRect(x: classTableView.frame.origin.x, y: classTableView.frame.origin.y, width: classTableView.frame.size.width, height: classTableView.contentSize.height)
    }
    
    override func viewDidLayoutSubviews(){
        classTableView.frame = CGRect(x: classTableView.frame.origin.x, y: classTableView.frame.origin.y, width: classTableView.frame.size.width, height: classTableView.contentSize.height)
        classTableHeight.constant = min(150, self.classTableView.contentSize.height)
        classTableView.reloadData()
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JoinToDetails" {
            let indexPath = groupTableView.indexPathForSelectedRow
            let group = groups[indexPath!.row]
            let detailViewController = segue.destination as! GroupDetailsViewController
            detailViewController.group = group
        }
    }
 

    //MARK: Action
    
    /* Brings down or retracts the drop down menu */
    @IBAction func onClickDropDown(_ sender: Any) {
        if classTableView.isHidden {
            animate(toogle: true)
        }
        else {
            animate(toogle: false)
        }
    }

    
    //MARK: Private Methods
    
    /* Loads the available study groups */
    private func loadGroups(selectedCourse: String) {
        groups = []
        let data = Database.database().reference().child("groups")
        data.observeSingleEvent(of: .value) { snapshot in
            //Loop through all the study groups
            for groups in snapshot.children {
                let snap = groups as! DataSnapshot
                let groupId = snap.key
                let groupChildren = data.child(groupId)
                groupChildren.observeSingleEvent(of: .value) { childSnap in
                    //Local variables to populate each groups details
                    var course = ""
                    var groupName = ""
                    var location = ""
                    var latitude = 0.0
                    var longitude = 0.0
                    var details = ""
                    var isClass = true
                    //Loop through each study groups details
                    for groupData in childSnap.children {
                        let csnap = groupData as! DataSnapshot
                        let category = csnap.key
                        let catInfo = csnap.value
                        if(category == "course") {
                            course = catInfo as! String
                            if(course != selectedCourse) {
                                isClass = false
                                break;
                            }
                        }
                        else if (category == "groupName") {
                            groupName = catInfo as! String
                        }
                        else if (category == "location") {
                            location = catInfo as! String
                        }
                        else if (category == "latitude") {
                            latitude = catInfo as! Double
                        }
                        else if (category == "longitude") {
                            longitude = catInfo as! Double
                        }
                        else {
                            details = catInfo as! String
                        }
                    }
                    //Only add the groups for the selected class to the list
                    if(isClass) {
                        //Create a group entry with all the group details
                        let entry = Group(groupName: groupName, groupID: groupId, location: location, locationLat: latitude, locationLong: longitude, locationDetails: details, course: course)
                        self.groups.append(entry)
                    }
                    //Reload the table
                    self.groupTableView.reloadData()
                }
            }
        }
    }
    
    /* Animates the class table */
    private func animate(toogle: Bool) {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.classTableView.isHidden = false
            }
        }
        else {
            UIView.animate(withDuration: 0.1) {
                self.classTableView.isHidden = true
            }
        }
    }
    
    /* Load the classes */
    private func loadClasses() {
        classes = []
        let data = Database.database().reference().child("users").child(userID!).child("classes")
        data.observeSingleEvent(of: .value) { snapshot in
            for courses in snapshot.children {
                let snap = courses as! DataSnapshot
                let courseName = snap.key
                self.classes.append(courseName)
                self.classTableView.reloadData()
            }
        }
    }
}
