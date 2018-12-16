//
//  Assignment.swift
//  AztecStudy
//
//  Created by Christopher Simonson on 12/16/18.
//  Copyright © 2018 SimonsonProductions. All rights reserved.
//

import Foundation

class Assignment {
    //MARK: Properties
    var course: String
    var dueDate: String
    var details: String
    var completed: Bool
    var assignmentID: String
    
    //MARK: Initialization
    init(course: String, dueDate: String, details: String, completed: Bool, assignmentID: String) {
        //Initialize properties
        self.course = course
        self.dueDate = dueDate
        self.details = details
        self.completed = completed
        self.assignmentID = assignmentID
    }
}
